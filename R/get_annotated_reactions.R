#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies the first param
#' 
#' @return the output
#' 
#' @importFrom magrittr %<>% %>%
#' 
#' @export
get_annotated_reactions <- function(reaction_consistencies, separator, annotations) {
    reaction_names <- rownames(reaction_consistencies)
    patterns <- stringr::str_glue("^(.+){separator}({annotation})$", separator = separator,annotation = annotations)
    annotated_reactions <- matrix(nrow = 0, ncol = 3)
    for (pattern in patterns) {
        annotated_reactions %<>% rbind(na.omit(stringr::str_match(reaction_names, pattern)))
    }
    annotated_reactions %<>%
        data.frame() %>%
        dplyr::rename(reaction_name = 1, unannotated_reaction = 2, annotation = 3)
    annotated_reactions
}
# TODO: Assumes reaction_name is of the form {unique reaction id}{separator}{one of several annotations}.
# TODO: Returns a data.frame with columns reaction_name <chr>, unannotated_reaction <chr>, and annotation <chr>.
