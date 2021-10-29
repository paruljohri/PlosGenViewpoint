Description of files in the HIV folder:

1. Slim script to simulate a single site as a nucleotide model, with two beneficial and two neutral alleles: 
>> single_site_sweeps_ntd.slim

2. Bash script to run the above in SLURM:
>> run_single_site_sweeps_ntd.sh

3. Output obtained from the bash script above:
>> single_site_sweeps_ntd_1.out

4. Python script used to process the output from the SLiM script:
>> python get_frequency_30_60_90.py input_filename ntd

5. Output from the python script (step 4):
>> single_site_sweeps_ntd_1.out.freq
