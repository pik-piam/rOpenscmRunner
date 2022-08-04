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
  res <- run(climateModelsConfigs = list(Mock = NULL), scenarios = df)

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


test_that("NULL configs are properly expanded", {
  emptyNamedList <- list()
  names(emptyNamedList) <- list()
  expect_identical(expandConfigs(list("A" = NULL)), list("A" = list(emptyNamedList)))
  expect_identical(expandConfigs(list("A" = list(NULL, list("s1" = 1, "s2" = 2)))),
                   list("A" = list(emptyNamedList, list("s1" = 1, "s2" = 2))))
  expect_identical(expandConfigs(list("A" = list(list("s1" = 1), list("s1" = 1, "s2" = 2)))),
                   list("A" = list(list("s1" = 1), list("s1" = 1, "s2" = 2))))
  expect_identical(expandConfigs(list("A" = NULL, "B" = NULL)),
                   list("A" = list(emptyNamedList), "B" = list(emptyNamedList)))
})


test_that("run works with MAGICC",  {
  skip_if_not(file.exists(Sys.getenv("MAGICC_EXECUTABLE_7")),
              "MAGICC_EXECUTABLE_7 environment variable does not point to a magicc binary.")

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

  # single run with default config
  res <- run(climateModelsConfigs = list("MAGICC7" = NULL), scenarios = df)

  # two runs, one with default config, one with higher climate sensitivity
  res <- run(climateModelsConfigs = list("MAGICC7" = list(NULL, list("CORE_CLIMATESENSITIVITY" = 4.))),
             scenarios = df)

  # two runs, with outConfig
  res <- run(climateModelsConfigs = list("MAGICC7" = list(list("CORE_CLIMATESENSITIVITY" = 3.),
                                                          list("CORE_CLIMATESENSITIVITY" = 4.))),
             scenarios = df,
             outConfig = list("MAGICC7" = list("CORE_CLIMATESENSITIVITY"))
  )

  # output sea level rise
  res <- run(climateModelsConfigs = list("MAGICC7" = list(list("CORE_CLIMATESENSITIVITY" = 3.),
                                                          list("CORE_CLIMATESENSITIVITY" = 4.))),
             scenarios = df,
             outConfig = list("MAGICC7" = list("CORE_CLIMATESENSITIVITY")),
             outputVariables = list("Surface Temperature", "Sea Level Rise")
  )
  expect_true("Sea Level Rise" %in% res$df[["variable"]])
})
