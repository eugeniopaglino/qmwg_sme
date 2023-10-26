
// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N; // Number of Observations
  int<lower=0> S; // Number of Areas
  int y[N]; // Deaths in County C for time T
  vector[N] pop; // Pop in County C for time T
  matrix[N,3] ageComp;
  int<lower=1,upper=S> geo[N]; // Area of Unit N
}

// The parameters accepted by the model.
parameters {
  real beta_0;
  real beta_a1;
  real beta_a2;
  real beta_a3;
  vector[S-1] beta_s_tilde_raw; // Age coefficients
  real<lower=0> sigma_s;
  vector[S-1] beta_as2_tilde_raw; // Age coefficients
  real<lower=0> sigma_as2;
  vector[S-1] beta_as3_tilde_raw; // Age coefficients
  real<lower=0> sigma_as3;
} 

transformed parameters {
  vector[N] mu;

  vector[S] beta_s_tilde = append_row(beta_s_tilde_raw, -sum(beta_s_tilde_raw));
  vector[S] beta_s =  beta_s_tilde * sigma_s;
  
  vector[S] beta_as2_tilde = append_row(beta_as2_tilde_raw, -sum(beta_as2_tilde_raw));
  vector[S] beta_as2 =  beta_as2_tilde * sigma_as2;
  
  vector[S] beta_as3_tilde = append_row(beta_as3_tilde_raw, -sum(beta_as3_tilde_raw));
  vector[S] beta_as3 =  beta_as3_tilde * sigma_as3;

  mu = beta_0 + beta_s[geo];
  mu = mu + beta_a1 * ageComp[,1];
  mu = mu + (beta_a2 + beta_as2[geo]) .* ageComp[,2];
  mu = mu + (beta_a3 + beta_as3[geo]) .* ageComp[,3];
}

// The model to be estimated.
model {
  
  beta_s_tilde ~ normal(0,1);
  beta_as2_tilde ~ normal(0,1);
  beta_as3_tilde ~ normal(0,1);

  sigma_s ~ student_t(7, 0, 1);
  sigma_as2 ~ student_t(7, 0, 1);
  sigma_as3 ~ student_t(7, 0, 1);

  y ~ poisson(exp(mu) .* (pop));
  
}

/*
generated quantities {
  int yp[N] = poisson_rng(exp(mu) .* pop);
}
*/
