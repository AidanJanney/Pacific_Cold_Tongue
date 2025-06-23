#!/bin/bash -l
#PBS -N process_bathy.sh
#PBS -A p93300012
#PBS -l select=1:ncpus=32:mpiprocs=30:mem=100GB
#PBS -l walltime=00:20:00
#PBS -q casper
#PBS -m abe

module purge
module load ncarenv-basic/24.12  
module load gcc/12.4.0  
module load openmpi/5.0.6
module load esmf/8.8.0

echo "Starting job at `date`"
mpirun -np 30 ESMF_Regrid -s bathymetry_original.nc -d bathymetry_unfinished.nc -m bilinear --src_var depth --dst_var depth --netcdf4 --src_regional --dst_regional
