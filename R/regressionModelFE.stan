
// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N; // Number of Observations
  int<lower=0> M; // Number of Groups
  real y[N]; // y 
  vector[N] x; // x
  int<lower=1,upper=M> group[N]; // Group of Unit N
}

// The parameters accepted by the model.
parameters {
  vector[M] alpha_g;
  vector[M] beta_g;
  real<lower=0> sigma;
} 

// The model to be estimated.
model {

  y ~ normal(alpha_g[group] + beta_g[group] .* x,sigma);
  
}
