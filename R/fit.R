exponentFun <- function(x, a, b) {
    a * exp(b * x)
}

gaussFun <- function(x, a, mean, sd) {
    a * exp(-0.5 * ((x - mean)/sd)^2)
}


