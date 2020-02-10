#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
Metadata <- R6::R6Class(
    "Metadata",
    public = list(

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
        #' @param cell_metadata A param.
        #' @param gene_metadata A param.
        #' @param metabolite_metadata A param.
        #' @param reaction_metadata A param.
        #' @param reaction_partitions A param.
        #'
        #' @return An output.
        initialize = function(cell_metadata, gene_metadata, metabolite_metadata, reaction_metadata, reaction_partitions) {
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
                "Metadata:",
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
