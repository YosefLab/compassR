#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reaction_consistencies A param.
#' @param min_consistency A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @noRd
drop_inconsistent_reactions <- function(reaction_consistencies, ..., min_consistency) {
    reactions_inconsistent_for_any_cells <- apply(reaction_consistencies <= min_consistency, 1, any)
    reactions_inconsistent_for_all_cells <- apply(reaction_consistencies <= min_consistency, 1, all)
    partially_inconsistent_reactions <- reactions_inconsistent_for_any_cells & !reactions_inconsistent_for_all_cells
    alert_of_drop(
        reactions_inconsistent_for_all_cells,
        "reactions are inconsistent for all cells."
    )
    alert_of_drop(
        partially_inconsistent_reactions,
        "reactions are inconsistent for a nonempty proper subset of cells.",
        TRUE
    )
    reaction_consistencies <- reaction_consistencies[!reactions_inconsistent_for_any_cells,]
    reaction_consistencies
}
