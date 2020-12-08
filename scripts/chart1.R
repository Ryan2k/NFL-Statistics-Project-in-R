scatterplot <- function(arrests_df){
  plot <- ggplot(data = arrests_df) + 
    geom_point(mapping = aes(x = home_score, y= arrests)) + 
    labs(title = "Arrest by Home Score", 
           y="Arrests", x = "Home score") +
    theme(plot.title = element_text(hjust = 0.5))
  return(plot)
}