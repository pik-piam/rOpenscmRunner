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
#' @param scenarios DataFrame containing one or multiple emissions scenarios to simulate.
#' @param outputVariables A list of variables to include in the output. Optional, default: list("Surface Temperature")
#' @param outConfig Named list where the names are climate models and the corresponding list member is a list of
#' configuration values to include in the output in the metadata. Optional, default: don't include input variables in
#' the output metadata.
#' @author Mika Pflüger
#' @importFrom reticulate import
#' @examples
#' \dontrun{
#' run(climateModelsConfigs = list("MAGICC7" = NULL), scenarios = ...)
#'
#' run(climateModelsConfigs = list("MAGICC7" = list("somesetting" = "12")), scenarios = ...)
#'
#' run(climateModelsConfigs = list("MAGICC7" = list(list("somesetting" = "12"),
#'                                                  list("somesetting" = "13")),
#'                                 "FaIR" = list(list("fairsetting" = "slr"),
#'                                               list("fairsetting" = "noslr"))),
#'     scenarios = ...,
#'     outConfig = list("MAGICC7" = list("somesetting"), "FaIR" = list("fairsetting")))
#' }
#' @export
run <- function(climateModelsConfigs, scenarios, outputVariables = list("Surface Temperature"), outConfig = NULL) {
  openscmRunner <- import("openscm_runner")
  scmdata <- import("scmdata")
  sr <- scmdata$ScmRun(scenarios)

  rawResult <- openscmRunner$run(
    climate_models_configs = climateModelsConfigs,
    scenarios = sr,
    output_variables = outputVariables,
    out_config = outConfig
  )

  return(rawResult)
}
