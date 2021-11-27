#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-5:00
#SBATCH -o /home/pjohri1/LOGFILES/Arguello_msp_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/Arguello_msp_%j.err

module load perl/5.22.1
echo "SLURM_JOBID: " $SLURM_JOBID
######################################
#To be run on AGAVE!
#100 simulations per submitted job!
#######################################

#folder="msprime_Arguello_const_rec_scaled100_nomigration_allpopns"
#folder="msprime_Arguello_const_rec_scaled100_zimanc"
#folder="msprime_Arguello_const_rec_scaled100_net_growth"
#folder="msprime_Arguello_const_rec_scaled100_ith_growth"
#folder="msprime_Arguello_const_rec_scaled100_netanc"
#folder="msprime_Arguello_const_rec_scaled100_nomigration_ith_nogrowth"
#folder="msprime_Arguello_const_rec_scaled100_nomigration_ith_admixture"
#folder="msprime_Arguello_const_rec_scaled100_nomigration_ith_admixture_gen0"
#folder="msprime_Arguello_const_rec_scaled100_nomigration_ith_admixture_sample"
#folder="msprime_Arguello_const_rec_scaled100_ith_nogrowth"
#folder="msprime_Arguello_const_rec_ith_nogrowth"
folder="msprime_Arguello_const_rec_nomigration_ith_nogrowth"



#make a new folder for this simulation ID
mkdir /scratch/pjohri1/PlosgenDroso/rescaling_debugging/${folder}

#run the simulations
cd /home/pjohri1/PlosgenDroso/rescaling_debugging
echo "Running msprime"
repID=1
while [ $repID -lt 11 ];
do
    python simulate_${folder}.py -outFolder /scratch/pjohri1/PlosgenDroso/rescaling_debugging/${folder} -repNum ${repID} -recType low
    repID=$(( ${repID} + 1 ))
done


#Zip the folder:
cd /scratch/pjohri1/PlosgenDroso/rescaling_debugging
echo "zipping folder"
tar -zcvf ${folder}.tar.gz ${folder}

#Remove the folder
cd /scratch/pjohri1/PlosgenDroso/rescaling_debugging
rm -r ${folder}


