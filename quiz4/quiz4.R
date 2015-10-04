URLBASE = "https://d396qusza40orc.cloudfront.net/getdata%2F"

dlf.ifne <- function(host, uri, destfile) {
    if (!file.exists(destfile)) {
        url <- paste0(host, uri)
        download.file(url = url, destfile = destfile)
    }
}

getGDPData <- function() {
    dlf.ifne(URLBASE, "data%2FGDP.csv", "gdp.csv")
    gdp <-
        read.csv(
            "gdp.csv", header = FALSE, skip = 5, nrows = 190,
            colClasses = c(
                "character", "integer", "NULL", "character", NA, "NULL", "NULL", "NULL", "NULL", "NULL"
            )
        )
    colnames(gdp) <-
        c("CountryCode", "GDPRank", "CountryLong", "MillionsUSD")
    gdp
}

getMergedData <- function() {
    gdp <- getGDPData()
    dlf.ifne(URLBASE, "data%2FEDSTATS_Country.csv", "fed.csv")
    fed <- read.csv("fed.csv")
    
    mdat <-
        merge(gdp, fed[,c("CountryCode","Special.Notes")], by = "CountryCode")
}

question1 <- function() {
    dlf.ifne(URLBASE, "data%2Fss06hid.csv", "question1.csv")
    dat <- read.csv("question1.csv")
    strsplit(names(dat), "wgtp")[[123]]
}

question2 <- function() {
    gdp <- getGDPData()
    mean(as.numeric(gsub(",", "", gdp$MillionsUSD)))
}

question3 <- function() {
    mdat <- getMergedData()
    countryNames <- enc2utf8(mdat$CountryLong)
    countryNames[grep("^United", countryNames)]
}

question4 <- function() {
    mdat <- getMergedData()
    sn <- mdat$Special.Notes
    fye <-
        sapply(strsplit(as.character(sn[grep("^Fiscal", sn)]), ";"), "[", 1)
    length(grep("June", sapply(strsplit(fye, ": "), "[", 2)))
}

question5 <- function() {
    library(lubridate)
    library(quantmod)
    amzn <- getSymbols("AMZN", auto.assign = FALSE)
    sampleTimes <- ymd(index(amzn))
    sT <- sampleTimes[year(sampleTimes) == 2012]
    print(c(length(sT), sum(weekdays(sT) == "Monday")))
}