arrest_number_on_day <- function(arrest_df) {
  # calculate number for each week day
  arrest_number <- arrests_df %>%
    group_by(day_of_week) %>%
    summarise(
      total_arrests = sum(arrests, na.rm = TRUE)
    )
  # Sort rows by week day
  sorting_order <- c("Sunday", "Monday", "Tuesday", "Wednesday",
                     "Thursday", "Friday", "Saturday")
  arrest_number$day_of_week <- factor(arrest_number$day_of_week,
                                         levels = sorting_order)

  # plot the histogram
  ggplot(arrest_number) +
    geom_histogram(
      aes(x = day_of_week, y = total_arrests,
          fill = day_of_week),
      stat = "identity"
    ) + labs(
      title = "Number of crimes for each day of week",
      x = "Day of Week",
      y = "Total arrests",
      fill = "Day of Week"
    ) + theme(plot.title = element_text(hjust = 0.5))
}