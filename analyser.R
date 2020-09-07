#Import libraries
library(dplyr) #for future manipulations
library(lubridate) #date and time manipulations

#get data from disk
TvData <- read.csv('TVData.csv', stringsAsFactors=FALSE)

#pick Moscow, further 
MoscowTvData <- TvData %>%
     filter(progLocation == 'Москва')

#remove all visual data (scans from magazines etc.), analyze them later
#these have no image link, so page link and image link are equal
CleanedMoscowTvData <- MoscowTvData %>%
     filter(progPageShortLink == progImgShortLink)
#this selection is what I will work with

#find out how much data for each year in Moscow, plot it
YearsForWhole <- TvData %>% group_by(year) %>% tally()
YearsForMoscow <- MoscowTvData %>% group_by(year)  %>% tally()
YearsForCleanedMoscow <- CleanedMoscowTvData %>% group_by(year)  %>% tally()

#we can see that 8 years have only scanned data, look which are
Difference <- setdiff(YearsForMoscow$year, YearsForCleanedMoscow$year)

#how many records are there
DifferenceLen <- length(MoscowTvData$year[MoscowTvData$year %in% Difference])
#surely we can ignore 62 rows from 27782, but there are a lack of data with many other years
#so OCR is necessary