URLBASE = "https://d396qusza40orc.cloudfront.net/getdata%2F"

dlf.ifne <- function(host, uri, destfile) {
    if (!file.exists(destfile)) {
        url <- paste0(host, uri)
        download.file(url = url, destfile = destfile)
    }
}

getMergedData <- function() {
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
    dlf.ifne(URLBASE, "data%2FEDSTATS_Country.csv", "fed.csv")
    fed <- read.csv("fed.csv")
    
    mdat <-
        merge(gdp, fed[,c("CountryCode","Income.Group")], by = "CountryCode")
}

question1 <- function() {
    dlf.ifne(URLBASE, "data%2Fss06hid.csv", "question1.csv")
    dat <- read.csv("question1.csv")
    agricultureLogical <- dat$ACR == 3 & dat$AGS == 6
    rownames(head(dat[which(agricultureLogical),], n = 3))
}

question2 <- function() {
    library(jpeg)
    dlf.ifne(URLBASE, "jeff.jpg", "question2.jpeg")
    dat <- readJPEG("question2.jpeg", native = TRUE)
    quantile(dat, c(0.3, 0.8))
}

question3 <- function() {
    mdat <- getMergedData()
    mdat <- mdat[with(mdat, order(-GDPRank)),]
    
    print(c(nrow(mdat), mdat[13,"CountryLong"]))
}

question4 <- function() {
    mdat <- getMergedData()
    aggregate(GDPRank ~ Income.Group, mdat, mean)
}

question5 <- function() {
    library(Hmisc)
    mdat <- getMergedData()
    mdat$GDPGroup <- cut2(mdat$GDPRank, g = 5)
    table(mdat$Income.Group, mdat$GDPGroup)
}