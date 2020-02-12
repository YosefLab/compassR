#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
CompassData <- R6::R6Class(
    "CompassData",
    public = list(

        #' @field settings A field.
        settings = NULL,

        #' @field reaction_consistencies A field.
        reaction_consistencies = NULL,

        #' @field metareaction_consistencies A field.
        metareaction_consistencies = NULL,

        #' @field gene_expression_statistics A field.
        gene_expression_statistics = NULL,

        #' @field cell_metadata A field.
        cell_metadata = NULL,

        #' @field gene_metadata A field.
        gene_metadata = NULL,

        #' @field metabolite_metadata A field.
        metabolite_metadata = NULL,

        #' @field reaction_metadata A field.
        reaction_metadata = NULL,

        #' @field reaction_partitions A field.
        reaction_partitions = NULL,

        #' @description
        #' Description.
        #'
        #' @param settings
        #'
        #' @return An output.
        initialize = function(settings) {
            gene_metadata_path <- file.path(
                settings$metabolic_model_directory,
                settings$gene_metadata_file
            )
            metabolite_metadata_path <- file.path(
                settings$metabolic_model_directory,
                settings$metabolite_metadata_file
            )
            reaction_metadata_path <- file.path(
                settings$metabolic_model_directory,
                settings$reaction_metadata_file
            )
            cell_metadata_path <- file.path(
                settings$user_data_directory,
                settings$cell_metadata_file
            )
            reaction_consistencies_path <- file.path(
                settings$user_data_directory,
                settings$reaction_consistencies_file
            )
            linear_gene_expression_matrix_path <- file.path(
                settings$user_data_directory,
                settings$linear_gene_expression_matrix_file
            )
            reaction_consistencies <- get_reaction_consistencies(
                reaction_consistencies_path,
                min_consistency = settings$min_reaction_consistency,
                min_range = settings$min_reaction_range
            )
            annotated_reactions <- get_annotations(
                rownames(reaction_consistencies),
                separator = settings$reaction_direction_separator,
                annotations = settings$reaction_directions,
                id_col_name = "reaction_id",
                unannotated_col_name = "undirected_reaction_id",
                annotation_col_name = "direction"
            )
            metareactions <- get_metareactions(
                reaction_consistencies,
                cluster_strength = settings$cluster_strength
            )
            metareaction_consistencies <- get_metareaction_consistencies(
                reaction_consistencies,
                metareactions
            )
            reaction_partitions <-
                annotated_reactions %>%
                dplyr::left_join(
                    metareactions,
                    by = "reaction_id"
                )
            cell_metadata <- read_compass_metadata(cell_metadata_path)
            gene_metadata <- read_compass_metadata(gene_metadata_path)
            metabolite_metadata <- read_compass_metadata(metabolite_metadata_path)
            reaction_metadata <- read_compass_metadata(reaction_metadata_path)
            gene_expression_statistics <- get_gene_expression_statistics(
                linear_gene_expression_matrix_path,
                gene_metadata,
                gene_symbol_col_name = settings$gene_symbol_col_name
            )
            self$settings <- settings
            self$reaction_consistencies <- reaction_consistencies
            self$metareaction_consistencies <- metareaction_consistencies
            self$gene_expression_statistics <- gene_expression_statistics
            self$cell_metadata <- cell_metadata
            self$gene_metadata <- gene_metadata
            self$metabolite_metadata <- metabolite_metadata
            self$reaction_metadata <- reaction_metadata
            self$reaction_partitions <- reaction_partitions
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
                "CompassData:",
                indent(get_tabular_data_representation(
                    self$reaction_consistencies,
                    "reaction_consistencies",
                    "data frame",
                    "reactions",
                    "cells"
                )),
                indent(get_tabular_data_representation(
                    self$metareaction_consistencies,
                    "metareaction_consistencies",
                    "data frame",
                    "metareactions",
                    "cells"
                )),
                indent(get_tabular_data_representation(
                    self$gene_expression_statistics,
                    "gene_expression_statistics",
                    "data frame",
                    "statistics",
                    "cells"
                )),
                indent(get_tabular_data_representation(
                    self$cell_metadata,
                    "cell_metadata",
                    "tibble",
                    "cells",
                    "fields"
                )),
                indent(get_tabular_data_representation(
                    self$gene_metadata,
                    "gene_metadata",
                    "tibble",
                    "genes",
                    "fields"
                )),
                indent(get_tabular_data_representation(
                    self$metabolite_metadata,
                    "metabolite_metadata",
                    "tibble",
                    "metabolites",
                    "fields"
                )),
                indent(get_tabular_data_representation(
                    self$reaction_metadata,
                    "reaction_metadata",
                    "tibble",
                    "reactions",
                    "fields"
                )),
                indent(get_tabular_data_representation(
                    self$reaction_partitions,
                    "reaction_partitions",
                    "tibble",
                    "reactions",
                    "fields"
                )),
                sep = "\n"
            )
            readable_representation
        }

    )
)
