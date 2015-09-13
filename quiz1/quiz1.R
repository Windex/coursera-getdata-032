URLBASE = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2F"

dlf.ifne <- function(host, uri, destfile) {
    if (!file.exists(destfile)) {
        url <- paste0(host, uri)
        download.file(url = url, destfile = destfile)
    }
}

question1 <- function() {
    dlf.ifne(URLBASE, "ss06hid.csv", "question1.csv")
    dat <- read.csv("question1.csv")
    sum(dat$VAL == 24, na.rm = TRUE)
}

question3 <- function() {
    library(xlsx)
    dlf.ifne(URLBASE, "DATA.gov_NGAP.xlsx", "question3.xlsx")
    dat <- read.xlsx(
        "question3.xlsx", sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15
    )
    sum(dat$Zip * dat$Ext, na.rm = TRUE)
}

question4 <- function() {
    library(XML)
    dlf.ifne(URLBASE, "restaurants.xml", "question4.xml")
    dat <-
        xmlRoot(xmlTreeParse("question4.xml", useInternalNodes = TRUE))
    zipcodes <- xpathSApply(dat, "//zipcode", xmlValue)
    sum(zipcodes == "21231", na.rm = TRUE)
}

question5 <- function() {
    library(data.table)
    dlf.ifne(URLBASE, "ss06pid.csv", "question5.csv")
    DT <- fread("question5.csv")
    DT[, mean(pwgtp15), by = SEX]
}