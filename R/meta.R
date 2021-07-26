#' Get metadata of all AURIN datasets
#'
#' @param force Logical. Default is `FALSE`. Loading metadata may takes a while,
#'  so if it has been loaded before it will not load again unluss `force` is set
#'  to `TRUE`.
#' @return a data.frame with two columns -- aurin_open_api_id and title.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # this may takes a while to return.
#' aur_meta()
#' }
aur_meta <- function(force = FALSE) {
  wfs_client <- create_aurinapi_wfs_client()
  cli::cli_alert_info("Fetching available datasets...")
  meta <- wfs_client$getFeatureTypes(pretty = TRUE)
  names(meta)[names(meta) == "name"] <- "aurin_open_api_id"
  return(meta)
}
