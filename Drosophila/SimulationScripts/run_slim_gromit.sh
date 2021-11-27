#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -s
#SBATCH -a 1-100%100
#SBATCH -n 1 #number of tasks
#SBATCH --time=2-0:00
#SBATCH -o /home/pjohri/LOGFILES/slim_%A_rep%a.out
#SBATCH -e /home/pjohri/LOGFILES/slim_%A_rep%a.err

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID

######################################
#To be run on GROMIT!
#100 simulations per submitted job!
#######################################

#folder="slim_Arguello_neutral_const_rec_low_scaled100_ith_nogrowth"
#folder="slim_Arguello_neutral_var_rec_droso_scaled100_ith_nogrowth"
#folder="slim_Arguello_DFE_var_rec_droso_scaled100_ith_nogrowth"
#folder="slim_Duchen_neutral_const_rec_low_scaled300_ral_nogrowth"
#folder="slim_Duchen_neutral_var_rec_droso_scaled300_ral_nogrowth"
folder="slim_Duchen_DFE_var_rec_droso_scaled300_ral_nogrowth"

#make a new folder for this simulation ID
mkdir /home/pjohri/PlosgenDroso/simulations_final/${folder}

#run the simulations
cd /home/pjohri/PlosgenDroso/programs_final
echo "Running slim"
declare -i repID=0+$SLURM_ARRAY_TASK_ID
/mnt/storage/software/slim.3.1/build/slim -d d_seed=${repID} -d "d_repID='${repID}'" -d "d_folder='/home/pjohri/PlosgenDroso/simulations_final/${folder}'" ${folder}.slim



