#' Create a AURIN WFS client object.
#'
#' @return a `ows4R::WFSClient` R6 object.
#' @export
create_aurinapi_wfs_client = function() {
  stop_if_no_aurin_api_userpwd()
  if (checkmate::test_r6(get_aurinapi_wfs_client(), classes = "WFSClient")) {
    return(get_aurinapi_wfs_client())
  }
  wfs = glue::glue("http://{Sys.getenv('AURIN_API_USERPWD')}@openapi.aurin.org.au/wfs")
  url = httr::parse_url(wfs)
  url$query = list(service = "WFS",
                   version = "2.0.0",
                   request = "GetCapabilities")
  request = httr::build_url(url)
  cli::cli_alert_info("Creating AURIN WFS Client...")
  client_wrapper = get_aurinapi_wfs_client_wrapper()
  client_wrapper$client = ows4R::WFSClient$new(wfs, serviceVersion = "2.0.0")
  return(get_aurinapi_wfs_client())
}


#' @export
#' @rdname create_aurinapi_wfs_client
get_aurinapi_wfs_client = function() {
  get("aurinapi_wfs_client_wrapper", envir = parent.env(environment()))$client
}

#' @export
#' @rdname create_aurinapi_wfs_client
get_aurinapi_wfs_client_wrapper = function() {
  get("aurinapi_wfs_client_wrapper", envir = parent.env(environment()))
}
