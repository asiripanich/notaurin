test_that("setup_authentication works", {
  skip_if(!isTRUE(as.logical(Sys.getenv("CI"))))
  temp_dir = tempdir()
  setup_authentication(username = "username", password = "password", save_dir = temp_dir)
})
