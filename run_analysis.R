# Load the tidyverse
library(tidyverse)

# Define function to tidy arbitrary folder of UCI HAR Dataset

make_df_by_folder <- function(folder_str){
    # create a prefix with the right folder
    prefix_path <- paste0("UCI HAR Dataset/",folder_str,"/")

    # load in all necessary data to data.tables
    bulk_data <- data.table::fread(paste0(prefix_path,"X_",folder_str,".txt"))
    data.table::setDT(bulk_data)
    bulk_data_names <- read.table("UCI HAR Dataset/features.txt")
    activity_data <- read.table(paste0(prefix_path,"y_",folder_str,".txt"))
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
    subject_data <- read.table(paste0(prefix_path,"subject_",folder_str,".txt"))

    # rename bulk data
    colnames(bulk_data) <- as.character(bulk_data_names$V2)

    # rename activity data
    colnames(activity_data) <- c("activity_code")

    # rename activity labels
    colnames(activity_labels) <- c("activity_code", "activity_label")

    # redefine activity data
    activity_data <- left_join(activity_data,activity_labels)

    # rename subject_data
    colnames(subject_data) <- c("subject")

    # add index columns
    bulk_data[, index := seq_len(.N)]
    activity_data["index"] <- 1:nrow(activity_data)
    subject_data["index"] <- 1:nrow(subject_data)

    # join and return by index
    return(left_join(
        left_join(subject_data,activity_data, by="index"),
        data.frame(bulk_data), by="index") %>%
            select(-index)
        )
}


# Create train and test data frames
train_df <- make_df_by_folder("train")
test_df <- make_df_by_folder("test")

# Step 1. Merges the training and the test sets to create one data set.
df <- rbind(train_df, test_df) %>%
        # Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
        select(all_of(c("subject","activity_label",grep("mean|std", names(.), value=TRUE)))) %>%
        # Step 3. Uses descriptive activity names to name the activities in the data set
        # the labels were added in make_df_by_folder folder here we just rename that column
        rename(activity="activity_label")



# Step 4. Appropriately labels the data set with descriptive variable names.

# Store column names
col_names <- colnames(df)
# Remove dots
col_names <- gsub("\\.", "_", col_names)
# Remove multi _
col_names <- gsub("__", "_", col_names)
col_names <- gsub("__", "_", col_names)
# Remove ending _
col_names <- gsub("_$", "", col_names)
# Fix camel case
col_names <- gsub("([a-z])([A-Z])", "\\1_\\2", col_names)
# Fix std
col_names <- gsub("_std", "_stdev", col_names)
# Fix t
col_names <- gsub("^t", "time", col_names)
# Fix f
col_names <- gsub("^f", "freq", col_names)
# lowercase cols
col_names <- tolower(col_names)

# Set column names
colnames(df) <- col_names



# Step 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

idep_tidy <- df %>%
    group_by(subject, activity) %>%
    summarise_all(mean)

# create clean data folder
dir.create("Cleaned UCI HAR Dataset")
# write results to folder
write.table(df, "Cleaned UCI HAR Dataset/full_clean_uci_har_data.txt", row.name=FALSE)
write.table(idep_tidy, "Cleaned UCI HAR Dataset/idependent_tidy_subject_activities_means.txt", row.name=FALSE)






