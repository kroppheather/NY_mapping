######################################################
###### Script for organizing NY weather data    ######
###### from NOAA                                ######
######################################################
library(dplyr)
library(rnoaa)
#set directory for data

Sys.setenv(RNOAA_GHCND_BASE_URL =
"ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all")
#stations to work with
stations <- read.csv("C:\\Users\\hkropp\\Google Drive\\NY_spring\\NY_stations.csv")

datW <- ghcnd(stationid = paste(stations$station_id[3]))
datV <- ghcnd_splitvars(datW)

datP <- datV[[1]]

datTmax <- datV[[]]

datW2 <- ghcnd(stationid = paste(stations$station_id[501]))
datV2 <- ghcnd_splitvars(datW2)

test <- ghcnd_search(paste(stations$station_id[220]), var=c("TMAX", "TMIN","TAVG","PRCP"))