#!/bin/bash

###### Set paths ########

PLINKFILES = "/pathto/plinkfiles/prefix" # Include the file prefix and not the extension eg. file not file.txt
PLINK_PATH = "/pathto/plinkbinary/"
GCTA_PATH = "/pathto/gctabinary/"
GRM = "/whereto/savegrm/prefix"
PHENO = "/pathto/phenofile/pheno.txt"
out = "/path/prefix"
chr = "chromosome"

####### GWAS + J-test ########

# If the GRM has not been computed uncomment this command
# ${GCTA_PATH}/gcta64  --bfile ${PLINKFILES}  --autosome  --make-grm  --out ${GRM}

${GCTA_PATH}/gcta64 --bfile ${PLINKFILES} --pheno ${PHENO} --mlma --out output/gwas_${out} --grm  --chr ${chr}

Rscript src/jtest.R ${out} ${PLINKFILES} ${PHENO} ${PLINK_PATH}

##

## BIMBAM

${PLINK_PATH}/plink --bfile ${PLINKFILES} --chr ${chr} --recode bimbam-1chr --out ${PLINKFILES}

cut -f 3 ${PHENO} > tmp.pheno

${BIMBAM_PATH}/bimbam -g ${PLINKFILES}.recode.geno.txt -p tmp.pheno -pos ${PLINKFILES}.recode.pos.txt -sort -df 1 -o ${out}

rm tmp.pheno

python src/bimbam_credsets.py ${out}

##

## BSLMM

# If the phenotype is not in the fam file run this, and use these plink files
# ${PLINK_PATH}/plink --bfile ${PLINKFILES} --pheno ${PHENO} --make-bed --out new_plinkfiles

/30days/uqvchun2/FineMapping/Code/bin/gemma -bfile ${PLINKFILES} -bslmm 1 -o ${probe}

python src/bslmm_credsets.py ${out}

##


