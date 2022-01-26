test_that("aur_get works", {
  skip_on_cran()
  
  open_api_id <- "aurin:datasource-UQ_ERG-UoM_AURIN_DB_public_toilets"
  
  data_sf <- aur_get(open_api_id)
  checkmate::expect_class(data_sf, classes = "sf")
  checkmate::expect_data_frame(data_sf, nrows = 16737, ncols = 40)

  data_first_10_sf <- aur_get(
    open_api_id,
    params = list(maxFeatures = 10)
  )
  checkmate::expect_data_frame(data_first_10_sf, nrow = 10)

  data_feature_28_sf <- aur_get(
    open_api_id,
    params = list(featureID = 28)
  )
  expect_equal(data_feature_28_sf$ogc_fid, 28)

})

