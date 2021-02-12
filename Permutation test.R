set.seed(123)
##Simple generation of simulated data

N1=500
N2=500
N.categories <- 3 #how many clinical categories

# IRR1 <- 0.7
# IRR2 <- 0.5
# IRR3 <- 0.1
IRR1 <- 1
IRR2 <- 1
IRR3 <- 1

Y1 <- matrix(NA, nrow=N1, ncol=N.categories)
Y1[,1] <- rbinom(N1, size=1, prob= 0.1 )
Y1[,2] <- rbinom(N1, size=1, prob= 0.8*Y1[,1] ) #80% of Y1 is also Y2
Y1[,3] <- rbinom(N1, size=1, prob= 0.5*Y1[,2] ) #50% of Y2 is also Y3

Y2 <- matrix(NA, nrow=N2, ncol=N.categories)
Y2[,1] <- rbinom(N2, size=1, prob= 0.1*IRR1 )
Y2[,2] <- rbinom(N2, size=1, prob= 0.8*Y2[,1]*(IRR2/IRR1) ) #80% of Y1 is also Y2
Y2[,3] <- rbinom(N2, size=1, prob= 0.5*Y2[,2]*(IRR3/(IRR1*IRR2) )) #50% of Y2 is also Y3

N.unvax <- nrow(Y1)
N.vax <- nrow(Y2)

##Permutation test
permute.func <- function(Y.unvax=Y1, Y.vax=Y2){
  Z <- rbind(Y.unvax, Y.vax)
  vax.index <- sample(1:nrow(Z), size=N.vax, replace=F)
  Z.vax <- Z[vax.index,]
  Z.unvax <- Z[-vax.index,]
  N.vax.outcomes <- apply(Z.vax,2,sum)
  N.unvax.outcome <- apply(Z.unvax,2,sum)
  RR <- (N.vax.outcomes/N.vax)/(N.unvax.outcome/N.unvax)
  return(RR)
}

sample1 <- replicate(9999, permute.func())
sample1.q <- t(apply(sample1,1,quantile,probs=c(0.025,0.5,0.975)))

Obs.unvax.events <- apply(Y1,2,sum)
Obs.vax.events <- apply(Y2,2,sum)
Obs.RR <- (Obs.vax.events/N.vax)/(Obs.unvax.events/N.unvax)

P.values <- rep(NA, 3 )
for(i in 1:3){
  P.values[i] <- 1 - mean(Obs.RR[i] < sample1[i,])
}
P.values
hist(sample1[1,], xlim=c(0,2.5), breaks=100)
abline(v=Obs.RR[1])

sig1 <- rep(NA, ncol(sample1))
sig3 <- rep(NA, ncol(sample1))
for(k in 1:ncol(sample1)){
  sig1[k] <- (Obs.RR[1] < sample1[1, k]) | (Obs.RR[2] < sample1[2,k]) | (Obs.RR[3] < sample1[3,k])
  sig3[k] <- (Obs.RR[1] < sample1[1, k]) & (Obs.RR[2] < sample1[2,k]) & (Obs.RR[3] < sample1[3,k])
  
}
 P.values.combined1 <- 1 - mean(sig1)
 P.values.combined3 <- 1 - mean(sig3)
 
  P.values.combined1
  P.values.combined3
 