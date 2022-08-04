#' setup
#'
#' Prepare rOpenscmRunner to run climate models.
#'
#' Some simple climate models need certain information to run. This function provides a unified
#' interface to supply this information.
#'
#' @param magiccExecutable7 The file path of a MAGICC version 7 executable file (with corresponding config file
#' structure around it). You have to supply this if you intend to run MAGICC version 7. Instead of using this
#' function to supply it, you can also set the environment variable MAGICC_EXECUTABLE_7 before starting your R session.
#' @param magiccWorkerNumber The number of processes which should be started when running MAGICC. By default, as many
#' processes are started as there are processors in your system. Instead of using this function to supply the setting,
#' you can also set the environment variable MAGICC_WORKER_NUMBER before starting your R session.
#' @param magiccWorkerRootDir The path to a folder where the temporary directories to run MAGICC will be created.
#' By default, a standard location is chosen depending on your operating system. Instead of using this function to
#' supply the setting, you can also set the environment variable MAGICC_WORKER_ROOT_DIR before starting your R session.
#' If you do supply a non-standard directory, you have to create and clean it up yourself. If you use the standard
#' settings, everything happens automatically.
#' @author Mika Pflüger
#' @importFrom reticulate import
#' @examples
#' setup(magiccExecutable7 = "/path/to/magicc/bin/magicc", magiccWorkerNumber = 4)
#' @export
setup <- function(magiccExecutable7 = NULL, magiccWorkerNumber = NULL, magiccWorkerRootDir = NULL) {
  if (!is.null(magiccExecutable7) || !is.null(magiccWorkerNumber) || !is.null(magiccWorkerRootDir)) {
    os <- import("os")
    if (!is.null(magiccExecutable7)) {
      # need to use __setitem__ because normal assignment doesn't reliably overwrite existing values.
      os$environ$"__setitem__"("MAGICC_EXECUTABLE_7", magiccExecutable7)
    }
    if (!is.null(magiccWorkerNumber)) {
      os$environ$"__setitem__"("MAGICC_WORKER_NUMBER", toString(magiccWorkerNumber))
    }
    if (!is.null(magiccWorkerRootDir)) {
      os$environ$"__setitem__"("MAGICC_WORKER_ROOT_DIR", magiccWorkerRootDir)
    }
  }
}
