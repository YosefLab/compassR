#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
Metadata <- R6::R6Class(
    "Metadata",
    public = list(

        #' @field gene_metadata A field.
        gene_metadata = NULL,

        #' @field metabolite_metadata A field.
        metabolite_metadata = NULL,

        #' @field reaction_metadata A field.
        reaction_metadata = NULL,

        #' @field compass_metadata A field.
        compass_metadata = NULL,

        #' @description
        #' Description.
        #'
        #' @param gene_metadata A param.
        #' @param metabolite_metadata A param.
        #' @param reaction_metadata A param.
        #' @param compass_metadata A param.
        #'
        #' @return An output.
        initialize = function(gene_metadata, metabolite_metadata, reaction_metadata, compass_metadata) {
            self$gene_metadata <- gene_metadata
            self$metabolite_metadata <- metabolite_metadata
            self$reaction_metadata <- reaction_metadata
            self$compass_metadata <- compass_metadata
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
                    self$compass_metadata,
                    "compass_metadata",
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
