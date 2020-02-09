#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reaction_consistencies A param.
#' @param min_range A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @noRd
drop_constant_reactions <- function(reaction_consistencies, ..., min_range) {
    constant_reactions <- apply(reaction_consistencies, 1, function(x) { max(x) - min(x) < min_range })
    alert_of_drop(
        constant_reactions,
        "reactions have too small a range of values."
    )
    reaction_consistencies <- reaction_consistencies[!constant_reactions,]
    reaction_consistencies
}
