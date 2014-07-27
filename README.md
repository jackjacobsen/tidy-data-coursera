tidy-data-coursera
==================
This script (run analysis.R) merges two data sets, which are then cleaned up, averaged and outputted to a new file (tidy.txt).

The script can be laid out in these main steps:


1. Open and merge the two sets
Open the two datasets to different dataframes, keeping the same variable names in the same order. The two sets are then merged (using rbind) to one large dataset with 10K+ cases.

2. Tidying and extracting variables
Variable names of measurements are added from the supplied file (features.txt). Activity and subject are also added as factor variables. Finally, the variables containing 'mean', 'Mean', 'Std' or 'std' in their name are extracted to a new data frame (extractedData).

3. Averaging data
The average of each variable - for each subject and each activity - is computed and added to a new data frame (tidy) using cbind in combination with tapply. Variable names are assigned from the first, larger dataset as they are the same. This leaves a dataset with 180 cases and 88 variables.

4. Outputting file
A text file containing the tidy dataset is saved in the workspace folder (./tidy.txt).

To open the tidy datafile in the original format enter these two commands (in R):
tidy <- read.table("./tidy.txt")
tidy$Subject <- factor(tidy$Subject)

(In hindsight I can see that the tidy$Subject variable should have been a character)
