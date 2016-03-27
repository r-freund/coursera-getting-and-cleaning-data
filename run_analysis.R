######
# 
# This script reads the UCI HAR Dataset, cleans it, and outputs some 
# measurements.
# See the readme file and codebook for more information.
# 
# The only precondition for this script is that the dataset is in a 
# subdirectory called "UCI HAR Dataset".
# 
######

library(data.table)
library(reshape2)

feature.names <-  fread(file.path("UCI HAR Dataset", "features.txt"), col.names = c("id", "variable.name"))

# read test and train data and combine
test <- ReadMeasurements("test")
train <- ReadMeasurements("train")
data <- rbindlist(list(test, train), use.names = TRUE)
data <- RearrangeAndFactor(data)

# create second tidy data set with means and write to disk
data.means  <- dcast(data, subject.id + activity ~ variable, mean)
write.table(data.means, "means.csv", row.name = FALSE, sep = ",")


# Function ReadMeasurements
# Reads the measurements for either test or training data.
# Argument type : one of "test", "train"
# Returned: data.table with the measurements
ReadMeasurements <- function(type) {
    
    if(type != "test" & type != "train") {
        stop("Bad argument: type")
    }
    
    path.testdata <- file.path("UCI HAR Dataset", type)
    
    path.subjects <- file.path(path.testdata, paste("subject_", type, ".txt", sep = ""))
    subjects <-  fread(path.subjects, col.names = c("subject.id"))
    
    path.activities <- file.path(path.testdata, paste("y_", type, ".txt", sep = ""))
    activities <-  fread(path.activities, col.names = c("activity"))
    
    path.features <- file.path(path.testdata, paste("X_", type, ".txt", sep = ""))
    features <- fread(path.features, col.names = feature.names[, variable.name])
    feature.variables <- grep(".+std|mean\\(.+", feature.names[, variable.name], value = TRUE)
    features.reduced  <- features[, feature.variables, with = FALSE]
    
    data.combined <- cbind(subjects, activities, features.reduced)
    data.combined <- melt(data.combined, id = c("subject.id", "activity"))

    return(data.combined)
}

# Function ReadMeasurements
# Rearrange some columns, factor some columns
# Arguments: data: the data frame to be rearranged and factored
# Return: rearranged and factored data
RearrangeAndFactor <- function(data) {
    
    # read activity labels - for factors
    path.activity.labels <- file.path("UCI HAR Dataset", "activity_labels.txt")
    activities <- fread(path.activity.labels, col.names = c("id", "label"))
    # sort activities by id column to make sure factors are applied in the right 
    # order when applying to the data
    activities <- activities[order(id)]
    # convert variable activity into factor
    data$activity <- as.factor(data$activity)
    levels(data$activity) <- activities$label
    data$variable <- as.factor(data$variable)
    
    return(data)
}
