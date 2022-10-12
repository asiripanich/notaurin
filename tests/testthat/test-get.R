test_that("aur_get works", {
  skip_on_cran()

  open_api_id <- "datasource-VIC_Govt_DELWP-VIC_Govt_DELWP:datavic_VMFEAT_CFA_FIRE_STATION"

  data_sf <- aur_get(open_api_id)
  checkmate::expect_class(data_sf, classes = "sf")
  checkmate::expect_data_frame(data_sf, min.rows = 1, min.cols = 1)

  data_first_10_sf <- aur_get(
    open_api_id,
    params = list(count = 10, version = "2.0.0")
  )
  checkmate::expect_data_frame(data_first_10_sf, nrow = 10)

  data_first_10_sf <- aur_get(
    open_api_id,
    params = list(maxFeatures = 10, version = "1.0.0")
  )
  checkmate::expect_data_frame(data_first_10_sf, nrow = 10)

  one_feature_id <- sample(data_first_10_sf$id, 1)

  data_feature_28_sf <- aur_get(
    open_api_id,
    params = list(featureID = one_feature_id)
  )
  expect_equal(data_feature_28_sf$id, one_feature_id)
})
