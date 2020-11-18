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
#' @param params a named list that will be used when constructing the WFS request.
#'
#' @return an `sf::sf` object.
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # follow the example in https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/
#' aurinapi_register(username = "your-username", password = "your-password")
#' aurinapi_get("aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017")
#' }
aurinapi_get = function(open_api_id, crs = "EPSG:4326", params = NULL) {

  checkmate::assert_string(open_api_id)
  checkmate::assert_list(params, types = "character", names = "unique", null.ok = TRUE)

  if (Sys.getenv("AURIN_API_USERPWD") == "") {
    stop("Sys.getenv('AURIN_API_USERPWD') has not been set. ",
         "Please use `aurinapi_register()` to save your AURIN API key.")
  }

  wfs = glue::glue("http://{Sys.getenv('AURIN_API_USERPWD')}@openapi.aurin.org.au/wfs")
  url = httr::parse_url(wfs)
  url$query = list(service="wfs",
                    version = "1.0.0",
                    request = "GetFeature",
                    srsName = crs,
                    typename = open_api_id)

  request = httr::build_url(url)

  cli::cli_alert_info("Downloading...")
  .data = sf::read_sf(request)
  cli::cli_alert_success("Finished!")

  return(.data)
}
