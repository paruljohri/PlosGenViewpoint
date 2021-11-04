#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-10:00
#SBATCH -o /home/pjohri1/LOGFILES/stats_plosgen_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/stats_plosgen_%j.err

module load perl/5.22.1
module load gcc/6.3.0
echo "SLURM_JOBID: " $SLURM_JOBID
#########################################
#AGAVE
#Models simulated and their index:
#Arguello_const_rec [0]
#Arguello_const_rec_low [1]
#Arguello_var_rec_droso [2]
#Arguello_var_rec_random [3]
#zambia_Johri_const_rec [4]
#zambia_Johri_var_rec_droso [5]
#zambia_Johri_var_rec_random [6]
#Duchen_const_rec [7]
#Duchen_const_rec_low [8]
#Duchen_var_rec_droso [9]
#Duchen_var_rec_random [10]
#LiandStephan_const_rec [11]
#LiandStephan_var_rec_droso [12]
#LiandStephan_var_rec_random [13]
#Arguello_neutral_const_rec_low [14]
#Arguello_neutral_const_rec_low_scaled50 [15]
#Arguello_neutral_const_rec_low_scaled20 [16]
#Arguello_DFE_const_rec_low [17]
#Arguello_DFE_var_rec_droso [18]
#Duchen_neutral_const_rec_low [19]
#Duchen_DFE_const_rec_low [20]
#Duchen_DFE_var_rec_droso [21]
##########################################

list_models=("Arguello_const_rec" "Arguello_const_rec_low" "Arguello_var_rec_droso" "Arguello_var_rec_random" "zambia_Johri_const_rec" "zambia_Johri_var_rec_droso" "zambia_Johri_var_rec_random" "Duchen_const_rec" "Duchen_const_rec_low" "Duchen_var_rec_droso" "Duchen_var_rec_random" "LiandStephan_const_rec" "LiandStephan_var_rec_droso" "LiandStephan_var_rec_random" "Arguello_neutral_const_rec_low" "Arguello_neutral_const_rec_low_scaled50" "Arguello_neutral_const_rec_low_scaled20" "Arguello_DFE_const_rec_low" "Arguello_DFE_var_rec_droso" "Duchen_neutral_const_rec_low" "Duchen_DFE_const_rec_low" "Duchen_DFE_var_rec_droso")

folder=${list_models[$1]}

echo "folder: " ${folder}

#make a new folder for this simulation ID
mkdir /scratch/pjohri1/PlosgenDroso/statistics/${folder}_stats

#Unzip the folder:
cd /scratch/pjohri1/PlosgenDroso/simulations
echo "zipping folder"
tar -zxvf ${folder}.tar.gz

#Get some basic stats:
#python /home/pjohri1/SlimStats/statistics_slidingwindow_pylibseq_general_reps.py -winSize 10000 -stepSize 10000 -regionLen 100000 -input_folder /scratch/pjohri1/PlosgenDroso/simulations/${folder} -output_folder /scratch/pjohri1/PlosgenDroso/simulations/${folder}_stats -output_prefix ${folder}

#Rscript /home/pjohri1/SlimStats/get_winsummary_general.R /scratch/pjohri1/PlosgenDroso/simulations/${folder}_stats ${folder} 100000 10000

#H1/H2 stats::
cd /scratch/pjohri1/PlosgenDroso/simulations/${folder}
repID=1
while [ $repID -lt 301 ];
do
    file="output${repID}.ms"
    segsites=`cat $file | grep segsites | cut -f2 -d' '`
    lineNo=`cat $file | grep -n segsites | cut -f1 -d ':'`
    (( lineNo = lineNo + 146 ))
    cat $file | head -${lineNo} | tail -146 > ${file}_cut

    python /home/pjohri1/PlosgenDroso/Harris_etal_response-master/convertMS.py ${file}_cut ${file}_MS

    python /home/pjohri1/PlosgenDroso/Harris_etal_response-master/H12_H2H1_simulations.py ${file}_MS 145 -o ${file}_cluster_snps -w 401 -j 50 -d 0 -s 0.5
    repID=$(( ${repID} + 1 ))
done
cat *_cluster_snps > /scratch/pjohri1/PlosgenDroso/statistics/${folder}_stats/${folder}_H12.stats

#Remove the folder
cd /scratch/pjohri1/PlosgenDroso/simulations
rm -r ${folder}


