#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(tidyverse)
library(stringr)
library(data.table)

data <- read.csv("thor-data-2.csv", stringsAsFactors = FALSE)
data$MISSIONDATE <- as.Date(data$MISSIONDATE) 
data$NUMBEROFPLANES <- as.numeric(data$NUMBEROFPLANES) 

shinyServer(function(input, output) {

  
  output$plot <- renderLeaflet({
  
  data <- setDT(data)[MISSIONDATE %between% c(input$dates[1], input$dates[2])] %>%
      filter(NUMBEROFPLANES>=input$size[1], NUMBEROFPLANES<=input$size[2])%>%
      filter(MDSnormalized %in% input$aircraft) %>%
      filter(COUNTRY %in% input$power) %>%
      filter(TAKEOFFTIMEnormalized %in% input$takeoff)
    
  map <- leaflet(data = data) %>% addTiles() %>%
    addCircles(~LONGITUDE, ~LATITUDE, weight = 1, radius = ~sqrt(BOMBLOAD) * 200, popup = ~as.character(TGTTYPE), label = ~as.character(ALTITUDE), fillColor = "#FF0000") %>%
    addCircles(~TAKEOFFLONGITUDE, ~TAKEOFFLATITUDE, weight = 1, radius = ~sqrt(as.numeric(NUMBEROFPLANES)) * 1000, popup = ~as.character(TAKEOFFBASE), label = ~as.character(ALTITUDE))
  
  for(i in 1:nrow(data)){
    map <- addPolylines(map, lat = as.numeric(data[i, c(25, 19)]), 
                        lng = as.numeric(data[i, c(26, 20)]), opacity = 0.1)
  }
  map
  })
  
  output$table1 <- renderTable({
    
    data <- setDT(data)[MISSIONDATE %between% c(input$dates[1], input$dates[2])] %>%
      filter(NUMBEROFPLANES>=input$size[1], NUMBEROFPLANES<=input$size[2])%>%
      filter(MDSnormalized %in% input$aircraft) %>%
      filter(COUNTRY %in% input$power) %>%
      filter(TAKEOFFTIMEnormalized %in% input$takeoff)
    data$MISSIONDATE <- as.character(data$MISSIONDATE) 
    data %>%
      select(MISSIONDATE, NUMBEROFPLANES, COUNTRY, MDS, TAKEOFFTIME, BOMBLOAD, ALTITUDE)
    },
  
    sanitize.text.function = function(x) x) 
      
   
    
  })
