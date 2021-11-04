#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-10:00
#SBATCH -o /home/pjohri1/LOGFILES/Arguello_droso_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/Arguello_droso_%j.err

module load perl/5.22.1
echo "SLURM_JOBID: " $SLURM_JOBID
######################################
#To be run on AGAVE!
#100 simulations per submitted job!
#######################################

folder="Arguello_var_rec_droso"

#make a new folder for this simulation ID
mkdir /scratch/pjohri1/PlosgenDroso/simulations/${folder}

#run the simulations
cd /home/pjohri1/PlosgenDroso/programs
echo "Running msprime"
repID=101
while [ $repID -lt 1001 ];
do
    python simulate_msprime_Arguello_var_rec.py -outFolder /scratch/pjohri1/PlosgenDroso/simulations/${folder} -repNum ${repID} -recMap droso
    repID=$(( ${repID} + 1 ))
done


#Zip the folder:
cd /scratch/pjohri1/PlosgenDroso/simulations
echo "zipping folder"
tar -zcvf ${folder}.tar.gz ${folder}

#Remove the folder
cd /scratch/pjohri1/PlosgenDroso/simulations
rm -r ${folder}


