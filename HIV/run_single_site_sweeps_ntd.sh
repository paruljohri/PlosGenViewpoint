#!/bin/bash
#SBATCH -n 2                        # number of cores
#SBATCH -t 1-00:00                  # wall time (D-HH:MM)
#SBATCH -o /home/pjohri1/HIVSweeps/simulations/single_site_sweeps_ntd_%j.out
#SBATCH -e /home/pjohri1/HIVSweeps/simulations/single_site_sweeps_ntd_%j.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

cd /home/pjohri1/HIVSweeps/programs
module load slim/3.3.1

selcoeff=(10.0 8.0 5.0 3.0 1.0 0.8 0.5 0.3 0.1)

for sel_1 in "${selcoeff[@]}"
do
    for sel_2 in "${selcoeff[@]}"
    do
        echo "selection 1: " $sel_1
        echo "selection 2: " $sel_2
        repID=1
        while [ $repID -lt 101 ];
        do
            slim -s ${repID} -d d_sC=${sel_1} -d d_sT=${sel_2} single_site_sweeps_ntd.slim
            repID=$(( ${repID} + 1 ))
        done
    done
done
