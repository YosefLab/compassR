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

        #' @field metabolic_genes Each row describes a gene in terms of its ID and whether it's a metabolic gene.
        metabolic_genes = NULL,

        #' @field gene_expression_statistics Each row describes a cell in terms of its ID, total expression, metabolic expression, and metabolic activity.
        gene_expression_statistics = NULL,

        #' @field cell_metadata The cell metadata from cell_metadata.csv. In this example it's the Th17 cell data from the papers linked above.
        cell_metadata = NULL,

        #' @field gene_metadata The gene metadata from the metabolic model (RECON2, by default).
        gene_metadata = NULL,

        #' @field metabolite_metadata The metabolite metadata from the metabolic model (RECON2, by default).
        metabolite_metadata = NULL,

        #' @field reaction_metadata The reaction metadata from the metabolic model (RECON2, by default).
        reaction_metadata = NULL,

        #' @field reaction_partitions Each row describes a reaction in terms of its ID, undirected ID, direction, and which metareaction (i.e. reaction group) it belongs to.
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
            compass_reaction_scores <- read_compass_matrix(settings$compass_reaction_scores_path, "reaction_id", suppress_warnings = TRUE)
            linear_gene_expression_matrix <- read_compass_matrix(settings$linear_gene_expression_matrix_path, "gene")
            reaction_consistencies <- get_reaction_consistencies(
                compass_reaction_scores,
                min_consistency = settings$min_reaction_consistency,
                min_range = settings$min_reaction_range
            )
            annotated_reactions <- get_annotations(
                rownames(reaction_consistencies),
                separator = settings$reaction_direction_separator,
                annotations = settings$reaction_directions,
                id_col_name = "reaction_id",
                unannotated_col_name = "reaction_no_direction",
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
            metabolic_genes <-
                tibble::tibble(gene = rownames(linear_gene_expression_matrix)) %>%
                dplyr::left_join(
                    tibble::tibble(
                        gene = gene_metadata[[settings$gene_id_col_name]],
                        is_metabolic = TRUE
                    ),
                    by = "gene"
                ) %>%
                tidyr::replace_na(list(
                    is_metabolic = FALSE
                ))
            gene_expression_statistics <- get_gene_expression_statistics(
                linear_gene_expression_matrix,
                metabolic_genes
            )
            self$settings <- settings
            self$reaction_consistencies <- reaction_consistencies
            self$metareaction_consistencies <- metareaction_consistencies
            self$metabolic_genes <- metabolic_genes
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
                    self$metabolic_genes,
                    "metabolic_genes",
                    "tibble",
                    "genes",
                    "fields"
                )),
                indent(get_tabular_data_representation(
                    self$gene_expression_statistics,
                    "gene_expression_statistics",
                    "tibble",
                    "cells",
                    "fields"
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
