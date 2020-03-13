#' @title CompassAnalyzer
#'
#' @description
#' An object through which you can access several useful functions for your COMPASS analysis.
#'
#' @export
CompassAnalyzer <- R6::R6Class(
    "CompassAnalyzer",
    public = list(

        #' @field settings The CompassSettings instance specifying the settings for this CompassAnalyzer instance.
        settings = NULL,

        #' @description
        #' Initialize the CompassAnalyzer instance.
        #'
        #' @param settings The CompassSettings instance specifying the settings for this CompassAnalyzer instance.
        #'
        #' @return NULL.
        initialize = function(settings) {
            self$settings <- settings
        },

        #' @description
        #' Prints a human-readable representation of this CompassAnalyzer instance.
        #'
        #' @param ... Unused.
        #'
        #' @return NULL.
        print = function(...) {
            cat(paste(self$repr(), "\n", sep = ""))
        },

        #' @description
        #' Returns a human-readable representation of this CompassAnalyzer instance.
        #'
        #' @param ... Unused.
        #'
        #' @return An output.
        repr = function(...) {
            readable_representation <- paste(
                "CompassAnalyzer",
                sep = "\n"
            )
            readable_representation
        },

        #' @description
        #' Description.
        #'
        #' @param consistencies_matrix Either your CompassData instance's reaction_consistencies matrix, or its metareaction_consistencies matrix, depending on whether you want a table whose rows correspond to reactions or metareactions.
        #' @param group_A_cell_ids A character vector containing the IDs of the cells that constitute group A.
        #' @param group_B_cell_ids A character vector containing the IDs of the cells that constitute group B.
        #' @param for_metareactions Whether the first argument is your reaction_consistencies matrix or your metareaction_consistencies matrix. This argument doesn't affect the contents of the returned tibble, but merely ensures that its column names are appropriate.
        #' @param ... Unused.
        #'
        #' @return A tibble, where each row represents a Wilcoxon rank-sum test for whether a reaction or metareaction achieves a higher consistency among the group A cells than among the group B cells. It has the following columns: reaction_id or metareaction_id, wilcoxon_statistic, cohens_d, p_value, and adjusted_p_value.
        #'
        #' @importFrom magrittr %>% %<>%
        conduct_wilcoxon_test = function(consistencies_matrix, group_A_cell_ids, group_B_cell_ids, ..., for_metareactions = TRUE) {
            if (0 < length(intersect(group_A_cell_ids, group_B_cell_ids))) {
                message("Groups A and B are not mutually exclusive. Continuing anyways ...")
            }
            group_A_values_per_metareaction <-
                consistencies_matrix %>%
                t() %>%
                tibble::as_tibble(rownames = self$settings$cell_id_col_name) %>%
                dplyr::right_join(
                    tibble::tibble(!!self$settings$cell_id_col_name := group_A_cell_ids),
                    by = self$settings$cell_id_col_name
                ) %>%
                as.data.frame()
            group_B_values_per_metareaction <-
                consistencies_matrix %>%
                t() %>%
                tibble::as_tibble(rownames = self$settings$cell_id_col_name) %>%
                dplyr::right_join(
                    tibble::tibble(!!self$settings$cell_id_col_name := group_B_cell_ids),
                    by = self$settings$cell_id_col_name
                ) %>%
                as.data.frame()
            metareaction_ids <- rownames(consistencies_matrix)
            wilcoxon_results <-
                purrr::map_dfr(
                    metareaction_ids,
                    function(metareaction_id) {
                        group_A_values <- group_A_values_per_metareaction[,metareaction_id]
                        group_B_values <- group_B_values_per_metareaction[,metareaction_id]
                        wilcoxon_result_obj <- wilcox.test(group_A_values, group_B_values)
                        wilcoxon_result_tbl <- data.frame(
                            metareaction_id = metareaction_id,
                            wilcoxon_statistic = wilcoxon_result_obj$statistic,
                            cohens_d = cohens_d(group_A_values, group_B_values),
                            p_value = wilcoxon_result_obj$p.value,
                            stringsAsFactors = FALSE
                        )
                        wilcoxon_result_tbl
                    }
                ) %>%
                tibble::as_tibble() %>%
                dplyr::mutate(adjusted_p_value = p.adjust(dplyr::pull(., p_value), method = "BH"))
            if (!for_metareactions) {
                wilcoxon_results %<>% dplyr::rename(reaction_id = metareaction_id)
            }
            wilcoxon_results
        },

        #' @description
        #' Description.
        #'
        #' @param consistencies_matrix Either your CompassData instance's reaction_consistencies matrix, or its metareaction_consistencies matrix, depending on whether the high-dimensional representation of each cell should encapsulate the cell's reaction consistencies or its metareaction consistencies. In the former case the UMAP algorithm will find a num_components-dimensional embedding for each cell in (# reactions)-dimensional space, and in the latter case the UMAP algorithm will find a num_components-dimensional embedding for each cell in (# metareactions)-dimensional space.
        #' @param num_components The number of UMAP components to calculate (i.e. the dimensionality of the embedding).
        #' @param ... Unused.
        #'
        #' @return A tibble, where each row represents the low-dimensional UMAP embedding of a cell. It has the following columns: Your CompassSettings instance's cell_id_col_name, component_1, component_2, ..., component_{num_components}.
        #'
        #' @importFrom magrittr %>% %<>%
        get_umap_components = function(consistencies_matrix, ..., num_components = 2) {
            require_suggested_package("uwot")
            umap_components <- uwot::umap(t(consistencies_matrix), n_components = num_components)
            umap_components %<>% cbind(colnames(consistencies_matrix), .)
            colnames(umap_components) <- append(
                self$settings$cell_id_col_name,
                paste("component", 1:num_components, sep = "_")
            )
            umap_components %<>% tibble::as_tibble()
            umap_components
        }

    )
)
