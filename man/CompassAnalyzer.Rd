% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CompassAnalyzer.R
\name{CompassAnalyzer}
\alias{CompassAnalyzer}
\title{CompassAnalyzer}
\description{
An object through which you can access several useful functions for your COMPASS analysis.
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{settings}}{The CompassSettings instance specifying the settings for this CompassAnalyzer instance.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{CompassAnalyzer$new()}}
\item \href{#method-print}{\code{CompassAnalyzer$print()}}
\item \href{#method-repr}{\code{CompassAnalyzer$repr()}}
\item \href{#method-conduct_wilcoxon_test}{\code{CompassAnalyzer$conduct_wilcoxon_test()}}
\item \href{#method-get_umap_components}{\code{CompassAnalyzer$get_umap_components()}}
\item \href{#method-clone}{\code{CompassAnalyzer$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\subsection{Method \code{new()}}{
Initialize the CompassAnalyzer instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompassAnalyzer$new(settings)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{settings}}{The CompassSettings instance specifying the settings for this CompassAnalyzer instance.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
NULL.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-print"></a>}}
\subsection{Method \code{print()}}{
Prints a human-readable representation of this CompassAnalyzer instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompassAnalyzer$print(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Unused.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
NULL.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-repr"></a>}}
\subsection{Method \code{repr()}}{
Returns a human-readable representation of this CompassAnalyzer instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompassAnalyzer$repr(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{Unused.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
An output.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-conduct_wilcoxon_test"></a>}}
\subsection{Method \code{conduct_wilcoxon_test()}}{
Description.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompassAnalyzer$conduct_wilcoxon_test(
  consistencies_matrix,
  group_A_cell_ids,
  group_B_cell_ids,
  ...,
  for_metareactions = TRUE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{consistencies_matrix}}{Either your CompassData instance's reaction_consistencies matrix, or its metareaction_consistencies matrix, depending on whether you want a table whose rows correspond to reactions or metareactions.}

\item{\code{group_A_cell_ids}}{A character vector containing the IDs of the cells that constitute group A.}

\item{\code{group_B_cell_ids}}{A character vector containing the IDs of the cells that constitute group B.}

\item{\code{...}}{Unused.}

\item{\code{for_metareactions}}{Whether the first argument is your reaction_consistencies matrix or your metareaction_consistencies matrix. This argument doesn't affect the contents of the returned tibble, but merely ensures that its column names are appropriate.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A tibble, where each row represents a Wilcoxon rank-sum test for whether a reaction or metareaction achieves a higher consistency among the group A cells than among the group B cells. It has the following columns: reaction_id or metareaction_id, wilcoxon_statistic, cohens_d, p_value, and adjusted_p_value.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-get_umap_components"></a>}}
\subsection{Method \code{get_umap_components()}}{
Description.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompassAnalyzer$get_umap_components(
  consistencies_matrix,
  ...,
  num_components = 2
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{consistencies_matrix}}{Either your CompassData instance's reaction_consistencies matrix, or its metareaction_consistencies matrix, depending on whether the high-dimensional representation of each cell should encapsulate the cell's reaction consistencies or its metareaction consistencies. In the former case the UMAP algorithm will find a num_components-dimensional embedding for each cell in (# reactions)-dimensional space, and in the latter case the UMAP algorithm will find a num_components-dimensional embedding for each cell in (# metareactions)-dimensional space.}

\item{\code{...}}{Unused.}

\item{\code{num_components}}{The number of UMAP components to calculate (i.e. the dimensionality of the embedding).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A tibble, where each row represents the low-dimensional UMAP embedding of a cell. It has the following columns: Your CompassSettings instance's cell_id_col_name, component_1, component_2, ..., component_{num_components}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompassAnalyzer$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
