# Readme
This repository contains the project assignment for the Coursera course "Getting and Cleaning Data".

In detail it contains:
- Analysis script: written in R, "run_analysis.r" which when run looks for the UCI HAR Dataset in a folder called "UCI HAR Dataset" in the current directory. 
- Computed means of all variables relevant in the assignment for all combinations of subjects and activities in csv format: means.csv. To read this file back into R, use read.csv("means.csv").

## Using the script
To run the analysis script, simply source the script in the directory containing the UCI HAR Dataset.
Cue UCI HAR Dataset can be obtained from this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Output
When the analysis script is run, it outputs a txt/csv file containing the means of all means and standard deviation values in the original data set. The file is saved as means.csv.
