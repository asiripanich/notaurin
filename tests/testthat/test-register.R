test_that("aur_register works", {
  skip_if(!isTRUE(as.logical(Sys.getenv("CI"))))
  aur_register(username = "username", password = "password", add_to_renviron = FALSE)
})
