##
# Prepare a tidy dataset that can be used for later analysis.
# Coursera - Getting and Cleaning Data - Project
# September 2015
#
# The source of this data is UC Irving's Machine Learning Archive:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Original Raw Data Files can be obtained here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Constants
BASE_DIR = "raw_data/"
SOURCES = c("test", "train")
PATTERN = c("mean()", "std()")

# Cache data
data_m <- NULL
activity_l <- NULL
feature_l <- NULL

## Merge the training and the test sets to create one data set
mergeData <- function() {
    for (obs in SOURCES) {
        obs_dir <- paste0(BASE_DIR, obs, "/")
        # read obs/subject_obs.txt for subject_id
        data_o <- extractSubjects(obs_dir, obs)
        
        # read obs/X_obs.txt for features; extract: means, stds
        data_o <-
            data.frame(data_o, extractFeatures(obs_dir, obs, PATTERN))
        
        # read obs/y_obs.txt for activity enum
        data_o <-
            data.frame(data_o, extractActivities(obs_dir, obs))
        
        # merge data frames
        data_m <<- rbind(data_m, data_o)
    }
}

## Extract the subject identifiers
extractSubjects <- function(obs_dir, obs) {
    fileloc <- paste0(obs_dir, "subject_", obs, ".txt")
    s_dat <- read.table(fileloc)
    colnames(s_dat) <- c("subject_id")
    s_dat
}

## Extract only the measurements for a given feature pattern
extractFeatures <- function(obs_dir, obs, features = PATTERN) {
    fileloc <- paste0(obs_dir, "X_", obs, ".txt")
    f_dat <- read.table(fileloc,
                        colClasses = featureLookup(features)$feature_class)
    colnames(f_dat) <- getFeatureColumnNames(features)
    f_dat
}

## Extract the activity data
extractActivities <- function(obs_dir, obs) {
    fileloc <- paste0(obs_dir, "y_", obs, ".txt")
    a_dat <- read.table(fileloc)
    colnames(a_dat) <- c("activity_id")
    
    # Apply descriptive activity names
    merge(a_dat, activityLookup(), by = "activity_id")
}

## Return a lookup table of features for the given filters
featureLookup <- function(features = PATTERN) {
    if (!is.data.frame(feature_l)) {
        fileloc = paste0(BASE_DIR, "features.txt")
        lookup <- read.table(fileloc)
        lookup <-
            data.frame(lookup, c("NULL"), stringsAsFactors = FALSE)
        colnames(lookup) <-
            c("feature_id", "feature_desc", "feature_class")
        
        # grep for filter patterns and combine into sorted index
        feature_id <-
            sort(c(sapply(features, function(x)
                grep(x, lookup[,2], fixed = TRUE))))
        
        lookup[,3][feature_id] <- "numeric"
        
        feature_l <<- lookup
    }
    feature_l
}

## Use descriptive activity names to name the activities in the data set
activityLookup <- function() {
    if (!is.data.frame(activity_l)) {
        fileloc = paste0(BASE_DIR, "activity_labels.txt")
        lookup <- read.table(fileloc)
        colnames(lookup) <- c("activity_id", "activity_desc")
        
        activity_l <<- lookup
    }
    activity_l
}

## Appropriately label the data set with descriptive variable names
getFeatureColumnNames <- function(features = PATTERN) {
    gsub("..", "",
         make.names(featureLookup(features)$feature_desc[
             featureLookup(features)$feature_class == "numeric"]),
        fixed = TRUE)
}

## Create an independent tidy data set with
# average of each variable, for each activity and each subject
createTidyDataSet <- function() {
    library(sqldf)
    
    if (!is.data.frame(data_m)) {
        mergeData()
    }
    
    query <- paste0(
        "SELECT subject_id, activity_desc",
        paste0(", avg(`", getFeatureColumnNames(PATTERN), "`) AS 'avg_",
               getFeatureColumnNames(PATTERN), "'", collapse = ""),
        " FROM data_m GROUP BY subject_id, activity_desc"
    )
    
    tidy_d <- sqldf(query)
    write.table(tidy_d, "tidy_dataset.txt", row.names = FALSE)
}