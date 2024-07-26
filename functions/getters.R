library(dplyr)
#' Get the finished phases of a given type
#' @param exp The experiment object
#' @param phase_type The type of phase to get "recallItems", "recallPlacement"
get_finished_phases <- function(exp, phase_type) {
  df_exp <- get_experiment_log(exp)
  df_exp <- df_exp %>%
    filter(Message == phase_type,
           Sender == "phase",
           Event == "start")
  if (nrow(df_exp) == 0) {
    warning("No phases of type ", phase_type, " found in the experiment log")
    return(NULL)
  }
  return(df_exp$Index)
}


morning_evening <- function(date) {
  # The time is in format HH-MM-SS-dd-mm-YYYY 19-48-14-16-05-2024
  # convert this to evening if the time is above 17:00 and to morning
  # if before 10:00 and to Unknown if between 10:00 and 17:00
  time <- lubridate::hour(as.POSIXct(date, format = "%H-%M-%S-%d-%m-%Y"))
  mornings <- case_when(
    time < 10 ~ "morning",
    time >= 17 ~ "evening",
    TRUE ~ "unknown"
  )
  return(mornings)
}

