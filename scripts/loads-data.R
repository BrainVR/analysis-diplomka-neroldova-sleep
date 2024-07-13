library(brainvr.vremt)

folder <- "data/"
# for each file in the folder, unzip it
files <- list.files(folder, pattern = ".zip", full.names = TRUE)
for (file in files) {
  unzip(file, exdir = folder)
}
file.remove(files)

# list all folders in folder
exp_folders <- list.dirs(folder, full.names = TRUE, recursive = FALSE)
participants <- list()
for (exp_folder in exp_folders) {
  message("Loading experiments from ", exp_folder)
  exps <- load_vremt_experiments(exp_folder, version = "2024")
  participant_name <- exps[[1]]$participant
  participants[[participant_name]] <- exps
}

save(participants, file = "data/participants.RData")
