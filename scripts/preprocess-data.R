library(brainvr.vremt)
library(dplyr)
source("functions/getters.R")
source("functions/analysis.R")

load("data/participants.RData")

df_collection <- data.frame()
df_placement <- data.frame()
for (participant in participants) {
  res <- analyze_participant(participant)
  if (is.null(res)) next
  df_collection <- rbind(df_collection, res$collection)
  df_placement <- rbind(df_placement, res$placement)
}

dir.create("processed", showWarnings = FALSE)
write.csv(df_collection, "processed/collection.csv")
write.csv(df_placement, "processed/placement.csv")

View(df_collection)
