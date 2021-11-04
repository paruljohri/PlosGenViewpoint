#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -s
#SBATCH -a 1-100%80
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-24:00
#SBATCH -o /home/pjohri/LOGFILES/Duchenvar_%A_rep%a.out
#SBATCH -e /home/pjohri/LOGFILES/Duchenvar_%A_rep%a.err

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID

######################################
#To be run on GROMIT!
#100 simulations per submitted job!
#######################################

folder="Duchen_DFE_var_rec_droso"

#make a new folder for this simulation ID
mkdir /home/pjohri/PlosgenDroso/simulations/${folder}

#run the simulations
cd /home/pjohri/PlosgenDroso/programs
echo "Running slim"
declare -i repID=200+$SLURM_ARRAY_TASK_ID
if [ ! -f "/home/pjohri/PlosgenDroso/simulations/${folder}/output${repID}.ms" ]
then
    echo "Running rep"${repID}
	/mnt/storage/software/slim.3.1/build/slim -d d_seed=${repID} -d "d_repID='${repID}'" -d "d_folder='/home/pjohri/PlosgenDroso/simulations/${folder}'" Duchen_DFE_var_rec_droso_scaled300.slim
fi


