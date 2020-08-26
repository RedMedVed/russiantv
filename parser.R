#Import libraries
library(xml2) #working with xpath
library(RCurl) #get data from web
library(rvest) #xml2 wrapper
library(dplyr) #for future manipulations

#Get tv program of russian TV for some years and analyze it.
homePage <- "http://tvp.netcollect.ru/"
webpage <- getURL(homePage)

#get list of links for every year on that site
shortLinks <- xml_find_all(read_html(webpage), '*//ul[@class="indexblock list_years"]/li/a/@href')
links <- paste(homePage, shortLinks)

#make links usable
links <- gsub('  href=\"/', '', links)
links <- gsub('\"', '', links)

#extract years from links
years <- gsub("[^[:digit:]]", "", links)
tvData <- data.frame(years, links, yearVar = paste('year', years, sep = ""))

#function for getting data by year
transformData <- function(yearLink) {
     yearPage <- getURL(yearLink)
     #parsing values
     yearDate <- xml_find_all(read_html(yearPage), '//div[@class = "link"]//a/text()')
     progPageShortLink <- xml_find_all(read_html(yearPage), 
                                       '//div[@class="link"]//a[@class="openprog"]/@href')
     progImgShortLink <- xml_find_all(read_html(yearPage), 
                                      '//div[@class="link"]//a[not(@class)]/@href')
     progLocation <- xml_find_all(read_html(yearPage), 
                                  '//span[@class="region"]')
     
     #transform values from xml nodes to lists
     yearDate <- paste(yearDate)
     progPageShortLink <- paste(progPageShortLink)
     progImgShortLink <- paste(progImgShortLink)
     progLocation <- paste(progLocation)
     tvYear <- data.frame(yearDate, progPageShortLink, progImgShortLink, progLocation)
}

#dataframe for collecting data
#it takes about 30 minutes, go and have some coffee
rawData <- data.frame()
for(link in tvData$links) {
     print(link) #look how fast it's going
     rawData <- rbind(rawData, transformData(link))
     }

write.csv(rawData, 'rawData.csv')

