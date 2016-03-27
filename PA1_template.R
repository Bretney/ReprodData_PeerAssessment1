## setting the directory
setwd("~/repdata-data-activity")
data <- read.csv("activity.csv")
str(data)

attach(data)
totalPerDay <- tapply(steps,list(date),sum)
detach(data)

## setting the environment
library(knitr) 
library(gridExtra) 
library(ggplot2) 
library(plyr) 
library(dplyr)
opts_chunk$set(echo = TRUE)

## Finding TotalPerDay and the Median/Mean Per Day
hist(totalPerDay,breaks=10)
meanPerDay = mean(totalPerDay,na.rm = TRUE)
meanPerDay

medianPerDay <- median(totalPerDay,na.rm = TRUE)
medianPerDay
-----------------------------------
attach(data)
meanEvery5min <- tapply(steps,list(interval),mean,na.rm=TRUE)
detach(data)

plot(meanEvery5min,type="l")
which.max(meanEvery5min)

meanEvery5min[104]

max(meanEvery5min)

--------------------------------------------
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

head(data)

attach(data)

totalPerDay2 <- tapply(imputedSteps,list(date),sum)
detach(data)
hist(totalPerDay2,breaks=10)
mean(totalPerDay2)

median(totalPerDay2)


date <- levels(data$date)
daytype <- weekdays(as.Date(date))

daytype <- as.factor(daytype)
isweekday <- rep(daytype,each=length(meanEvery5min))

data <- cbind(data,isweekday)
str(data)

head(data)

attach(data)

daytypeDiff <- aggregate(imputedSteps, list(interval,isweekday), mean)
detach(data)
library(lattice)

-------------------------------------------------
  
xyplot(x ~ Group.1|Group.2,data=daytypeDiff,type="l",layout=c(1,2),xlab="Interval",ylab="Number of Steps")

ggplot(data_weekdays, aes(x=interval, y=steps)) + 
     geom_line(color="purple") + 
      facet_wrap(~ dayofweek, nrow=2, ncol=1) +
     labs(x="Interval", y="Number of steps") +
       theme_bw()
