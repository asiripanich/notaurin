#' Fetch AURIN dataset.
#'
#' @param open_api_id Character. You can find the layer names for AURIN’s datasets
#'  by browsing the [Data Catalogue](https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/).
#'  The layer name is found in the ‘AURIN Open API ID’ field in a dataset’s metadata.
#'
#' @return an `sf::sf` object.
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # follow the example in https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/
#' setup_authentication(username = "your-username", password = "your-password")
#' fetch("aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017")
#' }
fetch_aurin = function(open_api_id) {

  checkmate::assert_string(open_api_id)

  if (Sys.getenv("AURINAPI_AUTHENTICATION_FILE") == "") {
    stop("Sys.getenv('AURINAPI_AUTHENTICATION_FILE') has not been set. ",
         "Please use `setup_authentication()` to setup the authentication file.")
  }

  temp_file = file.path(tempdir(), "output.geojson")

  gdalUtils::ogr2ogr(src_datasource_name = Sys.getenv("AURINAPI_AUTHENTICATION_FILE"),
                     dst_datasource_name = temp_file,
                     layer = open_api_id,
                     f = "GeoJSON",
                     overwrite = TRUE,
                     oo = "INVERT_AXIS_ORDER_IF_LAT_LONG=NO")

  return(sf::st_read(temp_file))
}
