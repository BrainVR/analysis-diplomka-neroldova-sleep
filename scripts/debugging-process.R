library(brainvr.vremt)
library(dplyr)
source("functions/getters.R")
source("functions/analysis.R")
load("data/participants.RData")

participant <- participants[[1]]
session <- participant[[1]]

analyze_session(session)
str(session)

get_finished_phases(session, "recallItems")
get_finished_phases(session, "recallPlacement")
get_recallItems_data(session, 1)

times <- get_phase_time(session, "recallItems", 1)
filter_times(session, times)
str(session$data$actions_log$data)
times

filter_log_timestamp
