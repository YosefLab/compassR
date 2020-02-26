# compassanalytics

This package provides a specialized pipeline for the analysis and interpretation of cell-to-cell metabolic heterogeneity based on the single-cell metabolic reaction consistency matrix produced by the [COMPASS algorithm](https://github.com/YosefLab/Compass). This package also includes a suite of expressive utility functions for conducting statistical analyses building thereupon.

Since COMPASS was originally designed for analyzing single-cell RNA-seq data, the presentation of the algorithm assumes a single-cell data set. However, it can also be applied to bulk RNA data. Note only that it is best suited to applications wherein the number of observations (e.g. RNA-seq libraries or microarrays) is large.

## Installation

1. Make sure you have installed [the `devtools` package](https://github.com/r-lib/devtools) from CRAN.
1. Run `devtools::install_github("YosefLab/compassanalytics")`.

You can accomplish both of these steps by running the following R code:

```R
# Install devtools from CRAN.
install.packages("devtools")

# Install compassanalytics from YosefLab.
devtools::install_github("YosefLab/compassanalytics")
```

## Usage

The following tutorial explains how to use `compassanalytics` to explore a small data set included with the package. If you plan on following along, you should first load `compassanalytics` and `tidyverse`:

```R
library(compassanalytics)
library(tidyverse)
```

For documentation and more in-depth examples, please refer to [the wiki](https://github.com/YosefLab/compassanalytics/wiki).

### Loading your data

In order to make use of the `compassanalytics` package, you first have to specify a few settings in a `CompassSettings` object. Here's an example, tailored to a basic analysis of the included Th17 cell data:

```R
compass_settings <- CompassSettings$new(
    user_data_directory = system.file("extdata", "Th17", package = "compassanalytics"),
    cell_id_col_name = "cell_id",
    gene_id_col_name = "HGNC.symbol"
)
```

Note that the `CompassSettings` constructor can also accept parameters specifying the gene, metabolite, and reaction metadata files that constitute a metabolic model. By omitting these parameters, we opt to use the version of the RECON2 model that ships with the `compassanalytics` package.

Note also that the `user_data_directory` should contain files `cell_metadata.csv`, `reaction_consistencies.tsv`, and `linear_gene_expression_matrix.tsv`. For more information on the contents of these files please refer to [the wiki](https://github.com/YosefLab/compassanalytics/wiki).

The next step is to create a `CompassData` object, like so:

```R
compass_data <- CompassData$new(compass_settings)
```

Upon instantiation, it will postprocess the results of the COMPASS algorithm and populate these tables:

* `compass_data$reaction_consistencies`: A data frame of per-cell reaction consistencies.
* `compass_data$metareaction_consistencies`: A data frame of per-cell metareaction consistencies.
* `compass_data$gene_expression_statistics`: A data frame describing the total expression, metabolic expression, and metabolic activity of each cell.
* `compass_data$cell_metadata`: A tibble containing cell metadata specific to the Th17 data set.
* `compass_data$gene_metadata`: A tibble containing gene metadata specific to the RECON2 metabolic model.
* `compass_data$metabolite_metadata`: A tibble containing metabolite metadata specific to the RECON2 metabolic model.
* `compass_data$reaction_metadata`: A tibble containing reaction metadata specific to the RECON2 metabolic model.
* `compass_data$reaction_partitions`: A tibble grouping similar reactions into metareactions.

### Exploring the statistical analysis suite

To conduct statistical analyses on the aforementioned data, make a `CompassAnalyzer` object:

```R
compass_analyzer <- CompassAnalyzer$new(compass_settings)
```

#### Making a UMAP plot

This code will generate a few UMAP plots, wherein each datum is a cell whose coordinates are a low-dimensional embedding of its consistencies with each of the metareactions in `compass_data$metareaction_consistencies`.

```R
cell_info_with_umap_components <-
    compass_analyzer$get_umap_components(
        compass_data$metareaction_consistencies
    ) %>%
    inner_join(
        compass_data$cell_metadata,
        by = "cell_id"
    ) %>%
    left_join(
        t(compass_data$gene_expression_statistics) %>% as_tibble(rownames = "cell_id"),
        by = "cell_id"
    )

ggplot(
    cell_info_with_umap_components,
    aes(x = component_1, y = component_2, color = cell_type)
) +
scale_color_discrete(guide = FALSE) +
geom_point(size = 1, alpha = 0.8) +
theme_bw()

ggplot(
    cell_info_with_umap_components,
    aes(x = component_1, y = component_2, color = metabolic_activity)
) +
scale_color_viridis_c() +
geom_point(size = 1, alpha = 0.8) +
theme_bw()
```

#### Conducting a Wilcoxon test

Meanwhile, this code will tell us whether each metareaction in `compass_data$metareaction_consistencies` is more consistent in cells with below-average overall metabolic activity or cells with above-average overall metabolic activity.

```R
cell_ids_with_gene_expression_statistics <-
    compass_data$gene_expression_statistics %>%
    t() %>%
    as_tibble(rownames = "cell_id")
group_A_cell_ids <-
    cell_ids_with_gene_expression_statistics %>%
    filter(metabolic_activity <= mean(metabolic_activity, na.rm = TRUE)) %>%
    pull(cell_id)
group_B_cell_ids <-
    cell_ids_with_gene_expression_statistics %>%
    filter(metabolic_activity > mean(metabolic_activity, na.rm = TRUE)) %>%
    pull(cell_id)
wilcoxon_results <- compass_analyzer$conduct_wilcoxon_test(
    compass_data$metareaction_consistencies,
    group_A_cell_ids,
    group_B_cell_ids
)
```
