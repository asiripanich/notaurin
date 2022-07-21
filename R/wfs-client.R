#' Create a AURIN WFS client object.
#'
#' @description
#'
#' This function creates a WFS client.
#'
#' @return a `ows4R::WFSClient` R6 object.
#' @export
create_aurinapi_wfs_client <- function() {
  stop_if_no_aurin_api_userpwd()
  if (checkmate::test_r6(get_aurinapi_wfs_client(), classes = "WFSClient")) {
    return(get_aurinapi_wfs_client())
  }
  cli::cli_alert_info("Creating AURIN WFS Client...")
  client_wrapper <- get_aurinapi_wfs_client_wrapper()
  cred <- Sys.getenv('AURIN_API_USERPWD') %>%
    strsplit(split = ":") %>%
    unlist()
  client_wrapper$client <- ows4R::WFSClient$new(
    ...aurin_hostname,
    user = cred[[1]],
    pwd = cred[[2]],
    serviceVersion = "2.0.0"
  )
  return(get_aurinapi_wfs_client())
}


#' @export
#' @rdname create_aurinapi_wfs_client
get_aurinapi_wfs_client <- function() {
  get("aurinapi_wfs_client_wrapper", envir = parent.env(environment()))$client
}

#' @export
#' @rdname create_aurinapi_wfs_client
get_aurinapi_wfs_client_wrapper <- function() {
  get("aurinapi_wfs_client_wrapper", envir = parent.env(environment()))
}
