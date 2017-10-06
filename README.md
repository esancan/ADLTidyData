# ADLTidyData

This scripts generates a tidy dataset from the ["Human Activity Recognition Using Smartphones Data Set"](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). This script was developed as an assignment for the "Getting and Cleaning Data" MOOC on Coursera.

# Copy?

If you think this repo looks like this one: https://github.com/AllanHasegawa/ds_gcd2015

Then, don't worry. I'm just redoing this course :) The code is almost the same, but I improved it a bit.

## Running the script

 * Clone this repo
 * Open R and set the working directory to this repo
 * Run `source("run_analysis.R")` in R

If the script run successfully, a `tidyData.txt` will be created in your working directory containg the tidy dataset.

## Understanding the `tidyData.txt` file

The `tidyData.txt` file contains all the features of the original dataset that represents mean and standard deviation for each subject id and activity. But, features values belonging to the same unique subject id/actitivity pair are grouped together with a mean operation.


The output is a table containg 180 rows (each row is a unique subject id/activity pair), where each row holds 66 features for each subject/activity pair (66 columns for each feature + 2 columns for subject and activity).

For a detailed description of this table, see the included `CookBook.md`.


A sample of `tidyData.txt` is:

```
"subject" "activity" "tBodyAcc-mean-X" "tBodyAcc-mean-Y" (... continues for 64 more columns)
1 "LAYING" 0.22159824394 -0.0405139534294 (...)
1 "SITTING" 0.261237565425532 -0.00130828765170213 (...)
(... continues for 178 more rows)
```

## Understanding step by step how the `tidyData.txt` was generated

Please, see the accompanying `run_analysis.R` script for a step by step instruction on how this dataset was generated. The provided script contains comments and descriptive variables names to walk you through the steps taken to generate this dataset.
