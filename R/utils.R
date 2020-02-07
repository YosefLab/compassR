#' Title
#' 
#' Description
#' 
#' @param expr the first param
#' 
#' @return the output
quiet <- function(expr) {
    suppressWarnings(suppressMessages(expr))
}

#' Title
#' 
#' Description
#' 
#' @param reactions_to_drop the first param
#' @param cause the second param
#' @param is_warning the third param
#' 
#' @return the output
alert_of_drop <- function(reactions_to_drop, cause, is_warning = FALSE) {
    if (any(reactions_to_drop)) {
        num_reactions_to_drop <- sum(reactions_to_drop)
        alert <- ifelse(is_warning, warning, message)
        alert(paste(
            num_reactions_to_drop,
            cause,
            "They will be dropped."
        ))
    }
}
