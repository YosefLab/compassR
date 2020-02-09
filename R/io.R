#' Title
#' 
#' Description
#' 
#' @param file_name the first param
#' 
#' @return the output
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

#' Title
#' 
#' Description
#' 
#' @param file_name the first param
#' 
#' @return the output
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
