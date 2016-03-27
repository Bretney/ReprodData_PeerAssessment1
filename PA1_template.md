Reproducible Research: Peer Assessment 1

Loading and preprocessing the data

1. Load the data (i.e. read.csv())

if(!file.exists('activity.csv')){
    unzip('activity.zip')
}
setwd("~/repdata-data-activity")
data <- read.csv("activity.csv")


2. Process/transform the data (if necessary) into a format suitable for your analysis
library(knitr) 
library(gridExtra) 
library(ggplot2) 
library(plyr) 
library(dplyr)
opts_chunk$set(echo = TRUE)


3. What is mean total number of steps taken per day?

totalPerDay <- tapply(steps,list(date),sum)
detach(data)

hist(totalPerDay,breaks=10)

4. Calculate and report the mean and median total number of steps taken per day

meanPerDay = mean(totalPerDay,na.rm = TRUE)
meanPerDay

medianPerDay <- median(totalPerDay,na.rm = TRUE)
medianPerDay


5. What is the average daily activity pattern?

plot(meanEvery5min,type="l")
which.max(meanEvery5min)
835 
104 

6. Calculate and report the total number of missing values in the dataset

calMissing <- sum(is.na(data$steps))
calMissing

na <- is.na(data$steps)
shiftmeanEvery5min <- c(meanEvery5min[288],meanEvery5min[1:287])
imputedSteps <- rep(0,length(data$steps))
for (i in 1:length(data$steps))
       if(na[i])
     imputedSteps[i] <- shiftmeanEvery5min[i%%length(meanEvery5min)+1]
       else
       imputedSteps[i] <- data$steps[i]

data <- cbind(data,imputedSteps)
str(data)

'data.frame':	17568 obs. of  5 variables:
 $ steps       : int  NA NA NA NA NA NA NA NA NA NA ...
 $ date        : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ interval    : int  0 5 10 15 20 25 30 35 40 45 ...
 $ imputedSteps: num  1.717 0.3396 0.1321 0.1509 0.0755 ...
 $ isweekday   : Factor w/ 1 level "weekend": 1 1 1 1 1 1 1 1 1 1 ...
 
 head(data)
  steps       date interval imputedSteps isweekday
1    NA 2012-10-01        0    1.7169811   weekend
2    NA 2012-10-01        5    0.3396226   weekend
3    NA 2012-10-01       10    0.1320755   weekend
4    NA 2012-10-01       15    0.1509434   weekend
5    NA 2012-10-01       20    0.0754717   weekend
6    NA 2012-10-01       25    2.0943396   weekend

7.  Are there differences in activity patterns between weekdays and weekends?

daytypeDiff <- aggregate(imputedSteps, list(interval,isweekday), mean)
detach(data)
library(lattice)


xyplot(x ~ Group.1|Group.2,data=daytypeDiff,type="l",layout=c(1,2),xlab="Interval",ylab="Number of Steps")

ggplot(data_weekdays, aes(x=interval, y=steps)) + 
     geom_line(color="purple") + 
      facet_wrap(~ dayofweek, nrow=2, ncol=1) +
     labs(x="Interval", y="Number of steps") +
       theme_bw()
