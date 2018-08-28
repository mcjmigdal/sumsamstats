exponentFun <- function(x, a, b) {
    a * exp(b * x)
}

gaussFun <- function(x, a, mean, sd) {
    a * exp(-0.5 * ((x - mean)/sd)^2)
}

nlsATAC <- function(gnumber = 3) {
  gaussians <- paste(sapply(1:gnumber, function(i) paste0("gaussFun(k", i, ", mean", i, ", sd", i, ")")), collapse = " + ")
  fit <- as.formula(paste0("y ~ exponentFun(x, a, b) +", gaussians))
}
