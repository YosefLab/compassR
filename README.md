# compassanalytics

This package provides a specialized pipeline for the analysis and interpretation of cell-to-cell metabolic heterogeneity based on the single-cell metabolic reaction consistency matrix produced by the [COMPASS algorithm](https://github.com/YosefLab/Compass). This package also includes a suite of expressive utility functions for conducting statistical analyses building thereupon.

Note: Compass is particularly useful when the number of observations (RNA-Seq libraries, microarrays etc.) is large, which is the case in single-cell RNA-Seq. For this reason, the presentation of the algorith assumes a single-cell dataset. However, Compass can also be applied to bulk RNA data.

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

Please refer to [the wiki](https://github.com/YosefLab/compassanalytics/wiki) for documentation on using this package.
