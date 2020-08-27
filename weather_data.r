######################################################
###### Script for organizing NY weather data    ######
###### from NOAA                                ######
######################################################
library(dplyr)
library(rnoaa)
library(rgdal)
library(rgeos)

#set directory for data output
outDir <- "/Users/hkropp/Google Drive/GIS/NYnoaa"

Sys.setenv(RNOAA_GHCND_BASE_URL =
"ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all")
#stations to work with
station <- read.csv("/Users/hkropp/Google Drive/GIS/NYnoaa/station_info.csv")

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


write.table(stations, paste0(outDir,"\\station_info.csv"),sep=",")

##########download##################
datW <- test <- ghcnd_search("USC00305676", var=c("TMAX", "TMIN","TAVG","PRCP"))
                     
                     
                     
for(i in 1:195){
	
	datW <- ghcnd_search(paste(stations$station_id[i]), var=c("TMAX", "TMIN","TAVG","PRCP"))
	
		for(j in 1:length(datW)){
			
			write.table(datW[[j]], paste0(outDir,"\\stations\\",stations$station_id[i],"_",colnames(datW[[j]][2]),".csv"),
			sep=",", row.names = FALSE)
		}
	print(paste("done station",stations$station_id[i], "number ",i)	)
}
#missing all variables of intest
datW <- ghcnd_search(paste(stations$station_id[196]), var=c("TMAX", "TMIN","TAVG","PRCP"))

for(i in 197:1043){
	
	datW <- ghcnd_search(paste(stations$station_id[i]), var=c("TMAX", "TMIN","TAVG","PRCP"))
	
		for(j in 1:length(datW)){
			
			write.table(datW[[j]], paste0(outDir,"\\stations\\",stations$station_id[i],"_",colnames(datW[[j]][2]),".csv"),
			sep=",")
		}
	print(paste("done station",stations$station_id[i], "number ",i)	)
}

#missing all variables of intest
datW <- ghcnd_search(paste(stations$station_id[1044]), var=c("TMAX", "TMIN","TAVG","PRCP"))

for(i in 1045:nrow(stations)){
	
	datW <- ghcnd_search(paste(stations$station_id[i]), var=c("TMAX", "TMIN","TAVG","PRCP"))
	
		for(j in 1:length(datW)){
			
			write.table(datW[[j]], paste0(outDir,"\\stations\\",stations$station_id[i],"_",colnames(datW[[j]][2]),".csv"),
			sep=",")
		}
	print(paste("done station",stations$station_id[i], "number ",i)	)
}