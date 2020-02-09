#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
MetabolicModel <- R6::R6Class(
    "MetabolicModel",
    public = list(

        #' @field gene_metadata A field.
        gene_metadata = NULL,

        #' @field metabolite_metadata A field.
        metabolite_metadata = NULL,

        #' @field reaction_metadata A field.
        reaction_metadata = NULL,

        #' @description
        #' Description.
        #'
        #' @param metabolic_model_directory A param.
        #' @param gene_metadata_file A param.
        #' @param metabolite_metadata_file A param.
        #' @param reaction_metadata_file A param.
        #' @param ... A param.
        #'
        #' @return An output.
        initialize = function(metabolic_model_directory, ..., gene_metadata_file = "gene_metadata.csv", metabolite_metadata_file = "metabolite_metadata.csv", reaction_metadata_file = "reaction_metadata.csv") {
            gene_metadata_path <- file.path(metabolic_model_directory, gene_metadata_file)
            metabolite_metadata_path <- file.path(metabolic_model_directory, metabolite_metadata_file)
            reaction_metadata_path <- file.path(metabolic_model_directory, reaction_metadata_file)
            self$gene_metadata <- read_compass_metadata(gene_metadata_path)
            self$metabolite_metadata <- read_compass_metadata(metabolite_metadata_path)
            self$reaction_metadata <- read_compass_metadata(reaction_metadata_path)
        }

    )
)
