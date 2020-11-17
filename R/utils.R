#' Browse AURIN data catalogue.
#'
#' @description
#'
#' Use the data catalogue to select spatial datasets available on AURIN. Any datasets
#' with 'AURIN Open API ID' field can be downloaded into your current r session
#' with `fetch_aurin()`.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' browse_aurin_catalogue()
#'
#' }
browse_aurin_catalogue = function() {
  browseURL("https://data.aurin.org.au/dataset")
}


#' Create an AURIN authentication file.
#'
#' @param username character. Your username.
#' @param password character. Your password.
#' @param add_to_renviron logical, default as `FALSE`. If `TRUE` then the file directory
#'  of the authentication file will be added to your `.Renviron` file.
#' @param overwrite Logical. Default as `FALSE`. If `TRUE` the authentication file will be overwritten.
#' @param save_dir a custom directory where the authentication file will be saved at.
#'  If not given it will be saved in your home directory, as returns by Sys.getenv("HOME").
#'  Regardless, of the directory the file will be saved as "aurin_wfs_connection.xml".
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#'
#' setup_authentication("username", "password")
#'
#' }
setup_authentication = function(username,
                                password,
                                add_to_renviron = FALSE,
                                overwrite = FALSE,
                                save_dir = Sys.getenv("HOME")) {

  checkmate::assert_string(username)
  checkmate::assert_string(password)
  checkmate::assert_flag(add_to_renviron)
  checkmate::assert_flag(overwrite)
  checkmate::assert_directory_exists(save_dir, access = "rw")

  if (!overwrite & Sys.getenv("AURINAPI_AUTHENTICATION_FILE") != '') {
    stop("Because overwrite is `FALSE` and `Sys.getenv(`AURINAPI_AUTHENTICATION_FILE`)` ",
         "is not emptied, the authentication file cannot be over written.")
  }

  # construct the authentication file's content
  content = paste0(
    "<OGRWFSDataSource>",
    "<URL>http://openapi.aurin.org.au/wfs?version=1.0.0</URL>",
    "<HttpAuth>BASIC</HttpAuth>",
    "<UserPwd>", username, ":", password, "</UserPwd>",
    "</OGRWFSDataSource>"
  )

  authen_filedir = file.path(save_dir, "aurin_wfs_connection.xml")

  if (overwrite & checkmate::test_file_exists(authen_filedir, access = "rw")) {
    cli::cli_alert_warning("Overwriting {.file {authen_filedir}}")
  }

  if (!checkmate::test_directory_exists(save_dir, access = "rw")) {
    stop(checkmate::check_directory_exists(save_dir, access = "rw"))
  }

  # write the authentication file
  file_conn = file(authen_filedir)
  cli::cli_alert_info("Creating the authentication file {.file {authen_filedir}}")
  writeLines(content, file_conn)
  cli::cli_alert_info("Adding the content.")
  close(file_conn)

  # save the file directory of the authentication file.
  if (add_to_renviron) {

    cli::cli_alert_info("Adding the authentication file directory to {.file ~/.Renviron}. \\
                        You won't need to do this again next time. ;)")
    # grab .Renviron file path
    environ_file <- file.path(Sys.getenv("HOME"), ".Renviron")

    # create .Renviron file if it does not exist
    if(!file.exists(file.path(Sys.getenv("HOME"), ".Renviron"))) {
      cli::cli_alert_info('Creating file {environ_file}')
      file.create(environ_file)
    }

    # read in lines
    environ_lines <- readLines(environ_file)

    # if no key present, add; otherwise replace old one
    if (!any(stringr::str_detect(environ_lines, "AURINAPI_AUTHENTICATION_FILE="))) {

      cli::cli_alert_info('Adding key to {environ_file}')
      environ_lines <- c(environ_lines, glue::glue("AURINAPI_AUTHENTICATION_FILE={authen_filedir}"))
      writeLines(environ_lines, environ_file)

    } else {

      filedir_line_index <- which(stringr::str_detect(environ_lines, "AURINAPI_AUTHENTICATION_FILE="))
      old_authen_filedir <- stringr::str_extract(environ_lines[filedir_line_index], "(?<=AURINAPI_AUTHENTICATION_FILE=)\\w+")
      cli::cli_alert_warning('Replacing old file directory ({old_authen_filedir}) with new file directory in {environ_file}')
      environ_lines[filedir_line_index] <- glue::glue("AURINAPI_AUTHENTICATION_FILE={authen_filedir}")
      writeLines(environ_lines, environ_file)

    }

    # set key in current session
    Sys.setenv("AURINAPI_AUTHENTICATION_FILE" = authen_filedir)

  } else {

    # set key in current session
    cli::cli_alert_info("Setting the authentication file directory for the current \\
                        session only.")
    Sys.setenv("AURINAPI_AUTHENTICATION_FILE" = authen_filedir)

  }

  return(invisible(NULL))

}
