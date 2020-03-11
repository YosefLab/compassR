#' @description
#' Description.
#'
#' @param file_path A param.
#' @param column_specification A param.
#'
#' @return An output.
#'
#' @noRd
read_table <- function(file_path, column_specification) {
    file_reader <- get_file_reader(file_path)
    data <- file_reader(
        file_path,
        col_types = column_specification,
        na = c("", "NA", "N/A", "N.A.", "na", "n/a", "n.a.")
    )
    data
}

#' @description
#' Description.
#'
#' @param file_path A param.
#'
#' @return An output.
#'
#' @noRd
get_file_reader <- function(file_path) {
    if (endsWith(file_path, ".csv") | endsWith(file_path, ".csv.gz")) {
        file_reader <- readr::read_csv
    } else if (endsWith(file_path, ".tsv") | endsWith(file_path, ".tsv.gz")) {
        file_reader <- readr::read_tsv
    } else {
        stop(
            stringr::str_glue("File \"{file_path}\" has an unsupported file extension."),
            call. = FALSE
        )
    }
    file_reader
}

#' @description
#' Description.
#'
#' @param file_path A param.
#'
#' @return An output.
#'
#' @noRd
read_compass_metadata <- function(file_path) {
    data <- read_table(file_path, readr::cols(.default = "c"))
    data
}

#' @description
#' Description.
#'
#' @param file_path A param.
#' @param index A param.
#' @param suppress_warnings A param.
#' @param ... A param.
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
read_compass_matrix <- function(file_path, index, ..., suppress_warnings = FALSE) {
    warning_handler <- if (suppress_warnings) { suppressWarnings } else { function(expr) { expr } }
    data <-
        warning_handler(read_table(file_path, readr::cols())) %>%
        dplyr::rename(!!index := 1) %>%
        tibble::column_to_rownames(index) %>%
        as.data.frame()
    data
}

#' @description
#' Description.
#'
#' @param package_name A param.
#'
#' @return An output.
#'
#' @noRd
require_suggested_package <- function(package_name) {
    if (!requireNamespace(package_name, quietly = TRUE)) {
        stop(
            stringr::str_glue(
                "Package \"{package_name}\" is required for this function. Please install it."
            ),
            call. = FALSE
        )
    }
}

#' @description
#' Description.
#'
#' @param reactions_to_drop A param.
#' @param description A param.
#' @param is_warning A param.
#'
#' @return An output.
#'
#' @noRd
alert_of_drop <- function(reactions_to_drop, description, is_warning = FALSE) {
    if (any(reactions_to_drop)) {
        num_reactions_to_drop <- sum(reactions_to_drop)
        alert <- ifelse(is_warning, warning, message)
        alert(stringr::str_glue(
            "Dropping {num_reactions_to_drop} reactions that are {description} ..."
        ))
    }
}

#' @description
#' Description.
#'
#' @param string A param.
#' @param indentation_level A param.
#' @param indentation_style A param.
#'
#' @return An output.
#'
#' @noRd
indent <- function(string, indentation_level = 1, indentation_style = "  ") {
    indented_string <- paste(
        strrep("  ", indentation_level),
        string,
        sep = ""
    )
    indented_string
}

#' @description
#' Description.
#'
#' @param binding_name A param.
#' @param binding_value A param.
#' @param separator A param.
#' @param ...
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
get_binding_representation <- function(binding_name, binding_value, ..., separator = ", ") {
    if (length(binding_value) > 1) {
        binding_value %<>% paste(collapse = separator)
    }
    binding_representation <- stringr::str_glue(
        "{binding_name}: {binding_value}"
    )
    binding_representation
}

#' @description
#' Description.
#'
#' @param table A param.
#' @param table_name A param.
#' @param table_class A param.
#' @param rows A param.
#' @param cols A param.
#'
#' @return An output.
#'
#' @noRd
get_tabular_data_representation <- function(table, table_name, table_class, rows, cols) {
    tabular_data_representation <- stringr::str_glue(
        "{table_name} {table_class} ({dim(table)[1]} {rows} x {dim(table)[2]} {cols})"
    )
    tabular_data_representation
}
