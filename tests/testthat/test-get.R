test_that("aur_get works", {
  skip_on_ci()
  skip_on_cran()
  open_api_id <- "aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets"
  data_sf <- aur_get(open_api_id)
  checkmate::expect_class(data_sf, classes = "sf")
  checkmate::expect_data_frame(data_sf, min.rows = 1)
})
