library(shinycssloaders)
library(shiny)
library(sf)
library(leaflet)
library(shinycssloaders)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("First World War Aerial Bombing Missions"),
  p("These maps are generated from a", a("dataset of Aerial Bombing Sorties from the Fist World War", href = "https://insight.livestories.com/s/v2/thor-world-war-i/5be11be2-83c7-4d20-b5bc-05b3dc325d7e/"), "compiled by the United States Department of Defense", a("Theater History of Operations (THOR) project.", href = "https://www.data.mil/s/v2/data-mil/1ff45997-196e-4e9a-96e2-eed27e3e17ab/")),
  p("The datasets represents over 1,400 sorties by British, French, Italian, and American aerial forces during the First World War."),
  p("The THOR project provides very little information about the origin of this data. This project makes no assurances of the accuracy or completeness of the information presented on these maps. "),
    sidebarLayout(
      sidebarPanel(
        dateRangeInput("dates", 
                      label = h3("Select Date Range"), 
                      start = "1915-05-26", 
                      end = "1918-11-10"),

        sliderInput("size", label = ("Number of Aircraft"), min = 1, max = 208, value = c(1, 208)),
        
        checkboxGroupInput("power", label = h3("Air Power"), 
                           choices = list("Britain" = "UK", "France" = "FRANCE", "Italy" = "ITALY", "United States" = "USA"),
                           selected = c("UK","FRANCE", "ITALY", "USA")),
        
        checkboxGroupInput("aircraft", label = h3("Aircraft Make"), 
                                choices = list("Airship" = "AIRSHIP", "AirCo" = "AIRCO", "Breguet" = "BREGUET", "Caproni" = "CAPRONI", "Hadley Page" = "HADLEY PAGE", "Liberty DH4" = "LIBERTY DH4", "Other" = "Other"),
                                selected = c("AIRSHIP", "AIRCO", "BREGUET", "CAPRONI", "HADLEY PAGE", "LIBERTY DH4", "Other")),
        
        checkboxGroupInput("takeoff", label = h3("Take-off Time"), 
                          choices = list("Morning" = "MORNING", "Day" = "DAY", "Evening" = "EVENING", "Night" = "NIGHT", "Left Blank" = "Left blank"),
                          selected = c("MORNING", "DAY", "EVENING", "NIGHT", "Left blank"))),
       
  mainPanel(
    withSpinner(leafletOutput("plot")),
    withSpinner(tableOutput("table1"))
    )
  )
))
