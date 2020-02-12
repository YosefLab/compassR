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
                self$settings$sample_col_name,
                paste("component", 1:num_components, sep = "_")
            )
            umap_components %<>% as_tibble()
            umap_components
        }

    )
)
