test_that("aur_register works", {
  orginal_key <- Sys.getenv("AURIN_API_USERPWD")
  aur_register(
    username = "username",
    password = "password",
    add_to_renviron = FALSE,
    overwrite = FALSE
  )
  expect_equal(Sys.getenv("AURIN_API_USERPWD"), "username:password")
  
  if (orginal_key != "") {
    Sys.setenv(AURIN_API_USERPWD = orginal_key)
  }

})