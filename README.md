
<!-- README.md is generated from README.Rmd. Please edit that file -->

# notaurin

<!-- badges: start -->

[![R-CMD-check](https://github.com/asiripanich/aurin/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/asiripanich/aurin/actions/workflows/R-CMD-check.yaml)
![](https://www.r-pkg.org/badges/version-ago/notaurin)
[![](https://cranlogs.r-pkg.org/badges/notaurin)](https://cran.r-project.org/package=notaurin)
[![](https://cranlogs.r-pkg.org/badges/grand-total/notaurin)](https://CRAN.R-project.org/package=notaurin)
<!-- badges: end -->

<p align="center">
<img src="https://aurin.org.au/wp-content/uploads/2018/07/aurin-logo-400.png" />
</p>
<p align="center">
🚧 <b>Warning! The `notaurin` package is not affiliated with AURIN in
any way.</b> 🚧 <br>
</p>

The official AURIN R tutorial can be found
[here](https://aurin.org.au/resources/training/explore-r/). Want to know
a more convenient way to access the AURIN data portal from R which AURIN
simply doesn’t seem to offer? Maybe give {notaurin} a try. 😬

The goal of {notaurin} is to provide an easy way for R users to access
**MORE THAN 5000 OPEN DATASETS** on [AURIN](https://aurin.org.au/) using
their [Data Portal](https://data.aurin.org.au/). You can request an API
key from:

> <https://aurin.org.au/resources/einfrastructure/>

**AURIN** is “*Australia’s :kangaroo: single largest resource for
accessing clean, integrated, spatially enabled and research-ready data
on issues surrounding health and wellbeing, socio-economic metrics,
transportation, and land-use.*”

## Installation

Here are ways you can install `notaurin`:

``` r
# from CRAN for the latest version
install.packages("notaurin")
# from GitHub for the latest development version
install.packages("remotes")
remotes::install_github("asiripanich/notaurin")
```

This package requires the [sf](https://github.com/r-spatial/sf) package.
Please see the sf package’s [GitHub
page](https://github.com/r-spatial/sf) to install its non R
dependencies.

## Example

First, you must add your [AURIN API username and
password](https://aurin.org.au/resources/aurin-apis/sign-up/) as an R
environment variable to your `.Renviron` file. `notaurin` provides
`aur_register()` function to help you with this step. If you choose to
set `add_to_renviron = TRUE` you won’t need to run this step again on
current machine after you restart your R session.

``` r
library(notaurin)

# add_to_renviron = TRUE, so you won't need to run this step again on current machine.
aur_register(username = "your-username", password = "your-password", add_to_renviron = T)  
```

`aur_browse()` opens [the data catalogue of
AURIN](https://data.aurin.org.au/dataset) on your default browser.

``` r
aur_browse()
```

Identify the ‘**AURIN Open API ID**’ field on the ‘Additional Info’
table of the dataset that you want to download. For example, for this
[public toilet 2017
dataset](https://data.aurin.org.au/dataset/au-govt-dss-national-public-toilets-2017-na)
its ‘**AURIN Open API ID**’ field is
`"aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets"`.

> Note that, some datasets on AURIN may not have ‘**AURIN Open API
> ID**’, meaning that it cannot be downloaded via their API.

Alternatively, you may use `aur_meta` to search datasets without leaving
your R console.

``` r
meta <- aur_meta()
#> ℹ Creating AURIN WFS Client...
#> ℹ Fetching available datasets...
# print out the first five rows
knitr::kable(head(meta))
```

| aurin_open_api_id                                                    | title                                                           |
|:---------------------------------------------------------------------|:----------------------------------------------------------------|
| datasource-NSW_Govt_DPE-UoM_AURIN_DB:nsw_srlup_additional_rural_2014 | Additional Rural Village Land 18/01/2014 for NSW                |
| datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:aus_2016_aust           | ABS - ASGS - Country (AUS) 2016                                 |
| datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:gccsa_2011_aust         | ABS - ASGS - Greater Capital City Statistical Area (GCCSA) 2011 |
| datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:gccsa_2016_aust         | ABS - ASGS - Greater Capital City Statistical Area (GCCSA) 2016 |
| datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2016_aust            | ABS - ASGS - Mesh Block (MB) 2016                               |
| datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:mb_2011_act             | ABS - ASGS - Mesh Block (MB) ACT 2011                           |

Use `aur_get()` to download the dataset.

``` r
# download this public toilet dataset.
open_api_id <- "datasource-AU_Govt_DSS-UoM_AURIN:national_public_toilets_2017"
public_toilets <- aur_get(open_api_id = open_api_id)
#> ℹ Downloading 'datasource-AU_Govt_DSS-UoM_AURIN:national_public_toilets_2017'...[K✔ Downloading 'datasource-AU_Govt_DSS-UoM_AURIN:national_public_toilets_2017'... [2.6s][K
state_polygons <- aur_get(open_api_id = "datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:ste_2016_aust")
#> ℹ Downloading 'datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:ste_2016_aust'...[K✔ Downloading 'datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel:ste_2016_aust'... [6.6s][K
state_polygons <- state_polygons[state_polygons$state_code_2016 %in% 1:8, ]
```

Let’s visualise the data using the `ggplot2` package.

``` r
# If you don't have the package you can install it with `install.packages("ggplot2")`.
library(ggplot2)
ggplot(public_toilets) +
  geom_sf(data = state_polygons, fill = "antiquewhite") +
  geom_sf(alpha = 0.05, aes(color = status)) +
  labs(title = "Public toilets in Australia, 2017") +
  scale_color_brewer(palette = "Dark2") +
  theme_bw() +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  theme(panel.background = element_rect(fill = "aliceblue"))
```

<img src="man/figures/README-example-public-toilet-plot-1.png" width="100%" />

See [here](https://data.aurin.org.au/group/aurin-api) to find available
datasets.

## Download multiple datasets in parallel

When there are many datasets that you need to download, you may want to
put all of your CPUs to work. The code chucks below show how you can
download multiple datasets in parallel using the {furrr} and {future}
packages.

First, setup the workers - this affects how many datasets you can
download in parallel at the same time. The maximum number of workers of
your machine can be determined using `future::availableCores()`.

``` r
library(furrr)
library(future)
future::plan(future::multiprocess, workers = 2)
#> Warning: Strategy 'multiprocess' is deprecated in future (>= 1.20.0) [2020-10-30]. Instead, explicitly specify either 'multisession' (recommended) or 'multicore'. In the current R session,
#> 'multiprocess' equals 'multicore'.
```

Let’s assume you want the *first 10 rows* of all datasets on AURIN with
the word “toilet” in their title.

``` r
knitr::kable(meta[grepl("toilet", meta$title, ignore.case = T), ])
```

|      | aurin_open_api_id                                                 | title                                                  |
|:-----|:------------------------------------------------------------------|:-------------------------------------------------------|
| 1519 | datasource-AU_Govt_DSS-UoM_AURIN:national_public_toilets_2017     | DSS - National Public Toilets (Point) 2017             |
| 1579 | datasource-AU_Govt_Doh-UoM_AURIN_DB_1:national_toilet_map_2018_06 | Department of Health - National Toilet Map - June 2018 |
| 3117 | datasource-UQ_ERG-UoM_AURIN_DB:public_toilets                     | Public Toilets 2004-2014 for Australia                 |

Extract their AURIN open API ids and download all of them in parallel.

``` r
toilet_datasets_ids <- meta$aurin_open_api_id[grepl("toilet", meta$title, ignore.case = T)]
data_lst <- furrr::future_map(toilet_datasets_ids, ~ aur_get(.x, params = list(maxFeatures = 10)))
#> ℹ Downloading 'datasource-AU_Govt_DSS-UoM_AURIN:national_public_toilets_2017'...[K✔ Downloading 'datasource-AU_Govt_DSS-UoM_AURIN:national_public_toilets_2017'... [2.7s][K
#> ℹ Downloading 'datasource-AU_Govt_Doh-UoM_AURIN_DB_1:national_toilet_map_2018_06'...[K✔ Downloading 'datasource-AU_Govt_Doh-UoM_AURIN_DB_1:national_toilet_map_2018_06'... [2.7s][K
#> ℹ Downloading 'datasource-UQ_ERG-UoM_AURIN_DB:public_toilets'...[K✔ Downloading 'datasource-UQ_ERG-UoM_AURIN_DB:public_toilets'... [2s][K
data_lst
#> [[1]]
#> Simple feature collection with 18789 features and 46 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 113.4102 ymin: -43.582 xmax: 153.6263 ymax: -10.57019
#> Geodetic CRS:  WGS 84
#> # A tibble: 18,789 × 47
#>    id          toile…¹ url   name  addre…² town  state postc…³ addre…⁴ male  female unisex dump_…⁵ facil…⁶ toile…⁷ acces…⁸ payme…⁹ key_r…˟ acces…˟ parking parki…˟ acces…˟ acces…˟ acces…˟ acces…˟ mlak 
#>    <chr>         <int> <chr> <chr> <chr>   <chr> <chr>   <int> <chr>   <lgl> <lgl>  <lgl>  <lgl>   <chr>   <chr>   <lgl>   <lgl>   <lgl>   <chr>   <lgl>   <chr>   <lgl>   <lgl>   <lgl>   <chr>   <lgl>
#>  1 national_p…     341 http… Elsi… Alden … Clif… Quee…    4361 <NA>    TRUE  TRUE   FALSE  FALSE   Park o… <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    TRUE    TRUE    FALSE   <NA>    FALSE
#>  2 national_p…     418 http… Luck… Lucky … Luck… Sout…    5602 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    TRUE    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  3 national_p…     634 http… Olds… Holley… Mort… New …    2223 <NA>    TRUE  TRUE   FALSE  FALSE   Park o… <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    TRUE    TRUE    FALSE   <NA>    TRUE 
#>  4 national_p…    1150 http… Jaeg… Hill S… Oran… New …    2800 <NA>    TRUE  TRUE   FALSE  FALSE   Park o… <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  5 national_p…    1207 http… Lake… Evans … Shen… West…    6008 <NA>    FALSE FALSE  TRUE   FALSE   Park o… Automa… FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   TRUE    <NA>    FALSE
#>  6 national_p…    1535 http… Earl… Earl S… Coff… New …    2450 <NA>    TRUE  TRUE   FALSE  FALSE   Sporti… Sewera… FALSE   FALSE   FALSE   <NA>    TRUE    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  7 national_p…    1590 http… Truc… Davids… Deni… New …    2710 <NA>    TRUE  TRUE   FALSE  FALSE   Car pa… Sewera… FALSE   FALSE   FALSE   <NA>    TRUE    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  8 national_p…    1913 http… Hemi… High S… Belm… Vict…    3216 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    TRUE    TRUE    FALSE   <NA>    FALSE
#>  9 national_p…    2081 http… Eden… Eden V… Keyn… Sout…    5353 The to… TRUE  TRUE   FALSE  FALSE   Park o… Septic  FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    TRUE    TRUE    FALSE   <NA>    FALSE
#> 10 national_p…    2377 http… Wils… Wilson… Watt… Vict…    3096 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#> # … with 18,779 more rows, 21 more variables: parking_accessible <lgl>, access_parking_note <chr>, ambulant <lgl>, lh_transfer <lgl>, rh_transfer <lgl>, adult_change <lgl>, is_open <chr>,
#> #   opening_hours <chr>, openinghours_note <chr>, baby_change <lgl>, showers <lgl>, drinking_water <lgl>, sharps_disposal <lgl>, sanitary_disposal <lgl>, icon_url <chr>, icon_alt_text <chr>,
#> #   notes <chr>, status <chr>, latitude <dbl>, longitude <dbl>, geometry <POINT [°]>, and abbreviated variable names ¹​toilet_id, ²​address1, ³​postcode, ⁴​address_note, ⁵​dump_point, ⁶​facility_type,
#> #   ⁷​toilet_type, ⁸​access_limited, ⁹​payment_required, ˟​key_required, ˟​access_note, ˟​parking_note, ˟​accessible_male, ˟​accessible_female, ˟​accessible_unisex, ˟​accessible_note
#> 
#> [[2]]
#> Simple feature collection with 19034 features and 47 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 113.4102 ymin: -43.58278 xmax: 153.6263 ymax: -10.57019
#> Geodetic CRS:  WGS 84
#> # A tibble: 19,034 × 48
#>    id          toile…¹ url   name  addre…² town  state postc…³ addre…⁴ male  female unisex dump_…⁵ facil…⁶ toile…⁷ acces…⁸ payme…⁹ key_r…˟ acces…˟ parking parki…˟ acces…˟ acces…˟ acces…˟ acces…˟ mlak 
#>    <chr>         <int> <chr> <chr> <chr>   <chr> <chr>   <int> <chr>   <lgl> <lgl>  <lgl>  <lgl>   <chr>   <chr>   <lgl>   <lgl>   <lgl>   <chr>   <lgl>   <chr>   <lgl>   <lgl>   <lgl>   <chr>   <lgl>
#>  1 national_t…     272 http… Bris… Brisba… Merr… New …    2329 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  2 national_t…     578 http… Nati… Wimmer… Nati… Vict…    3409 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    TRUE    TRUE    FALSE   <NA>    FALSE
#>  3 national_t…     628 http… Brid… Bridge… Pens… New …    2222 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  4 national_t…     868 http… Sand… Oroya … Sand… West…    6639 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    TRUE    <NA>    TRUE    TRUE    FALSE   <NA>    FALSE
#>  5 national_t…    1300 http… Murr… Ravens… Rave… West…    6208 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    TRUE    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  6 national_t…    1461 http… Menz… Purslo… Moun… West…    6016 <NA>    TRUE  TRUE   FALSE  FALSE   Park o… Sewera… FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    TRUE    TRUE    FALSE   <NA>    FALSE
#>  7 national_t…    1638 http… Roy … Warreg… Dula… Quee…    4425 <NA>    TRUE  TRUE   FALSE  FALSE   Park o… Sewera… FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   TRUE    <NA>    FALSE
#>  8 national_t…    1750 http… Meri… Tagger… Meri… Vict…    3496 <NA>    TRUE  TRUE   FALSE  FALSE   <NA>    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#>  9 national_t…    2520 http… Show… Evans … Wang… Vict…    3677 <NA>    TRUE  TRUE   FALSE  FALSE   Sporti… <NA>    FALSE   FALSE   FALSE   <NA>    FALSE   <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#> 10 national_t…    2725 http… Haro… Paxton… Clev… Quee…    4163 <NA>    TRUE  TRUE   FALSE  FALSE   Park o… Sewera… FALSE   FALSE   FALSE   <NA>    TRUE    <NA>    FALSE   FALSE   FALSE   <NA>    FALSE
#> # … with 19,024 more rows, 22 more variables: parking_accessible <lgl>, access_parking_note <chr>, ambulant <lgl>, lh_transfer <lgl>, rh_transfer <lgl>, adult_change <lgl>, changing_places <lgl>,
#> #   is_open <chr>, opening_hours <chr>, openinghours_note <chr>, baby_change <lgl>, showers <lgl>, drinking_water <lgl>, sharps_disposal <lgl>, sanitary_disposal <lgl>, icon_url <chr>,
#> #   icon_alt_text <chr>, notes <chr>, status <chr>, latitude <dbl>, longitude <dbl>, geometry <POINT [°]>, and abbreviated variable names ¹​toilet_id, ²​address1, ³​postcode, ⁴​address_note, ⁵​dump_point,
#> #   ⁶​facility_type, ⁷​toilet_type, ⁸​access_limited, ⁹​payment_required, ˟​key_required, ˟​access_note, ˟​parking_note, ˟​accessible_male, ˟​accessible_female, ˟​accessible_unisex, ˟​accessible_note
#> 
#> [[3]]
#> Simple feature collection with 16737 features and 39 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 113.4102 ymin: -43.582 xmax: 153.6222 ymax: -10.57119
#> Geodetic CRS:  WGS 84
#> # A tibble: 16,737 × 40
#>    id    ogc_fid status lastupdate name  addre…¹ town  state postc…² addre…³  male female unisex facil…⁴ toile…⁵ acces…⁶ payme…⁷ keyre…⁸ acces…⁹ parking parki…˟ yeari…˟ acces…˟ acces…˟ acces…˟ acces…˟
#>    <chr>   <int> <chr>  <date>     <chr> <chr>   <chr> <chr> <chr>   <chr>   <int>  <int> <chr>  <chr>   <chr>     <int>   <int>   <int> <chr>     <int> <chr>   <chr>     <int>   <int>   <int> <chr>  
#>  1 publ…      28 Verif… 2008-02-13 Flyi… Esplan… Flyi… Quee… 4860    <NA>        1      1 <NA>   <NA>    <NA>          0       0       0 <NA>          0 <NA>    <NA>          0       0       0 <NA>   
#>  2 publ…     301 Verif… 2009-03-25 Tour… Leslie… Stan… Quee… 4380    <NA>        1      1 <NA>   <NA>    <NA>          0       0       0 <NA>          0 <NA>    <NA>          1       1       0 <NA>   
#>  3 publ…     381 Verif… 2010-03-24 Pinn… Day St… Pinn… Sout… 5304    <NA>        1      1 <NA>   <NA>    <NA>          0       0       0 <NA>          1 <NA>    <NA>          0       0       0 <NA>   
#>  4 publ…     500 Verif… 2008-01-30 Rive… <NA>    Waik… Sout… 5330    <NA>        1      1 <NA>   Park o… <NA>          0       0       0 <NA>          0 <NA>    <NA>          0       0       0 <NA>   
#>  5 publ…     612 Verif… 2008-02-18 Kend… <NA>    Kend… West… 6323    <NA>        1      1 <NA>   <NA>    <NA>          0       0       0 <NA>          0 <NA>    <NA>          0       0       0 <NA>   
#>  6 publ…     620 Verif… 2006-02-10 Shen… 124 Sh… Menz… West… 6436    Toilet…     1      1 <NA>   Other   Sewera…       0       0       0 <NA>          0 <NA>    <NA>          0       0       0 <NA>   
#>  7 publ…     673 Verif… 2008-02-18 Rota… 1836 N… Sout… West… 6701    Near 1…     1      1 <NA>   Park o… Septic        0       0       0 <NA>          0 <NA>    <NA>          0       0       0 Access…
#>  8 publ…     708 Verif… 2009-02-24 Sand… Oroya … Sand… West… 6639    <NA>        1      1 <NA>   <NA>    <NA>          0       0       0 <NA>          1 <NA>    <NA>          1       1       0 <NA>   
#>  9 publ…     734 Verif… 2009-02-18 McIn… Bent S… Leon… Vict… 3953    <NA>        1      1 <NA>   Park o… <NA>          0       0       0 <NA>          1 <NA>    <NA>          1       1       0 <NA>   
#> 10 publ…     847 Verif… 2008-02-18 Libr… Civic … Aubu… New … 2144    <NA>        1      1 <NA>   Other   Sewera…       0       0       0 <NA>          0 <NA>    <NA>          0       0       0 <NA>   
#> # … with 16,727 more rows, 14 more variables: mlak <int>, parkingaccessible <int>, accessibleparkingnote <chr>, isopen <chr>, openinghoursschedule <chr>, openinghoursnote <chr>, babychange <int>,
#> #   showers <int>, drinkingwater <int>, sharpsdisposal <int>, sanitarydisposal <int>, iconalttext <chr>, notes <chr>, geometry <POINT [°]>, and abbreviated variable names ¹​address1, ²​postcode,
#> #   ³​addressnote, ⁴​facilitytype, ⁵​toilettype, ⁶​accesslimited, ⁷​paymentrequired, ⁸​keyrequired, ⁹​accessnote, ˟​parkingnote, ˟​yearinstalled, ˟​accessiblemale, ˟​accessiblefemale, ˟​accessibleunisex,
#> #   ˟​accessiblenote
```
