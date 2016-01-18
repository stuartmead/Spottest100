#Shiny UI, butchered from data table demo
library(shiny)
library(ggplot2)

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("Spottest 100 2016"),
    
    # Create a new row for the table.
    fluidRow(
      #Side Panel
      column(4,
             h2("Summary"),
             h6("By: Stuart Mead"),
             p("This is using the Spotify web",
               a("API", href = "https://developer.spotify.com/web-api/"),
               "to try and guess what the",
               a("triple j hottest 100", href = "http://hottest100.triplej.net.au/"),
               "will be in 2016."),
             p("My guess at ranking score was based on accounting for
               album popularity and age of the song which may artificially
               inflate the spotify popularity score (relative to the triplej votes)"),
             p("Feel free to modify the ranking or code as you see fit. Source code
               and data are avaliable on",
               a("github", href = "https://github.com/stuartmead/Spottest100"),
               ". Any questions, contact me through there.")
      ),
      align = "left",
      #Data panel
      column(8,
          DT::dataTableOutput("table")
      )
    )
  )
)

