######################################################
###### Script for organizing NY weather data    ######
###### from NOAA                                ######
######################################################
library(dplyr)
library(rnoaa)
library(rgdal)
library(rgeos)

#set directory for data output
outDir <- "C:\\Users\\hkropp\\Google Drive\\NY_spring\\NYweather"

Sys.setenv(RNOAA_GHCND_BASE_URL =
"ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all")
#stations to work with

##########get all stations in NY##################

States <- readOGR("C:\\Users\\hkropp\\Google Drive\\NY_spring\\USA\\STATES.shp")
NYm <- States[States$STATE_NAME == "New York",]
plot(NYm)
NYm@proj4string

stationsA <- read.csv("C:\\Users\\hkropp\\Google Drive\\NY_spring\\all_stations.csv")
#no coordinate system reference in metadata, assume wgs 84 for now
stationMap <- SpatialPoints(stationsA[,3:2], NYm@proj4string)
stationMap <-SpatialPointsDataFrame(stationsA[,3:2], stationsA[,1:5], 
      proj4string = NYm@proj4string)


plot(stationMap, add=TRUE)

StationsOverlap <- gIntersection(stationMap,NYm, byid=TRUE, id=as.character(stationMap@data$station_id))
plot(StationsOverlap )
str(StationsOverlap)
NYstations <- data.frame(station_id=rownames(StationsOverlap@coords))

stations <- inner_join(stationsA, NYstations, by="station_id")


#download and append all files


#initialize


datW <- list()

for(i in 1:1){
	
	datW <- ghcnd_search(paste(stations$station_id[i]), var=c("TMAX", "TMIN","TAVG","PRCP"))
	dir.create(paste0(outDir,"\\",stations$station_id[i]))
		for(j in 1:length(datW)){
			
			write.table(datW[[j]], paste0(outDir,"\\",stations$station_id[i],"\\",stations$station_id[i],"_",colnames(datW[[j]][2]),".csv"),
			sep=",")
		}
}


for(i in 2:300){
	
	datW <- ghcnd_search(paste(stations$station_id[i]), var=c("TMAX", "TMIN","TAVG","PRCP"))
	dir.create(paste0(outDir,"\\",stations$station_id[i]))
		for(j in 1:length(datW)){
			
			write.table(datW[[j]], paste0(outDir,"\\",stations$station_id[i],"\\",stations$station_id[i],"_",colnames(datW[[j]][2]),".csv"),
			sep=",")
		}
	print(paste("done station",stations$station_id[i], "number ",i)	)
}



for(i in 301:nrow(stations)){
	
	datW <- ghcnd_search(paste(stations$station_id[i]), var=c("TMAX", "TMIN","TAVG","PRCP"))
	dir.create(paste0(outDir,"\\",stations$station_id[i]))
		for(j in 1:length(datW)){
			
			write.table(datW[[j]], paste0(outDir,"\\",stations$station_id[i],"\\",stations$station_id[i],"_",colnames(datW[[j]][2]),".csv"),
			sep=",")
		}
	print(paste("done station",stations$station_id[i], "number ",i)	)
}
