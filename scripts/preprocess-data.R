library(brainvr.vremt)
library(dplyr)
source("functions/getters.R")
source("functions/analysis.R")
load("data/participants.RData")

df_collection <- data.frame()
df_placement <- data.frame()
for (participant in participants) {
  message("analyzing participant ", participant[[1]]$participant)
  res <- analyze_participant(participant)
  if (is.null(res)) next
  df_collection <- rbind(df_collection, res$collection)
  df_placement <- rbind(df_placement, res$placement)
}

df_collection$time_of_day <- morning_evening(df_collection$timestamp)
df_placement$time_of_day <- morning_evening(df_placement$timestamp)

dir.create("processed", showWarnings = FALSE)
write.csv(df_collection, "processed/collection.csv")
write.csv(df_placement, "processed/placement.csv")


get_recallPlacement_data(participants[[3]][[2]], 2)$data$actions_log$data$trial_name[1]
