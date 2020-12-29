//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//

data {
  int<lower=0> N2;
  vector[N2] x1;  
  vector[N2] x2;  
  int<lower=0> Y2[N2];  
}

parameters {
  real alpha;
  real beta1;
  real beta2;
}


model {
  Y2 ~ poisson_log(alpha + x1*beta1 + beta2*x2) ;
  }
