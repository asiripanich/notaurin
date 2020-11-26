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
