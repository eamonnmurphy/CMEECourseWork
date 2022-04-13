
function (file, data = NULL, inits, n.chains = 1, n.adapt = 1000, 
          quiet = FALSE) 
{
  if (missing(file)) {
    stop("Model file name missing")
  }
  if (is.character(file)) {
    modfile <- file
    con <- try(file(modfile, "rt"))
    if (inherits(con, "try-error")) {
      stop(paste("Cannot open model file \"", modfile, 
                 "\"", sep = ""))
    }
    close(con)
    model.code <- readLines(file, warn = FALSE)
  }
  else if (inherits(file, "connection")) {
    modfile <- tempfile()
    model.code <- readLines(file, warn = FALSE)
    writeLines(model.code, modfile)
  }
  else {
    stop("'file' must be a character string or connection")
  }
  if (quiet) {
    .quiet.messages(TRUE)
    on.exit(.quiet.messages(FALSE), add = TRUE)
  }
  p <- .Call("make_console", PACKAGE = "rjags")
  .Call("check_model", p, modfile, PACKAGE = "rjags")
  if (!is.character(file)) {
    unlink(modfile)
  }
  varnames <- .Call("get_variable_names", p, PACKAGE = "rjags")
  if (missing(data) || is.null(data)) {
    data <- list()
  }
  else if (is.environment(data)) {
    data <- mget(varnames, envir = data, mode = "numeric", 
                 ifnotfound = list(NULL))
    data <- data[!sapply(data, is.null)]
  }
  else if (is.list(data)) {
    v <- names(data)
    if (is.null(v) && length(v) != 0) {
      stop("data must be a named list")
    }
    if (any(nchar(v) == 0)) {
      stop("unnamed variables in data list")
    }
    if (any(duplicated(v))) {
      stop("Duplicated names in data list: ", paste(v[duplicated(v)], 
                                                    collapse = " "))
    }
    relevant.variables <- v %in% varnames
    data <- data[relevant.variables]
    unused.variables <- setdiff(v, varnames)
    for (i in seq(along = unused.variables)) {
      warning("Unused variable \"", unused.variables[i], 
              "\" in data")
    }
    df <- which(as.logical(sapply(data, is.data.frame)))
    for (i in seq(along = df)) {
      if (all(sapply(data[[df[i]]], is.numeric))) {
        data[[df[i]]] <- as.matrix(data[[df[i]]])
      }
      else {
        stop("Data frame with non-numeric elements provided as data: ", 
             names(data)[df[i]])
      }
    }
  }
  else {
    stop("data must be a list or environment")
  }
  .Call("compile", p, data, as.integer(n.chains), TRUE, PACKAGE = "rjags")
  if (!missing(inits) && !is.null(inits)) {
    checkParameters <- function(inits) {
      if (!is.list(inits)) {
        return("inits parameter must be a list")
      }
      inames <- names(inits)
      if (is.null(inames) || any(nchar(inames) == 0)) {
        return("No variable names supplied for the initial values")
      }
      dupinames <- duplicated(inames)
      if (any(dupinames)) {
        return(paste("Duplicated initial values for variable(s): ", 
                     paste0(unique(inames[dupinames]), collapse = ", ")))
      }
      if (any(inames == ".RNG.name")) {
        rngname <- inits[[".RNG.name"]]
        if (!is.character(rngname) || length(rngname) != 
            1) {
          return("Incorrect .RNG.name value")
        }
        inits[[".RNG.name"]] <- NULL
      }
      null.inits <- sapply(inits, is.null)
      if (any(null.inits)) {
        warning(paste("NULL initial value supplied for variable(s) ", 
                      paste(inames[null.inits], collapse = ", "), 
                      sep = ""))
        inits <- inits[!null.inits]
      }
      num_vals <- sapply(inits, is.numeric)
      if (any(!num_vals)) {
        return(paste("Non-numeric initial values supplied for variable(s) ", 
                     paste(inames[!num_vals], collapse = ", "), 
                     sep = ""))
      }
      return("ok")
    }
    setParameters <- function(inits, chain) {
      if (!is.null(inits[[".RNG.name"]])) {
        .Call("set_rng_name", p, inits[[".RNG.name"]], 
              as.integer(chain), PACKAGE = "rjags")
        inits[[".RNG.name"]] <- NULL
      }
      .Call("set_parameters", p, inits, as.integer(chain), 
            PACKAGE = "rjags")
    }
    init.values <- vector("list", n.chains)
    if (is.function(inits)) {
      if (any(names(formals(inits)) == "chain")) {
        for (i in 1:n.chains) {
          init.values[[i]] <- inits(chain = i)
        }
      }
      else {
        for (i in 1:n.chains) {
          init.values[[i]] <- inits()
        }
      }
    }
    else if (is.list(inits)) {
      if (!is.null(names(inits))) {
        for (i in 1:n.chains) {
          init.values[[i]] <- inits
        }
      }
      else {
        if (length(inits) != n.chains) {
          stop("Length mismatch between inits and n.chains")
        }
        init.values <- inits
      }
    }
    for (i in 1:n.chains) {
      msg <- checkParameters(init.values[[i]])
      if (!identical(msg, "ok")) {
        stop("Invalid parameters for chain ", i, ":\n", 
             msg)
      }
      setParameters(init.values[[i]], i)
      unused.inits <- setdiff(names(init.values[[i]]), 
                              varnames)
      unused.inits <- setdiff(unused.inits, c(".RNG.seed", 
                                              ".RNG.state", ".RNG.name"))
      for (j in seq(along = unused.inits)) {
        warning("Unused initial value for \"", unused.inits[j], 
                "\" in chain ", i)
      }
    }
  }
  .Call("initialize", p, PACKAGE = "rjags")
  model.state <- .Call("get_state", p, PACKAGE = "rjags")
  model.data <- .Call("get_data", p, PACKAGE = "rjags")
  model <- list(ptr = function() {
    p
  }, data = function() {
    model.data
  }, model = function() {
    model.code
  }, state = function(internal = FALSE) {
    if (!internal) {
      for (i in 1:n.chains) {
        model.state[[i]][[".RNG.state"]] <- NULL
        model.state[[i]][[".RNG.name"]] <- NULL
      }
    }
    return(model.state)
  }, nchain = function() {
    .Call("get_nchain", p, PACKAGE = "rjags")
  }, iter = function() {
    .Call("get_iter", p, PACKAGE = "rjags")
  }, sync = function() {
    model.state <<- .Call("get_state", p, PACKAGE = "rjags")
  }, recompile = function() {
    .Call("clear_console", p, PACKAGE = "rjags")
    p <<- .Call("make_console", PACKAGE = "rjags")
    mf <- tempfile()
    writeLines(model.code, mf)
    .Call("check_model", p, mf, PACKAGE = "rjags")
    unlink(mf)
    .Call("compile", p, data, n.chains, FALSE, PACKAGE = "rjags")
    if (!is.null(model.state)) {
      if (length(model.state) != n.chains) {
        stop("Incorrect number of chains in saved state")
      }
      for (i in 1:n.chains) {
        statei <- model.state[[i]]
        rng <- statei[[".RNG.name"]]
        if (!is.null(rng)) {
          .Call("set_rng_name", p, rng, i, PACKAGE = "rjags")
          statei[[".RNG.name"]] <- NULL
        }
        .Call("set_parameters", p, statei, i, PACKAGE = "rjags")
      }
      .Call("initialize", p, PACKAGE = "rjags")
      adapting <- .Call("is_adapting", p, PACKAGE = "rjags")
      if (n.adapt > 0 && adapting) {
        cat("Adapting\n")
        .Call("update", p, n.adapt, PACKAGE = "rjags")
        if (!.Call("check_adaptation", p, PACKAGE = "rjags")) {
          warning("Adaptation incomplete")
        }
      }
      model.state <<- .Call("get_state", p, PACKAGE = "rjags")
    }
    invisible(NULL)
  })
  class(model) <- "jags"
  if (n.adapt > 0) {
    pb <- if (quiet) 
      NULL
    else getOption("jags.pb")
    ok <- adapt(model, n.adapt, end.adaptation = FALSE, progress.bar = pb)
    if (ok) {
      .Call("adapt_off", p, PACKAGE = "rjags")
    }
    else {
      warning("Adaptation incomplete")
    }
  }
  return(model)
}