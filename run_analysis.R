#####################################################################
## Step 1: Merge the test and train sets to make one big dataset ####
#####################################################################

#reads the inertial signals train/test files (along with their labels), then row binds them
train_df <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_labels <- read.table('./UCI HAR Dataset/train/Y_train.txt')
train_subjects <- read.table('./UCI HAR Dataset/train/subject_train.txt')
train_df_labelled <- cbind(train_subjects,train_labels,train_df)

test_df <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_labels <- read.table('./UCI HAR Dataset/test/Y_test.txt')
test_subjects <- read.table('./UCI HAR Dataset/test/subject_test.txt')
test_df_labelled <- cbind(test_subjects,test_labels,test_df)

combined_df <- rbind(train_df_labelled,test_df_labelled)


#reads the variable names
features <- read.table('./UCI HAR Dataset/features.txt')
features_vector <- as.character(features$V2)
#add in the fact that the first column is 'ActivityNumber'
features_vector <- c('Subject','ActivityNumber',features_vector)

#renames the variables in combined_df to be as described in features_vector
names(combined_df) <- features_vector


#####################################################################
## Step 2: Only keep the variables which measure mean/stdev      ####
#####################################################################

#search for variable names containing 'mean' or 'std' and 'meanFreq'
contains_mean_logical <- grepl("mean",features_vector)
contains_std_logical <- grepl("std",features_vector)
contains_meanfreq_logical <- grepl("meanFreq",features_vector)
activity_number <- grepl("ActivityNumber",features_vector)
subjects <- grepl("Subject",features_vector)


#keep only the variable names for which contains_mean_logical or contains_std_logical are true
#and contains_meanfreq_logical is false, also keeps 'ActivityNumber' and 'Subject'
mean_std_data <- combined_df[,(contains_mean_logical|contains_std_logical) & !contains_meanfreq_logical | activity_number | subjects]

#convert mean_std_data into a dplyr 'tibble'
library(dplyr)
mean_std <- as_tibble(mean_std_data)

#####################################################################
## Step 3: Use descriptive activity labels to name activities in df #
#####################################################################

#read activity labels
activities <- read.table('./UCI HAR Dataset/activity_labels.txt')

#change numbers in the data to a factor variable containing the activity names
# 1->WALKING, 2->WALKING_UPSTAIRS etc.
encoding <- activities$V2
names(encoding) <- activities$V1
# add encoded column, remove previous ActivityNumber column
mean_std <- mutate(mean_std,ActivityLabel = recode(mean_std$ActivityNumber, !!!encoding))
mean_std <- select(mean_std,!ActivityNumber)


#####################################################################
## Step 4: Label dataset with appropriate descriptive names     #####
#####################################################################

#Remove the dashes to make the titles cleaner
names(mean_std) <- gsub("-","",names(mean_std))
#Remove the brackets
names(mean_std) <- gsub("\\(\\)","",names(mean_std))
#Remove std and replace with StDev, remove mean and replace with Mean
names(mean_std) <- gsub("std","StDev",names(mean_std))
names(mean_std) <- gsub("mean","Mean",names(mean_std))
#Replace 't' with Time and 'f' with Fourier
names(mean_std) <- gsub("^t","Time",names(mean_std))
names(mean_std) <- gsub("^f","Fourier",names(mean_std))


##################################################################################
## Step 5: Tidy dataset with a mean for each variable for each activity type #####
##         and each subject                                                  #####
##################################################################################

#get a vector of all column names minus 'Subject' and 'ActivityLabel'
all_cols <- names(mean_std)[names(mean_std) != 'Subject' & names(mean_std) != 'ActivityLabel']


#group_by 'Subject' and 'ActivityLabel'
#then summarize by taking the mean for each variable
mean_std_tidy <- group_by(mean_std,Subject,ActivityLabel) %>%
  summarize_at(all_cols,mean) %>%
  print
