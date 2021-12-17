#' Browse AURIN data catalogue.
#'
#' @description
#' 
#' A convenience function that opens up AURIN data catelogue in your default 
#' web browser. Use the data catalogue to select spatial datasets available 
#' on AURIN. Any datasets with 'AURIN Open API ID' field can be downloaded 
#' into your current R session with `aur_get()`.
#' 
#' @return NULL
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#'  aur_browse()
#' }
aur_browse <- function() {
  utils::browseURL("https://data.aurin.org.au/group/aurin-api")
  invisible()
}
