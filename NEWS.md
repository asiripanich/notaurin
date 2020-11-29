# aurinapi 0.3.4

* `aurinapi_build_get_feature_request()` gains `outputFormat` argument, default as "application/json".
* `aurinapi_search()` returns a query result from the AURIN API search.

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