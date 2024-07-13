library(dplyr)
#' Get the finished phases of a given type
#' @param exp The experiment object
#' @param phase_type The type of phase to get "recallItems", "recallPlacement"
get_finished_phases <- function(exp, phase_type) {
  df_exp <- get_experiment_log(exp)
  df_exp <- df_exp %>%
    filter(Message == phase_type, Sender == "phase", Event == "start")
  if (nrow(df_exp) == 0) {
    warning("No phases of type ", phase_type, " found in the experiment log")
    return(NULL)
  }
  return(df_exp$Index)
}
