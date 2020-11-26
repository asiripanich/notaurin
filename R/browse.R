#' Browse AURIN data catalogue.
#'
#' @description
#'
#' Use the data catalogue to select spatial datasets available on AURIN. Any datasets
#' with 'AURIN Open API ID' field can be downloaded into your current r session
#' with `aurinapi_get()`.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' aurinapi_browse()
#'
#' }
aurinapi_browse = function() {
  utils::browseURL("https://data.aurin.org.au/group/aurin-api")
}
