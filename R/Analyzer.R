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

        #' @field reaction_identifiers A field.
        reaction_identifiers = NULL,

        #' @description
        #' Description.
        #'
        #' @param metabolic_model A param.
        #' @param reaction_consistencies_file A param.
        #' @param linear_gene_expression_matrix_file A param.
        #' @param reaction_annotation_separator A param.
        #' @param reaction_annotations A param.
        #' @param min_reaction_consistency A param.
        #' @param min_reaction_range A param.
        #' @param cluster_strength A param.
        #' @param ... A param.
        #'
        #' @return An output.
        initialize = function(..., metabolic_model, reaction_consistencies_file, linear_gene_expression_matrix_file, reaction_annotation_separator = "_", reaction_annotations = c("pos", "neg"), min_reaction_consistency = 1e-4, min_reaction_range = 1e-8, cluster_strength = 0.1) {
            self$reaction_consistencies <- get_reaction_consistencies(
                reaction_consistencies_file,
                min_consistency = min_reaction_consistency,
                min_range = min_reaction_range
            )
            metareactions <- get_metareactions(
                self$reaction_consistencies,
                cluster_strength = cluster_strength
            )
            self$metareaction_consistencies <- get_metareaction_consistencies(
                self$reaction_consistencies,
                metareactions
            )
            self$gene_expression_statistics <- get_gene_expression_statistics(
                linear_gene_expression_matrix_file,
                metabolic_model$gene_metadata
            )
            self$reaction_identifers <- get_reaction_identifiers(
                rownames(self$reaction_consistencies),
                metareactions,
                separator = reaction_annotation_separator,
                annotations = reaction_annotations
            )
        },

        #' @description
        #' Description.
        #'
        #' @param ... A param.
        #'
        #' @return An output.
        print = function(...) {
            readable_representation <- paste(
                "Analyzer:",
                indent(get_tabular_data_representation(
                    self$reaction_consistencies,
                    "reaction_consistencies",
                    "matrix",
                    "reactions",
                    "cells"
                )),
                indent(get_tabular_data_representation(
                    self$metareaction_consistencies,
                    "metareaction_consistencies",
                    "matrix",
                    "metareactions",
                    "cells"
                )),
                indent(get_tabular_data_representation(
                    self$gene_expression_statistics,
                    "gene_expression_statistics",
                    "matrix",
                    "statistics",
                    "cells"
                )),
                "",
                sep = "\n"
            )
            cat(readable_representation)
        }

    )
)
