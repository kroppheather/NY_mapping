######################################################
###### Script for organizing NY weather data    ######
###### from NOAA                                ######
######################################################
install.packages("rnoaa")
library(rnoaa)

Sys.setenv(RNOAA_GHCND_BASE_URL =
"ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all")
test <- ghcnd("USC00300023")

