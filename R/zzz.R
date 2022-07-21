...aurin_hostname <- "adp.aurin.org.au/geoserver/wfs"

#' @importFrom R6 R6Class
client_wrapper <- R6::R6Class(
  classname = "client_wrapper",
  public = list(
    client = NULL
  )
)

#' aurinapi_wfs_client_wrapper
#'
#' @description
#' An R6 object for wrapping a WFS Client object. It will be created each
#' the `aurinapi` package is being loaded. See [ows4R::WFSClient].
#'
#' @name aurinapi_wfs_client_wrapper
#' @export aurinapi_wfs_client_wrapper
NULL

.onLoad <- function(...) {
  assign("aurinapi_wfs_client_wrapper", client_wrapper$new(), envir = parent.env(environment()))
  cli::cli_alert_warning(
    paste(
      "The `notaurin` package is not affiliated with AURIN.",
      "Any issues or feedback related to the `notaurin` package should be reported",
      "to https://github.com/asiripanich/notaurin.",
      "If you would like to see the official AURIN R API Guide please visit",
      "https://aurin.org.au/resources/aurin-apis/aurin-open-api-and-r/"
    )
  )
}
