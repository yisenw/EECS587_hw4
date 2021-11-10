#!/bin/bash

#SBATCH --job-name=mpi_hw3
#SBATCH --mail-type=END
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1 
#SBATCH --time=00:05:00
#SBATCH --account=eecs587f21_class 
#SBATCH --partition=gpu

{ time ./cudaa > out.txt ; } 2> time.txt
