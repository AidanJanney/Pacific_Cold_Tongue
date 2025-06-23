#!/bin/bash -l
#PBS -N large_data_workflow.sh
#PBS -A p93300012
#PBS -l select=1:ncpus=30
#PBS -l walltime=01:15:00
#PBS -q main
#PBS -m abe

module purge
module load conda

conda activate CrocoDash

## You change this. Don't forget the project code too!
large_data_workflow_path="/glade/work/ajanney/CrocoDash_Input/pacific_cold_tongue_0006/glorys/large_data_workflow"

python3 "$large_data_workflow_path/driver.py" # path to driver.py