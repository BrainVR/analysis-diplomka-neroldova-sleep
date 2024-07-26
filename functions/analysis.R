analyze_participant <- function(exps) {
  message("Analyzing participant ", exps[[1]]$participant)
  message("--------------------")
  df_collection <- data.frame()
  df_placement <- data.frame()
  for (i_exp in seq_along(exps)) {
    exp <- exps[[i_exp]]
    message("Analysisng experiment ", exp$timestamp)
    res <- analyze_session(exp)
    if (is.null(res)) next
    df_collection <- rbind(df_collection, res$collection)
    df_placement <- rbind(df_placement, res$placement)
  }
  if (nrow(df_collection) == 0 || nrow(df_placement) == 0) {
    warning("No data found for participant ", exps[[1]]$participant)
    return(NULL)
  }
  df_placement$participant <- exp$participant
  df_collection$participant <- exp$participant
  return(list(collection = df_collection, placement = df_placement))
}

analyze_session <- function(exp) {
  df_collection <- data.frame()
  df_placement <- data.frame()
  i_items <- get_finished_phases(exp, "recallItems")
  i_placement <- get_finished_phases(exp, "recallPlacement")

  if (length(i_items) == 0 || length(i_placement) == 0) {
    warning("Skipping analysis of ", exp$participant,
            " timestamp: ", exp$timestamp,
            " because it has no recallItems or recallPlacement phases")
    return(NULL)
  }
  if (length(i_items) != length(i_placement)) {
    warning("Skipping analysis of ", exp$participant,
            " timestamp: ", exp$timestamp, " because it has different number ",
            "of recallItems and recallPlacement phases")
    return(NULL)
  }
  for (i_phase in i_items) {
    collection <- get_recallItems_data(exp, i_phase)
    if (nrow(get_actions_log(collection)) == 0) {
      warning("Skipping analysis of ", exp$participant,
              " timestamp: ", exp$timestamp, "phase: ", i_phase,
              " because collection log has no actions")
      next
    }
    placement <- get_recallPlacement_data(exp, i_phase)
    if (nrow(get_actions_log(placement)) == 0) {
      warning("Skipping analysis of ", exp$participant,
              " timestamp: ", exp$timestamp, "phase: ", i_phase,
              " because placement log has no actions")
      next
    }
    res_collection <- vremt_collection_performance(collection)[["summary"]]
    res_placement <- vremt_placement_performance(placement)
    res_placement$trial_name <- placement$data$actions_log$data$trial_name[1]
    res_placement <- distinct(res_placement)
    res_collection$phase <- i_phase
    res_placement$phase <- i_phase
    df_collection <- rbind(df_collection, res_collection)
    df_placement <- rbind(df_placement, res_placement)
  }
  if (nrow(df_collection) == 0 || nrow(df_placement) == 0) {
    warning("Could not analyze data for ", exp$participant, " timestamp: ",
            exp$timestamp, " due to unslecified missing data")
    return(NULL)
  }
  df_placement$timestamp <- exp$timestamp
  df_collection$timestamp <- exp$timestamp
  return(list(collection = df_collection, placement = df_placement))
}
