has_aurin_api_userpwd <- function() {
  Sys.getenv("AURIN_API_USERPWD") != ""
}

stop_if_no_aurin_api_userpwd <- function() {
  if (!has_aurin_api_userpwd()) {
    stop(
      "Sys.getenv('AURIN_API_USERPWD') has not been set. ",
      "Please use `aur_register()` to save your AURIN API key."
    )
  }
  return(invisible(NULL))
}
