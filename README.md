
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aurinapi

<!-- badges: start -->

[![R build
status](https://github.com/asiripanich/aurinapi/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/aurinapi/actions)

<!-- badges: end -->
<p align="center">
<img src="https://aurin.org.au/wp-content/uploads/2018/07/aurin-logo-400.png" />
</p>

The goal of `aurinapi` is to provide an easy way for R users to download
[AURIN](https://aurin.org.au/) datasets using their
[API](https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/).

## Installation

You can install the released version of `aurinapi` from
[GitHub](https://github.com/asiripanich/aurinapi) with:

``` r
install.packages("remotes")
remotes::install_github("asiripanich/aurinapi")
```

This package requires the [sf](https://github.com/r-spatial/sf) package.
Please see the sf package’s [GitHub
page](https://github.com/r-spatial/sf) to install its non R
dependencies.

## Example

Let’s recreate this [AURIN API AND
R](https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/)
example using `aurinapi`.

``` r
library(aurinapi)

# add_to_renviron = TRUE, so you won't need to run this step again on current machine.
aurinapi_register("your-username", password = "your-password", add_to_renviron = T)  
```

`aurinapi_browse()` opens [the data catalogue of
AURIN](https://data.aurin.org.au/dataset) on your default browser.

``` r
aurinapi_browse()
```

Identify the ‘**AURIN Open API ID**’ field on the ‘Additional Info’
table of the dataset that you want to download. For example, for this
[public toilet 2017
dataset](https://data.aurin.org.au/dataset/au-govt-dss-national-public-toilets-2017-na)
its ‘**AURIN Open API ID**’ field is
`"aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017"`.

> Note that, some datasets on AURIN may not have ‘**AURIN Open API
> ID**’, meaning that it cannot be downloaded via their API.

``` r
# download this public toilet dataset.
open_api_id = "aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017"
public_toilets = aurinapi_get(open_api_id = open_api_id)
```

Let’s visualise the data using the `ggplot2` package.

``` r
# If you don't have the package you can install it with `install.packages("ggplot2")`.
library(ggplot2)
ggplot(public_toilets) +
  geom_sf() +
  labs(title = "Public toilets in Australia, 2017")
```

<img src="man/figures/README-example-1.png" width="100%"/>

See [here](https://data.aurin.org.au/group/aurin-api) to find available
datasets.
