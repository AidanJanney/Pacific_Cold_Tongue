#!/bin/bash -l
#PBS -N process_bathy.sh
#PBS -A p93300012
#PBS -l select=1:ncpus=32
#PBS -l walltime=00:20:00
#PBS -q main
#PBS -m abe

module purge
module load ncarenv-basic/24.12  
module load gcc/12.4.0
module load cray-mpich/8.1.29
module load esmf/8.8.0

echo "Starting job at `date`"
mpirun -wd ./mpi_logs -np 30 ESMF_Regrid -s bathymetry_original.nc -d bathymetry_unfinished.nc -m bilinear --src_var depth --dst_var depth --netcdf4 --src_regional --dst_regional