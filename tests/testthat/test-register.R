test_that("aurinapi_register works", {
  skip_if(!isTRUE(as.logical(Sys.getenv("CI"))))
  temp_dir = tempdir()
  aurinapi_register(username = "username", password = "password", save_dir = temp_dir)
})
