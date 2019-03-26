# Examining the Impact of Imputation Errors on Fine-Mapping Using DNA Methylation QTL as a Model Trait - Chundru et al. GENETICS 2019

This repository contains a pipeline to run the three Fine-mapping approaches (BIMBAM, BSLMM, and the J-test) and obtain credible sets from each.

# Prerequistes

 - BIMBAM: http://www.haplotype.org/bimbam.html
 - GEMMA: https://github.com/genetics-statistics/GEMMA
  - gsl
  - lapack
 - GCTA: http://cnsgenomics.com/software/gcta/index.html
 - R
 - python3
 - plink
 
# Running the methods

 - Edit the paths at the begining of the file run.sh
 - comment out any parts you don't wish to run in the run.sh file
 - execute the run.sh file
 
# Result files
  - output/foo.jtest.credsets is the credible set from the J-test
  - output/foo.bimbam.credsets is the credible set from BIMBAM
  - output/foo.bslmm.credsets is the credible set from the BSLMM
  
# Please feel free to contact me if you have any questions
