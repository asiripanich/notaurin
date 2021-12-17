test_that("aur_meta works", {
  skip_on_cran()
  meta <- aur_meta()
  checkmate::expect_data_frame(meta, min.rows = 1000, ncols = 2)
})
