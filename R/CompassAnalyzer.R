#' @title Title
#' 
#' @description
#' Description.
#' 
#' @export
CompassAnalyzer <- R6::R6Class(
    "CompassAnalyzer",
    public = list(

        #' @field settings A field.
        settings = NULL,

        #' @description
        #' Description.
        #'
        #' @param settings
        #'
        #' @return An output.
        initialize = function(settings) {
            self$settings <- settings
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
                "CompassAnalyzer",
                sep = "\n"
            )
            readable_representation
        },

        #' @description
        #' Description.
        #' 
        #' @param consistencies_matrix A param.
        #' @param num_components A param.
        #' @param ... A param.
        #' 
        #' @return An output.
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
            umap_components %<>% as_tibble()
            umap_components
        },

        #' @description
        #' Description.
        #' 
        #' @param consistencies_matrix A param.
        #' @param group_A_cell_ids A param.
        #' @param group_B_cell_ids A param.
        #' @param for_metareactions A param.
        #' @param ... A param.
        #' 
        #' @return An output.
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
        }

    )
)
