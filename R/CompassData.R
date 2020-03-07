#' @title CompassData
#'
#' @description
#' An object through which you can access several useful tables for your COMPASS analysis.
#'
#' @export
CompassData <- R6::R6Class(
    "CompassData",
    public = list(

        #' @field settings The CompassSettings instance specifying the settings for this CompassData instance.
        settings = NULL,

        #' @field reaction_consistencies Each row is a reaction and each column is a cell. reaction_consistencies[i, j] is the consitency (or "compatibility") between reaction i and cell j.
        reaction_consistencies = NULL,

        #' @field metareaction_consistencies Each row is a metareaction and each column is a cell. metareaction_consistencies[i, j] is the consistency (or "compatibility") between metareaction i and cell j.
        metareaction_consistencies = NULL,

        #' @field gene_expression_statistics Each column describes a cell's total expression, metabolic expression, and metabolic activity.
        gene_expression_statistics = NULL,

        #' @field cell_metadata The cell metadata from cell_metadata.csv. In this example it's the Th17 cell data from the papers linked above.
        cell_metadata = NULL,

        #' @field gene_metadata The gene metadata from the metabolic model (RECON2, by default).
        gene_metadata = NULL,

        #' @field metabolite_metadata The metabolite metadata from the metabolic model (RECON2, by default).
        metabolite_metadata = NULL,

        #' @field reaction_metadata The reaction metadata from the metabolic model (RECON2, by default).
        reaction_metadata = NULL,

        #' @field reaction_partitions Each row describes a reaction in terms of its ID, undirected ID, direction, and metareaction ID.
        reaction_partitions = NULL,

        #' @description
        #' Initialize the CompassSettings instance. Postprocess COMPASS data and populate tables.
        #'
        #' @param settings The CompassSettings instance specifying the settings for this CompassData instance.
        #'
        #' @return NULL.
        initialize = function(settings) {
            gene_metadata <- read_compass_metadata(settings$gene_metadata_path)
            metabolite_metadata <- read_compass_metadata(settings$metabolite_metadata_path)
            reaction_metadata <- read_compass_metadata(settings$reaction_metadata_path)
            cell_metadata <- read_compass_metadata(settings$cell_metadata_path)
            compass_scores <- read_compass_matrix(settings$compass_scores_path, "reaction_id")
            linear_gene_expression_matrix <- read_compass_matrix(settings$linear_gene_expression_matrix_path, "gene")
            reaction_consistencies <- get_reaction_consistencies(
                compass_scores,
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
            gene_expression_statistics <- get_gene_expression_statistics(
                linear_gene_expression_matrix,
                gene_metadata,
                gene_id_col_name = settings$gene_id_col_name
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
        #' Prints a human-readable representation of this CompassData instance.
        #'
        #' @param ... Unused.
        #'
        #' @return NULL.
        print = function(...) {
            cat(paste(self$repr(), "\n", sep = ""))
        },

        #' @description
        #' Returns a human-readable representation of this CompassData instance.
        #'
        #' @param ... Unused.
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
