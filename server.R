#Shiny server, butchered from data table demo
library(shiny)
library(ggplot2)


# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- read.csv(file="trackdata.csv")
    data <- data.frame(inputData[, "name"], 
                       inputData[, "artist"], 
                       inputData[, "popularity"],
                       inputData[, "albumpopularity"],
                       inputData[, "ageweeks"],
                       inputData[, "ranking"])
    colnames(data) <- c("Song name", 
                        "Artist", 
                        "Popularity",
                        "Album popularity",
                        "Age (weeks)",
                        "Ranking")
    data
  }))
  
})

