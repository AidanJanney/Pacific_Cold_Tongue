## <span style="color:red">Note</span>: github branches
Make sure to run in the CrocoDash Directory:

`git pull`

`git checkout Jofia_Pacific_Cold_Tongue` (unless otherwise specified)

`git submodule update --init --recursive`


## Choosing Notebooks
Note: run these notebooks from a casper node (login or PBS Batch/qvscode) because derecho still throws a weird mpi error. 


### `new_case.ipynb` – Changing horizontal resolution
This will walk through generating each piece of the case from scratch. Make sure to use different names for the horizontal grid and the case itself otherwise you risk overriding a previous case. 

Note: Either run this notebook on a node with large resources (for the bathymetry regrid step), or run it cell by cell and use the `mpi_interpolate_from_file()` function and follow the instructions. 

**See the `process_bathy_casper.sh` and `process_bathy_derecho.sh` scripts. Submit whichever system you are on. Casper will likely queue faster.**
The current setup for casper uses all of the 100GB of memory, but it also runs in 6 minutes, so not an issue.

- If you are changing the horizontal grid or using a different source bathymetry dataset, you must use this notebook. 
- You will also be able to change the vertical grid (or load it from a file). Then all the forcings must be regenerated as well. 


### `modify_case.ipynb` – loads already regridded bathymetry, still able to edit bathymetry, change date range, change forcings, etc.
If you are only changing the vertical grid, the date range, or the forcings, you can use this notebook. It will load a horizontal grid and a regridded bathymetry already. You are still able to modify the regridded bathymetry with the TopoEditor.
- Assumes you still need to change something significant about the case (e.g. forcings or vertical grid), but you can skip the expensive bathymetry regridding step. 
- Will walk through the case generation and forcings generation/regridding process. 
- Will create entirely new input directory, case, forcing files, grid files, etc.

**See notebook for guide on running driver!**
  

### I only want to change the physics, not the grids/bathymetry/forcings
Here we can back out of CrocoDash a little and use the `create_clone` utility built into CESM and CIME.
1. `cd /glade/.../CESM-version/cime/scripts`
2. Run `./create_clone --case NEW_CASE_PATH --clone OLD_CASE_PATH`

This will create an identical copy of the case contents, allowing you to modfiy the user_nl_mom, the diag_table, and anything else in the case directory. Then you need to `./case.build && ./case.submit` again. 

It does NOT create a duplicate of the input directory contents (grids, bathymetry, forcings). Instead it points to the same input directory as the original case, meaning that you should not use `./create_clone` if you would like to change any of these. Also be careful modifying old case input directories you may have cloned from, as it could affect many more cases. 

## Running Very Long Spans (specal note: leap year calendar)
Use `./xmlquery` and `./xmlchange` from within your case directory with all of the following variables.

This is where you want to use the RESUBMIT and modify the values of STOP_N and STOP_OPTION. 
[CESM Tutorial on Run Length](https://ncar.github.io/CESM-Tutorial/notebooks/modifications/xml/run_length/changing_run_length.html)

- STOP_OPTION: Units for how long to run (ndays, nmonths, nyears)
- STOP_N: number of units to run for (e.g. 5)
  - Run model for six days: `./xmlchange STOP_N=6, STOP_OPTION="ndays"`
- RESUBMIT: Number of times to save the restart files and start another run of the same length

Example: If STOP_OPTION=nmonths, STOP_N=4, and RESUBMIT=2, it will run for 12 months. 
Runs for 4 months, resubmits (1), runs for another 4 months (8 total), resubmits (2), runs for another 4 months (12 total). 

### Note: Leap years
If you are running with a year that is a leap year (2000,2004,...), you need to change the calendar type. 
- Check the current calendar: `./xmlquery CALENDAR` will likely return NO_LEAP or GREGORIAN
- Change it to GREGORIAN: `./xmlchange CALENDAR="GREGORIAN"`