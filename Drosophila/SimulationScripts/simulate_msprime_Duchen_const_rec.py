#This is to simulate a chromosome of size 100kb using msprime and output data in ms format:
#python simulate_msprime_Duchen_const_rec.py -outFolder /scratch/pjohri1/PlosgenDroso/simulations/Duchen_const_rec -repNum repID -recType mean
#python simulate_msprime_Duchen_const_rec.py -outFolder /scratch/pjohri1/PlosgenDroso/simulations/Duchen_const_rec_low -repNum repID -recType low
import sys
import os
import msprime
import math
import argparse

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-outFolder', dest = 'outFolder', action='store', nargs = 1, type = str, help = 'full path to output folder')#output foldername
parser.add_argument('-repNum', dest = 'repNum', action='store', nargs = 1, type = int, help = 'replicate number')
parser.add_argument('-recType', dest = 'recType', action='store', nargs = 1, type = str, help = 'mean/low')

args = parser.parse_args()
out_folder = args.outFolder[0]
repID = args.repNum[0]
rec_type = args.recType[0]

#define some constants:
if rec_type == "mean":
    rec_rate = 1e-8
elif rec_type == "low":
    rec_rate = 0.5e-8
mutn_rate = 1.0e-9
chrom_len = 100000
num_indv = 150 #sample size
s_seed = int(repID)


def Duchen_Model_C():
    #mean estimates for the African population:
    Nanc_zim = 5224100.0
    Nbot_zim = 620.0
    duration_bot_zim = 1000.0 #generations
    Tbot_zim = (237227.0*10) - duration_bot_zim #in generations
    Ncur_zim = 4975360.0
    #mean estimates for the European
    Ncur_net = 3122470.0
    Nanc_net = round(10.0**(4.23))
    Ncur_ral = 15984500.0
    Nanc_ral = round(10.0**(3.40))
    Tsplit_net = round(10.0**(5.29)) #in generations
    Tadm = round(10.0**(3.16)) #in generations
    Admix_prop_net = 0.85
    #Growth rates:
    #Figure out the two growth rates for the raleigh and netherland populations:
    r_ral = (-1.0/Tadm)*math.log(Nanc_ral/Ncur_ral)
    r_net = (-1.0/Tsplit_net)*math.log(Nanc_net/Ncur_net)
    #No migration in this model.
    #Setting up initial populations such that zim=0, net=1, ral=2
    population_configurations = [
        msprime.PopulationConfiguration(sample_size=0, initial_size=Ncur_zim, growth_rate=0),
        msprime.PopulationConfiguration(sample_size=0, initial_size=Ncur_net, growth_rate=r_net),
        msprime.PopulationConfiguration(sample_size=num_indv, initial_size=Ncur_ral, growth_rate=r_ral)
    ]
    #migration matrix
    migration_matrix = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
    ]
    demographic_events = [
        #Raleigh population splits and merges into the Zim(0) and Net(1) populations
        msprime.MassMigration(time=Tadm, source=2, destination=1, proportion=Admix_prop_net),
        msprime.MassMigration(time=Tadm, source=2, destination=0, proportion=1.0),
        #Net popn merges into Zim:
        msprime.MassMigration(time=Tsplit_net, source=1, destination=0, proportion=1.0),
        # A bottleneck occurs in the African population
        msprime.PopulationParametersChange(time=Tbot_zim, initial_size=Nbot_zim, growth_rate=0, population_id=0),
        msprime.PopulationParametersChange(time=Tbot_zim+duration_bot_zim, initial_size=Nanc_zim, growth_rate=0, population_id=0)
        ]
    return (population_configurations, demographic_events, migration_matrix)

try:
    f_check = open(out_folder + "/output" + str(repID) + ".ms", 'r')
    f_check.close()
except:
    #get the population configuration and demographic events
    print ("recombination rate: " + str(rec_rate))
    t_tmp = Duchen_Model_C()#function defined above
    population_configurations = t_tmp[0]
    demographic_events = t_tmp[1]
    migration_matrix = t_tmp[2]

    #check demographic history:
    dd = msprime.DemographyDebugger(population_configurations=population_configurations, demographic_events=demographic_events, migration_matrix=migration_matrix)
    dd.print_history()

    #simulate
    tree = msprime.simulate(population_configurations=population_configurations, demographic_events=demographic_events, migration_matrix=migration_matrix, length=chrom_len, recombination_rate=rec_rate, mutation_rate=mutn_rate, random_seed=s_seed)
    
    #Get positions of SNPs
    d_posn, d_geno = {}, {}
    l_sites = []
    for variant in tree.variants():
        l_sites.append(variant.site.id)
        d_posn[variant.site.id] = round(float(variant.site.position)/chrom_len, 7)
        d_geno[variant.site.id] = variant.genotypes
        #print ('\t' + variant.site.position)
    print("number of SNPs:" + str(len(d_geno)))
    
    #write in file
    result = open(out_folder + "/output" + str(repID) + ".ms", 'w+')
    result.write("//" + '\n')
    result.write("segsites: " + str(len(l_sites)) + '\n')
    result.write("positions:")
    for site in l_sites:
        result.write(" " + str(d_posn[site]))
    print("number of genomes:" + str(len(d_geno[l_sites[0]])))
    result.write('\n')
    #write out genotypes for the raleigh population
    i = 0
    while i < num_indv:
        for site in l_sites:
            result.write(str(d_geno[site][i]))
        result.write('\n')
        i = i + 1
    result.close()

print ("done")

