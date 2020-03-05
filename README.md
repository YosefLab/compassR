# compassanalytics

This package provides a specialized pipeline for the analysis and interpretation of cell-to-cell metabolic heterogeneity based on the single-cell metabolic reaction consistency matrix produced by the [COMPASS algorithm](https://github.com/YosefLab/Compass). It also includes a suite of expressive utility functions for conducting statistical analyses building thereupon.

Since COMPASS was originally designed for analyzing single-cell RNA-seq data, the presentation of the algorithm assumes a single-cell data set. However, it can also be applied to bulk RNA data. Note only that it is best suited to applications wherein the number of observations (e.g. RNA-seq libraries or microarrays) is large.

## Installation

1. Make sure you have installed [the `devtools` package](https://github.com/r-lib/devtools) from CRAN.
1. Run `devtools::install_github("YosefLab/compassanalytics")`.

You can accomplish both of these steps by running the following R code.

```R
# Install devtools from CRAN.
install.packages("devtools")

# Install compassanalytics from YosefLab.
devtools::install_github("YosefLab/compassanalytics")
```

## Usage

In the following tutorial, we'll explore the [Th17 cell data set](https://www.biorxiv.org/content/10.1101/2020.01.23.912717v1) that ships with the package. It will help you get acquainted with the basics, while skipping over some of the finer details; if you're an advanced user looking for the full documentation, please refer to the [the wiki](https://github.com/YosefLab/compassanalytics/wiki) instead.

### Loading your data

Our first step is to specify a few settings via a `CompassSettings` object.

```R
compass_settings <- CompassSettings$new(
    user_data_directory = system.file("extdata", "Th17", package = "compassanalytics"),
    cell_id_col_name = "cell_id",
    gene_id_col_name = "HGNC.symbol"
)
```

There are 3 important parameters.

* `user_data_directory` is the path to the directory that contains the data you want to analyze. This directory should include files named `"cell_metadata.csv"`, `"reactions.tsv"`, and `"linear_gene_expression_matrix.tsv"`.
* `cell_id_col_name` is the column in `"cell_metadata.csv"` that uniquely identifies the cells in your data set.
* And finally, `gene_id_col_name` is the column in `"gene_metadata.csv"` that uniquely identifies the genes you're interested in. Note that you do not have to provide this file unless you're an advanced user. By default, analyses will just use the one included in the version of RECON2 that comes with the package -- in which case you can use `"HGNC.symbol"` for human genes or `"MGI.symbol"` for mouse genes.

Now we can load our data by creating a `CompassData` object.

```R
compass_data <- CompassData$new(compass_settings)
```

This line may take a minute to run. Under the hood, it's postprocessing the results of the COMPASS algorithm and populating a few tables that we'll find useful for our analyses later on:

| Table                        | Type       | Description                                                  |
| ---------------------------- | ---------- | ------------------------------------------------------------ |
| `reaction_consistencies`     | Data frame | Each row is a reaction and each column is a cell. `reaction_consistencies[i, j]` is the consitency (or "compatibility") between reaction `i` and cell `j`. |
| `metareaction_consistencies` | Data frame | Each row is a metareaction and each column is a cell. `metareaction_consistencies[i, j]` is the consistency (or "compatibility") between metareaction `i` and cell `j`. |
| `gene_expression_statistics` | Data frame | Each column describes a cell's total expression, metabolic expression, and metabolic activity. |
| `cell_metadata`              | Tibble     | The cell metadata from `"cell_metadata.csv"`. In this example it's the Th17 cell data from the paper linked above. |
| `gene_metadata`              | Tibble     | The gene metadata from the metabolic model (RECON2, by default). |
| `metabolite_metadata`        | Tibble     | The metabolite metadata from the metabolic model (RECON2, by default). |
| `reaction_metadata`          | Tibble     | The reaction metadata from the metabolic model (RECON2, by default). |
| `reaction_partitions`        | Tibble     | Each row describes a reaction and which metareaction it belongs to. (A metareaction is a group of similar reactions.) |

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
