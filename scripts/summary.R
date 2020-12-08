library("dplyr")

get_summary_info <- function(arrests_df) {
  return(c(
    #Mean Home Score
    arrests_df %>% summarize(mean_home_score = mean(home_score)) %>% pull(mean_home_score),
    #Mean Away Score
    arrests_df %>% summarize(mean_away_score = mean(away_score)) %>% pull(mean_away_score),
    #Mean difference in score
    arrests_df %>% summarize(mean_score_difference = mean(home_score - away_score)) %>% pull(mean_score_difference),
    #Away Score SD
    nrow(arrests_df%>% filter(OT_flag == "OT"))/nrow(arrests_df),
    #Home score Std Dev
    arrests_df %>% summarize(mean_arrests = mean(arrests, na.rm =T)) %>% pull(mean_arrests)
  ))
}

