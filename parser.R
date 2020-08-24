#Import libraries
library(XML)
library(RCurl)

#Get tv program of russian TV for some years and analyze it.

webpage <- getURL("http://tvp.netcollect.ru/")
#webpage <- readLines(tc <- textConnection(webpage)); close(tc)
pagetree <- htmlTreeParse(webpage, error=function(...){}, useInternalNodes = TRUE)
root <- xmlRoot(pagetree)

query <- '*//ul[@class="indexblock list_years"]/li/a/@href'

#smth goes wrong with xpath, returns empty list