#' Create a AURIN WFS client object.
#'
#' @description
#'
#' This function creates a WFS client.
#'
#' @param n_try maximum number of tries creating a WFS client.
#' @param sec_wait seconds wait before trying again.
#'
#' @return a `ows4R::WFSClient` R6 object.
#' @export
create_aurinapi_wfs_client <- function(n_try = 5, sec_wait = 2) {
  stop_if_no_aurin_api_userpwd()
  checkmate::assert_count(n_try, positive = TRUE)
  checkmate::assert_count(sec_wait, positive = TRUE)
  if (checkmate::test_r6(get_aurinapi_wfs_client(), classes = "WFSClient")) {
    return(get_aurinapi_wfs_client())
  }
  wfs <- glue::glue("http://{Sys.getenv('AURIN_API_USERPWD')}@openapi.aurin.org.au/wfs")
  url <- httr::parse_url(wfs)
  url$query <- list(
    service = "WFS",
    version = "2.0.0",
    request = "GetCapabilities"
  )
  request <- httr::build_url(url)
  cli::cli_alert_info("Creating AURIN WFS Client...")
  client_wrapper <- get_aurinapi_wfs_client_wrapper()
  n <- 1
  while (is.null(client_wrapper$client) && n_try >= n) {
    cli::cli_alert_info("Try number {n} of {n_try}.")
    try(
      client_wrapper$client <- ows4R::WFSClient$new(wfs, serviceVersion = "2.0.0")
    )
    if (is.null(client_wrapper$client)) {
      cli::cli_alert_warning("Failed to create a WFS client :(.")
      if (n_try == n) {
        stop("Failed to create a WFS client.")
      }
      n <- n + 1
      cli::cli_alert_info("Stopping for {sec_wait} seconds before the next try..")
      Sys.sleep(sec_wait)
    } else {
      cli::cli_alert_success("Success! 🦘")
    }
  }
  invisible(get_aurinapi_wfs_client())
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