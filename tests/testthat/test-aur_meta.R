test_that("aur_meta works", {
  meta <- aur_meta()
  checkmate::expect_data_frame(meta, min.rows = 1000, ncols = 2)
})
