test_that("setup works for MAGICC", {
  os <- reticulate::import("os")

  setup(magiccExecutable7 = "/some/path")
  expect_identical(os$environ["MAGICC_EXECUTABLE_7"], "/some/path")

  setup(magiccWorkerNumber = 4)
  expect_identical(os$environ["MAGICC_WORKER_NUMBER"], "4")

  setup(magiccWorkerRootDir = "/other/path")
  expect_identical(os$environ["MAGICC_WORKER_ROOT_DIR"], "/other/path")
})
