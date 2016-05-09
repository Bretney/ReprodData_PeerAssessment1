# RFile
Bretney  
8 May 2016  
# SUMMARY
This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. 

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.


##1.  Setting the environment

```r
setwd('C:/Users/Bretney/Documents/GitHub/ReprodData_PeerAssessment1/activity')
data <- read.csv("activity.csv")
str(data)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

```r
attach(data)
totalPerDay <- tapply(steps,list(date),sum)
detach(data)
library(knitr) 
library(gridExtra) 
library(ggplot2) 
library(plyr) 
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```
## The following object is masked from 'package:gridExtra':
## 
##     combine
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
opts_chunk$set(echo = TRUE)
```

##2. Finding TotalPerDay and the Median/Mean Per Day

```r
hist(totalPerDay,breaks=10)
```

![](RmdFileTest_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
meanPerDay = mean(totalPerDay,na.rm = TRUE)
meanPerDay
```

```
## [1] 10766.19
```

```r
medianPerDay <- median(totalPerDay,na.rm = TRUE)
medianPerDay
```

```
## [1] 10765
```

```r
  attach(data)
meanEvery5min <- tapply(steps,list(interval),mean,na.rm=TRUE)
detach(data)
plot(meanEvery5min,type="l")
```

![](RmdFileTest_files/figure-html/unnamed-chunk-2-2.png)<!-- -->

```r
which.max(meanEvery5min)
```

```
## 835 
## 104
```

```r
###What is the mean and max value across all the days of the data
meanEvery5min[104]
```

```
##      835 
## 206.1698
```

```r
max(meanEvery5min)
```

```
## [1] 206.1698
```

##3. Imputting the Missing VAlues

```r
calMissing <- sum(is.na(data$steps))
calMissing
```

```
## [1] 2304
```

##4. Replacng the Missing Values

```r
na <- is.na(data$steps)
shiftmeanEvery5min <- c(meanEvery5min[288],meanEvery5min[1:287])
imputedSteps <- rep(0,length(data$steps))
 for (i in 1:length(data$steps))
 if(na[i])
     imputedSteps[i] <- shiftmeanEvery5min[i%%length(meanEvery5min)+1]
 
   imputedSteps[i] <- data$steps[i]
 
 data <- cbind(data,imputedSteps)
 str(data)
```

```
## 'data.frame':	17568 obs. of  4 variables:
##  $ steps       : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date        : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval    : int  0 5 10 15 20 25 30 35 40 45 ...
##  $ imputedSteps: num  1.717 0.3396 0.1321 0.1509 0.0755 ...
```


```r
 head(data)
```

```
##   steps       date interval imputedSteps
## 1    NA 2012-10-01        0    1.7169811
## 2    NA 2012-10-01        5    0.3396226
## 3    NA 2012-10-01       10    0.1320755
## 4    NA 2012-10-01       15    0.1509434
## 5    NA 2012-10-01       20    0.0754717
## 6    NA 2012-10-01       25    2.0943396
```

##5. Setting the Average Number of steps taken per day

```r
averages <- aggregate(x=list(steps=data$steps), by=list(interval=data$interval),
                      FUN=mean, na.rm=TRUE)
ggplot(data=averages, aes(x=interval, y=steps)) +
  geom_line() +
 xlab("5-minute interval") +
   ylab("average number of steps taken")
```

![](RmdFileTest_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

##6. Total Number of Steps Taken

```r
total.steps <- tapply(imputedSteps, imputedSteps, FUN=sum)
qplot(total.steps, binwidth=100, xlab="The Total Number Steps Each Day")
```

![](RmdFileTest_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

```r
mean(total.steps)
```

```
## [1] 339.0883
```

```r
median(total.steps)
```

```
## [1] 319.3962
```


##7. Comparism of Number of Steps taken: a Weekday vs Weekend

