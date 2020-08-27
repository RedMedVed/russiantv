#Import libraries
library(dplyr) #for future manipulations
library(lubridate) #date and time manipulations

#get raw from disk
rawData <- read.csv('rawData.csv', stringsAsFactors=FALSE)

#modify the cells with doubled date
rawData$yearDate <- sapply(strsplit(rawData$yearDate," - "), `[`, 1)
rawData$yearDate <- sapply(strsplit(rawData$yearDate,", "), `[`, 1)

#create seperate columns for year, month, day and weekday
#current format is DD-MM-YYYY
rawData$yearDate <- dmy(rawData$yearDate)
#after this we have 12 dates as NA. Originally there were these values:
#[1] "00-00-1991" "00-00-1996" "00-00-2002" "31-09-2002" "31-06-2003" "00-00-2012" "00-00-2012" "00-00-2013"
#[9] "00-00-2013" "00-00-2020" "00-00-2020" "00-00-2020"
#we will not make any investigation about these bugs, just remove them.
rawData <- rawData[complete.cases(rawData), ]
rawData <- mutate(rawData, year = format.Date(yearDate, '%Y')) %>%
     mutate(month = format.Date(yearDate, '%m')) %>%
     mutate(day = format.Date(yearDate, '%d')) %>%
     mutate(weekday = weekdays(yearDate))

#change links to full, delete quote symbols
#site contains several types of links, so this part has to be done by hands
#or not?

#progPageShortLink
rawData$progPageShortLink <- gsub(' href="', 'http://tvp.netcollect.ru/', rawData$progPageShortLink)
rawData$progPageShortLink <- gsub('"$', '', rawData$progPageShortLink)

#progImgShortLink
rawData$progImgShortLink <- gsub(' href=\"prog', 'http://tvp.netcollect.ru/prog', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href="////tvp.netcollect', 'http://tvp.netcollect', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"https://lubernet', 'https://lubernet', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"/tvps', 'http://tvp.netcollect.ru/tvps', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href="https://img-fotki', 'https://img-fotki', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href="http://img-fotki', 'https://img-fotki', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"https://image.isu.pub', 'https://image.isu.pub', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"https://murmanlib.ru', 'https://murmanlib.ru', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"https://www.megionlib.ru', 'https://www.megionlib.ru', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"https://content-', 'https://content-', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"https://ki.ill.in', 'https://ki.ill.in', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"http://kreschatic', 'http://kreschatic', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href=\"////pp.userapi', 'https://pp.userapi', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href="//////pp.userapi', 'https://pp.userapi', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href="////scholar.lib', 'https://scholar.lib', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub(' href="//', 'http://', rawData$progImgShortLink)
rawData$progImgShortLink <- gsub('"$', '', rawData$progImgShortLink)

#use this if you need to discover how many bad entries left
#print(rawData$progImgShortLink[startsWith(rawData$progImgShortLink, ' href')])

#progLocation
rawData$progLocation <- gsub('<span class="region"> ', '', rawData$progLocation)
rawData$progLocation <- gsub('</span>', '', rawData$progLocation)

#now it's tidy data
write.csv(rawData, 'TVData.csv')