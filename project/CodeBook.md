# Code Book

### Variable Descriptions

    subject_id
> Subject identifier who performed the test

    activity_desc
> Activity subject was performing while data was being collected

> Activity descriptions were determined by merging the data from the [activity labels](https://github.com/Windex/coursera/blob/master/getdata-032/project/raw_data/activity_labels.txt)

    avg_(t|f)(BodyAcc|GravityAcc|BodyGyro)(|Jerk|Mag).(mean|std)(|.X|.Y|.Z)
> 66 fields representing the average value of each "feature" variable for each activity and each subject

- `(t|f)` - time domain or fast fourier transform
- `(BodyAcc|GravityAcc|BodyGyro)` - acceleration signal separated into body or gravity or gyroscope signal
- `(|Jerk|Mag)` - derived jerk or magnitude signals
- `(mean|std)` - estimated variable mean() or std() from signals
- `(|.X|.Y|.Z)` - triaxial raw signal in the X, Y or Z direction
- For more details see [feature info](https://github.com/Windex/coursera/blob/master/getdata-032/project/raw_data/features_info.txt)

> The average was calculated using the SQL `avg()` function via the `sqlfd` library

> The subset of feature variables was determined by filtering (grepping) on "mean()" and "std()" values from the [superset of feature variables](https://github.com/Windex/coursera/blob/master/getdata-032/project/raw_data/features.txt)
