#' Get metadata of all AURIN datasets
#'
#' @param force Logical. Default is `FALSE`. Loading metadata may takes a while,
#'  so if it has been loaded before it will not load again unluss `force` is set
#'  to `TRUE`.
#' @return a data.frame with two columns -- name and title. The name column is
#'  'AURIN Open API id' and can be used in `aurinapi_get()`.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # this may takes a while to return.
#' aurinapi_meta()
#'
#' }
aurinapi_meta = function(force = FALSE) {
  wfs = glue::glue("http://{Sys.getenv('AURIN_API_USERPWD')}@openapi.aurin.org.au/wfs")
  url = parse_url(wfs)
  url$query = list(service = "WFS",
                   version = "2.0.0",
                   request = "GetCapabilities")
  request = build_url(url)
  cli::cli_alert_info("Creating WFS Client...")
  wfs_client = WFSClient$new(wfs,
                             serviceVersion = "2.0.0")
  cli::cli_alert_info("Fetching available datasets...")
  wfs_client$getFeatureTypes(pretty = TRUE)
}
