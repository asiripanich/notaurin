#' Create an AURIN authentication file.
#' 
#' @description 
#'
#' This function writes your AURIN API authentication as a R environment
#' variable of your current session. If `add_to_renviron` is `TRUE`, it
#' will write the API to your `.Renviron` file as `AURIN_API_USERPWD`.
#'
#' @param username Character. AURIN API username.
#' @param password Character. AURIN API password.
#' @param add_to_renviron Logical. Default is `FALSE`. If `TRUE` then the file directory
#'  of the authentication file will be added to your `.Renviron` file.
#' @param overwrite Logical. Default is `FALSE`. If `TRUE`, the existing `AURIN_API_USERPWD`
#' R environment variable will be replaced with new `username` and `password`.
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#'
#'  aur_register("username", "password")
#' }
aur_register <- function(username,
                         password,
                         add_to_renviron = FALSE,
                         overwrite = FALSE) {
  checkmate::assert_string(username)
  checkmate::assert_string(password)
  checkmate::assert_flag(add_to_renviron)
  checkmate::assert_flag(overwrite)

  AURIN_API_USERPWD <- glue::glue("{username}:{password}")

  # save the file directory of the authentication file.
  if (add_to_renviron) {
    if (!overwrite & Sys.getenv("AURIN_API_USERPWD") != "") {
      stop(
        "Because overwrite is `FALSE` and `Sys.getenv('AURIN_API_USERPWD')` ",
        "is not emptied, the authentication key cannot be over written."
      )
    }

    cli::cli_alert_info(paste(
      "Adding your AURIN API Username and Password to {.file ~/.Renviron}.",
      "You won't need to do this again next time. ;)"
    ))

    # grab .Renviron file path
    environ_file <- file.path(Sys.getenv("HOME"), ".Renviron")

    # create .Renviron file if it does not exist
    if (!file.exists(file.path(Sys.getenv("HOME"), ".Renviron"))) {
      cli::cli_alert_info("Creating file {environ_file}")
      file.create(environ_file)
    }

    # read in lines
    environ_lines <- readLines(environ_file)

    # if no key present, add; otherwise replace old one
    if (!any(stringr::str_detect(environ_lines, "AURIN_API_USERPWD="))) {
      cli::cli_alert_info("Adding AURIN API Username and Password to {environ_file}")
      environ_lines <- c(environ_lines, glue::glue("AURIN_API_USERPWD={AURIN_API_USERPWD}"))
      writeLines(environ_lines, environ_file)
    } else {
      userpwd_line_index <- which(stringr::str_detect(environ_lines, "AURIN_API_USERPWD="))
      old_userpwd <- stringr::str_extract(environ_lines[userpwd_line_index], "(?<=AURIN_API_USERPWD=)\\w+:\\w+")
      cli::cli_alert_warning("Replacing old credential \\
                             ({.emph {old_userpwd}}) with new credential ({.emph {AURIN_API_USERPWD}}) in {.path {environ_file}}")
      environ_lines[userpwd_line_index] <- glue::glue("AURIN_API_USERPWD={AURIN_API_USERPWD}")
      writeLines(environ_lines, environ_file)
    }

    # set key in current session
    Sys.setenv("AURIN_API_USERPWD" = AURIN_API_USERPWD)
  } else {

    # set key in current session
    cli::cli_alert_info("Setting your AURIN API Username and Password for the \\
                        current session only. This will not be remembered and you
                        will have to set it again after you close this session.")
    Sys.setenv("AURIN_API_USERPWD" = AURIN_API_USERPWD)
  }

  return(invisible(NULL))
}
