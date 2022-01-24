
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aurin

<!-- badges: start -->

![](https://www.r-pkg.org/badges/version-ago/aurin)
[![R-CMD-check](https://github.com/asiripanich/aurin/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/aurin/actions)
<!-- badges: end -->

<p align="center">
<img src="https://aurin.org.au/wp-content/uploads/2018/07/aurin-logo-400.png" />
</p>

The goal of `aurin` is to provide an easy way for R users to access
**MORE THAN 5000 OPEN DATASETS** on [AURIN](https://aurin.org.au/) using
their
[API](https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/).
You can request a **FREE** API key from:

> <https://aurin.org.au/resources/aurin-apis/sign-up/>

**AURIN** is “*Australia’s 🦘 single largest resource for accessing
clean, integrated, spatially enabled and research-ready data on issues
surrounding health and wellbeing, socio-economic metrics,
transportation, and land-use.*”

## Installation

Here are ways you can install `aurin`:

``` r
# from CRAN for the latest version
install.packages("aurin")
# from GitHub for the latest development version
install.packages("remotes")
remotes::install_github("asiripanich/aurin")
```

This package requires the [sf](https://github.com/r-spatial/sf) package.
Please see the sf package’s [GitHub
page](https://github.com/r-spatial/sf) to install its non R
dependencies.

## Example

Let’s recreate this [AURIN API AND
R](https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/)
example using `aurin`.

First, you must add your [AURIN API username and
password](https://aurin.org.au/resources/aurin-apis/sign-up/) as an R
environment variable to your `.Renviron` file. `aurin` provides
`aur_register()` function to help you with this step. If you choose to
set `add_to_renviron = TRUE` you won’t need to run this step again on
current machine after you restart your R session.

``` r
library(aurin)

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
#> i Creating AURIN WFS Client...
#> i Fetching available datasets...
# print out the first five rows
knitr::kable(head(meta))
```

| aurin_open_api_id                                                          | title                                                           |
|:---------------------------------------------------------------------------|:----------------------------------------------------------------|
| aurin:datasource-NSW_Govt_DPE-UoM_AURIN_DB_nsw_srlup_additional_rural_2014 | Additional Rural Village Land 18/01/2014 for NSW                |
| aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_aus_2016_aust           | ABS - ASGS - Country (AUS) 2016                                 |
| aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_gccsa_2011_aust         | ABS - ASGS - Greater Capital City Statistical Area (GCCSA) 2011 |
| aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_gccsa_2016_aust         | ABS - ASGS - Greater Capital City Statistical Area (GCCSA) 2016 |
| aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_mb_2016_aust            | ABS - ASGS - Mesh Block (MB) 2016                               |
| aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_mb_2011_act             | ABS - ASGS - Mesh Block (MB) ACT 2011                           |

Use `aur_get()` to download the dataset.

``` r
# download this public toilet dataset.
open_api_id <- "aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets"
public_toilets <- aur_get(open_api_id = open_api_id)
#> i Downloading 'aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets'...
#> v Finished!
state_polygons <- aur_get(open_api_id = "aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_ste_2016_aust")
#> i Downloading 'aurin:datasource-AU_Govt_ABS-UoM_AURIN_DB_GeoLevel_ste_2016_aust'...
#> v Finished!
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
```

Let’s assume you want all datasets on AURIN with the word “toilet” in
their title.

``` r
knitr::kable(meta[grepl("toilet", meta$title, ignore.case = T), ])
```

|      | aurin_open_api_id                                                     | title                                                  |
|:-----|:----------------------------------------------------------------------|:-------------------------------------------------------|
| 1406 | aurin:datasource-AU_Govt_DSS-UoM_AURIN_national_public_toilets_2017   | DSS - National Public Toilets (Point) 2017             |
| 1466 | aurin:datasource-AU_Govt_Doh-UoM_AURIN_DB_national_toilet_map_2018_06 | Department of Health - National Toilet Map - June 2018 |
| 2946 | aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets                   | Public Toilets 2004-2014 for Australia                 |

Extract their AURIN open API ids and download all of them in parallel.

``` r
toilet_datasets_ids <- meta$aurin_open_api_id[grepl("toilet", meta$title, ignore.case = T)]
data_lst <- furrr::future_map(toilet_datasets_ids, ~ aur_get(.x))
#> i Downloading 'aurin:datasource-AU_Govt_DSS-UoM_AURIN_national_public_toilets_2017'...
#> v Finished!
#> i Downloading 'aurin:datasource-AU_Govt_Doh-UoM_AURIN_DB_national_toilet_map_2018_06'...
#> v Finished!
#> i Downloading 'aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets'...
#> v Finished!
data_lst
#> [[1]]
#> Simple feature collection with 18789 features and 46 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 113.4102 ymin: -43.582 xmax: 153.6263 ymax: -10.5702
#> Geodetic CRS:  WGS 84
#> # A tibble: 18,789 x 47
#>    id        toilet_id url     name  address1 town  state postcode address_note  male  female unisex dump_point facility_type toilet_type access_limited payment_required key_required
#>    <chr>         <int> <chr>   <chr> <chr>    <chr> <chr>    <int> <chr>         <lgl> <lgl>  <lgl>  <lgl>      <chr>         <chr>       <lgl>          <lgl>            <lgl>       
#>  1 datasour~       341 https:~ Elsi~ Alden S~ Clif~ Quee~     4361 <NA>          TRUE  TRUE   FALSE  FALSE      Park or rese~ <NA>        FALSE          FALSE            FALSE       
#>  2 datasour~       418 https:~ Luck~ Lucky B~ Luck~ Sout~     5602 <NA>          TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  3 datasour~       634 https:~ Olds~ Holley ~ Mort~ New ~     2223 <NA>          TRUE  TRUE   FALSE  FALSE      Park or rese~ <NA>        FALSE          FALSE            FALSE       
#>  4 datasour~      1150 https:~ Jaeg~ Hill St~ Oran~ New ~     2800 <NA>          TRUE  TRUE   FALSE  FALSE      Park or rese~ <NA>        FALSE          FALSE            FALSE       
#>  5 datasour~      1207 https:~ Lake~ Evans S~ Shen~ West~     6008 <NA>          FALSE FALSE  TRUE   FALSE      Park or rese~ Automatic   FALSE          FALSE            FALSE       
#>  6 datasour~      1535 https:~ Earl~ Earl St~ Coff~ New ~     2450 <NA>          TRUE  TRUE   FALSE  FALSE      Sporting fac~ Sewerage    FALSE          FALSE            FALSE       
#>  7 datasour~      1590 https:~ Truc~ Davidso~ Deni~ New ~     2710 <NA>          TRUE  TRUE   FALSE  FALSE      Car park      Sewerage    FALSE          FALSE            FALSE       
#>  8 datasour~      1913 https:~ Hemi~ High St~ Belm~ Vict~     3216 <NA>          TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  9 datasour~      2081 https:~ Eden~ Eden Va~ Keyn~ Sout~     5353 The toilet i~ TRUE  TRUE   FALSE  FALSE      Park or rese~ Septic      FALSE          FALSE            FALSE       
#> 10 datasour~      2377 https:~ Wils~ Wilson ~ Watt~ Vict~     3096 <NA>          TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#> # ... with 18,779 more rows, and 29 more variables: access_note <chr>, parking <lgl>, parking_note <chr>, accessible_male <lgl>, accessible_female <lgl>, accessible_unisex <lgl>,
#> #   accessible_note <chr>, mlak <lgl>, parking_accessible <lgl>, access_parking_note <chr>, ambulant <lgl>, lh_transfer <lgl>, rh_transfer <lgl>, adult_change <lgl>, is_open <chr>,
#> #   opening_hours <chr>, openinghours_note <chr>, baby_change <lgl>, showers <lgl>, drinking_water <lgl>, sharps_disposal <lgl>, sanitary_disposal <lgl>, icon_url <chr>,
#> #   icon_alt_text <chr>, notes <chr>, status <chr>, latitude <dbl>, longitude <dbl>, geometry <POINT [°]>
#> 
#> [[2]]
#> Simple feature collection with 19034 features and 47 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 113.4102 ymin: -43.5828 xmax: 153.6263 ymax: -10.5702
#> Geodetic CRS:  WGS 84
#> # A tibble: 19,034 x 48
#>    id        toilet_id url     name   address1 town  state postcode address_note male  female unisex dump_point facility_type toilet_type access_limited payment_required key_required
#>    <chr>         <int> <chr>   <chr>  <chr>    <chr> <chr>    <int> <chr>        <lgl> <lgl>  <lgl>  <lgl>      <chr>         <chr>       <lgl>          <lgl>            <lgl>       
#>  1 datasour~       272 https:~ Brisb~ Brisban~ Merr~ New ~     2329 <NA>         TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  2 datasour~       578 https:~ Natim~ Wimmera~ Nati~ Vict~     3409 <NA>         TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  3 datasour~       628 https:~ Bridg~ Bridge ~ Pens~ New ~     2222 <NA>         TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  4 datasour~       868 https:~ Sands~ Oroya S~ Sand~ West~     6639 <NA>         TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  5 datasour~      1300 https:~ Murra~ Ravensw~ Rave~ West~     6208 <NA>         TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  6 datasour~      1461 https:~ Menzi~ Purslow~ Moun~ West~     6016 <NA>         TRUE  TRUE   FALSE  FALSE      Park or rese~ Sewerage    FALSE          FALSE            FALSE       
#>  7 datasour~      1638 https:~ Roy H~ Warrego~ Dula~ Quee~     4425 <NA>         TRUE  TRUE   FALSE  FALSE      Park or rese~ Sewerage    FALSE          FALSE            FALSE       
#>  8 datasour~      1750 https:~ Merin~ Taggert~ Meri~ Vict~     3496 <NA>         TRUE  TRUE   FALSE  FALSE      <NA>          <NA>        FALSE          FALSE            FALSE       
#>  9 datasour~      2520 https:~ Show ~ Evans S~ Wang~ Vict~     3677 <NA>         TRUE  TRUE   FALSE  FALSE      Sporting fac~ <NA>        FALSE          FALSE            FALSE       
#> 10 datasour~      2725 https:~ Harol~ Paxton ~ Clev~ Quee~     4163 <NA>         TRUE  TRUE   FALSE  FALSE      Park or rese~ Sewerage    FALSE          FALSE            FALSE       
#> # ... with 19,024 more rows, and 30 more variables: access_note <chr>, parking <lgl>, parking_note <chr>, accessible_male <lgl>, accessible_female <lgl>, accessible_unisex <lgl>,
#> #   accessible_note <chr>, mlak <lgl>, parking_accessible <lgl>, access_parking_note <chr>, ambulant <lgl>, lh_transfer <lgl>, rh_transfer <lgl>, adult_change <lgl>,
#> #   changing_places <lgl>, is_open <chr>, opening_hours <chr>, openinghours_note <chr>, baby_change <lgl>, showers <lgl>, drinking_water <lgl>, sharps_disposal <lgl>,
#> #   sanitary_disposal <lgl>, icon_url <chr>, icon_alt_text <chr>, notes <chr>, status <chr>, latitude <dbl>, longitude <dbl>, geometry <POINT [°]>
#> 
#> [[3]]
#> Simple feature collection with 16737 features and 39 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 113.4102 ymin: -43.582 xmax: 153.6222 ymax: -10.5712
#> Geodetic CRS:  WGS 84
#> # A tibble: 16,737 x 40
#>    id     ogc_fid status  lastupdate name  address1 town  state postcode addressnote   male female unisex facilitytype toilettype accesslimited paymentrequired keyrequired accessnote
#>    <chr>    <int> <chr>   <date>     <chr> <chr>    <chr> <chr> <chr>    <chr>        <int>  <int> <chr>  <chr>        <chr>              <int>           <int>       <int> <chr>     
#>  1 datas~      28 Verifi~ 2008-02-13 Flyi~ Esplana~ Flyi~ Quee~ 4860     <NA>             1      1 <NA>   <NA>         <NA>                   0               0           0 <NA>      
#>  2 datas~     301 Verifi~ 2009-03-25 Tour~ Leslie ~ Stan~ Quee~ 4380     <NA>             1      1 <NA>   <NA>         <NA>                   0               0           0 <NA>      
#>  3 datas~     381 Verifi~ 2010-03-24 Pinn~ Day Str~ Pinn~ Sout~ 5304     <NA>             1      1 <NA>   <NA>         <NA>                   0               0           0 <NA>      
#>  4 datas~     500 Verifi~ 2008-01-30 Rive~ <NA>     Waik~ Sout~ 5330     <NA>             1      1 <NA>   Park or res~ <NA>                   0               0           0 <NA>      
#>  5 datas~     612 Verifi~ 2008-02-18 Kend~ <NA>     Kend~ West~ 6323     <NA>             1      1 <NA>   <NA>         <NA>                   0               0           0 <NA>      
#>  6 datas~     620 Verifi~ 2006-02-10 Shen~ 124 She~ Menz~ West~ 6436     Toilets are~     1      1 <NA>   Other        Sewerage               0               0           0 <NA>      
#>  7 datas~     673 Verifi~ 2008-02-18 Rota~ 1836 No~ Sout~ West~ 6701     Near 10 mil~     1      1 <NA>   Park or res~ Septic                 0               0           0 <NA>      
#>  8 datas~     708 Verifi~ 2009-02-24 Sand~ Oroya S~ Sand~ West~ 6639     <NA>             1      1 <NA>   <NA>         <NA>                   0               0           0 <NA>      
#>  9 datas~     734 Verifi~ 2009-02-18 McIn~ Bent St~ Leon~ Vict~ 3953     <NA>             1      1 <NA>   Park or res~ <NA>                   0               0           0 <NA>      
#> 10 datas~     847 Verifi~ 2008-02-18 Libr~ Civic R~ Aubu~ New ~ 2144     <NA>             1      1 <NA>   Other        Sewerage               0               0           0 <NA>      
#> # ... with 16,727 more rows, and 21 more variables: parking <int>, parkingnote <chr>, yearinstalled <chr>, accessiblemale <int>, accessiblefemale <int>, accessibleunisex <int>,
#> #   accessiblenote <chr>, mlak <int>, parkingaccessible <int>, accessibleparkingnote <chr>, isopen <chr>, openinghoursschedule <chr>, openinghoursnote <chr>, babychange <int>,
#> #   showers <int>, drinkingwater <int>, sharpsdisposal <int>, sanitarydisposal <int>, iconalttext <chr>, notes <chr>, geometry <POINT [°]>
```
