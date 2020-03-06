#' @title Title
#'
#' @description
#' Description.
#'
#' @param linear_gene_expression_matrix A param.
#' @param gene_metadata A param.
#' @param gene_id_col_name A param.
#' @param ... A param.
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
get_gene_expression_statistics <- function(linear_gene_expression_matrix, gene_metadata, ..., gene_id_col_name) {
    metabolic_genes <- intersect(
        rownames(linear_gene_expression_matrix),
        gene_metadata[[gene_id_col_name]]
    )
    total_expressions <- colSums(linear_gene_expression_matrix)
    metabolic_expressions <- colSums(linear_gene_expression_matrix[metabolic_genes,])
    gene_expression_statistics <- rbind(
        total_expression = total_expressions,
        metabolic_expression = metabolic_expressions,
        metabolic_activity = metabolic_expressions / total_expressions
    )
    gene_expression_statistics
}
