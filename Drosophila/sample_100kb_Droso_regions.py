#This is to sample a 1000 regions of the Drosophila genome to get its recombination rate variation:
#Here recombination rate will be given in units cM/Mb.
#Format of the file is as per msprime 0.7.3.

import sys
import random

num_reps = 1000
lower_bound = 0.5 #That is, 0.5 cM/Mb, (=5 x 10^-7 cM/bp)

l_chrom = ["2L", "2R", "3L", "3R"]
l_rec_rates = []
for chrom in l_chrom:
    f_rate = open("/home/pjohri1/PlosgenDroso/Dmel_rec_rates/Dmel_coord_10kb_" + chrom + ".txt.rrc", 'r')
    for line in f_rate:
        line1 = line.strip('\n')
        line2 = line1.split()
        #print (line2)
        if line2[0] != "genomic_locus" and len(line2) > 0:
            l_rec_rates.append(line2[5]) #Comeron_midpoint_rate
    f_rate.close()

#sampling:
repID = 1
while repID <= num_reps:
    print(repID)
    #sample a random position across the entire set of positions:
    posn = random.randint(0, len(l_rec_rates)-10)
    #get the rates for the next 100 kb region:
    l_rec_rates_sampled = []
    m = 0
    while m < 10:
        l_rec_rates_sampled.append(l_rec_rates[posn + m])
        m = m + 1
    #check if any rates here are less than the cut-off value:
    check = 0
    for x in l_rec_rates_sampled:
        if float(x) > lower_bound:
            check = 1
    #If everything is okay, write it to a file and increase the repID:
    if check == 1:
        print ("writing in file")
        result = open("/home/pjohri1/PlosgenDroso/Dmel_rec_rates/100kb_1000replicates/rep" + str(repID) + ".rrc", 'w+')
        result.write("Chromosome" + '\t' + "Position(bp)" + '\t' + "Rate(cM/Mb)" + '\n')
        s_posn = 0
        for x in l_rec_rates_sampled:
            result.write("chrom" + '\t' + str(s_posn) + '\t' + x + '\n')
            s_posn += 10000
        result.write("chrom" + '\t' + "100000.0" + '\t' + "0.0" + '\n')
        result.close()
        repID += 1
print ("done")


