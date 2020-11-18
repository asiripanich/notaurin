test_that("aurinapi_get works", {
  skip_on_ci()
  skip_on_cran()
  open_api_id = "aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017"
  data_sf = aurinapi_get(open_api_id)
  checkmate::expect_class(data_sf, classes = "sf")
  checkmate::expect_data_frame(data_sf, min.rows = 1)
})
