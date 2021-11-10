#!/bin/bash

#SBATCH --job-name=mpi_hw3
#SBATCH --mail-type=END
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --exclusive
#SBATCH --time=00:05:00
#SBATCH --account=eecs587f21_class
#SBATCH --partition=standard

{ time ./main > out.txt ; } 2> time.txt
