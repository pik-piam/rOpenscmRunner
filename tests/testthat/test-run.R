test_that("run works with a mock model", {
  # set up mock model which has no further dependencies
  reticulate::py_run_file("add_mock_model.py")

  # create minimal emissions scenario
  df <- data.frame(
    model = c("rand", "rand"),
    scenario = c("weirdEMI", "weirdEMI"),
    region = c("World", "World"),
    variable = c("Emissions|CO2", "Emissions|CH4"),
    unit = c("Mt CO2 / yr", "Mt CH4 / yr"),
    "2015" = c(9., 12.),
    "2020" = c(10., 11.),
    check.names = FALSE)

  # simulate the scenario using the Mock model
  # returnRaw = TRUE returns a python object
  res <- run(climateModelsConfigs = list("Mock" = NULL), scenarios = df, returnRaw = TRUE)

  expect_identical(
    data.frame(reticulate::py_to_r(res$meta)),
    data.frame(
      climate_model = "Mock",
      model = "rand",
      region = "World",
      scenario = "weirdEMI",
      unit = "degC",
      variable = "Surface Temperature",
      row.names = 0)
  )

  # normal return an R named list
  res <- run(climateModelsConfigs = list("Mock" = NULL), scenarios = df)

  emptyNamedList <- list()
  names(emptyNamedList) <- list()
  expect_identical(res$metadata, emptyNamedList)
  attributes(res$df)$pandas.index <- NULL
  expectedDF <- data.frame(
    climate_model = "Mock",
    model = "rand",
    region = "World",
    scenario = "weirdEMI",
    unit = "degC",
    variable = "Surface Temperature",
    "2015-01-01 00:00:00" = 0.,
    "2020-01-01 00:00:00" = 0.,
    check.names = FALSE
  )
  expect_identical(res$df, expectedDF)
})
