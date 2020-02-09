#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param linear_gene_expression_matrix_file A param.
#' @param gene_metadata A param.
#' 
#' @return An output.
#' 
#' @importFrom magrittr %>%
#' 
#' @noRd
get_gene_expression_statistics <- function(linear_gene_expression_matrix_file, gene_metadata) {
    linear_gene_expression_matrix <-
        read_compass_matrix(linear_gene_expression_matrix_file) %>%
        dplyr::rename(gene = 1) %>%
        tibble::column_to_rownames("gene") %>%
        data.matrix()
    metabolic_genes <- intersect(
        rownames(linear_gene_expression_matrix),
        gene_metadata$HGNC.symbol # TODO: Change this to gene.symbol once you split RECON2 into RECON2_Homo_Sapien and RECON2_Mus_Musculus
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
