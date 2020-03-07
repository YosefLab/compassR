#' @title CompassSettings
#'
#' @description
#' An object through which you can specify settings for your COMPASS analysis.
#'
#' @export
CompassSettings <- R6::R6Class(
    "CompassSettings",
    public = list(

        #' @field gene_metadata_path A path to a file containing tabular gene metadata. Each row should represent a single gene. The columns are up to you, so long as one of them provides a unique identifier for each gene.
        gene_metadata_path = NULL,

        #' @field metabolite_metadata_path A path to a file containing tabular metabolite metadata. Each row should represent a single metabolite. The columns are up to you, so long as one of them provides a unique identifier for each metabolite.
        metabolite_metadata_path = NULL,

        #' @field reaction_metadata_path A path to a file containing tabular reaction metadata. Each row should represent a single reaction. The columns are up to you, so long as one of them provides a unique identifier for each reaction.
        reaction_metadata_path = NULL,

        #' @field cell_metadata_path A path to a file containing tabular cell metadata. Each row should represent a single cell. The columns are up to you, so long as one of them provides a unique identifier for each cell.
        cell_metadata_path = NULL,

        #' @field compass_scores_path A path to a file containing the raw reaction consistencies matrix. (This is the output of the COMPASS algorithm.)
        compass_scores_path = NULL,

        #' @field linear_gene_expression_matrix_path A path to a file containing the linear gene expression matrix. (This is the input to the COMPASS algorithm.)
        linear_gene_expression_matrix_path = NULL,

        #' @field cell_id_col_name The name of the column that uniquely identifies each cell in the cell metadata file.
        cell_id_col_name = NULL,

        #' @field gene_id_col_name The name of the column that uniquely identifies each gene in the gene metadata file.
        gene_id_col_name = NULL,

        #' @field reaction_direction_separator It is assumed that reaction IDs take the form {unique id}{separator}{one of N annotations}, where the separator is specified by this length-1 character vector, interpreted as a regular expression.
        reaction_direction_separator = NULL,

        #' @field reaction_directions It is assumed that reaction IDs take the form {unique id}{separator}{one of N annotations}, where the annotations are specified by this length-N character vector, interpreted as regular expressions.
        reaction_directions = NULL,

        #' @field min_reaction_consistency Reactions are dropped that have consistency scores below this threshold.
        min_reaction_consistency = NULL,

        #' @field min_reaction_range Reactions are dropped that have a range of consistency scores narrow than this threshold.
        min_reaction_range = NULL,

        #' @field cluster_strength A number between 0 and 1, specifying the aggressiveness with which to cluster similar reactions together into metareactions.
        cluster_strength = NULL,

        #' @description
        #' Description.
        #'
        #' @param metabolic_model_directory The path to the directory containing the specifications of your metabolic model.
        #' @param gene_metadata_file A path to a file in the metabolic_model_directory containing tabular gene metadata. Each row should represent a single gene. The columns are up to you, so long as one of them provides a unique identifier for each gene.
        #' @param metabolite_metadata_file A path to a file in the metabolic_model_directory containing tabular metabolite metadata. Each row should represent a single metabolite. The columns are up to you, so long as one of them provides a unique identifier for each metabolite.
        #' @param reaction_metadata_file A path to a file in the metabolic_model_directory containing tabular reaction metadata. Each row should represent a single reaction. The columns are up to you, so long as one of them provides a unique identifier for each reaction.
        #' @param user_data_directory The path to the directory containing the data specific to the analysis you hope to conduct.
        #' @param cell_metadata_file A path to a file in the user_data_directory containing tabular cell metadata. Each row should represent a single cell. The columns are up to you, so long as one of them provides a unique identifier for each cell.
        #' @param compass_scores_file A path to a file in the user_data_directory containing the raw reaction consistencies matrix. (This is the output of the COMPASS algorithm.)
        #' @param linear_gene_expression_matrix_file A path to a file in the user_data_directory containing the linear gene expression matrix. (This is the input to the COMPASS algorithm.)
        #' @param cell_id_col_name The name of the column that uniquely identifies each cell in the cell metadata file.
        #' @param gene_id_col_name The name of the column that uniquely identifies each gene in the gene metadata file.
        #' @param reaction_direction_separator It is assumed that reaction IDs take the form {unique id}{separator}{one of N annotations}, where the separator is specified by this length-1 character vector, interpreted as a regular expression.
        #' @param reaction_directions It is assumed that reaction IDs take the form {unique id}{separator}{one of N annotations}, where the annotations are specified by this length-N character vector, interpreted as regular expressions.
        #' @param min_reaction_consistency Reactions are dropped that have consistency scores below this threshold.
        #' @param min_reaction_range Reactions are dropped that have a range of consistency scores narrow than this threshold.
        #' @param cluster_strength A number between 0 and 1, specifying the aggressiveness with which to cluster similar reactions together into metareactions.
        #' @param ... Unused.
        #'
        #' @return NULL.
        initialize = function(
            ...,
            metabolic_model_directory = system.file("extdata", "RECON2", package = "compassR", mustWork = TRUE),
            gene_metadata_file = "gene_metadata.csv",
            metabolite_metadata_file = "metabolite_metadata.csv",
            reaction_metadata_file = "reaction_metadata.csv",
            user_data_directory,
            cell_metadata_file = "cell_metadata.csv",
            compass_scores_file = "reactions.tsv",
            linear_gene_expression_matrix_file = "linear_gene_expression_matrix.tsv",
            cell_id_col_name,
            gene_id_col_name,
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
            self$compass_scores_path <- file.path(
                user_data_directory,
                compass_scores_file
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
        #' Prints a human-readable representation of this CompassSettings instance.
        #'
        #' @param ... Unused.
        #'
        #' @return NULL.
        print = function(...) {
            cat(paste(self$repr(), "\n", sep = ""))
        },

        #' @description
        #' Returns a human-readable representation of this CompassSettings instance.
        #'
        #' @param ... Unused.
        #'
        #' @return An output.
        repr = function(...) {
            readable_representation <- paste(
                "CompassSettings:",
                indent(get_binding_representation(
                    "Gene metadata path",
                    self$gene_metadata_path
                )),
                indent(get_binding_representation(
                    "Metabolite metadata path",
                    self$metabolite_metadata_path
                )),
                indent(get_binding_representation(
                    "Reaction metadata path",
                    self$reaction_metadata_path
                )),
                indent(get_binding_representation(
                    "Cell metadata path",
                    self$cell_metadata_path
                )),
                indent(get_binding_representation(
                    "Reaction consistencies path",
                    self$compass_scores_path
                )),
                indent(get_binding_representation(
                    "Linear gene expression matrix path",
                    self$linear_gene_expression_matrix_path
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
