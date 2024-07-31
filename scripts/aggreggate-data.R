library(dplyr)
library(tidyr)

dir.create("processed", showWarnings = FALSE)

df_collection <- read.csv("processed/collection.csv")
df_placement <- read.csv("processed/placement.csv")

View(df_collection)

df_collection %>%
  group_by(timestamp) %>%
  summarise(total_missing_items = sum(n_missing_items),
            total_extra_items = sum(n_extra_items),
            n_correct_items = sum(n_correct_items),
            time_of_day = time_of_day[1],
            participant = participant[1]) %>%
  write.csv("processed/collection_aggregated_timestamp.csv")

df_collection %>%
  group_by(timestamp) %>%
  summarise(total_missing_items = sum(n_missing_items),
            total_extra_items = sum(n_extra_items),
            total_correct_items = sum(n_correct_items),
            time_of_day = time_of_day[1],
            participant = participant[1]) %>%
  pivot_wider(names_from = time_of_day, id_cols = c(participant),
              values_from = c(total_missing_items, total_extra_items, total_correct_items)) %>%
  write.csv("processed/collection_aggregated_timeofday.csv")

head(df_placement)

df_placement %>%
  group_by(timestamp) %>%
  summarise(total_order_error = sum(abs(order_error)),
            total_arm_correct = sum(arm_correct != arm),
            total_location_correct = sum(location_correct != location),
            participant = participant[1],
            time_of_day = time_of_day[1]) %>%
  write.csv("processed/placement_aggregated_timestamp.csv")

df_placement %>%
  group_by(timestamp, trial_name) %>%
  summarise(total_order_error = sum(abs(order_error)),
            total_arm_correct = sum(arm_correct != arm),
            total_location_correct = sum(location_correct != location),
            participant = participant[1],
            time_of_day = time_of_day[1]) %>%
  pivot_wider(names_from = trial_name, id_cols = c(timestamp, participant),
              values_from = c(total_order_error, total_arm_correct, total_location_correct)) %>%
  write.csv("processed/placement_aggregated_trialname.csv")


df_placement %>%
  group_by(timestamp) %>%
  summarise(total_order_error = sum(abs(order_error)),
            total_arm_correct = sum(arm_correct != arm),
            total_location_correct = sum(location_correct != location),
            participant = participant[1],
            time_of_day = time_of_day[1]) %>%
  pivot_wider(names_from = time_of_day, id_cols = c(participant),
              values_from = c(total_order_error, total_arm_correct, total_location_correct)) %>%
  write.csv("processed/placement_aggregated_timeofday.csv")
