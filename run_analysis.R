
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"

download.file(url, zip_file)

unzip(zip_file)

library(dplyr)

train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")


merged_data <- bind_rows(train_data, test_data)
merged_labels <- bind_rows(train_labels, test_labels)
merged_subjects <- bind_rows(train_subjects, test_subjects)


features <- read.table("./UCI HAR Dataset/features.txt")


mean_std_features <- grep("mean|std", features$V2, ignore.case = TRUE)


merged_data <- merged_data[, mean_std_features]


names(merged_data) <- features$V2[mean_std_features]


activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


merged_labels$V1 <- factor(merged_labels$V1, levels = activity_labels$V1, labels = activity_labels$V2)


final_data <- cbind(Subject = merged_subjects$V1, Activity = merged_labels$V1, merged_data)



tidy_data <- final_data %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean = ~mean(.)))


write.table(tidy_data, "tidy_data.txt", row.name = FALSE)
