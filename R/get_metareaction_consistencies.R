#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reaction_consistencies A param.
#' @param metareactions A param.
#' 
#' @return An output.
#' 
#' @importFrom magrittr %>%
#' 
#' @noRd
get_metareaction_consistencies <- function(reaction_consistencies, metareactions) {
    metareaction_consistencies <-
        reaction_consistencies %>%
        tibble::as_tibble(rownames = "reaction_id") %>%
        dplyr::inner_join(metareactions, by = "reaction_id") %>%
        dplyr::select(-reaction_id) %>%
        dplyr::group_by(metareaction_id) %>%
        dplyr::summarize_all(mean) %>% # TODO: Pick a better summary statistic than the mean.
        dplyr::ungroup() %>%
        tibble::column_to_rownames("metareaction_id") %>%
        data.matrix()
    metareaction_consistencies
}
