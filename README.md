# compassR

This package provides a specialized pipeline for the analysis and interpretation of cell-to-cell metabolic heterogeneity based on the single-cell metabolic reaction consistency matrix produced by the [COMPASS algorithm](https://github.com/YosefLab/Compass). It also includes a suite of expressive utility functions for conducting statistical analyses building thereupon.

The presentation of the algorithm assumes a single-cell data set. However, you may choose to group cells together (e.g. via [metacell](https://github.com/tanaylab/metacell) or [micropooling](https://github.com/YosefLab/Vision)) to reduce computational overhead. You may also apply COMPASS to bulk transcriptome data sets (e.g. bulk RNA-seq or microarray data sets) of ample size.

## Installation

1. Make sure you have installed [the `devtools` package](https://github.com/r-lib/devtools) from CRAN.
1. Run `devtools::install_github("YosefLab/compassR")`.

You can accomplish both of these steps by running the following R code.

```R
# Install devtools from CRAN.
install.packages("devtools")

# Install compassR from YosefLab.
devtools::install_github("YosefLab/compassR")
```

## Usage

In the following tutorial, we'll explore the Th17 cell data set ([Wagner et al.](https://www.biorxiv.org/content/10.1101/2020.01.23.912717v1); [Wang et al.](https://www.biorxiv.org/content/10.1101/2020.01.23.911966v1)) that ships with the package. It will help you get acquainted with the basics, while skipping over some of the finer details; if you're an advanced user looking for the full documentation, please refer to the [the wiki](https://github.com/YosefLab/compassR/wiki) instead.

### Loading your data

Our first step is to specify a few settings via a `CompassSettings` object.

```R
compass_settings <- CompassSettings$new(
    user_data_directory = system.file("extdata", "Th17", package = "compassR"),
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
| `cell_metadata`              | Tibble     | The cell metadata from `cell_metadata.csv`. In this example it's the Th17 cell data from the papers linked above. |
| `gene_metadata`              | Tibble     | The gene metadata from the metabolic model (RECON2, by default). |
| `metabolite_metadata`        | Tibble     | The metabolite metadata from the metabolic model (RECON2, by default). |
| `reaction_metadata`          | Tibble     | The reaction metadata from the metabolic model (RECON2, by default). |
| `reaction_partitions`        | Tibble     | Each row describes a reaction and which metareaction (i.e. reaction group) it belongs to. |

### Exploring the statistical analysis suite

Now we're ready to start our analysis! We begin by making a `CompassAnalyzer` object.

```R
compass_analyzer <- CompassAnalyzer$new(compass_settings)
```

With the `CompassAnalyzer`, it's easy to conduct statistical analyses. Let's do a Wilcoxon rank-sum test for whether each reaction achieves a higher consistency among Th17p cells or Th17n cells.

```R
group_A_cell_ids <-
    compass_data$cell_metadata %>%
    filter(cell_type == "Th17p") %>%
    pull(cell_id)
group_B_cell_ids <-
    compass_data$cell_metadata %>%
    filter(cell_type == "Th17n") %>%
    pull(cell_id)
wilcoxon_results <- compass_analyzer$conduct_wilcoxon_test(
    compass_data$reaction_consistencies,
    group_A_cell_ids,
    group_B_cell_ids,
    for_metareactions = FALSE
)
```

We can use functions from the tidyverse to combine the results of our Wilcoxon test with the data we loaded earlier.

```R
cohens_d_by_subsystem <-
    wilcoxon_results %>%
    left_join(
        select(compass_data$reaction_partitions, "reaction_id", "undirected_reaction_id"),
        by = "reaction_id"
    ) %>%
    left_join(
        compass_data$reaction_metadata,
        by = c("undirected_reaction_id" = "rxn_code_nodirection")
    ) %>%
    # Keep only "confident reactions", as defined in our paper.
    filter(!is.na(rxn_EC_number)) %>%
    filter(rxn_confidence == "0" | rxn_confidence == "4") %>%
    # Keep only "interesting subsystems", as defined in our paper.
    filter(!(startsWith(subsystem, "Transport") | startsWith(subsystem, "Exchange"))) %>%
    filter(!(subsystem == "Miscellaneous" | subsystem == "Unassigned")) %>%
    # Keep only subsystems of non-negligible size.
    group_by(subsystem) %>%
    filter(n() > 5) %>%
    ungroup() %>%
    # Order subsystems in a manner that will lend itself to a visually aesthetic plot.
    mutate(
        subsystem_priority = factor(subsystem) %>%
        fct_reorder2(
            cohens_d,
            adjusted_p_value,
            .fun = function(cohens_d, adjusted_p_value) {
                abs(median(cohens_d[adjusted_p_value < 0.1]))
            },
            .desc = FALSE
        )
    )
```

And now, with a little `ggplot2`, we can reproduce the plot from the paper linked above ...

```R
ggplot(
    cohens_d_by_subsystem,
    aes(
        x = subsystem_priority,
        y = cohens_d,
        color = if_else(cohens_d > 0, "up_regulated", "down_regulated"),
        alpha = if_else(adjusted_p_value < 0.1, "significant", "insignificant")
    )
) +
ggtitle("Up- and Down-Regulated Reactions Cross Pathway Boundaries") +
xlab("") +
ylab("Cohen's d") +
scale_color_manual(
    values = c(up_regulated = "#ca0020", down_regulated = "#0571b0"),
    guide = FALSE
) +
scale_alpha_manual(
    name = "",
    values = c(significant = 1, insignificant = 0.25),
    labels = c(significant = "BH-adjusted p-value < 0.1", insignificant = "insignificant")
) +
coord_flip() +
geom_point() +
geom_hline(yintercept = 0, linetype = "dashed") +
theme_bw() +
theme(legend.position = "bottom", legend.direction = "horizontal")
```

Voila!

![Up- and Down- Regulated Reactions Cross Pathway Boundaries](assets/Up- and Down- Regulated Reactions Cross Pathway Boundaries.pdf)
