Description of files/folders:

1. Folder name: Dmel_rec_rates
Has the recombination rates estimated by Comeron et al and also rates from sampled 100kb genomic elements (1000 in number).

2. File name: sample_100kb_Droso_regions.py
Python script used to subsample 100 kb regions from the Drosophila genome and write out the recombination rates.

3. Folder name: SimulationScripts
Has the SLiM and msprime scripts to simulate Arguello et al and Duchen et al models.
Also has the Slurm submission scripts.
<<<<<<<<<<ALERT!!!! Dec 14th, 2022: Debora Brandt has just alerted me of a dicrepancy between the values presented in Table 3 and the text of Arguello et al. The values of split times presented in Table 3 of Arguello et al are actually given in the "number of years" (not generations). So the values of time in the simulation scripts have to be multiplied by 10 (assuming 10 generations in 1 year).>>>>>>>>>>>>

4. Folder name: H12StatsScripts
Has scripts adapted from the authors of Garud et al, to calculate H12 stats from 100kb genomic regions.

5. File name: plot_H12_densityplots_final.r
R script to plot the distribution of H12 stats.

