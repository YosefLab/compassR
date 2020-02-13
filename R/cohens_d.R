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
    group_A_mean <- mean(group_A_values)
    group_B_mean <- mean(group_B_values)
    group_A_variance <- var(group_A_values)
    group_B_variance <- var(group_B_values)
    cohen_d <- (group_A_mean - group_B_mean) / sqrt((group_A_variance + group_B_variance) / 2)
    cohen_d
}
