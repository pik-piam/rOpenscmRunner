#' run
#'
#' Run one or multiple climate models over one or multiple emissions scenarios.
#'
#' Some simple climate models need certain information to run. Use the setup function to supply this information
#' before attempting to use run.
#'
#' @param climateModelsConfigs Named list where the names are climate models and the corresponding list member is a
#' configuration or list of configurations to use for this model. Use null to denote the default configuration with
#' no changes. Climate model names supported: CiceroSCM, FaIR, and MAGICC7. The supported configuration settings
#' depend on the used climate model, please refer to their respective documentation.
#' @param scenarios DataFrame containing one or multiple emissions scenarios to simulate. The data shoud be in
#' IAMC format, i.e. a wide data frame with the years as columns. Index columns that are additionally required are
#' "model", "scenario", "region", "variable", and "unit". The "variable" must also follow the IAMC format naming
#' conventions, e.g. "Emissions|CO2" for the 'total CO2 emissions (not including CCS)'.
#' @param outputVariables A list of variables to include in the output. Optional, default: list("Surface Temperature")
#' @param outConfig Named list where the names are climate models and the corresponding list member is a list of
#' configuration values to include in the output in the metadata. Optional, default: don't include input variables in
#' the output metadata.
#' @param returnRaw Boolean to control the return type. By default (returnRaw = FALSE), run() returns a named list
#' result, where result$df is a data frame which contains the result in the same format as the input scenarios, and
#' result$metadata is a named list of metadata generated during the run. If returnRaw is TRUE, run() returns a python
#' scmdata.ScmRun object.
#' @author Mika Pflüger
#' @importFrom reticulate import py_to_r
#' @examples
#' \dontrun{
#' # create very minimal emissions scenario.
#' df <- data.frame(
#'  model = c("rand", "rand"),
#'  scenario = c("weirdEMI", "weirdEMI"),
#'  region = c("World", "World"),
#'  variable = c("Emissions|CO2", "Emissions|CH4"),
#'  unit = c("Mt CO2 / yr", "Mt CH4 / yr"),
#'  "2015" = c(9., 12.),
#'  "2020" = c(10., 11.),
#'  check.names = FALSE)
#'
#' # simulate the scenario using MAGICC7 with default settings.
#' run(climateModelsConfigs = list("MAGICC7" = NULL), scenarios = df)
#'
#' # simulate the scenario using MAGICC7 with default settings but "somesetting" set to "12"
#' run(climateModelsConfigs = list("MAGICC7" = list("somesetting" = "12")), scenarios = df)
#'
#' # simulate the scenario with MAGICC7 and FaIR, each with two different sets of configurations
#' # where in MAGICC7 we change "somesetting" and in FaIR we change "fairsetting".
#' # Also include the changed configuration settings in the output.
#' run(climateModelsConfigs = list("MAGICC7" = list(list("somesetting" = "12"),
#'                                                  list("somesetting" = "13")),
#'                                 "FaIR" = list(list("fairsetting" = "slr"),
#'                                               list("fairsetting" = "noslr"))),
#'     scenarios = df,
#'     outConfig = list("MAGICC7" = list("somesetting"), "FaIR" = list("fairsetting")))
#' }
#' @export
run <- function(climateModelsConfigs, scenarios, outputVariables = list("Surface Temperature"), outConfig = NULL,
                returnRaw = FALSE) {
  openscmRunner <- import("openscm_runner", convert = FALSE)
  scmdata <- import("scmdata")
  sr <- scmdata$ScmRun(scenarios)
  climateModelsConfigs <- expandConfigs(climateModelsConfigs)

  if (!is.null(outConfig)) {
    for (model in names(outConfig)) {
      if (!is.null(outConfig[[model]])) {
        outConfig[[model]] <- reticulate::tuple(outConfig[[model]])
      }
    }
  }

  rawResult <- openscmRunner$run(
    climate_models_cfgs = climateModelsConfigs,
    scenarios = sr,
    output_variables = outputVariables,
    out_config = outConfig
  )
  if (returnRaw) {
    return(rawResult)
  } else {
    return(list(df = py_to_r(rawResult$timeseries()$reset_index()),
                metadata = py_to_r(rawResult$metadata)))
  }
}

expandConfigs <- function(climateModelsConfigs) {
  emptyNamedList <- list()
  names(emptyNamedList) <- list()

  for (model in names(climateModelsConfigs)) {
    # if the configs variable is NULL, assume a single default config
    if (is.null(climateModelsConfigs[[model]])) {
      climateModelsConfigs[[model]] <- list(emptyNamedList)
    }
    # if the configs variable is a named list, there is only one config, put it into a list
    if (!is.null(names(climateModelsConfigs[[model]]))) {
      climateModelsConfigs[[model]] <- list(climateModelsConfigs[[model]])
    }
    # replace NULL configs with empty (default) configs
    for (i in seq_along(climateModelsConfigs[[model]])) {
      if (is.null(climateModelsConfigs[[model]][[i]])) {
        climateModelsConfigs[[model]][[i]] <- emptyNamedList
      }
    }
  }
  return(climateModelsConfigs)
}
