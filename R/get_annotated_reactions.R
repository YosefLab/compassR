#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reaction_ids A param.
#' @param separator A param.
#' @param annotations A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @importFrom magrittr %>% %<>%
#' 
#' @noRd
get_annotated_reactions <- function(reaction_ids, ..., separator, annotations) {
    if (is.null(separator) | is.null(annotations)) {
        annotated_reactions <-
            tibble::tibble(
                reaction_id = reaction_ids,
                unannotated_reaction = NA,
                annotation = NA
            )
    } else {
        patterns <- stringr::str_glue(
            "^(.+){separator}({annotation})$",
            separator = separator,
            annotation = annotations
        )
        annotated_reactions <- matrix(nrow = 0, ncol = 3)
        for (pattern in patterns) {
            annotated_reactions %<>% rbind(na.omit(stringr::str_match(reaction_ids, pattern)))
        }
        colnames(annotated_reactions) <- c(
            "reaction_id",
            "unannotated_reaction",
            "annotation"
        )
        annotated_reactions %<>% tibble::as_tibble()
    }
    annotated_reactions
}

# TODO FYI: Assumes reaction_id is of the form {unique id}{separator}{one of several annotations}.
