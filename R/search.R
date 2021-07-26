#' Search AURIN API
#'
#' @param query a character.
#' @importFrom jsonlite read_json
#'
#' @return a data.frame with two columns: aurin_open_api_id, brief_description.
#' @export
aur_search <- function(query) {
  checkmate::assert_string(query)
  url <- httr::parse_url("https://data.aurin.org.au/api/action/package_search?")
  url$query <- list(q = query)
  request <- httr::build_url(url)
  res <- jsonlite::read_json(request)
  if (!isTRUE(res$success)) {
    stop(
      "The request is not success. Please check that you are connected to ",
      "the Internet or try again."
    )
  }
  cli::cli_alert_info("There are {res$result$count} results that matched your \\
                      query [{query}].")
  if (res$result$count > 10) {
    cli::cli_alert_warning("Only the first 10 results returned by the search API will \\
                           be returned as the result.")
  }

  .data <-
    lapply(res$result$results, function(x) {
      id_idx <- sapply(x$extras, function(x) {
        x$key == "AURIN Open API ID"
      }) %>% which()

      if (length(id_idx) == 0) {
        id <- NA
      } else {
        id <- x$extras[[id_idx]][["value"]]
      }

      sentence <- strsplit(x$notes, "(?<=[.?!]) ?", perl = TRUE)[[1]]

      data.frame(
        aurin_open_api_id = id,
        brief_description = sentence[[1]]
      )
    }) %>%
    do.call(rbind, .)

  return(invisible(.data))
}
