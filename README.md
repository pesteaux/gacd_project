gacd_project
============

Coursera Getting and Cleaning Data Project

The run_analysis.R script is located in project/.
The script needs to be run directly from the UCI HAR Dataset directory. Unzip the following file and download
  the script into the resulting directory: 
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Comments are provided in the script which explain each of the steps, in summary:
  The script opens all of the required files and concatenates them into a data frame. It starts by reading in the 
  activity labels and features.txt. The first file will replace the numbers in the y_train.txt file. Features is a list
  of observation parameters that will eventually become column names. Each of these files is stored in a data frame.
  
  The script then moves into the train directory and reads the list of subjects, the X_train and y_train files into
  individual data frames. The X_train are the observations for each of the parameters in features.txt. The y_train file
  is the number-coded activities list. The script somewhat non-programatically replaces the numbers with the names
  provided in activity_labels.txt. These data frames are then combined into a complete training set data frame.
  
  The same process is then repeated for the test data. The final test and train data frames are then combined to form
  a final dataset. The final data set represents tidy data in that each row is a single observation and each measured
  variable is in its own row. The result is a single table in 3nf appropriate for immediate db import (a seq() index
  may be desirable).
  
  The script then strips the final dataset of non-numeric values, finds the averages columnwise and rowwise, and
  appends the results back into the original data frame.
  
