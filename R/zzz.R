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
}
