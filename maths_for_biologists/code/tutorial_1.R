max = 10
Nt_2 = c(1:max)
Nt_3 = c(1:max)

for (i in c(1:max)) {
  Nt_2[i] = 100 * exp(1) ^ (2 * i)
  Nt_3[i] = 100 * exp(1) ^ (3 * i)
}

plot(Nt_2, col = "red", type = "l")
lines(Nt_3, col =)
