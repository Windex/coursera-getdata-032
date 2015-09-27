# Getting and Cleaning Data
## Course Project - September 2015

### Purpose

The purpose of this project is to collect, work with and clean a data set.  The output is a [tidy data set](https://github.com/Windex/coursera/blob/master/getdata-032/project/tidy_dataset.txt) that can be used for future analysis.

The source of this data is [UC Irving's Machine Learning Archive](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Original Raw Data Files can be obtained [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Usage Description

To produce the tidy data set, run `createTidyDataSet()` in `run_analysis.R`

The tiny data set is produced by merging subject, means and standard deviaiton of feature data and activity data for both training and test data.

### Code Book

See [CodeBook.md](https://github.com/Windex/coursera/blob/master/getdata-032/project/CodeBook.md) for details
