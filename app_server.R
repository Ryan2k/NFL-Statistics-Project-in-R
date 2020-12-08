library(shiny)
library(ggplot2)
library(dplyr)

server <- function(input, output) {
  # read datasets
  rush <- read.csv("data/nflstatistics/Career_Stats_Rushing.csv", stringsAsFactors = F)
  pass <- read.csv("data/nflstatistics/Career_Stats_Passing.csv", stringsAsFactors = F)
  arrests <- read.csv("data/nfl-arrests/arrests.csv", stringsAsFactors = F)
  stadiums <-read.csv("data/nfl_stadiums.csv", stringsAsFactors = FALSE)

  # plot 1
  df_diff <- arrests %>%
    mutate(score_diff = home_score - away_score) %>%
    select(score_diff, arrests)
  
  df_diff_react <- reactive({
    df_diff %>%
      filter(
        score_diff <= input$diff[2] & score_diff >= input$diff[1]
      )
  })
  
  output$hist <- renderPlot({
    ggplot(df_diff_react(), aes(x=arrests)) +
      geom_histogram() +
      labs(
        x="Num Arrests",
        y="Total Difference"
      )
  })
  
  # plot 2
  stadiums <-read.csv("data/nfl_stadiums.csv", stringsAsFactors = FALSE)
  stadiums <- stadiums %>% mutate(stadium_capacity = as.numeric(stadium_capacity))
  stadiums <- stadiums %>% mutate(stadium_capacity = stadium_capacity/1000)
  stadiums <- stadiums %>% mutate(stadium_open = (stadium_open-1950))
  stadiums <- stadiums %>% mutate(stadium_close = (stadium_close-1950))
  
  label_info <- paste0(
    "Stadium Name: " , stadiums$stadium_name, "<br>" , 
    "Stadium Type: " , stadiums$stadium_type, "<br>" , 
    "Stadium Location: " , stadiums$stadium_location, "<br>"
  )

  output$map <- renderLeaflet({
    leaflet(stadiums) %>%
      addProviderTiles("CartoDB.Positron")%>%
      addCircleMarkers(
        lat = ~stadiums$LATITUDE,
        lng = ~stadiums$LONGITUDE,
        radius = ~(stadiums[[input$Radius_Field]]),
        color = "green",
        stroke = FALSE,
        label = lapply(label_info, htmltools::HTML),
        fillOpacity = 0.3
      )
  })

  # plot 3
  output$scatter <- renderPlot({
    df <- merge(
      rush,
      pass,
      by = 1:6,
      all = TRUE
    )
    df[df == "--"] <- NA
    for (i in 7:ncol(df)) {
      df[, i] <- as.numeric(df[, i])
    }
    summ_df <- df %>%
      group_by(Year) %>%
      #summarize(across(where(is.numeric), ~mean(.x, na.rm = TRUE)))%>%
      as.data.frame()
    plot_df <- data.frame(
      X = summ_df$Year,
      Y = summ_df[, c(input$columns)]
    )
    plot_df %>%
      ggplot(aes(X, Y)) +
      ggtitle(paste("Mean", input$columns, "per Player, per Year")) +
      xlab("Years") +
      ylab(input$columns) +
      geom_point() +
      geom_smooth() +
      theme_minimal()
  })
}