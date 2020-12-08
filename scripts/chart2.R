number_of_arrests_per_week <- function(arrest_df) {
  plot2 <- ggplot(data = arrests_df, aes(x = week_num , y = arrests) ) +
    geom_bar(stat = "identity") +
    labs(title = "Number of arrests per Week ", 
         y="Arrests", x = "Week Number") + 
    theme(plot.title = element_text(hjust = 0.5))
  return(plot2)
}