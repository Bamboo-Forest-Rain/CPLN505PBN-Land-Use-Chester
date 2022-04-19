rm(list=ls())

library(tidyverse)
##################################
# READ DATA AND CLEAN UP
##################################

per_dat <- read.csv("HH Travel Survey/per_pub.csv") # read csv
dim(per_dat) # 10391 rows
head(per_dat)

trip_dat <- read.csv("HH Travel Survey/trip_pub.csv") # read csv
dim(trip_dat) # 47072 rows

hh_dat <- read.csv("HH Travel Survey/hh_pub_CSV.csv", header = TRUE)
dim(hh_dat) # 3598 rows
head(hh_dat)

#let's grab anyone who has one of three modes in their sequence: 
#bike/non-motorized
#drive alone 
#transit

head(trip_dat)
##let's be a little better about how we select mode
##you can do better than this, just a few examples:
##take a look at the TRIP_PUB text file for details about modes

#bike/non-motorized
trip_dat$bike[trip_dat$TRAN1==14 & is.na(trip_dat$TRAN2)]<-1
trip_dat$bike[trip_dat$TRAN1==14 & trip_dat$TRAN2==23]<-1
trip_dat$bike[trip_dat$TRAN1==14 & trip_dat$TRAN2==11]<-1
trip_dat$bike[trip_dat$TRAN1==14 & trip_dat$TRAN2==12]<-1

trip_dat$bike[trip_dat$TRAN1==23 & is.na(trip_dat$TRAN2)]<-1 #let's include motorcycles
trip_dat$bike[trip_dat$TRAN1==23 & trip_dat$TRAN2==14]<-1
trip_dat$bike[trip_dat$TRAN1==23 & trip_dat$TRAN2==11]<-1
trip_dat$bike[trip_dat$TRAN1==23 & trip_dat$TRAN2==12]<-1

trip_dat$bike[trip_dat$TRAN1==11 & is.na(trip_dat$TRAN2)]<-1
trip_dat$bike[trip_dat$TRAN1==11 & trip_dat$TRAN2==14]<-1
trip_dat$bike[trip_dat$TRAN1==11 & trip_dat$TRAN2==23]<-1

trip_dat$bike[trip_dat$TRAN1==12 & is.na(trip_dat$TRAN2)]<-1
trip_dat$bike[trip_dat$TRAN1==12 & trip_dat$TRAN2==14]<-1
trip_dat$bike[trip_dat$TRAN1==12 & trip_dat$TRAN2==23]<-1

summary(trip_dat$bike)

#drive alone
trip_dat$drivealone[trip_dat$TRAN1==21]<-1
summary(trip_dat$drivealone)

#assume transit is 
#47 Trolley, trolley bus
#48 Jitney
#51 Subway/elevated (Market-Frankford, Broad St., PATCO)
#52 Commuter railroad (SEPTA, NJ transit)
#41 Bus (SEPTA, NJ transit)
trip_dat$transit[(trip_dat$TRAN1==47)|(trip_dat$TRAN1==48)|(trip_dat$TRAN1==51)|(trip_dat$TRAN1==41) ]<-1
trip_dat$transit[trip_dat$TRAN2==47|trip_dat$TRAN2==48| trip_dat$TRAN2==51  |trip_dat$TRAN2==41]<-1
trip_dat$transit[trip_dat$TRAN3==47|trip_dat$TRAN3==48| trip_dat$TRAN3==51  |trip_dat$TRAN3==41]<-1
trip_dat$transit[trip_dat$TRAN4==47|trip_dat$TRAN4==48| trip_dat$TRAN4==51  |trip_dat$TRAN4==41]<-1

#Carpool
trip_dat$carpool[trip_dat$TRAN1==31|trip_dat$TRAN2==31| trip_dat$TRAN3==31  |trip_dat$TRAN4==31]<-1

head(trip_dat,20)

## if both are true, let's give it to transit, makes the most sense 
trip_dat$drivealone[trip_dat$transit==1 & trip_dat$drivealone==1]<-0
trip_dat$bike[trip_dat$transit==1 & trip_dat$bike==1]<-0
trip_dat$carpool [trip_dat$transit==1 & trip_dat$carpool==1]<-0
head(trip_dat)

#clean and convert NAs to zero
trip_dat$drivealone[which(is.na(trip_dat$drivealone))]<-0
summary(trip_dat$drivealone)
table(trip_dat$drivealone)

trip_dat$bike[which(is.na(trip_dat$bike))]<-0
summary(trip_dat$bike)
table(trip_dat$bike)

trip_dat$transit[which(is.na(trip_dat$transit))]<-0
summary(trip_dat$transit)
table(trip_dat$transit)

trip_dat$transit[which(is.na(trip_dat$carpool))]<-0

##clean out any rows where they are all zero 
trip_dat$SUMZERO<- trip_dat$transit+ trip_dat$bike+trip_dat$drivealone + trip_dat$carpool
summary(trip_dat$SUMZERO)
table(trip_dat$SUMZERO)

trip_dat <- trip_dat[-which(trip_dat$SUMZERO == 0), ] 

head(trip_dat, 10)

#now let's pick out that first work trip
CommuteTripsClean <- trip_dat[which(trip_dat$Dest_PTYE == 2), ] 
head(CommuteTripsClean)

#combine modes into a single column so that we can plot
CommuteTripsClean$Commute[CommuteTripsClean$drivealone == 1] <- 1
CommuteTripsClean$Commute[CommuteTripsClean$bike == 1] <- 2
CommuteTripsClean$Commute[CommuteTripsClean$transit == 1] <- 3

#are there NAs?
table(is.na(CommuteTripsClean$Commute))
table(CommuteTripsClean$Commute)

#plot frequency of each mode chosen
hist(CommuteTripsClean$Commute)

################################same as last time
#let's merge in on person number and SAMPN
#we have to merge together the SAMPN and the person number
#there is already a column called X that represents SAMPN + PERNO but this is how you would create it
CommuteTripsClean$SAMPN_PER <- do.call(paste, c(CommuteTripsClean[c("SAMPN", "PERNO")], sep = ""))

#the following command does the same thing
#CommuteTripsClean$SAMPN_PER <- paste(CommuteTripsClean$SAMPN, CommuteTripsClean$PERNO, sep = "")

?paste
?do.call
?subset

head(CommuteTripsClean)

##but still, some people take multiple work trips. Let's just grab the first work trip
CommuteTripsClean <- subset(CommuteTripsClean, !duplicated(SAMPN_PER))
head(CommuteTripsClean, 20)

#let's merge in on person number and SAMPN
per_hh_dat <- merge(per_dat, hh_dat,
                    by.x = "SAMPN", 
                    by.y = "SAMPN", 
                    all.x = TRUE, 
                    all.y=FALSE, 
                    sort = FALSE)

#get rid of columns we don't need
colnamCleaning<-c("VETMO", "W2TY", "W2TYO",  "W2TYP", "W2LOC", "W2IND", "W2INO", "W2OCC", "W2OCO", "W2DAY", "W2HOM", "W2HOO", "W2ST", "W2ET",  "W1WKD3", "W1WKD4", "W1WKE", "W1WKD1", "W1WKD2")
per_datClean<-per_hh_dat[ , -which(names(per_dat) %in% colnamCleaning)]
head(per_datClean)

## we have to merge together the SAMPN and the person number 
per_datClean$SAMPN_PER <- do.call(paste, c(per_datClean[c("SAMPN", "PERNO")], sep = ""))
head(per_datClean)

#merge trip with person and household
CommuteTripsPerson <- merge(CommuteTripsClean, per_datClean,
                            by.x = "SAMPN_PER", 
                            by.y = "SAMPN_PER", 
                            all.x = TRUE, 
                            all.y=FALSE, 
                            sort = FALSE)
dim(CommuteTripsPerson)
head(CommuteTripsPerson)


##let's check there is no one with 2 yes: 
CommuteTripsPerson$check<-CommuteTripsPerson$transit+CommuteTripsPerson$drivealone+CommuteTripsPerson$bike
max(CommuteTripsPerson$check)

#all set

##finally, we can think about modeling 
#keep only useful variables
varsInterest <- c("SAMPN", "PERNO", "AGE", "GENDER", "INCOME", "SAMPN_PER", "TOLLA", "TOLL", "PARKC", "PARKU", "PRKUO", "TRPDUR", "drivealone", "bike", "transit", "Commute")
CommuteTripsPerson<-CommuteTripsPerson[ , which(names(CommuteTripsPerson) %in% varsInterest)]
head(CommuteTripsPerson)

#getting rid of NAs in income
CommuteTripsPerson<-CommuteTripsPerson[-which(is.na(CommuteTripsPerson$INCOME)),]
head(CommuteTripsPerson)
##how does this differ from the sample datasets we've worked with

#we don't know the alternatives price and time 
#let's just look at time. 
#let's assume the following speeds: 
##this isn't great b/c it's really non-linear
#auto: 30mph 
#biking/non-mot: 12mph 
#transit: 25mph

#let's do the calculation for each mode separately
#here I'm splitting the data set into three based on mode choice
Biking<-CommuteTripsPerson[which(CommuteTripsPerson$bike ==1),]
Drivealone<-CommuteTripsPerson[which(CommuteTripsPerson$drivealone ==1),]
Transit<-CommuteTripsPerson[which(CommuteTripsPerson$transit ==1),]

#double check and see if each data set indeed only has information for one mode
table(Biking$Commute)
table(Drivealone$Commute)
table(Transit$Commute)

#take a look at trip duration.
#it is likely in minutes
summary(Biking$TRPDUR)
summary(Drivealone$TRPDUR) #someone drove 8 hours to work! Alone!
summary(Transit$TRPDUR)

#distance = speed * time in minutes
Drivealone$distance<-(30/60)*Drivealone$TRPDUR
head(Drivealone)
Biking$distance<-(12/60)*Biking$TRPDUR
head(Biking)
Transit$distance<-(25/60)*Transit$TRPDUR

#re-combine the three data sets 
dat<-rbind(Biking, Transit, Drivealone)
head(dat)

#now we can calc a trip duration on every mode
#in other words, this is what the trip duration WOULD be if the person had chosen each mode
dat$time.auto <-dat$distance/30
dat$time.bike <- dat$distance/12
dat$time.transit <- dat$distance/25

head(dat)

#add a variable to enable us to recast the data later on
dat$mode[dat$bike == 1] <- "bike"
dat$mode[dat$transit == 1] <- "transit"
dat$mode[dat$drivealone == 1] <- "auto"
head(dat)

#the row indices are messed up because of the subsets we did
#need to fix them
rownames(dat) <- NULL 
head(dat)

varsInterest <- c("AGE", "GENDER", "INCOME", "time.auto", "time.bike", "time.transit", "mode")
dat<-dat[ , which(names(dat) %in% varsInterest)]
head(dat)

require(mlogit)

#let's try... 
head(dat)
datMNL <- mlogit.data(dat, shape="wide", choice="mode")

?mlogit.data

#check it! 
head(datMNL, 20)

#yes! 

#modeling

#let's first look at a few different model specifications
#formula specification
#(dependent variable ~ alternative specific | decision maker specific)
#intercept only
mod.int <- mlogit (mode ~ 1, data = datMNL)
summary(mod.int)

#the coefficients are associated with probability/proportion of each mode

#only alt. specific
mod <- mlogit (mode ~ time | 1, data = datMNL)
summary(mod)

#only decision maker (individual) specific
mod1 <- mlogit (mode ~ 1 | AGE + INCOME, data = datMNL)
summary(mod1)

#both alternative and individual specific
mod1 <- mlogit (mode ~ time | AGE + INCOME, data = datMNL)
summary(mod1)

#goodness of fit
#McFadden's R squared measures how the current model 
#compares with the intercept only model
#what's the McFadden's R squared for the intercept only model?
summary(mod.int)

#likelihood ratio test (chisq test)- tests decrease in unexpained variance 
#from baseline model to final model (models must be nested!!!)
#deviance = -2 * log likelihood
#remember deviance?

#think back to chisq test we did for binomial
modelChi <- (-2*(-1104.5)) - (-2*(-1007)) 
#-1007 = log likelihood for mod 
#-1104.5 = log likelihood for mod.int
#this is the chisq in output
summary(mod)

#calculating change in degree of freedom
mod$logLik
df.mod <- 3
mod.int$logLik
df.mod.int <- 2

chidf <- df.mod - df.mod.int

#if prob < 0.05, then the final model significantly improves fit
chisq.prob <- 1 - pchisq(modelChi, chidf)
chisq.prob #this is the chisq p-value in the output
summary(mod)

#Akaike Info Criterion
AIC(mod.int, mod, mod1)

#interpretation for coefficients
summary(mod1)

#what is the reference category? auto.

#time: one is significantly less likely to bike or take transit to work than 
#driving alone as travel time goes up, controlling for age and income.

#bike:age: a one year increase in age is associated with a 
#100*[(e^-3.5970e-04)-1] = 0.036% decrease in the odds of biking to work, 
#compared to driving alone, controlling for income and travel time.

#transit:income: a one dollar increase in income is associated with a 
#100*[(e^-1.7000e-05)-1] = 0.0017% decrease in the odds of taking transit to work, 
#compared to driving alone, controlling for age and travel time.

#it would make sense to divide income by 1000 before running the model
#the effect of a one dollar increase in income is too trivial

library(stargazer)
stargazer(mod.int, mod, mod1, type = "text")
