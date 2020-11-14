# CleaningDataWk4

# This repository aims to clean the UCI HAR Dataset and present it in a tidy summarised data. The code 'run_analysis.R' does this by performing the following steps

# 1. Merges the training and the test sets to create one data set.

###### this is described in phase 1 of the run_analysis script. The test and train datasets are compiled together, along with the activity and subject labels to form one large dataset

# 2. Extracts only the measurements on the mean and standard deviation for each measurement

####### the 'Code_Book.txt' file will come in handy here. It gives more details of the mean and standard deviation measurements in question
.
# 3. Uses descriptive activity names to name the activities in the data set

####### again, refer to 'Code_Book.txt' for more details of the variables.

# 4. Appropriately labels the data set with descriptive variable names.

####### again, refer to 'Code_Book.txt' for more details of the variables. The completed dataset after stage 4 is entitled 'mean_std' in the 'run_analysis.R' code


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####### this summary leads to the final 'mean_std_tidy' dataset which is the output of the R process. This is a tidy dataset.