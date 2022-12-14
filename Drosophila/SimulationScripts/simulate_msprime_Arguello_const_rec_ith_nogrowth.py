#ALERT!!!! Dec 14th, 2022: Debora Brandt has just alerted me of a dicrepancy between teh values presented in Table 3 and the text of Arguello et al. 
#The values of split times presented in Table 3 of Rguello et al are actually in the "number of years". So the values of time in the script have to be multiplied by 10 (assuming 10 generations in 1 year).
#This is to simulate a chromosome of size 100kb using msprime and output data in ms format:
#python simulate_msprime_Arguello_const_rec.py -outFolder /scratch/pjohri1/PlosgenDroso/simulations/Arguello_const_rec -repNum repID
import sys
import os
import msprime
import math
import argparse

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-outFolder', dest = 'outFolder', action='store', nargs = 1, type = str, help = 'full path to output folder')#output foldername
#parser.add_argument('-simNum', dest = 'simNum', action='store', nargs = 1, type = int, help = 'simulation number')
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
mutn_rate = 1.39e-9
chrom_len = 100000
num_indv = 145 #sample size
s_seed = int(repID)


def Arguello_INZ():
    #mean estimates of population sizes:
    Ncur_ith = 5.54e5
    Ncur_net = 1.60e6
    Ncur_zim = 3.98e6
    Nanc_ith = 8.39e2
    Nanc_net = 3.78e4
    Nanc_zim = 1.93e6
    Admix_prop_zim=1.82e-1
    #estimates of time in number of generations:
    Tsplit_ith = 179.0
    Tsplit_net = 2.0e4
    Tgrowth_zim = 1.13e5
    #Growth rates:
    #Figure out the two growth rates for ithaca and netherland populations:
    #Ncur_ith = Nanc_ith / math.exp(-r_ith * Tsplit_ith)
    r_ith = (-1.0/Tsplit_ith)*math.log(Nanc_ith/Ncur_ith)
    r_net = (-1.0/Tsplit_net)*math.log(Nanc_net/Ncur_net)
    #Migrations rates where M = 2Nm
    #These are given backwards in time in the paper and msprime also models it backwards in time.
    M_ith_net = 64.3
    M_net_ith = 66.7
    M_zim_net = 80.0
    M_net_zim = 30.1
    M_ith_zim = 11.9
    M_zim_ith = 57.9
    Manc_zim_net = 17.4
    Manc_net_zim = 17.8
    #Calculate m = M/(2*Ncur_of_first_popn), personal sommunication with Stefan
    m_ith_net = M_ith_net/(2.0*Ncur_ith)
    m_net_ith = M_net_ith/(2.0*Ncur_net)
    m_zim_net = M_zim_net/(2.0*Ncur_zim)
    m_net_zim = M_net_zim/(2.0*Ncur_net)
    m_ith_zim = M_ith_zim/(2.0*Ncur_ith)
    m_zim_ith = M_zim_ith/(2.0*Ncur_zim)
    manc_zim_net = Manc_zim_net/(2.0*Ncur_zim) #as Zim has const population till then
    manc_net_zim = Manc_net_zim/(2.0*Ncur_net) #don't know this one! Check!
    #Setting up initial populations such that zim=0, net=1, ith=2
    population_configurations = [
        msprime.PopulationConfiguration(sample_size=0, initial_size=Ncur_zim, growth_rate=0), 
        msprime.PopulationConfiguration(sample_size=0, initial_size=Ncur_net, growth_rate=r_net),
        msprime.PopulationConfiguration(sample_size=num_indv, initial_size=Ncur_ith, growth_rate=0)
    ]
    #migration matrix
    migration_matrix = [
        [0, m_zim_net, m_zim_ith],
        [m_net_zim, 0, m_net_ith],
        [m_ith_zim, m_ith_net, 0],
    ]
    demographic_events = [
        #Ithaca population splits equally and merges into the Zim and Net populations
        msprime.MassMigration(time=Tsplit_ith, source=2, destination=0, proportion=Admix_prop_zim),
        msprime.MassMigration(time=Tsplit_ith, source=2, destination=1, proportion=1.0),
        #migration rates change to ancestral rates between zim and net:
        msprime.MigrationRateChange(time=Tsplit_ith, rate=0),
        msprime.MigrationRateChange(time=Tsplit_ith, rate=manc_zim_net, matrix_index=(0, 1)),
        msprime.MigrationRateChange(time=Tsplit_ith, rate=manc_net_zim, matrix_index=(1, 0)),
        #Net popn merges into Zim:
        msprime.MassMigration(time=Tsplit_net, source=1, destination=0, proportion=1.0),
        #stop migration again:
        msprime.MigrationRateChange(time=Tsplit_net, rate=0),
        # Size changes to Nanc_zim at Tgrowth_zim
        msprime.PopulationParametersChange(time=Tgrowth_zim, initial_size=Nanc_zim, growth_rate=0, population_id=0)
        ]
    return (population_configurations, demographic_events, migration_matrix)

try:
    f_check = open(out_folder + "/output" + str(repID) + ".ms", 'r')
    f_check.close()
except:
    #get the poopulation configuration and demographic events
    t_tmp = Arguello_INZ()#function defined above
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
    #write out genotypes for the ithaca population
    i = 0
    while i < num_indv:
        for site in l_sites:
            result.write(str(d_geno[site][i]))
        result.write('\n')
        i = i + 1
    result.close()

print ("done")

