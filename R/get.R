#' Fetch AURIN dataset.
#'
#' @description
#'
#' Query data using [WFS getFeature](https://docs.geoserver.org/latest/en/user/services/wfs/reference.html).
#'
#' @param open_api_id Character. You can find the layer names for AURIN’s datasets
#'  by browsing the [Data Catalogue](https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/).
#'  The layer name is found in the ‘AURIN Open API ID’ field in a dataset’s metadata.
#' @param crs default as "EPSG:4326". The Coordinate Reference System you wish to use
#' @param params a named list that contains additional parameters to be used when
#'  constructing a WFS GetFeature request. This is useful when you know the ID of
#'  a specific feature or the maximum number of features you want to query.
#'  See examples [here](https://docs.geoserver.org/latest/en/user/services/wfs/reference.html#getfeature).
#'
#' @return an `sf::sf` object.
#' @export
#'
#' @examples
#' # follow the example in https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/
#' \dontrun{
#' aur_get("aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets")
#' 
#' # Get the first 10 features.
#' aur_get(
#'    open_api_id,
#'    params = list(maxFeatures = 10)
#'  )
#' }
aur_get <- function(open_api_id, crs = "EPSG:4326", params = NULL) {
  request <- aur_build_request(open_api_id, crs = "EPSG:4326", params = params)

  cli::cli_alert_info("Downloading '{open_api_id}'...")
  .data <- sf::read_sf(request)
  cli::cli_alert_success("Finished!")

  return(.data)
}

#' @param outputFormat default as "application/json",
#'   see https://docs.geoserver.org/latest/en/user/services/wfs/outputformats.html
#'   for other available options.
#'
#' @note
#' `aur_build_request()` returns a URL.
#' @export
#' @rdname aur_get
aur_build_request <- function(open_api_id, crs = "EPSG:4326", params = NULL, outputFormat = "application/json") {
  checkmate::assert_string(open_api_id)
  checkmate::assert_list(params, types = c("character", "numeric"), names = "unique", null.ok = TRUE)

  stop_if_no_aurin_api_userpwd()

  wfs <- glue::glue("http://{Sys.getenv('AURIN_API_USERPWD')}@openapi.aurin.org.au/wfs")
  url <- httr::parse_url(wfs)

  url$query <- append(
    list(
      service = "wfs",
      version = "1.0.0",
      request = "GetFeature",
      srsName = crs,
      outputFormat = outputFormat,
      typename = open_api_id
    ),
    params
  )

  request <- httr::build_url(url)
  
  return(request)
}
