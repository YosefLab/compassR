#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reaction_ids A param.
#' @param metareactions A param.
#' @param separator A param.
#' @param annotations A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @importFrom dplyr %>%
#' 
#' @noRd
get_reaction_identifiers <- function(reaction_ids, metareactions, ..., separator, annotations) {
    # reaction_identifiers <-
    #     get_annotated_reactions(
    #         reaction_ids,
    #         separator = separator,
    #         annotations = annotations
    #     ) %>%
    #     dplyr::left_join(
    #         metareactions,
    #         by = "reaction_id"
    #     )
    # reaction_identifiers
    metareactions
}

# TODO: (1) Finish implementing this function. It should return a tibble with columns reaction_id, metareaction_id, unannotated_reaction, and annotation.
# TODO: (2) Add the reaction_identifers tibble to the Analyzer's print method.
# TODO: (3) Make annotations optional. If the user has no annotations, then the reaction_identifers tibble's associated columns should be empty / null.
# TODO: (4) The user should not have to first make a MetabolicModel and then make an Analyzer. Instead they should just have to make an Analyzer, and the Analyzer's init method will make the MetabolicModel for them, accessible through analyzer$metabolic_model.
# TODO: (5) Email Allon terminal output of loading analyzer and looking at all its attributes. Ask if it's reasonable. Mention you're subscribing to the distributed data convention (a.k.a. the star schema or snowflake schema).
# TODO: (6) Attend to the todos in example.R.
