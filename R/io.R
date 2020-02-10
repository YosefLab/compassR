#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param expr A param.
#' 
#' @return An output.
#' 
#' @noRd
quiet <- function(expr) {
    suppressWarnings(suppressMessages(expr))
}

#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param file_name A param.
#' 
#' @return An output.
#' 
#' @noRd
read_compass_metadata <- function(file_name) {
    data <- quiet(readr::read_csv(
            file_name,
            col_types = readr::cols(.default = "c"),
            na = c("", "NA", "N/A")
        ))
    data
}

#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param file_name A param.
#' 
#' @return An output.
#' 
#' @noRd
read_compass_matrix <- function(file_name) {
    data <- quiet(readr::read_tsv(
            file_name,
            col_types = readr::cols(X1 = "c", .default = "d"),
            na = c("", "NA", "N/A")
        ))
    data
}

#' @title Title
#' 
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

#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param object_name A param.
#' 
#' @return An output.
#' 
#' @noRd
get_object_representation <- function(object_name) {
    object_representation <- stringr::str_glue(
        "{object_name} object (...)"
    )
    object_representation
}

#' @title Title
#' 
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

#' @title Title
#' 
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
            stringr::str_glue("Package \"{package_name}\" is required for this function. Please install it."),
            call. = FALSE
        )
    }
}

#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reactions_to_drop A param.
#' @param cause A param.
#' @param is_warning A param.
#' 
#' @return An output.
#' 
#' @noRd
alert_of_drop <- function(reactions_to_drop, cause, is_warning = FALSE) {
    if (any(reactions_to_drop)) {
        num_reactions_to_drop <- sum(reactions_to_drop)
        alert <- ifelse(is_warning, warning, message)
        alert(paste(
            num_reactions_to_drop,
            cause,
            "They will be dropped."
        ))
    }
}
