get_df <- function() {
  col <- c("mean_home_score", "mean_away_score", "mean_score_difference", "proportion_OT", "mean_arrests")
  return(data.frame(col, v))
}

aggregate_df <- function(arrests_df){
  return(
    arrests_df %>% group_by(day_of_week) %>% summarize(day_occurrences = n())
  )
}
