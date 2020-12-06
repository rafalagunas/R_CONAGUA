#!/usr/bin/env Rscript

repos <- "http://cran.us.r-project.org"
#install.packages(c("shiny", 
#"shinydashboard","plotly",
#"datasets","openxlsx",
#"dplyr","stringr",
#"caTools","gapminder", "ggplot2","gganimate",
#"tidyverse","plyr","treemap","rworldmap","rgdal","threejs"), repos = repos)

library(shiny)
library(shinydashboard)
library(plotly)
library(datasets)
library(openxlsx)
library(dplyr)
library(stringr)
library(caTools)
library(gapminder)
library(ggplot2)
library(gganimate)
library(tidyverse)
library(plyr)
library(treemap)
library(rworldmap)
library(rgdal)
library(threejs)


datos = read.csv("QuintanaRoo.csv", sep=",", stringsAsFactors = F) # Colocarla como variable global

ciudades = unique(datos$city_name)

ui <- dashboardPage(skin = "purple",
                    
        dashboardHeader(title = textOutput("vv") ,titleWidth = 300),
                    
        dashboardSidebar( width = 250,
                          sidebarMenu( 
                          menuItem("Inicio",  icon=icon("info"), tabName = "Inicio"),
                          menuItem("Condiciones atmosféricas",  icon=icon("globe"), tabName = "Map"),
                          menuItem("Buscador",  icon=icon("map-marker-alt"), tabName = "Buscador"),
                          menuItem("Tabla de resultados", icon = icon("tasks"), tabName = "Tabla"),
                          menuItem("Gráficas", icon = icon("signal"), tabName = "Gráficas")
                            )
                    ),
        dashboardBody(
                      tags$head(
                      tags$style(HTML('.main-header .logo {font-family: "Impact", fantasy;font-size: 28px;}')),
                      tags$style(HTML(".main-sidebar { font-size: 18px; }"))
                      ),
                      tabItems(
                        ######################
                        tabItem(tabName = "Inicio",
                                box(title = "Información de la API", status = "info", collapsible = T, width = 20, solidHeader = TRUE, "La API de CONAGUA (Comisión Nacional del Agua) provee más de 13 millones de registros de las condiciones atmosféricas de todo el país. Contiene datos como la dirección del viento, probabilidad de precipitación, descripción del cielo, velocidad del viento, 
                                    entre otros datos que ayudarán a observar las condiciones de cada estado de la república mexicana. Estos datos los puedes encontrar en: https://api.datos.gob.mx/v1/condiciones-atmosfericas", align = "left"),
                                img(src='https://www.revista.unam.mx/wp-content/uploads/img1-45.jpg', width = 870, height = 447)
                                ),
                        ######################
                        tabItem(tabName = "Buscador",
                                selectInput(inputId = "pais", label = "Elija un estado:", 
                                             ciudades),
                                h3(" "),
                                fluidRow(
                                  box(title = "Condiciones Atmosféricas por Estado", status="success", collapsible = T, plotOutput("region1", width = "100%", height = "800px"), width = 10, background = "black"),
                                ),
                        ),
                        ######################
                        tabItem(tabName = "Tabla",
                                selectInput(inputId = "pais", label = "Elija un estado:", 
                                            ciudades),
                                fluidRow(
                                  box(title = "Condiciones atmosféricas", status="success", collapsible = T, plotOutput(outputId = "ojivas",  brush = "plot_brush", height = "500px"), width = 10, height = 20, background = "light-blue"),
                                )
                        ),
                        ######################
                        tabItem(tabName = "Map",
                                
                                box(title = "Mapa", status = "info" , collapsible = T, width = 20, solidHeader = TRUE, 
                                img(src='https://upload.wikimedia.org/wikipedia/commons/4/40/Koppen-Geiger_Map_MEX_present.svg', width = 870, height = 447)
                                ),
                                box(title = "Información ", status = "info" , collapsible = T, width = 20, solidHeader = TRUE, "En el presente mapa se muestra las zonas climáticas generales hasta 2016, 
                                    esto nos sirve para comparar con las condiciones atmosféricas hoy en día y ver el impacto del calentamiento global.")
                                
                                ),
                        ######################
                        tabItem(tabName = "Gráficas",
                                selectInput(inputId = "pais", label = "Elija un estado:", 
                                            ciudades),
                                fluidRow(
                                  box(title = "Condiciones atmosféricas", status="success", collapsible = T, plotOutput(outputId = "ojivas",  brush = "plot_brush", height = "500px"), width = 10, height = 20, background = "teal"),
                                )
                        )
                      )
                      )
                    
)

server <- function(input, output) {

    output$vv <- renderText({ 
    "You have selected this"
  })
library(httr)
library(jsonlite)
library(dplyr)
res <- GET("https://api.datos.gob.mx/v1/condiciones-atmosfericas")
dat <- fromJSON(rawToChar(res$content))

getData <- function (pageSize,state){
    URL <- sprintf("https://api.datos.gob.mx/v1/condiciones-atmosfericas?pageSize=%s&stateabbr=%s",pageSize,state)
    res <- GET(URL,verbose())
    dat <- fromJSON(rawToChar(res$content))
    return(dat)
}

data <- getData(50,"ROO")

df <- as.data.frame(data)
head(df)


  
  
}

shinyApp(ui = ui, server = server)