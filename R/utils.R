has_aurin_api_userpwd = function() {
  Sys.getenv('AURIN_API_USERPWD') != ""
}

stop_if_no_aurin_api_userpwd = function() {
  if (!has_aurin_api_userpwd()) {
    stop("Has no Sys.getenv('AURIN_API_USERPWD'). Use `aurinapi_register()` to set it up.")
  }
  return(invisible(NULL))
}
