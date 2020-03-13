#' @description
#' Description.
#'
#' @param linear_gene_expression_matrix A param.
#' @param metabolic_genes A param.
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
get_gene_expression_statistics <- function(linear_gene_expression_matrix, metabolic_genes) {
    total_expressions <- colSums(linear_gene_expression_matrix)
    metabolic_expressions <- colSums(linear_gene_expression_matrix[
        metabolic_genes %>%
        dplyr::filter(is_metabolic == TRUE) %>%
        dplyr::pull(gene),
    ])
    gene_expression_statistics <-
        rbind(
            total_expression = total_expressions,
            metabolic_expression = metabolic_expressions,
            metabolic_activity = metabolic_expressions / total_expressions
        ) %>%
        t() %>%
        tibble::as_tibble(rownames = "cell_id")
    gene_expression_statistics
}
