#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
Analyzer <- R6::R6Class(
    "Analyzer",
    public = list(

        #' @field metadata A field.
        metadata = NULL,

        #' @field reaction_consistencies A field.
        reaction_consistencies = NULL,

        #' @field metareaction_consistencies A field.
        metareaction_consistencies = NULL,

        #' @field gene_expression_statistics A field.
        gene_expression_statistics = NULL,

        #' @description
        #' Description.
        #'
        #' @param metadata_directory A param.
        #' @param gene_metadata_file A param.
        #' @param metabolite_metadata_file A param.
        #' @param reaction_metadata_file A param.
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
        initialize = function(..., metadata_directory, gene_metadata_file, metabolite_metadata_file, reaction_metadata_file, reaction_consistencies_file, linear_gene_expression_matrix_file, reaction_annotation_separator = NULL, reaction_annotations = NULL, min_reaction_consistency = 1e-4, min_reaction_range = 1e-8, cluster_strength = 0.1) {
            gene_metadata_path <- file.path(metadata_directory, gene_metadata_file)
            metabolite_metadata_path <- file.path(metadata_directory, metabolite_metadata_file)
            reaction_metadata_path <- file.path(metadata_directory, reaction_metadata_file)
            reaction_consistencies <- get_reaction_consistencies(
                reaction_consistencies_file,
                min_consistency = min_reaction_consistency,
                min_range = min_reaction_range
            )
            annotated_reactions <- get_annotated_reactions(
                rownames(reaction_consistencies),
                separator = reaction_annotation_separator,
                annotations = reaction_annotations
            )
            metareactions <- get_metareactions(
                reaction_consistencies,
                cluster_strength = cluster_strength
            )
            metareaction_consistencies <- get_metareaction_consistencies(
                reaction_consistencies,
                metareactions
            )
            gene_metadata <- read_compass_metadata(gene_metadata_path)
            metabolite_metadata <- read_compass_metadata(metabolite_metadata_path)
            reaction_metadata <- read_compass_metadata(reaction_metadata_path)
            compass_metadata <-
                annotated_reactions %>%
                dplyr::left_join(
                    metareactions,
                    by = "reaction_id"
                )
            gene_expression_statistics <- get_gene_expression_statistics(
                linear_gene_expression_matrix_file,
                gene_metadata
            )
            self$metadata <- Metadata$new(
                gene_metadata,
                metabolite_metadata,
                reaction_metadata,
                compass_metadata
            )
            self$reaction_consistencies <- reaction_consistencies
            self$metareaction_consistencies <- metareaction_consistencies
            self$gene_expression_statistics <- gene_expression_statistics
        },

        #' @description
        #' Description.
        #'
        #' @param ... A param.
        #'
        #' @return An output.
        print = function(...) {
            cat(paste(self$repr(), "\n", sep = ""))
        },

        #' @description
        #' Description.
        #'
        #' @param ... A param.
        #'
        #' @return An output.
        repr = function(...) {
            readable_representation <- paste(
                "Analyzer:",
                indent(get_object_representation("metadata")),
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
                sep = "\n"
            )
            readable_representation
        }

    )
)
