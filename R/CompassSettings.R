#' @title Title
#'
#' @description
#' Description.
#'
#' @export
CompassSettings <- R6::R6Class(
    "CompassSettings",
    public = list(

        #' @field gene_metadata_path A field.
        gene_metadata_path = NULL,

        #' @field metabolite_metadata_path A field.
        metabolite_metadata_path = NULL,

        #' @field reaction_metadata_path A field.
        reaction_metadata_path = NULL,

        #' @field cell_metadata_path A field.
        cell_metadata_path = NULL,

        #' @field reaction_consistencies_path A field.
        reaction_consistencies_path = NULL,

        #' @field linear_gene_expression_matrix_path A field.
        linear_gene_expression_matrix_path = NULL,

        #' @field gene_id_col_name A field.
        gene_id_col_name = NULL,

        #' @field cell_id_col_name A field.
        cell_id_col_name = NULL,

        #' @field reaction_direction_separator A field.
        reaction_direction_separator = NULL,

        #' @field reaction_directions A field.
        reaction_directions = NULL,

        #' @field min_reaction_consistency A field.
        min_reaction_consistency = NULL,

        #' @field min_reaction_range A field.
        min_reaction_range = NULL,

        #' @field cluster_strength A field.
        cluster_strength = NULL,

        #' @description
        #' Description.
        #'
        #' @param metabolic_model_directory A param.
        #' @param gene_metadata_file A param.
        #' @param metabolite_metadata_file A param.
        #' @param reaction_metadata_file A param.
        #' @param user_data_directory A param.
        #' @param cell_metadata_file A param.
        #' @param reaction_consistencies_file A param.
        #' @param linear_gene_expression_matrix_file A param.
        #' @param gene_id_col_name A param.
        #' @param cell_id_col_name A param.
        #' @param reaction_direction_separator A param.
        #' @param reaction_directions A param.
        #' @param min_reaction_consistency A param.
        #' @param min_reaction_range A param.
        #' @param cluster_strength A param.
        #' @param ... A param.
        #'
        #' @return An output.
        initialize = function(
            ...,
            metabolic_model_directory = system.file("extdata", "RECON2", package = "compassR", mustWork = TRUE),
            gene_metadata_file = "gene_metadata.csv",
            metabolite_metadata_file = "metabolite_metadata.csv",
            reaction_metadata_file = "reaction_metadata.csv",
            user_data_directory,
            cell_metadata_file = "cell_metadata.csv",
            reaction_consistencies_file = "reactions.tsv",
            linear_gene_expression_matrix_file = "linear_gene_expression_matrix.tsv",
            gene_id_col_name,
            cell_id_col_name,
            reaction_direction_separator = "_",
            reaction_directions = c("pos", "neg"),
            min_reaction_consistency = 1e-4,
            min_reaction_range = 1e-8,
            cluster_strength = 0.1
        ) {
            self$gene_metadata_path <- file.path(
                metabolic_model_directory,
                gene_metadata_file
            )
            self$metabolite_metadata_path <- file.path(
                metabolic_model_directory,
                metabolite_metadata_file
            )
            self$reaction_metadata_path <- file.path(
                metabolic_model_directory,
                reaction_metadata_file
            )
            self$cell_metadata_path <- file.path(
                user_data_directory,
                cell_metadata_file
            )
            self$reaction_consistencies_path <- file.path(
                user_data_directory,
                reaction_consistencies_file
            )
            self$linear_gene_expression_matrix_path <- file.path(
                user_data_directory,
                linear_gene_expression_matrix_file
            )
            self$gene_id_col_name <- gene_id_col_name
            self$cell_id_col_name <- cell_id_col_name
            self$reaction_direction_separator <- reaction_direction_separator
            self$reaction_directions <- reaction_directions
            self$min_reaction_consistency <- min_reaction_consistency
            self$min_reaction_range <- min_reaction_range
            self$cluster_strength <- cluster_strength
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
                "CompassSettings:",
                indent(get_binding_representation(
                    "Metabolic model directory",
                    self$metabolic_model_directory
                )),
                indent(get_binding_representation(
                    "Gene metadata file",
                    self$gene_metadata_file
                )),
                indent(get_binding_representation(
                    "Metabolite metadata file",
                    self$metabolite_metadata_file
                )),
                indent(get_binding_representation(
                    "Reaction metadata file",
                    self$reaction_metadata_file
                )),
                indent(get_binding_representation(
                    "User data directory",
                    self$user_data_directory
                )),
                indent(get_binding_representation(
                    "Cell metadata file",
                    self$cell_metadata_file
                )),
                indent(get_binding_representation(
                    "Reaction consistencies file",
                    self$reaction_consistencies_file
                )),
                indent(get_binding_representation(
                    "Linear gene expression matrix file",
                    self$linear_gene_expression_matrix_file
                )),
                indent(get_binding_representation(
                    "Gene symbol column name",
                    self$gene_id_col_name
                )),
                indent(get_binding_representation(
                    "Cell ID column name",
                    self$cell_id_col_name
                )),
                indent(get_binding_representation(
                    "Reaction direction separator",
                    self$reaction_direction_separator
                )),
                indent(get_binding_representation(
                    "Reaction directions",
                    self$reaction_directions
                )),
                indent(get_binding_representation(
                    "Minimum reaction consistency",
                    self$min_reaction_consistency
                )),
                indent(get_binding_representation(
                    "Minimum reaction range",
                    self$min_reaction_range
                )),
                indent(get_binding_representation(
                    "Cluster strength",
                    self$cluster_strength
                )),
                sep = "\n"
            )
            readable_representation
        }

    )
)
