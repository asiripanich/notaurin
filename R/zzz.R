client_wrapper = R6::R6Class(classname = "client_wrapper",
                             public = list(
                               client = NULL
                             ))

.onLoad <- function(...){

  if (Sys.getenv("AURIN_API_USERPWD") != "") {
    assign("aurinapi_wfs_client_wrapper",
           client_wrapper$new(),
           envir = parent.env(environment()))
  }

}

#' @export 
"aurinapi_wfs_client_wrapper"