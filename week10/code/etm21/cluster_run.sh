#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
cp $HOME/etm21_HPC_2021_main.R .
echo "R is about to run"
R --vanilla < $HOME/etm21_HPC_2021_cluster.R
mv sim_results_* $HOME
echo "R has finished running"