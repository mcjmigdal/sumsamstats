exponentFun <- function(x, a, b) {
    a * exp(b * x)
}

gaussFun <- function(x, a, mean, sd) {
    a * exp(-0.5 * ((x - mean)/sd)^2)
}

nlsATAC <- function(data, start, gnumber = 3, ...) {
  gaussians <- paste(sapply(1:gnumber, function(i) paste0("gaussFun(insert_size, k", i, ", mean", i, ", sd", i, ")")), collapse = " + ")
  fit_formula <- as.formula(paste0("pairs_total ~ exponentFun(insert_size, a, b) +", gaussians))
  model <- nlsLM(
    formula = fit_formula,
    data = data,
    start = start,
    ...
  )
  return(model)
}
