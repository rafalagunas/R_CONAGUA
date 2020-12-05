#!/usr/bin/env Rscript

#repos <- "http://cran.us.r-project.org"
#install.packages(c("httr", "jsonlite","dplyr"), repos = repos)
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
#head(df)

# Now we change the names of the columns so we can have a standar
names(df)[1] <- "pageSize"
names(df)[2] <- "pageNumber"
names(df)[3] <- "paginationTotal"
names(df)[4] <- "ID"
names(df)[5] <- "city_ID"
names(df)[6] <- "valid_date_utc"
names(df)[7] <- "wind_direction"
names(df)[8] <- "precipitation_prob"
names(df)[9] <- "relative_humidity"
names(df)[10] <- "city_name"
names(df)[11] <- "date_insert"
names(df)[12] <- "long"
names(df)[13] <- "state"
names(df)[14] <- "last_report_time"
names(df)[15] <- "sky_description"
names(df)[16] <- "state_abbr"
names(df)[17] <- "temp_celsius"
names(df)[18] <- "lat"
names(df)[19] <- "iconcode"
names(df)[20] <- "wind_speed"


# We verify the new colnames
#print("Colnames")
colnames(df)


searchSpecificColumns <- function(params){
df <- df %>% select((params))
#str(df)
return(df)
}

#Parámetros de búsqueda.
params <- c("city_ID", "valid_date_utc", "wind_direction","relative_humidity","city_name")

result <- searchSpecificColumns(params)

#Nombres de todas las ciudades del estado.
#result$city_name

benito_juarez <- df %>% 
  filter(city_name == "Benito Juárez")


head(benito_juarez)


getMeans <- function(df){
    relative_humidity <- mean((as.numeric(as.character(df$relative_humidity))))
    celsius <- mean((as.numeric(as.character(df$temp_celsius))))
    wind_speed <- mean((as.numeric(as.character(df$wind_speed))))
    object <- list(relative_humidity,celsius,wind_speed)
    object
    return(object)
}

getMeans(df)