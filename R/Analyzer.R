#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
Analyzer <- R6::R6Class(
    "Analyzer",
    public = list(

        #' @field reaction_consistencies A field.
        reaction_consistencies = NULL,

        #' @field metareaction_consistencies A field.
        metareaction_consistencies = NULL,

        #' @field gene_expression_statistics A field.
        gene_expression_statistics = NULL,

        #' @description
        #' Description.
        #'
        #' @param metabolic_model A param.
        #' @param reaction_consistencies_file A param.
        #' @param linear_gene_expression_matrix_file A param.
        #' @param min_reaction_consistency A param.
        #' @param min_reaction_range A param.
        #' @param cluster_strength A param.
        #' @param ... A param.
        #'
        #' @return An output.
        initialize = function(..., metabolic_model, reaction_consistencies_file, linear_gene_expression_matrix_file, min_reaction_consistency = 1e-4, min_reaction_range = 1e-8, cluster_strength = 0.1) {
            self$reaction_consistencies <- get_reaction_consistencies(
                reaction_consistencies_file,
                min_consistency = min_reaction_consistency,
                min_range = min_reaction_range
            )
            self$metareaction_consistencies <- get_metareaction_consistencies(
                self$reaction_consistencies,
                cluster_strength = cluster_strength
            )
            self$gene_expression_statistics <- NULL # TODO
        }

    )
)

# TODO: Before moving on, reorganize the files. Maybe one R function per file?
