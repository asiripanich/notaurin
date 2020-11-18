test_that("aurinapi_get works", {
  skip_if(!isTRUE(as.logical(Sys.getenv("CI"))))
  open_api_id = "aurin:datasource-au_govt_dss-UoM_AURIN_national_public_toilets_2017"
  data_sf = aurinapi_get(open_api_id)
  checkmate::expect_class(data_sf, classes = "sf")
})
