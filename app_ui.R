library(shiny)
library(plotly)
library(leaflet)

# overview tab
project_overview_section <- div(
  h1("Project Overview"),
  p("
    Regardless of whether or not you are interested in sports, our group believes that everybody can find
    some degree of interest in sports statistics. We chose to gather data about the NFL because of the abundance
    of high quality data that we could access. We hope to highlight surprising and interesting connections
    between NFL datasets. Here's the table of contents for this overview page:
  "),
  HTML("
    <ul>
        <a href='#domain-of-interest'>
            <li>Domain of interest</li>
        </a>
        <a href='#questions'>
            <li>Questions to answer</li>
        </a>
        <a href='#datasets'>
            <li>Datasets</li>
        </a>
    </ul>
  ")
)

domain_of_interest <- div(
  a(
    name = "domain-of-interest",
    h1("What is this project about?")
  ),
  p("
    We are examining nfl statistics from various datasets in order to answer questions that
    require multiple columns to answer. We also hope to establish independent/dependent relationships
    between columns of data.
  ")
)

questions <- div(
  a(
    name = "questions",
    h1("What are we trying to answer?")
  ),
  HTML("
    <ul>
      <li>
        How does region affect Score Home - Score Away? Our Washington Post data set gives us the hometeam, away team, and score of the game to analyze this question.
      </li>
      <li>
        How do the ages of local stadiums affect team rush statistics? Our “NFL statistics” dataset contains rush statistics, our betting dataset contains stadium age.
      </li>
      <li>
        What does the distribution of when a stadium opens and closes down look like across the U.S? NFL stadiums dataset contains relevant information.
      </li>
    </ul>
  ")
)

datasets <- div(
  a (
    name = "datasets",
    h1("Datasets")
  ),
  p(
    a(
      target="blank",
      href="https://www.kaggle.com/kendallgillies/nflstatistics",
      h2("https://www.kaggle.com/tobycrabtree/nfl-scores-and-betting-data")
    ),
    "We got this data from kaggle. All data from this dataset was collected from http://www.nfl.com. This data provides
    basic statistics for each player, career statistics for each player, and game logs. There are 17,173 rows and 16
    columns in this data set. The original author of this dataset is Kendall Gillies who is a contributor on Kaggle.",
    img(src=base64enc::dataURI(file="./imgs/dataset1.png", mime="image/png"))
  ),
  br(),
  p(
    a(
      target="blank",
      href="https://www.kaggle.com/tobycrabtree/nfl-scores-and-betting-data",
      h2("https://www.kaggle.com/tobycrabtree/nfl-scores-and-betting-data")
    ),
    "The dataset is about NFL games and their corresponding betting info. The dataset was created by using data from websites
    such as ESPN, NFL.com, and Pro Football. Data about whether is collected from NOAA data with NFLweather.com. The source
    of the betting data is http://www.repole.com/sun4cast/data.html from 1978-2013. There are 3 datasets. One has 15 columns
    and 100 rows, one has 8 columns and 41 rows, one has 17 columns and 11000 rows. The author of the dataset is spreadspoke.",
    img(src=base64enc::dataURI(file="./imgs/dataset2.png", mime="image/png"))
  ),
  br(),
  p(
    a(
      target="blank",
      href="https://www.kaggle.com/washingtonpost/nfl-arrests",
      h2("https://www.kaggle.com/washingtonpost/nfl-arrests")
    ),
    "We got this dataset from kaggle. This dataset was created by the Washington Post who went to police departments that
    oversee security at NFL stadiums to retrieve data. The original authors were Kent Babb and Steven Rich of the Washington
    Post This data gives us information from the years of 2011-2015 about which team played on which homefield, number of
    arrests for teams in certain seasons, the scores for the game, what day of the week the game was, and what teams were
    playing. There are 11 columns and 1007 rows.",
    img(src=base64enc::dataURI(file="./imgs/dataset3.png", mime="image/png"))
  )
)

overview_panel <- tabPanel(
  "Project Overview",
  includeCSS("styles.css"),
  div(
    class = "view",
    project_overview_section,
    domain_of_interest,
    questions,
    datasets
  )
  # setBackgroundImage(src = 'https://www.gannett-cdn.com/-mm-/4265ce32c136d57b0870e84218966181a790c41a/c=0-570-5561-3712/local/-/media/2017/12/31/USATODAY/USATODAY/636503484962738487-USP-NFL-LOS-ANGELES-CHARGERS-AT-NEW-YORK-JETS-96188261.JPG?width=3200&height=1680&fit=crop')
)

# Plot 1 tab
first_panel <- tabPanel(
  "Home score - Away score v.s. Num arrests",
  fluidPage(
    titlePanel("balls"), #page layout doesnt rly matter, only thing that matters is sliderInput param
    sidebarLayout(
      sidebarPanel(
        sliderInput("diff", "Home score - Away score", -38, 58, c(-38, 58), step = 1)
      ),
      mainPanel(
        plotOutput("hist")
      )
    )
  )
)

# Plot 2 tab
second_panel <- tabPanel(
  "Stadiums in U.S.",
  titlePanel("Map of Stadiums"),
  sidebarLayout(
    sidebarPanel(
      h4(strong("Select What you want to display:")),
      selectInput(
        inputId = "Radius_Field",
        label = "Data:",
        choices = list("stadium_capacity", "stadium_open", "stadium_close")
      )
    ),
    mainPanel(
      h3(strong("Stadium Statistics")),
      leafletOutput("map")
    )
  )
)

# Plot 3 tab
third_panel <- tabPanel(
  "Rushing and Passing Statistics by Year",
  sidebarLayout(
    sidebarPanel(
      selectInput("columns",
                  "Select What to Plot on Y Axis:",
                  c("Rushing.TDs",
                    "TD.Passes",
                    "Longest.Pass",
                    "Longest.Rushing.Run",
                    "Rushing.Yards",
                    "Passes.Attempted",
                    "Passing.Yards",
                    "Sacked.Yards.Lost"))
    ),
    mainPanel(
      plotOutput("scatter")
    )
  )
)

# Summart tab
summary_overview <- div(
  h1("Summary"),
  HTML("
    <ul>
      <li>
        <a href='#plot1'>Home score - Away score v.s. Num arrests</a>
      </li>
      <li>
        <a href='#plot2'>Stadiums in U.S.</a>
      </li>
      <li>
        <a href='#plot3'>Rushing and Passing Statistics by Year</a>
      </li>
    </ul>
  ")
)

plot1_analysis <- div(
  a(
    name="plot1",
    h1("Home score - Away score v.s. Num arrests")
  ),
  div(
    class="analysis",
    div(
      img(src=base64enc::dataURI(file="./imgs/plot1.png", mime="image/png")),
    ),
    p(
      HTML("
        The distribution is right skewed at practically every point in the \"Home score - Away score\" slider.
        \"Home score - Away score\" apparently <strong>does not really affect the the incidences of games</strong> where there
        are a high number of arrests. The distribution of num arrests becomes less right skewed when
        the home team lost, however the vast majority of games had zero to very few arrests, even when the
        home team lost by a landslide. This indicates that there <strong>whether a team loses or not does strongly
        affect the number of crimes that occur</strong>.
      ")
    )
  )
)

plot2_analysis <- div(
  a(
    name="plot2",
    h1("Stadiums in U.S.")
  ),
  div(
    class="analysis",
    div(
      div(
        h3("Stadiums open"),
        img(src=base64enc::dataURI(file="./imgs/plot2_1.png", mime="image/png")),
      ),
      div(
        h3("Stadiums closed"),
        img(src=base64enc::dataURI(file="./imgs/plot2_2.png", mime="image/png")),
      )
    ),
    p(
      HTML("
        A lot of the stadiums that we plotted seem to be mainly concentrated on the <strong>east coast</strong>. When we pick
        radius to be the year the stadium opened we can see that the east coast has bigger circles indicating that
        they had stadiums that were <strong>opened later than the west coast</strong>. When we select the radius to be the year
        the stadium closed, the west coast seems to have generally more stadiums that closed earlier than the east
        coast. These insights tell us that the <strong>east coast had more football stadiums and in general opened later
        but have kept them open for longer</strong>. The data doesn’t have a lot of data for the stadium capacity(there
        are a lot of NA values) so we can’t tell that much from the map.
      ")
    )
  )
)

summary_panel <- tabPanel(
  "Summary",
  div(
    class="view",
    summary_overview,
    plot1_analysis,
    plot2_analysis
  )
)

ui <- navbarPage(
  "Final Project",
  overview_panel,
  first_panel,
  second_panel,
  third_panel,
  summary_panel
)
