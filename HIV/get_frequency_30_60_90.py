#This is to get a probability from bash output:
#python get_frequency_30_60_90.py /path/to/file ntd

import sys
import numpy as np
s_type = sys.argv[2] #ntd or nonntd
cutoff_freq = 0.95

N = 100000
singleton_freq = float(1.0/(2.0*N))
mutn_rate = 1.0e-5
num_new_mutns = float(2.0*N*mutn_rate)

def mean_of_list(l_values):
    if len(l_values) > 0:
        s_mean = str(np.mean(l_values))
    else:
        s_mean = "NA"
    return(s_mean)

f_out = open(sys.argv[1], 'r')
result = open(sys.argv[1] + ".freq", 'w+')
result.write("selection1" + '\t' + "selection2" + '\t' + "sweep_30" + '\t' + "nosweep_30" + '\t' +  "soft_feder_30" + '\t' + "soft_30" + '\t' + "soft_60" + '\t' + "soft_90" + '\t')
if s_type == "nonntd":
    result.write( "freq_m1_30" + '\t' + "freq_m2_30" + '\t' + "freq_m1_60" + '\t' + "freq_m2_60" + '\t' + "freq_m1_90" + '\t' + "freq_m2_90" + '\n')
elif s_type == "ntd":
    result.write( "freq_C_30" + '\t' + "freq_T_30" + '\t' + "freq_C_60" + '\t' + "freq_T_60" + '\t' + "freq_C_90" + '\t' + "freq_T_90" + '\n')

sweep_count = ""
no_sweep_count = 0
soft_feder = 0
soft_30, soft_60, soft_90 = 0, 0, 0
check_30, check_60, check_90 = 0, 0, 0
d_freq = {}
d_freq["m1"], d_freq["m2"] = {}, {}
for line in f_out:
    line1 = line.strip('\n')
    if "selection 1:" in line:
        if sweep_count!="":
            #print (str(sel1) + '\t' + str(soft_30))
            result.write(sel1 + '\t' + sel2 + '\t' + str(sweep_count) + '\t' + str(nosweep_count) + '\t' + str(soft_feder) + '\t' + str(soft_30) + '\t' + str(soft_60) + '\t' + str(soft_90) + '\t' + mean_of_list(d_freq["m1"]["30"]) + '\t' + mean_of_list(d_freq["m2"]["30"]) + '\t' + mean_of_list(d_freq["m1"]["60"]) + '\t' + mean_of_list(d_freq["m2"]["60"]) + '\t' + mean_of_list(d_freq["m1"]["90"]) + '\t' + mean_of_list(d_freq["m2"]["90"]) + '\n')
        sel1 = line1.split().pop()
    if "selection 2:" in line:
        #if sweep_count!="":
        #    result.write(sel1 + '\t' + sel2 + '\t' + str(sweep_count) + '\t' + str(nosweep_count) + '\t' + str(soft_feder) + '\t' + str(soft_30) + '\t' + str(soft_60) + '\t' + str(soft_90) + '\t' + str(np.mean(d_freq["m1"]["30"])) + '\t' + str(np.mean(d_freq["m2"]["30"])) + '\t' + str(np.mean(d_freq["m1"]["60"])) + '\t' + str(np.mean(d_freq["m2"]["60"])) + '\t' + str(np.mean(d_freq["m1"]["90"])) + '\t' + str(np.mean(d_freq["m2"]["90"])) + '\n')
        sel2 = line1.split().pop()
        sweep_count = 0
        nosweep_count = 0
        soft_feder = 0
        soft_30, soft_60, soft_90 = 0, 0, 0
        d_freq["m1"]["30"], d_freq["m1"]["60"], d_freq["m1"]["90"] = [], [], []
        d_freq["m2"]["30"], d_freq["m2"]["60"], d_freq["m2"]["90"] = [], [], []
    if "soft feder sweep" in line:
        soft_feder += 1
    elif "sweep detected" in line:
        sweep_count += 1
    elif "sweep not detected" in line:
        nosweep_count += 1
    
    if "At generation 30" in line:
        check_30 = 1
    if "At generation 60" in line:
        check_60 = 1
    if "At generation 90" in line:
        check_90 = 1
    if check_30 == 1:
        if "freq of m1" in line or "freq of C" in line:
            line1 = line.strip('\n').replace('"', '')
            m1_freq = line1.split().pop()
            d_freq["m1"]["30"].append(float(m1_freq))
        if "freq of m2" in line or "freq of T" in line:
            line1 = line.strip('\n').replace('"', '')
            m2_freq = line1.split().pop()
            d_freq["m2"]["30"].append(float(m2_freq))
            #print (m1_freq + '\t' + m2_freq)
            if float(m1_freq) > cutoff_freq or float(m2_freq) > cutoff_freq:
                if sel1 == "10.0" and sel2 == "5.0":
                    print (m1_freq)
                    print (m2_freq)
                    print (soft_30)
                soft_30 += 1
            check_30 = 0
    if check_60 == 1:
        if "freq of m1" in line or "freq of C" in line:
            line1 = line.strip('\n').replace('"', '')
            m1_freq = line1.split().pop()
            d_freq["m1"]["60"].append(float(m1_freq))
        if "freq of m2" in line or "freq of T" in line:
            line1 = line.strip('\n').replace('"', '')
            m2_freq = line1.split().pop()
            d_freq["m2"]["60"].append(float(m2_freq))
            if float(m1_freq) > cutoff_freq or float(m2_freq) > cutoff_freq:
                soft_60 += 1
            check_60 = 0
    if check_90 == 1:
        if "freq of m1" in line or "freq of C" in line:
            line1 = line.strip('\n').replace('"', '')
            m1_freq = line1.split().pop()
            d_freq["m1"]["90"].append(float(m1_freq))
        if "freq of m2" in line or "freq of T" in line:
            line1 = line.strip('\n').replace('"', '')
            m2_freq = line1.split().pop()
            d_freq["m2"]["90"].append(float(m2_freq))
            #print(m1_freq + '\t' + m2_freq)
            if float(m1_freq) > cutoff_freq or float(m2_freq) > cutoff_freq:
                soft_90 += 1
            check_90 = 0
result.write(sel1 + '\t' + sel2 + '\t' + str(sweep_count) + '\t' + str(nosweep_count) + '\t' + str(soft_feder) + '\t' + str(soft_30) + '\t' + str(soft_60) + '\t' + str(soft_90) + '\t' + mean_of_list(d_freq["m1"]["30"]) + '\t' + mean_of_list(d_freq["m2"]["30"]) + '\t' + mean_of_list(d_freq["m1"]["60"]) + '\t' + mean_of_list(d_freq["m2"]["60"]) + '\t' + mean_of_list(d_freq["m1"]["90"]) + '\t' + mean_of_list(d_freq["m2"]["90"]) + '\n')
f_out.close()
result.close()
