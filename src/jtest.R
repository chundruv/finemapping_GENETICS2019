out <- commandArgs(trailingOnly=TRUE)[1]
plinkfiles <- commandArgs(trailingOnly=TRUE)[2]
pheno <- commandArgs(trailingOnly=TRUE)[3]
plinkpath <- commandArgs(trailingOnly=TRUE)[4]

assoc<-read.table(paste0('output/', out, '.mlma'), header = T, stringsAsFactors = F)
assoc<-assoc[complete.cases(assoc),]
assoc$T <- (assoc$b/assoc$se)**2
assoc<-assoc[order(assoc$T, decreasing = T),]
o<-assoc
# keep only one snp of snps in perfect ld
o <- subset(o, !duplicated(o$T))
# call plink to extract just the top snp from the bed file and output as genotype file
system('mkdir fm_tmp/')
system(paste0(plinkpath,' --bfile ',plinkfiles,' --recode A --pheno ', pheno,' --out fm_tmp/tmp --snp ', o[1,2]), ignore.stdout=T)
x<-read.table('fm_tmp/tmp.raw', stringsAsFactors = F, header = T)

x<-x[complete.cases(x),]
# do a linear regression
fit<-lm(x$PHENOTYPE~x[,7])

t<-0
count<-0
step<-25

while(t<1){  
    count<-count+step
  # We want to correct for multiple testing using benferroni correction
    p<-0.05/count
  # call plink once again, this time only keeping the snp in question
    system(paste0(plinkpath,' --bfile ', plinkfiles,' --recode A --pheno ',pheno,' --out fm_tmp/tmp --snp ', o[count+1,2] , sep = ''), ignore.stdout=T)
    x<-read.table('fm_tmp/tmp.raw', stringsAsFactors = F, header = T)
    x$fit<-fitted(fit)
    x<-x[complete.cases(x),]

    if(is.na(pmatch(o[count+1,2], names(x)))==T){
        next
    }
    if(length(summary(lm(x$PHENOTYPE~x[,7]+x$fit))$coefficients[,4])<3){
        next
    }
  # If the regression coefficient of the fitted values of our best snp is significant => snp in question cannot be causal
    if(summary(lm(x$PHENOTYPE~x[,7]+x$fit))$coefficients[3,4] < p){
        if(step==1){
            t <- 1
            write.table(subset(assoc, assoc$T > o$T[count+1]),paste0('output/',out,'.jtest.credsets', sep=''), quote=F, row.names=F, col.names=F)
        }
        else{
            count <- count - step
            step <- step/5
        }
    }
}


