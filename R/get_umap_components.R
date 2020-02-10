#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param consistencies_matrix A param.
#' @param num_components A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @importFrom magrittr %>% %<>%
#' 
#' @export
get_umap_components <- function(consistencies_matrix, ..., num_components = 2) {
    require_suggested_package("uwot")
    umap_components <- uwot::umap(t(consistencies_matrix), n_components = num_components)
    colnames(umap_components) <- paste("component", 1:num_components, sep = "_")
    umap_components %<>%
        cbind(cell_id = colnames(consistencies_matrix), .) %>%
        tibble::as_tibble()
    umap_components
}
