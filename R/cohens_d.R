#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param group_A_values A param.
#' @param group_B_values A param.
#' 
#' @return An output.
#' 
#' @noRd
cohens_d <- function(group_A_values, group_B_values) {
    n_A <- length(group_A_values)
    n_B <- length(group_B_values)
    mu_A <- mean(group_A_values)
    mu_B <- mean(group_B_values)
    var_A <- var(group_A_values)
    var_B <- var(group_B_values)
    pooled_sd <- sqrt(((n_A - 1) * var_A + (n_B - 1) * var_B) / (n_A + n_B - 2))
    cohen_d <- (mu_A - mu_B) / pooled_sd
    cohen_d
}
