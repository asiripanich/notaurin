test_that("aurinapi_register works", {
  skip_if(!isTRUE(as.logical(Sys.getenv("CI"))))
  aurinapi_register(username = "username", password = "password", add_to_renviron = T)
})
