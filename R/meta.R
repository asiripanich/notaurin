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
  wfs_client = get_aurinapi_wfs_client()
  cli::cli_alert_info("Fetching available datasets...")
  wfs_client$getFeatureTypes(pretty = TRUE)
}
