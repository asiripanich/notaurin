<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# notaurin 0.7.1

- Updated the R-CMD-Check GitHub workflow.
- Updated README.


# notaurin 0.7.0

- The package now works with the new AURIN API. (thanks @Hi-Vis, #15)


# notaurin 0.6.0.9001

- Warn users that the package is not affiliated with AURIN on load.
- Change the package name as per AURIN's request.


# aurin 0.6.0

- `aur_get()` now accepts additional parameters. You can now query a specific feature if you know its ID using `params = list(featureID=ID)`. See https://docs.geoserver.org/latest/en/user/services/wfs/reference.html#getfeature for other available options.
- Removed the minimum versions of the imported packages.
- Improved a README example.
- Upgrade pkgdown's template to bootstrap 5.


# aurin 0.5.1

- Released the package on CRAN.


# aurin 0.5.0

- Henceforth, You Shall Be Known As "aurin"! 🦘
- Removed 'render-rmarkdown' GHA. 


# aurinapi 0.4.1.9000

- Run examples that requires an API key.
- Use testthat edition 3.
- Update GHAs.
- Add 'render-rmarkdown' GHA.
- Import magrittr's pipe.
- Fixed the ggplot example in README (thanks @williamlai2).


# aurinapi 0.4.1

- Renamed `aur_build_get_feature_request()` to `aur_build_request()`. Not sure why it was named like that in the first place!


# aurinapi 0.4.0

- Fix `aur_register()`, `overwrite` now works as it should.
- Test `aur_register()`.
- All main functions now start with the prefix `aur_*`() instead of `aurinapi_*()`.


# aurinapi 0.3.4

* `aurinapi_build_get_feature_request()` gains `outputFormat` argument, default as "application/json".
* `aurinapi_search()` returns a query result from the AURIN API search.
* Update the example data layer. `aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017` layer no longer exists hence we are replacing it with `aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets`, which is most similar.
* Add `jsonlite` to Imports.

# aurinapi 0.3.3

* `aurinapi_wfs_client_wrapper` is now exported, this fixes the error when calling `aurinapi_meta()` in the previous versions.
* `ows4R` and `R6` packages are now in Imports, where they should have been.

# aurinapi 0.3.2

* `aurinapi_browse()` now opens the URL to the data catalog of datasets that are accessible via AURIN API.

# aurinapi 0.3.1

* Refactored the WFS's GetFeature request constructor in `aurinapi_get()` as its own function.

# aurinapi 0.3.0

* Added `aurinapi_meta()`, this function returns a data.frame that contains metadata of all available AURIN datasets through their API.

# aurinapi 0.2.0

* Switched to using WFS request instead of `gdalUtils::ogr2ogr` to download AURIN datasets. This provides a faster and more reliable download than the former approach.

# aurinapi 0.1.0

* Added a `NEWS.md` file to track changes to the package.
