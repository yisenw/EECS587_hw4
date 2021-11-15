#!/bin/bash

#SBATCH --job-name=mpi_hw3
#SBATCH --mail-type=END
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1 
#SBATCH --time=00:05:00
#SBATCH --account=eecs587f21_class 
#SBATCH --partition=gpu

bash sel.sh
{ ./sel 2000 10 > out_sel_2000.txt ; } 2> time.txt
