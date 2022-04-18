---
title: "CPLN505-Assignment 3 Part 2: Mode Choice Modelling"
author: "Yihong Hu & Anna Duan"
date: "4/14/2022"
output:
  html_document:
    keep_md: yes
    toc: yes
    theme: cosmo
    toc_float: yes
    code_folding: hide
    number_sections: yes
  pdf_document:
    toc: yes
---



# Introduction    
In this report, we model the following using trip data from the Delaware Valley Regional Planning Commission:        
1. Whether a commuter drove to work      
2. Whether a commuter walked or biked to work    
3. Whether a commuter drove to work, carpooled, took public transit, or walked or biked          

```r
# Read Chester land use Data and its geometry
trips <- read.csv("/Users/annaduan/Documents/GitHub/CPLN505PBN-Land-Use-Chester/HH\ Travel\ Survey/trip_pub.csv") %>%
 # filter(ACT1 == 11 | ACT1 ==12) %>% #filter for work trips
  mutate(drove_work = ifelse(TRAN1 == 21, 1, 0),
         bike_walk_work = ifelse(TRAN1 == 11 | TRAN1 == 14, 1, 0),
         transit_work = ifelse(TRAN1 == 41 | TRAN1 == 44 | TRAN1 == 47 | TRAN1 == 51 | TRAN1 == 52 | TRAN1 == 53, 1, 0),
         carpool_work = ifelse(TRAN1 == 31, 1,0)) 
# %>%
#   dplyr::select(-DVRPC, -SPDFLAG, -OEGRES, -EGRESS, -EXIT, -OTRFS, -FARE3, -PAY3O, -PAY3, -TRFL2, -TRFS2, -FARE2, -PAY2O, -PAY2, -TRFL1, -TRFS1, -TRFR, -FARE1, -PAY1O, -PAY1, -LINE, -OACESS, -ACCESS, -SUBTR, -APDPN, -APDPH, -ADDPN, -ADDPH, -ADDP, -TOLLA, -TOLL, -PRKUO, -NNHTR, -PHHTR, -ADP, -HHVU, -OTRAN, -PLANO, -X, -ACT2, -ACT3, -ACT4, -ACT5, -ACT6, -ACT1O, -ACTO, -TRAN4, -TRAN3, -PARKO, -APDP, -X.1, -TRAN1, -TRAN2)



households <- read.csv("/Users/annaduan/Documents/GitHub/CPLN505PBN-Land-Use-Chester/HH\ Travel\ Survey/hh_pub_CSV.csv", header = TRUE) %>%
  dplyr::select(ADVLT, TOTVEH, DWELL, YRMOV, RENT, DIARY, ENGL, HHSIZE, NPHON, NOPHO, SHPHN, ETHNC, INCLV, INCOM, INCOME, ASSN, DPHON, NPLAC, NTRIPS, NOWRK, NOSTU, OWNSH, EACCT, CPA, DAYOFWK, HBW, HBO, NHB, MOTTRIP, SAMPN, LISTD, HADDR)

persons <- read.csv("/Users/annaduan/Documents/GitHub/CPLN505PBN-Land-Use-Chester/HH\ Travel\ Survey/per_pub.csv") %>%
  dplyr::select(SAMPN, PERNO, GEND, AGE, LIC, RESP, RELAT, DISAB, DISTY1, DISTY2, EDUC, SHOME, SDAY, SMODE1)
```

First, we clean the data and merge three datasets capturing participants' trip, household, and demographic attributes. We clean out NAs, and filter the data to make sure the values are all in the correct ranges.  

```r
trips$drove_work[which(is.na(trips$drove_work))]<-0
trips$bike_walk_work[which(is.na(trips$bike_walk_work))]<-0
trips$transit_work[which(is.na(trips$transit_work))]<-0
trips$carpool_work[which(is.na(trips$carpool_work))]<-0
trips$SUMZERO<- trips$drove_work + trips$bike_walk_work + trips$transit_work + trips$carpool_work
trips <- trips[-which(trips$SUMZERO == 0), ] 

trips <- trips[which(trips$Dest_PTYE == 2), ] 
trips$Commute[trips$drove_work == 1] <- 1
trips$Commute[trips$bike_walk_work == 1] <- 2
trips$Commute[trips$transit_work == 1] <- 3
trips$Commute[trips$carpool_work == 1] <- 4



trips$SAMPN_PER <- do.call(paste, c(trips[c("SAMPN", "PERNO")], sep = ""))
trips <- subset(trips, !duplicated(SAMPN_PER))

person_hh <- merge(persons, households,
                    by.x = "SAMPN", 
                    by.y = "SAMPN", 
                    all.x = TRUE, 
                    all.y=FALSE, 
                    sort = FALSE)
# colnamCleaning<-c("VETMO", "W2TY", "W2TYO",  "W2TYP", "W2LOC", "W2IND", "W2INO", "W2OCC", "W2OCO", "W2DAY", "W2HOM", "W2HOO", "W2ST", "W2ET",  "W1WKD3", "W1WKD4", "W1WKE", "W1WKD1", "W1WKD2")
# person_hh<-person_hh[ , -which(names(persons) %in% colnamCleaning)]

person_hh$SAMPN_PER <- do.call(paste, c(person_hh[c("SAMPN", "PERNO")], sep = ""))

trips_person_hh <- merge(trips, person_hh,
                            by.x = "SAMPN_PER", 
                            by.y = "SAMPN_PER", 
                            all.x = TRUE, 
                            all.y=FALSE, 
                            sort = FALSE)

# varsInterest <- c("SAMPN", "PERNO", "AGE", "GENDER", "INCOME", "SAMPN_PER", "TOLLA", "TOLL", "PARKC", "PARKU", "PRKUO", "TRPDUR", "drove_work", "bike_walk_work", "transit_work", "carpool_work", "Commute")
# trips_person_hh<-trips_person_hh[ , which(names(trips_person_hh) %in% varsInterest)]

# trips_person_hh<-trips_person_hh[-which(is.na(trips_person_hh$INCOME)),]

drive<-trips_person_hh[which(trips_person_hh$drove_work ==1),]
walk_bike<-trips_person_hh[which(trips_person_hh$bike_walk_work ==1),]
transit<-trips_person_hh[which(trips_person_hh$transit_work ==1),]
carpool<-trips_person_hh[which(trips_person_hh$carpool_work ==1),]


summary(drive$TRPDUR)     #mean: 26
summary(walk_bike$TRPDUR) #mean: 21
summary(transit$TRPDUR)   #mean: 51
summary(carpool$TRPDUR)   #mean: 40

drive$distance<-(30/60)*drive$TRPDUR
walk_bike$distance<-(12/60)*walk_bike$TRPDUR
transit$distance<-(25/60)*transit$TRPDUR
carpool$distance<-(30/60)*carpool$TRPDUR

#re-combine the three data sets 
dat<-rbind(drive, walk_bike, transit, carpool)

#potential times for each
dat$time.auto <-dat$distance/30
dat$time.bike.walk <- dat$distance/12
dat$time.transit <- dat$distance/25
dat$time.carpool <- dat$distance/30

dat$mode[dat$drove_work == 1] <- "drove"
dat$mode[dat$transit_work == 1] <- "transit"
dat$mode[dat$bike_walk_work == 1] <- "bike"
dat$mode[dat$carpool_work == 1] <- "carpool"

rownames(dat) <- NULL 
# 
# varsInterest <- c("AGE", "GENDER", "INCOME", "time.auto", "time.bike.walk", "time.transit", "time.carpool", "mode")
# dat<-dat[ , which(names(dat) %in% varsInterest)]

#clean data further
trips_person_hh <-trips_person_hh[which(trips_person_hh$AGE %in% 1:110),]
trips_person_hh <-trips_person_hh[which(trips_person_hh$TRPDUR %in% 0:400),]
trips_person_hh <-trips_person_hh[which(trips_person_hh$INCOME %in% 0:200000),]
```

# Binary Logit: Driving, Biking, and Walking to Work   
## Model 1: Drive to Work       
First, we test a model using the maximum number of variables, just as a baseline. This model includes trip duration, gender, age, disability, education, total vehicles in a household, adults in household, rent or not, whether they speak English, household size, number of phones in the household, income, and whether a household has working adults. The AIC is 1493, with just about half of the variables marked as statistically significant.   

```r
mod_drive <- glm ( drove_work ~  TRPDUR  + GEND + AGE+DISAB+EDUC + TOTVEH + ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK, data=trips_person_hh, family = binomial)
summary(mod_drive)

#take out some outliers
trips_person_hh <-trips_person_hh[which(trips_person_hh$AGE %in% 1:110),]
trips_person_hh <-trips_person_hh[which(trips_person_hh$TRPDUR %in% 0:400),]
trips_person_hh <-trips_person_hh[which(trips_person_hh$INCOME %in% 0:200000),]
```

Using vif(), we can see that the variance inflation factor for all variables is below 5, meaning the model does not suffer from too much collinearity.  


```r
vif(mod_drive)
```

```
##   TRPDUR     GEND      AGE    DISAB     EDUC   TOTVEH    ADVLT     RENT 
## 1.025864 1.021570 1.222729 1.007698 1.102111 1.858384 1.003979 1.202719 
##     ENGL   HHSIZE    NPHON   INCOME    NOWRK 
## 1.000000 1.690689 1.160306 1.327662 2.056474
```

To create the "leanest and meanest" model, we use forward and backward selection to select the variables which contribute statistically significantly to the model and lower its AIC.     

```r
#Backward Selection
step(glm(drove_work ~  TRPDUR  + GEND + AGE+DISAB+EDUC + TOTVEH + ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK, data=trips_person_hh), direction = "backward")
```

```
## Start:  AIC=916.89
## drove_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + ADVLT + 
##     RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - NPHON   1   231.59  914.93
## - ENGL    1   231.60  915.08
## - ADVLT   1   231.63  915.39
## - HHSIZE  1   231.63  915.45
## - DISAB   1   231.67  915.93
## <none>        231.59  916.89
## - INCOME  1   231.79  917.51
## - EDUC    1   232.01  920.27
## - AGE     1   232.02  920.38
## - GEND    1   232.05  920.69
## - RENT    1   233.47  938.60
## - NOWRK   1   235.04  958.08
## - TRPDUR  1   236.62  977.60
## - TOTVEH  1   253.41 1177.82
## 
## Step:  AIC=914.93
## drove_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + ADVLT + 
##     RENT + ENGL + HHSIZE + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - ENGL    1   231.60  913.11
## - ADVLT   1   231.63  913.42
## - HHSIZE  1   231.63  913.47
## - DISAB   1   231.67  913.96
## <none>        231.59  914.93
## - INCOME  1   231.82  915.82
## - EDUC    1   232.01  918.28
## - AGE     1   232.03  918.42
## - GEND    1   232.05  918.70
## - RENT    1   233.48  936.68
## - NOWRK   1   235.04  956.08
## - TRPDUR  1   236.62  975.60
## - TOTVEH  1   253.82 1180.46
## 
## Step:  AIC=913.11
## drove_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + ADVLT + 
##     RENT + HHSIZE + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - ADVLT   1   231.64  911.60
## - HHSIZE  1   231.65  911.64
## - DISAB   1   231.69  912.15
## <none>        231.60  913.11
## - INCOME  1   231.83  914.01
## - EDUC    1   232.03  916.44
## - AGE     1   232.04  916.57
## - GEND    1   232.07  916.93
## - RENT    1   233.49  934.75
## - NOWRK   1   235.08  954.55
## - TRPDUR  1   236.63  973.78
## - TOTVEH  1   253.91 1179.50
## 
## Step:  AIC=911.6
## drove_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + RENT + 
##     HHSIZE + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - HHSIZE  1   231.69  910.13
## - DISAB   1   231.72  910.64
## <none>        231.64  911.60
## - INCOME  1   231.88  912.55
## - EDUC    1   232.07  914.93
## - AGE     1   232.07  914.98
## - GEND    1   232.11  915.44
## - RENT    1   233.55  933.53
## - NOWRK   1   235.11  953.00
## - TRPDUR  1   236.65  972.08
## - TOTVEH  1   253.93 1177.76
## 
## Step:  AIC=910.13
## drove_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + RENT + 
##     INCOME + NOWRK
## 
##          Df Deviance     AIC
## - DISAB   1   231.77  909.20
## <none>        231.69  910.13
## - INCOME  1   231.92  911.08
## - EDUC    1   232.10  913.31
## - GEND    1   232.13  913.70
## - AGE     1   232.22  914.85
## - RENT    1   233.56  931.60
## - NOWRK   1   236.00  962.01
## - TRPDUR  1   236.72  970.89
## - TOTVEH  1   254.11 1177.79
## 
## Step:  AIC=909.2
## drove_work ~ TRPDUR + GEND + AGE + EDUC + TOTVEH + RENT + INCOME + 
##     NOWRK
## 
##          Df Deviance     AIC
## <none>        231.77  909.20
## - INCOME  1   232.00  910.16
## - EDUC    1   232.18  912.32
## - GEND    1   232.21  912.69
## - AGE     1   232.31  913.98
## - RENT    1   233.64  930.66
## - NOWRK   1   236.09  961.09
## - TRPDUR  1   236.82  970.10
## - TOTVEH  1   254.16 1176.39
```

```
## 
## Call:  glm(formula = drove_work ~ TRPDUR + GEND + AGE + EDUC + TOTVEH + 
##     RENT + INCOME + NOWRK, data = trips_person_hh)
## 
## Coefficients:
## (Intercept)       TRPDUR         GEND          AGE         EDUC       TOTVEH  
##   5.822e-01   -2.127e-03   -2.470e-02    1.216e-03    4.262e-02    1.035e-01  
##        RENT       INCOME        NOWRK  
##   6.965e-02    2.518e-07   -5.727e-02  
## 
## Degrees of Freedom: 2918 Total (i.e. Null);  2910 Residual
## Null Deviance:	    271.5 
## Residual Deviance: 231.8 	AIC: 909.2
```

```r
#Forward Selection
fullmod<-glm(drove_work ~ TRPDUR  + GEND + AGE+DISAB+EDUC + TOTVEH + ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK, family = binomial, data = trips_person_hh)

intonly<-glm(drove_work ~ 1, family = binomial, data = trips_person_hh)

step(intonly, scope=list(lower=intonly, upper=fullmod), direction="forward")
```

```
## Start:  AIC=1948.15
## drove_work ~ 1
## 
##          Df Deviance    AIC
## + TOTVEH  1   1608.7 1612.7
## + RENT    1   1873.2 1877.2
## + TRPDUR  1   1891.2 1895.2
## + INCOME  1   1905.0 1909.0
## + AGE     1   1924.6 1928.6
## + NPHON   1   1928.5 1932.5
## + EDUC    1   1938.9 1942.9
## + NOWRK   1   1939.3 1943.3
## + GEND    1   1939.4 1943.4
## + HHSIZE  1   1940.2 1944.2
## <none>        1946.2 1948.2
## + ENGL    1   1945.0 1949.0
## + ADVLT   1   1945.7 1949.7
## + DISAB   1   1945.7 1949.7
## 
## Step:  AIC=1612.66
## drove_work ~ TOTVEH
## 
##          Df Deviance    AIC
## + NOWRK   1   1532.6 1538.6
## + TRPDUR  1   1571.8 1577.8
## + HHSIZE  1   1579.9 1585.9
## + AGE     1   1581.6 1587.6
## + EDUC    1   1593.3 1599.3
## + RENT    1   1601.6 1607.6
## <none>        1608.7 1612.7
## + INCOME  1   1606.9 1612.9
## + DISAB   1   1607.1 1613.1
## + GEND    1   1607.1 1613.1
## + NPHON   1   1607.3 1613.3
## + ENGL    1   1607.8 1613.8
## + ADVLT   1   1608.6 1614.6
## 
## Step:  AIC=1538.64
## drove_work ~ TOTVEH + NOWRK
## 
##          Df Deviance    AIC
## + TRPDUR  1   1495.3 1503.3
## + AGE     1   1518.6 1526.6
## + EDUC    1   1523.0 1531.0
## + RENT    1   1524.2 1532.2
## + HHSIZE  1   1530.1 1538.1
## <none>        1532.6 1538.6
## + DISAB   1   1530.8 1538.8
## + ENGL    1   1531.5 1539.5
## + GEND    1   1531.6 1539.6
## + INCOME  1   1532.6 1540.6
## + ADVLT   1   1532.6 1540.6
## + NPHON   1   1532.6 1540.6
## 
## Step:  AIC=1503.26
## drove_work ~ TOTVEH + NOWRK + TRPDUR
## 
##          Df Deviance    AIC
## + AGE     1   1483.7 1493.7
## + EDUC    1   1486.0 1496.0
## + RENT    1   1486.2 1496.2
## + GEND    1   1492.7 1502.7
## <none>        1495.3 1503.3
## + HHSIZE  1   1493.3 1503.3
## + DISAB   1   1493.7 1503.7
## + ENGL    1   1494.3 1504.3
## + ADVLT   1   1495.2 1505.2
## + INCOME  1   1495.2 1505.2
## + NPHON   1   1495.2 1505.2
## 
## Step:  AIC=1493.73
## drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE
## 
##          Df Deviance    AIC
## + EDUC    1   1478.4 1490.4
## + RENT    1   1478.5 1490.5
## + GEND    1   1480.9 1492.9
## <none>        1483.7 1493.7
## + DISAB   1   1482.2 1494.2
## + ENGL    1   1482.8 1494.8
## + HHSIZE  1   1483.2 1495.2
## + ADVLT   1   1483.6 1495.6
## + INCOME  1   1483.7 1495.7
## + NPHON   1   1483.7 1495.7
## 
## Step:  AIC=1490.42
## drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE + EDUC
## 
##          Df Deviance    AIC
## + RENT    1   1473.5 1487.5
## + GEND    1   1475.7 1489.7
## <none>        1478.4 1490.4
## + DISAB   1   1476.7 1490.7
## + ENGL    1   1477.3 1491.3
## + HHSIZE  1   1477.8 1491.8
## + ADVLT   1   1478.3 1492.3
## + INCOME  1   1478.3 1492.3
## + NPHON   1   1478.4 1492.4
## 
## Step:  AIC=1487.55
## drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE + EDUC + RENT
## 
##          Df Deviance    AIC
## + GEND    1   1470.9 1486.9
## <none>        1473.5 1487.5
## + DISAB   1   1471.9 1487.9
## + ENGL    1   1472.2 1488.2
## + HHSIZE  1   1472.6 1488.6
## + INCOME  1   1473.3 1489.3
## + ADVLT   1   1473.5 1489.5
## + NPHON   1   1473.5 1489.5
## 
## Step:  AIC=1486.87
## drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE + EDUC + RENT + GEND
## 
##          Df Deviance    AIC
## <none>        1470.9 1486.9
## + DISAB   1   1469.2 1487.2
## + ENGL    1   1469.5 1487.5
## + HHSIZE  1   1469.8 1487.8
## + INCOME  1   1470.6 1488.6
## + ADVLT   1   1470.8 1488.8
## + NPHON   1   1470.9 1488.9
```

```
## 
## Call:  glm(formula = drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE + EDUC + 
##     RENT + GEND, family = binomial, data = trips_person_hh)
## 
## Coefficients:
## (Intercept)       TOTVEH        NOWRK       TRPDUR          AGE         EDUC  
##    -0.70445      1.71772     -0.87879     -0.01875      0.01446      0.53137  
##        RENT         GEND  
##     0.35146     -0.22761  
## 
## Degrees of Freedom: 2918 Total (i.e. Null);  2911 Residual
## Null Deviance:	    1946 
## Residual Deviance: 1471 	AIC: 1487
```

Forward and backward selection outputs the list of variables that give the model the lowest AIC of 1452: TOTVEH (total vehicles) + NOWRK (nobody working in household) + TRPDUR (trip duration) + AGE + EDUC (education) + RENT (renter or not) + GEND (gender). After running the model, I remove gender because it is not statistically significant. This model now has all statistically significant variables. qchisq() then tells us that the critical value is 5666.533. Since the null deviance of the model is 1946, we know that our predicted results will have no significant difference from the observations.     

```r
#lowest aic: 1493, vars: TOTVEH + NOWRK + TRPDUR + AGE + GEND

mod_drive_3 <- glm(drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE + EDUC + RENT, family = binomial, data = trips_person_hh)
summary(mod_drive_3)
```

```
## 
## Call:
## glm(formula = drove_work ~ TOTVEH + NOWRK + TRPDUR + AGE + EDUC + 
##     RENT, family = binomial, data = trips_person_hh)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -4.7670   0.1488   0.3077   0.4340   1.9013  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.084417   0.555128  -1.953   0.0508 .  
## TOTVEH       1.726836   0.111150  15.536  < 2e-16 ***
## NOWRK       -0.879614   0.109266  -8.050 8.26e-16 ***
## TRPDUR      -0.018263   0.002998  -6.091 1.12e-09 ***
## AGE          0.014105   0.006383   2.210   0.0271 *  
## EDUC         0.536212   0.236154   2.271   0.0232 *  
## RENT         0.356934   0.166382   2.145   0.0319 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1946.1  on 2918  degrees of freedom
## Residual deviance: 1473.5  on 2912  degrees of freedom
## AIC: 1487.5
## 
## Number of Fisher Scoring iterations: 6
```

```r
#test fit
qchisq(.95, df=2918) 
```

```
## [1] 3044.783
```

Anova also tells us that the variables all contribute significantly, and add to the model's accuracy in the following order: total vehicles, no work, trip duration, age, education, and renters.      

```r
#anova
anova(mod_drive_3, test="Chisq") #anova tells us that the following are statistically significant contributions: Trip duration, gender, age, total vehicles, household size, no work 
```

```
## Analysis of Deviance Table
## 
## Model: binomial, link: logit
## 
## Response: drove_work
## 
## Terms added sequentially (first to last)
## 
## 
##        Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
## NULL                    2918     1946.2              
## TOTVEH  1   337.49      2917     1608.7 < 2.2e-16 ***
## NOWRK   1    76.02      2916     1532.6 < 2.2e-16 ***
## TRPDUR  1    37.38      2915     1495.3 9.714e-10 ***
## AGE     1    11.53      2914     1483.7 0.0006848 ***
## EDUC    1     5.31      2913     1478.4 0.0212261 *  
## RENT    1     4.87      2912     1473.5 0.0273039 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

We also calculate the predicted probabilities using the model. Here, we set the cut off for driving to work as 0.5. The results tell us that our model predicts correctly 92% of the time. 

```r
#calculate predicted probabilities 
pred <- as.data.frame(fitted(mod_drive_3))
pred <- rename(pred, "prob" = "fitted(mod_drive_3)")
pred <- mutate(pred, "binary" = ifelse(prob < 0.5, 0, 1))
#append to original df
trips_person_hh$binary <- pred$binary
       
(sum(trips_person_hh$drove_work == 1 & trips_person_hh$binary == 1) + sum(trips_person_hh$drove_work == 0  #92%: not bad
  & trips_person_hh$binary == 0)) / nrow(trips_person_hh)
```

```
## [1] 0.919493
```





## Model 2: Walk or Bike to Work   
Just like with drive to work, we start with a "kitchen sink" model to get an overview of all the variables. Just like before, only about half of the variables are statistically significant, and the AIC is 915.  

```r
mod_bike <- glm ( bike_walk_work ~  TRPDUR  + GEND + AGE+DISAB+EDUC + TOTVEH + ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK, data=trips_person_hh, family = binomial)
summary(mod_bike)
```

Using vif(), we can see that the variance inflation factor for all variables is below 5, meaning the model does not suffer from too much collinearity.  

```r
vif(mod_bike)
```

```
##   TRPDUR     GEND      AGE    DISAB     EDUC   TOTVEH    ADVLT     RENT 
## 1.074215 1.015967 1.277096 1.020155 1.134235 1.929338 1.009872 1.278280 
##     ENGL   HHSIZE    NPHON   INCOME    NOWRK 
## 1.000000 1.737731 1.136401 1.383584 2.163777
```

To create the "leanest and meanest" model, we use forward and backward selection to select the variables which contribute statistically significantly to the model and lower its AIC.     

```r
#Backward Selection
step(glm(bike_walk_work ~  TRPDUR  + GEND + AGE+DISAB+EDUC + TOTVEH + ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK, data=trips_person_hh), direction = "backward")
```

```
## Start:  AIC=-776.18
## bike_walk_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + 
##     ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - ENGL    1   129.66 -778.14
## - GEND    1   129.68 -777.87
## - ADVLT   1   129.69 -777.54
## - HHSIZE  1   129.71 -777.15
## - EDUC    1   129.75 -776.25
## <none>        129.66 -776.18
## - DISAB   1   129.75 -776.17
## - NPHON   1   129.87 -773.59
## - AGE     1   129.90 -772.96
## - INCOME  1   130.04 -769.72
## - RENT    1   130.05 -769.39
## - TRPDUR  1   130.78 -753.01
## - NOWRK   1   130.99 -748.41
## - TOTVEH  1   136.74 -623.01
## 
## Step:  AIC=-778.14
## bike_walk_work ~ TRPDUR + GEND + AGE + DISAB + EDUC + TOTVEH + 
##     ADVLT + RENT + HHSIZE + NPHON + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - GEND    1   129.68 -779.83
## - ADVLT   1   129.69 -779.51
## - HHSIZE  1   129.71 -779.09
## - EDUC    1   129.75 -778.21
## <none>        129.66 -778.14
## - DISAB   1   129.75 -778.13
## - NPHON   1   129.87 -775.55
## - AGE     1   129.90 -774.94
## - INCOME  1   130.04 -771.68
## - RENT    1   130.05 -771.38
## - TRPDUR  1   130.79 -754.97
## - NOWRK   1   131.00 -750.23
## - TOTVEH  1   136.76 -624.57
## 
## Step:  AIC=-779.83
## bike_walk_work ~ TRPDUR + AGE + DISAB + EDUC + TOTVEH + ADVLT + 
##     RENT + HHSIZE + NPHON + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - ADVLT   1   129.71 -781.21
## - HHSIZE  1   129.72 -780.88
## - EDUC    1   129.76 -779.95
## <none>        129.68 -779.83
## - DISAB   1   129.77 -779.80
## - NPHON   1   129.89 -777.16
## - AGE     1   129.91 -776.67
## - INCOME  1   130.06 -773.28
## - RENT    1   130.07 -773.07
## - TRPDUR  1   130.79 -756.97
## - NOWRK   1   131.00 -752.23
## - TOTVEH  1   136.76 -626.55
## 
## Step:  AIC=-781.21
## bike_walk_work ~ TRPDUR + AGE + DISAB + EDUC + TOTVEH + RENT + 
##     HHSIZE + NPHON + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - HHSIZE  1   129.75 -782.25
## - EDUC    1   129.79 -781.32
## <none>        129.71 -781.21
## - DISAB   1   129.80 -781.18
## - NPHON   1   129.91 -778.64
## - AGE     1   129.93 -778.13
## - INCOME  1   130.08 -774.78
## - RENT    1   130.10 -774.25
## - TRPDUR  1   130.82 -758.19
## - NOWRK   1   131.03 -753.65
## - TOTVEH  1   136.79 -628.06
## 
## Step:  AIC=-782.25
## bike_walk_work ~ TRPDUR + AGE + DISAB + EDUC + TOTVEH + RENT + 
##     NPHON + INCOME + NOWRK
## 
##          Df Deviance     AIC
## - DISAB   1   129.84 -782.29
## <none>        129.75 -782.25
## - EDUC    1   129.84 -782.22
## - AGE     1   129.94 -779.96
## - NPHON   1   129.96 -779.48
## - INCOME  1   130.13 -775.76
## - RENT    1   130.18 -774.64
## - TRPDUR  1   130.88 -758.90
## - NOWRK   1   131.07 -754.62
## - TOTVEH  1   137.10 -623.46
## 
## Step:  AIC=-782.29
## bike_walk_work ~ TRPDUR + AGE + EDUC + TOTVEH + RENT + NPHON + 
##     INCOME + NOWRK
## 
##          Df Deviance     AIC
## - EDUC    1   129.92 -782.32
## <none>        129.84 -782.29
## - AGE     1   130.03 -779.94
## - NPHON   1   130.05 -779.54
## - INCOME  1   130.21 -775.84
## - RENT    1   130.26 -774.69
## - TRPDUR  1   130.96 -759.12
## - NOWRK   1   131.16 -754.67
## - TOTVEH  1   137.16 -624.05
## 
## Step:  AIC=-782.32
## bike_walk_work ~ TRPDUR + AGE + TOTVEH + RENT + NPHON + INCOME + 
##     NOWRK
## 
##          Df Deviance     AIC
## <none>        129.92 -782.32
## - NPHON   1   130.12 -779.81
## - AGE     1   130.21 -777.89
## - INCOME  1   130.30 -775.81
## - RENT    1   130.35 -774.71
## - TRPDUR  1   131.07 -758.73
## - NOWRK   1   131.31 -753.32
## - TOTVEH  1   137.26 -624.02
```

```
## 
## Call:  glm(formula = bike_walk_work ~ TRPDUR + AGE + TOTVEH + RENT + 
##     NPHON + INCOME + NOWRK, data = trips_person_hh)
## 
## Coefficients:
## (Intercept)       TRPDUR          AGE       TOTVEH         RENT        NPHON  
##   2.435e-01   -1.007e-03   -8.563e-04   -5.960e-02   -3.335e-02   -1.200e-02  
##      INCOME        NOWRK  
##   3.274e-07    3.232e-02  
## 
## Degrees of Freedom: 2918 Total (i.e. Null);  2911 Residual
## Null Deviance:	    140.5 
## Residual Deviance: 129.9 	AIC: -782.3
```

```r
#Forward Selection
fullmod<-glm(bike_walk_work ~ TRPDUR  + GEND + AGE+DISAB+EDUC + TOTVEH + ADVLT + RENT + ENGL + HHSIZE + NPHON + INCOME + NOWRK, family = binomial, data = trips_person_hh)

intonly<-glm(bike_walk_work ~ 1, family = binomial, data = trips_person_hh)

step(intonly, scope=list(lower=intonly, upper=fullmod), direction="forward")
```

```
## Start:  AIC=1172.97
## bike_walk_work ~ 1
## 
##          Df Deviance    AIC
## + TOTVEH  1   1007.4 1011.4
## + RENT    1   1141.4 1145.4
## + NPHON   1   1148.8 1152.8
## + TRPDUR  1   1151.3 1155.3
## + AGE     1   1162.4 1166.4
## + HHSIZE  1   1162.7 1166.7
## + EDUC    1   1167.2 1171.2
## + INCOME  1   1168.7 1172.7
## <none>        1171.0 1173.0
## + NOWRK   1   1169.9 1173.9
## + DISAB   1   1170.2 1174.2
## + ADVLT   1   1170.3 1174.3
## + GEND    1   1170.3 1174.3
## + ENGL    1   1170.5 1174.5
## 
## Step:  AIC=1011.44
## bike_walk_work ~ TOTVEH
## 
##          Df Deviance     AIC
## + NOWRK   1   963.76  969.76
## + TRPDUR  1   972.55  978.55
## + INCOME  1   989.70  995.70
## + AGE     1   998.34 1004.34
## + EDUC    1  1000.62 1006.62
## + HHSIZE  1  1002.28 1008.28
## <none>       1007.44 1011.44
## + DISAB   1  1005.74 1011.74
## + NPHON   1  1006.04 1012.04
## + RENT    1  1006.18 1012.18
## + ENGL    1  1007.07 1013.07
## + ADVLT   1  1007.14 1013.14
## + GEND    1  1007.37 1013.37
## 
## Step:  AIC=969.76
## bike_walk_work ~ TOTVEH + NOWRK
## 
##          Df Deviance    AIC
## + TRPDUR  1   924.31 932.31
## + INCOME  1   951.53 959.53
## + NPHON   1   959.26 967.26
## + EDUC    1   960.05 968.05
## + AGE     1   960.55 968.55
## <none>        963.76 969.76
## + DISAB   1   961.86 969.86
## + HHSIZE  1   962.14 970.14
## + RENT    1   962.17 970.17
## + ENGL    1   963.28 971.28
## + ADVLT   1   963.56 971.56
## + GEND    1   963.57 971.57
## 
## Step:  AIC=932.31
## bike_walk_work ~ TOTVEH + NOWRK + TRPDUR
## 
##          Df Deviance    AIC
## + INCOME  1   910.52 920.52
## + AGE     1   919.08 929.08
## + EDUC    1   919.36 929.36
## + NPHON   1   920.29 930.29
## + DISAB   1   922.06 932.06
## <none>        924.31 932.31
## + RENT    1   922.75 932.75
## + HHSIZE  1   923.36 933.36
## + GEND    1   923.57 933.57
## + ENGL    1   923.71 933.71
## + ADVLT   1   924.24 934.24
## 
## Step:  AIC=920.52
## bike_walk_work ~ TOTVEH + NOWRK + TRPDUR + INCOME
## 
##          Df Deviance    AIC
## + AGE     1   903.32 915.32
## + NPHON   1   903.87 915.87
## + EDUC    1   904.46 916.46
## + RENT    1   907.20 919.20
## + DISAB   1   908.08 920.08
## <none>        910.52 920.52
## + GEND    1   909.92 921.92
## + HHSIZE  1   909.98 921.98
## + ENGL    1   910.00 922.00
## + ADVLT   1   910.38 922.38
## 
## Step:  AIC=915.32
## bike_walk_work ~ TOTVEH + NOWRK + TRPDUR + INCOME + AGE
## 
##          Df Deviance    AIC
## + NPHON   1   896.80 910.80
## + EDUC    1   899.93 913.93
## + DISAB   1   900.80 914.80
## <none>        903.32 915.32
## + HHSIZE  1   901.59 915.59
## + RENT    1   901.93 915.93
## + GEND    1   902.82 916.82
## + ENGL    1   902.84 916.84
## + ADVLT   1   903.21 917.21
## 
## Step:  AIC=910.8
## bike_walk_work ~ TOTVEH + NOWRK + TRPDUR + INCOME + AGE + NPHON
## 
##          Df Deviance    AIC
## + EDUC    1   893.21 909.21
## + DISAB   1   894.36 910.36
## <none>        896.80 910.80
## + HHSIZE  1   895.37 911.37
## + RENT    1   895.43 911.43
## + ENGL    1   896.26 912.26
## + GEND    1   896.45 912.45
## + ADVLT   1   896.61 912.61
## 
## Step:  AIC=909.21
## bike_walk_work ~ TOTVEH + NOWRK + TRPDUR + INCOME + AGE + NPHON + 
##     EDUC
## 
##          Df Deviance    AIC
## + DISAB   1   890.63 908.63
## <none>        893.21 909.21
## + RENT    1   892.00 910.00
## + HHSIZE  1   892.00 910.00
## + ENGL    1   892.65 910.65
## + GEND    1   892.85 910.85
## + ADVLT   1   893.02 911.02
## 
## Step:  AIC=908.63
## bike_walk_work ~ TOTVEH + NOWRK + TRPDUR + INCOME + AGE + NPHON + 
##     EDUC + DISAB
## 
##          Df Deviance    AIC
## <none>        890.63 908.63
## + HHSIZE  1   889.24 909.24
## + RENT    1   889.50 909.50
## + ENGL    1   890.08 910.08
## + GEND    1   890.31 910.31
## + ADVLT   1   890.45 910.45
```

```
## 
## Call:  glm(formula = bike_walk_work ~ TOTVEH + NOWRK + TRPDUR + INCOME + 
##     AGE + NPHON + EDUC + DISAB, family = binomial, data = trips_person_hh)
## 
## Coefficients:
## (Intercept)       TOTVEH        NOWRK       TRPDUR       INCOME          AGE  
##   6.617e-01   -1.978e+00    9.056e-01   -3.649e-02    1.153e-05   -1.736e-02  
##       NPHON         EDUC        DISAB  
##  -4.567e-01   -6.169e-01    3.609e-01  
## 
## Degrees of Freedom: 2918 Total (i.e. Null);  2910 Residual
## Null Deviance:	    1171 
## Residual Deviance: 890.6 	AIC: 908.6
```

Forward and backward selection outputs the list of variables that give the model the lowest AIC of 1452: TOTVEH (total vehicles) + NOWRK (nobody working in household) + TRPDUR (trip duration) + AGE + EDUC (education) + RENT (renter or not) + DISAB (disability) + INCOME. After running the model, I remove NPHON, INCOME, and DISAB because they are not statistically significant. This model now has all statistically significant variables. qchisq() then tells us that the critical value is 5666.533. Since the null deviance of the model is 1946, we know that our predicted results will have no significant difference from the observations.       

```r
#lowest aic: 1493, vars: TOTVEH + NOWRK + TRPDUR + AGE + GEND

mod_bike_3 <- glm(bike_walk_work ~ TRPDUR + AGE + TOTVEH + RENT + NOWRK + EDUC, family = binomial, data = trips_person_hh)
summary(mod_bike_3)
```

```
## 
## Call:
## glm(formula = bike_walk_work ~ TRPDUR + AGE + TOTVEH + RENT + 
##     NOWRK + EDUC, family = binomial, data = trips_person_hh)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.0699  -0.3212  -0.2007  -0.1049   3.6651  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.142074   0.723641   1.578   0.1145    
## TRPDUR      -0.035580   0.006304  -5.644 1.66e-08 ***
## AGE         -0.012881   0.008234  -1.564   0.1177    
## TOTVEH      -1.771034   0.140910 -12.569  < 2e-16 ***
## RENT        -0.136832   0.211836  -0.646   0.5183    
## NOWRK        0.900289   0.141052   6.383 1.74e-10 ***
## EDUC        -0.528683   0.305521  -1.730   0.0836 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1171.0  on 2918  degrees of freedom
## Residual deviance:  915.8  on 2912  degrees of freedom
## AIC: 929.8
## 
## Number of Fisher Scoring iterations: 7
```

```r
#test fit
qchisq(.95, df=2918) 
```

```
## [1] 3044.783
```

Anova also tells us that the variables all contribute significantly, and add to the model's accuracy in the following order: trip duration, age, total vehicles, rent, no work, education.   

```r
#anova
anova(mod_bike_3, test="Chisq") 
```

```
## Analysis of Deviance Table
## 
## Model: binomial, link: logit
## 
## Response: bike_walk_work
## 
## Terms added sequentially (first to last)
## 
## 
##        Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
## NULL                    2918    1170.97              
## TRPDUR  1   19.682      2917    1151.29 9.146e-06 ***
## AGE     1    9.304      2916    1141.99  0.002286 ** 
## TOTVEH  1  182.534      2915     959.45 < 2.2e-16 ***
## RENT    1    0.067      2914     959.39  0.796080    
## NOWRK   1   40.786      2913     918.60 1.698e-10 ***
## EDUC    1    2.802      2912     915.80  0.094149 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

We also calculate the predicted probabilities using the model. Here, we set the cut off for biking or walking to work as 0.5. Unfortunately, our model predicts correctly just 6.5% of the time.   

```r
#calculate predicted probabilities 
pred <- as.data.frame(fitted(mod_bike_3))
pred <- rename(pred, "prob" = "fitted(mod_bike_3)")
pred <- mutate(pred, "binary" = ifelse(prob < 0.5, 0, 1))
#append to original df
trips_person_hh$binary <- pred$binary
       
(sum(trips_person_hh$bike_walk_work == 1 & trips_person_hh$binary == 1) + sum(trips_person_hh$bike_walk_work == 0  
  & trips_person_hh$binary == 0)) / nrow(trips_person_hh)
```

```
## [1] 0.9513532
```

## Binary Logit Conclusion and Plots      
For the drive to work model, the results tell us that the following factors are the most influential in determining whether somebody drives to work:      
  
1. Total vehicles in household     
3. Trip duration  
4. Commuter age    
5. Whether someone is in school    
6. Whether someone rents or owns their home   

For our walk and bike to work model, the following variables are the most significant:     
  
1. Trip duration  
2. Commuter Age  
3. Total vehicles in the household  
4. Whether someone rents or owns their home  
5. Number of workers in the home  
6. Whether someone is in school  

These results offer us several important takeaways:  
   
1. The more vehicles someone has in their household, the more likely they are to drive and less likely they are to walk or bike. This may be due solely to the fact that someone with access to more cars is less likely to have to compete with another household member for a vehicle. However, it could also reflect the fact that people living in the suburbs tend to have more cars and lower access to other modes such as transit or walking.      
  
2. More workers in a household means a person is less likely to drive, and more likely to bike or walk to work. This supports the theory that mode choice is determined, in part, with whether one has to compete with household members for transportation resources.     
  
3. Trip duration is a predictor for mode because on average, a car commute takes 4 minutes longer than a bike or walking commute. It's possible that this is because people are unlikely to choose biking or walking, more labor intensive modes, for longer commutes.    
  
4. The older someone is, the more likely they are to drive instead of walk or bike. This is expected, as the literature has documented that older populations in the United States tend to prefer automobile transport over other modes.      
  
Overall, our drive to work model predicts much better than the walk and bike to work model. The drive model has an accuracy rate of 92%, compared to just 6.5% for the walk/bike model. Part of this is likely due to the low number of bike and walk to work trips. In all, there are only 173 observations of either bike or walking trips, compared to 3038 observations of driving trips. Due to these limitations, the bike or walk to work model should not be used for predictive purposes. For future modeling, it would be valuable to explore data sources that feature a higher number of biking and walking trips.  


## Model 3: Drive to work, carpool, transit, walk, or bike  


