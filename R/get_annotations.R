#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param ids A param.
#' @param separator A param.
#' @param annotations A param.
#' @param id_col_name A param.
#' @param unannotated_col_name A param.
#' @param annotation_col_name A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @importFrom magrittr %>% %<>%
#' 
#' @noRd
get_annotations <- function(ids, ..., separator, annotations, id_col_name, unannotated_col_name, annotation_col_name) {
    if (is.null(separator) | is.null(annotations)) {
        annotations <- cbind(ids, NA, NA)
    } else {
        patterns <- stringr::str_glue(
            "^(.+){separator}({annotation})$",
            separator = separator,
            annotation = annotations
        )
        annotations <- matrix(nrow = 0, ncol = 3)
        for (pattern in patterns) {
            annotations %<>% rbind(na.omit(stringr::str_match(ids, pattern)))
        }
    }
    colnames(annotations) <- c(
        id_col_name,
        unannotated_col_name,
        annotation_col_name
    )
    annotations %<>% tibble::as_tibble()
    annotations
}

# TODO FYI: Assumes reaction_id is of the form {unique id}{separator}{one of several annotations}.
