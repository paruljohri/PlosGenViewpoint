#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-2:00
#SBATCH -o /home/pjohri1/LOGFILES/stats_final_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/stats_final_%j.err

module load perl/5.22.1
module load gcc/6.3.0
echo "SLURM_JOBID: " $SLURM_JOBID
#########################################
#AGAVE
############################################

#folder="slim_Arguello_neutral_const_rec_low_scaled100_ith_nogrowth"
#folder="slim_Arguello_neutral_var_rec_droso_scaled100_ith_nogrowth"
#folder="slim_Arguello_DFE_var_rec_droso_scaled100_ith_nogrowth"

#folder="slim_Duchen_neutral_const_rec_low_scaled300_ral_nogrowth"
#folder="slim_Duchen_neutral_var_rec_droso_scaled300_ral_nogrowth"
folder="slim_Duchen_DFE_var_rec_droso_scaled300_ral_nogrowth"

echo "folder: " ${folder}

#Unzip the folder:
cd /scratch/pjohri1/PlosgenDroso/simulations_final
echo "zipping folder"
tar -zxvf ${folder}.tar.gz

#Get some basic stats:
#python /home/pjohri1/SlimStats/statistics_slidingwindow_pylibseq_general_reps.py -winSize 10000 -stepSize 10000 -regionLen 100000 -input_folder /scratch/pjohri1/PlosgenDroso/simulations/${folder} -output_folder /scratch/pjohri1/PlosgenDroso/simulations/${folder}_stats -output_prefix ${folder}

#Rscript /home/pjohri1/SlimStats/get_winsummary_general.R /scratch/pjohri1/PlosgenDroso/simulations/${folder}_stats ${folder} 100000 10000

#H1/H2 stats::
cd /scratch/pjohri1/PlosgenDroso/simulations_final/${folder}
files=(*.ms)
echo ${files[@]}
for file in "${files[@]}"
do
    segsites=`cat $file | grep segsites | cut -f2 -d' '`
    lineNo=`cat $file | grep -n segsites | cut -f1 -d ':'`
    (( lineNo = lineNo + 146 ))
    cat $file | head -${lineNo} | tail -146 > ${file}_cut

    python /home/pjohri1/PlosgenDroso/Harris_etal_response-master/convertMS.py ${file}_cut ${file}_MS

    python /home/pjohri1/PlosgenDroso/Harris_etal_response-master/H12_H2H1_simulations.py ${file}_MS 145 -o ${file}_cluster_snps -w 401 -j 50 -d 0 -s 0.5
done
cat *_cluster_snps > /scratch/pjohri1/PlosgenDroso/simulations_final/${folder}_H12.stats

#Remove the folder
cd /scratch/pjohri1/PlosgenDroso/simulations_final
rm -r ${folder}


