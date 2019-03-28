#!/bin/bash

###### Set paths ########

PLINKFILES="test/test" # Include the file prefix and not the extension eg. file not file.bed
PLINK_PATH="/pathto/plink"
GCTA_PATH="/pathto/gcta64"
BIMBAM_PATH='/pathto/bimbam'
GEMMA_PATH='/pathto/gemma'
GRM="test"
PHENO="test/test.phen"
out="test"
chr="1"

mkdir output
mkdir fm_tmp

####### GWAS + J-test ########

# If the GRM has been computed comment this command and edit the path in the next command
${GCTA_PATH}  --bfile ${PLINKFILES}  --autosome  --make-grm  --out fm_tmp/${GRM}

${GCTA_PATH} --bfile ${PLINKFILES} --pheno ${PHENO} --mlma --out output/${out} --grm fm_tmp/${GRM} --chr ${chr}

Rscript src/jtest.R ${out} ${PLINKFILES} ${PHENO} ${PLINK_PATH}

##

## BIMBAM

${PLINK_PATH} --bfile ${PLINKFILES} --chr ${chr} --recode bimbam-1chr --out fm_tmp/${out}

${BIMBAM_PATH} -g fm_tmp/${out}.recode.geno.txt -p fm_tmp/${out}.recode.pheno.txt -pos fm_tmp/${out}.recode.pos.txt -sort -df 1 -o ${out}

python src/bimbam_credsets.py ${out}

##

## BSLMM

# If the phenotype is not in the fam file run this, and use these plink files
# ${PLINK_PATH}/plink --bfile ${PLINKFILES} --pheno ${PHENO} --make-bed --out new_plinkfiles

${GEMMA_PATH} -bfile ${PLINKFILES} -bslmm 1 -o ${out}

python src/bslmm_credsets.py ${out}

##

rm -r fm_tmp/

