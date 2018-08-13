exponentFun <- function(x, a, b ) {
  x = seq(min(x), max(x), length.out = 1000)
  a * exp(b*x)
}

gaussFun <- function(x, a, mean, sd) {
  x = seq(min(x), max(x), length.out = 1000)
  a * exp( -0.5 * ((x-mean)/sd)**2 )
}
