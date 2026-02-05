library(brainvr.vremt)
library(googledrive)

missing_data <- "1cZnbOM1SorEaxR9bViS2BUC4IHTkgI4S"
original_data <- "1vgXmZYj7Wse1pHmcuqSlGNiWhUkkGuD4"

# download original data from google drive to data/original_data.zip
if (!dir.exists("data")) {
  dir.create("data")
}
if (!file.exists("data/original_data.zip")) {
  message("Downloading original data from Google Drive...")
  drive_download(as_id(original_data),
                 path = "data/original_data.zip",
                 overwrite = TRUE,
                 type = "zip")
  drive_download(as_id(missing_data),
                 path = "data/missing_data.zip",
                 overwrite = TRUE,
                 type = "zip")
} else {
  message("Original data already downloaded.")
}
drive_deauth()

folder <- "data/"
# for each file in the folder, unzip it
files <- list.files(folder, pattern = ".zip", full.names = TRUE)
for (file in files) {
  print(file)
  try(unzip(file, exdir = folder))
}
file.remove(files)

# list all folders in folder
exp_folders <- list.dirs(folder, full.names = TRUE, recursive = FALSE)
participants <- list()
for (exp_folder in exp_folders) {
  message("-----------------")
  message("NEW PARTICIPANT")
  message("-----------------")
  message("Loading experiments from ", exp_folder)
  exps <- load_vremt_experiments(exp_folder, version = "2024")
  participant_name <- exps[[1]]$participant
  participants[[participant_name]] <- exps
}

save(participants, file = "data/participants.RData")
