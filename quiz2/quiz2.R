URLBASE = "https://d396qusza40orc.cloudfront.net/getdata%2F"

dlf.ifne <- function(host, uri, destfile) {
    if (!file.exists(destfile)) {
        url <- paste0(host, uri)
        download.file(url = url, destfile = destfile)
    }
}

question1 <- function() {
    library(httr)
    
    myapp <- oauth_app("github",
                       key = "c67aa8d1766437320208",
                       secret = "7e3fefb71bb85152c4c2a7a83650550c798f6f8f")
    github_token <-
        oauth2.0_token(oauth_endpoints("github"), myapp, cache = FALSE)
    cfg <- config(token = github_token)
    req <-
        with_config(cfg, GET("https://api.github.com/users/jtleek/repos"))
    stop_for_status(req)
    j <- fromJSON(content(req, as = "text"))
    j[j$name == "datasharing", "created_at"]
}

question2 <- function() {
    library(sqldf)
    dlf.ifne(URLBASE, "data%2Fss06pid.csv", "acs.csv")
    acs <- read.csv("acs.csv")
    str(sqldf("SELECT pwgtp1 FROM acs WHERE AGEP < 50"))
}

question3 <- function() {
    library(sqldf)
    dlf.ifne(URLBASE, "ss06pid.csv", "acs.csv")
    acs <- read.csv("acs.csv")
    r1 <- unique(acs$AGEP)
    r2 <- sqldf("SELECT DISTINCT AGEP FROM acs")
    
    all.equal.numeric(r1, unlist(r2, use.names = FALSE))
}

question4 <- function() {
    library(httr)
    h <-
        content(GET("http://biostat.jhsph.edu/~jleek/contact.html"), as = "text")
    l <- strsplit(h[[1]], "\n")[[1]]
    sapply(c(10, 20, 30, 100), function(x) {
        nchar(l[x])
    })
}

question5 <- function() {
    dlf.ifne(URLBASE, "wksst8110.for", "question5.for")
    dat <-
        read.fwf("question5.for", widths = c(10, 9, 4, 9, 4, 9, 4, 9, 4), skip = 4)
    sum(dat$V4)
}