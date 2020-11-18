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
#' browse_aurin_catalogue()
#'
#' }
browse_aurin_catalogue = function() {
  browseURL("https://data.aurin.org.au/dataset")
}
