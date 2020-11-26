#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

client_wrapper = R6::R6Class(classname = "client_wrapper",
                             public = list(
                               client = NULL
                             ))

#' @export aurinapi_wfs_client_wrapper
NULL

.onLoad <- function(...){

  if (Sys.getenv("AURIN_API_USERPWD") != "") {
    assign("aurinapi_wfs_client_wrapper",
           client_wrapper$new(),
           envir = parent.env(environment()))
  }

}

