---
title: "CPLN505-Assignment 3"
author: "Yihong Hu & Anna Duan"
date: "4/22/2022"
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



# Part 1: Modelling Land Use Change  

In this report, we will develop a binary model to predict the possibility of land-use change in Chester County, PA. We want to know:
(1) What are the main factors that determine a location to change from non-urban to urban in Chester County.
(2) What are the possibility for specific locations for land-use change in Chester County 


```r
# Read Chester land use Data and its geometry
Chester_L <- read.csv("Chester_Urban_Growth.csv") 
Chester_L_geo <-
  Chester_L%>%
  st_as_sf(coords=c("X","Y"),crs = "EPSG:25832")
```

## Summary Statistics 

<table class="table table-striped" style="">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">     SLOPE </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_WATER </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_RAILS </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_REGRA </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_PASSR </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_4LNE_ </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_INTER </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   DIST_PARKS </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">    POPDEN90 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">    MEDINC90 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   MEDHSEVAL_ </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   PCT_WHITE_ </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   PCT_SFHOME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   PCT_POV_90 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   PCT_HSB_19 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   PCT_COLGRD </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Min.   : 0.050 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :    0 </td>
   <td style="text-align:left;"> Min.   :     0 </td>
   <td style="text-align:left;"> Min.   :     0 </td>
   <td style="text-align:left;"> Min.   : 34.00 </td>
   <td style="text-align:left;"> Min.   :  0.00 </td>
   <td style="text-align:left;"> Min.   : 0.000 </td>
   <td style="text-align:left;"> Min.   :  0.00 </td>
   <td style="text-align:left;"> Min.   : 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 1st Qu.: 1.344 </td>
   <td style="text-align:left;"> 1st Qu.: 1414 </td>
   <td style="text-align:left;"> 1st Qu.: 6671 </td>
   <td style="text-align:left;"> 1st Qu.: 6265 </td>
   <td style="text-align:left;"> 1st Qu.: 1000 </td>
   <td style="text-align:left;"> 1st Qu.: 1414 </td>
   <td style="text-align:left;"> 1st Qu.: 5590 </td>
   <td style="text-align:left;"> 1st Qu.: 2500 </td>
   <td style="text-align:left;"> 1st Qu.:   21 </td>
   <td style="text-align:left;"> 1st Qu.: 37986 </td>
   <td style="text-align:left;"> 1st Qu.:128000 </td>
   <td style="text-align:left;"> 1st Qu.: 94.00 </td>
   <td style="text-align:left;"> 1st Qu.: 77.00 </td>
   <td style="text-align:left;"> 1st Qu.: 2.000 </td>
   <td style="text-align:left;"> 1st Qu.: 14.00 </td>
   <td style="text-align:left;"> 1st Qu.: 2.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Median : 2.048 </td>
   <td style="text-align:left;"> Median : 3162 </td>
   <td style="text-align:left;"> Median :12500 </td>
   <td style="text-align:left;"> Median :12176 </td>
   <td style="text-align:left;"> Median : 2236 </td>
   <td style="text-align:left;"> Median : 3000 </td>
   <td style="text-align:left;"> Median :12530 </td>
   <td style="text-align:left;"> Median : 4472 </td>
   <td style="text-align:left;"> Median :   61 </td>
   <td style="text-align:left;"> Median : 45074 </td>
   <td style="text-align:left;"> Median :150200 </td>
   <td style="text-align:left;"> Median : 97.00 </td>
   <td style="text-align:left;"> Median : 86.00 </td>
   <td style="text-align:left;"> Median : 4.000 </td>
   <td style="text-align:left;"> Median : 19.00 </td>
   <td style="text-align:left;"> Median : 4.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Mean   : 2.407 </td>
   <td style="text-align:left;"> Mean   : 3753 </td>
   <td style="text-align:left;"> Mean   :13233 </td>
   <td style="text-align:left;"> Mean   :12918 </td>
   <td style="text-align:left;"> Mean   : 2763 </td>
   <td style="text-align:left;"> Mean   : 3416 </td>
   <td style="text-align:left;"> Mean   :15640 </td>
   <td style="text-align:left;"> Mean   : 5161 </td>
   <td style="text-align:left;"> Mean   :  189 </td>
   <td style="text-align:left;"> Mean   : 48876 </td>
   <td style="text-align:left;"> Mean   :167526 </td>
   <td style="text-align:left;"> Mean   : 94.74 </td>
   <td style="text-align:left;"> Mean   : 82.67 </td>
   <td style="text-align:left;"> Mean   : 4.424 </td>
   <td style="text-align:left;"> Mean   : 23.11 </td>
   <td style="text-align:left;"> Mean   : 4.424 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 3rd Qu.: 3.036 </td>
   <td style="text-align:left;"> 3rd Qu.: 5701 </td>
   <td style="text-align:left;"> 3rd Qu.:18201 </td>
   <td style="text-align:left;"> 3rd Qu.:18000 </td>
   <td style="text-align:left;"> 3rd Qu.: 4123 </td>
   <td style="text-align:left;"> 3rd Qu.: 5315 </td>
   <td style="text-align:left;"> 3rd Qu.:24076 </td>
   <td style="text-align:left;"> 3rd Qu.: 7106 </td>
   <td style="text-align:left;"> 3rd Qu.:  154 </td>
   <td style="text-align:left;"> 3rd Qu.: 56394 </td>
   <td style="text-align:left;"> 3rd Qu.:214200 </td>
   <td style="text-align:left;"> 3rd Qu.: 98.00 </td>
   <td style="text-align:left;"> 3rd Qu.: 93.00 </td>
   <td style="text-align:left;"> 3rd Qu.: 6.000 </td>
   <td style="text-align:left;"> 3rd Qu.: 31.00 </td>
   <td style="text-align:left;"> 3rd Qu.: 6.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Max.   :12.042 </td>
   <td style="text-align:left;"> Max.   :13730 </td>
   <td style="text-align:left;"> Max.   :40771 </td>
   <td style="text-align:left;"> Max.   :40771 </td>
   <td style="text-align:left;"> Max.   :11181 </td>
   <td style="text-align:left;"> Max.   :11511 </td>
   <td style="text-align:left;"> Max.   :49359 </td>
   <td style="text-align:left;"> Max.   :16808 </td>
   <td style="text-align:left;"> Max.   :13000 </td>
   <td style="text-align:left;"> Max.   :103043 </td>
   <td style="text-align:left;"> Max.   :384000 </td>
   <td style="text-align:left;"> Max.   :100.00 </td>
   <td style="text-align:left;"> Max.   :100.00 </td>
   <td style="text-align:left;"> Max.   :29.000 </td>
   <td style="text-align:left;"> Max.   :100.00 </td>
   <td style="text-align:left;"> Max.   :29.000 </td>
  </tr>
</tbody>
</table>

## Binary Variables

We first created a column that indicates the land-use change from non-urban to urban between 1992 and 2002. If the change occurred, it will be marked as "1" in the new column, otherwise it will be marked as "0".


```r
#Find urban land use change between 1992 and 2001
Chester_L <-
  Chester_L %>%
  mutate(CHNG_URB = URBAN01 - URBAN92) 

#Negative indicates that the urban land use  in 1992 has changed to other use in 2021. Replace them with 0.
Chester_L$CHNG_URB[Chester_L$CHNG_URB < 0] <- 0
```

## Build Binomial Logit Model 

First, we cleaned the dataset. We changed the some zeros to "NA", so the regression can bypass them.  

```r
Chester_L_clean <- Chester_L %>%
  select(DIST_WATER,DIST_RAILS, DIST_REGRA, DIST_PASSR, DIST_4LNE_, DIST_INTER, DIST_PARKS)

is.na(Chester_L_clean) <- !Chester_L_clean

Chester_Clean_2 <- Chester_L %>%
  select(-DIST_WATER,-DIST_RAILS, -DIST_REGRA, -DIST_PASSR, -DIST_4LNE_, -DIST_INTER, -DIST_PARKS)

Chester_L_Final <-
  cbind(Chester_L_clean, Chester_Clean_2)

bi_model <-
  glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + PARKS500M + WATER100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + PCT_COLGRD + DIST_WATER + DIST_RAILS + DIST_REGRA + DIST_PASSR + DIST_4LNE_ + DIST_INTER+ DIST_PARKS, family = binomial, data = Chester_L_Final)

summary(bi_model)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + 
##     RAILSTN100 + PARKS500M + WATER100 + CITBORO_10 + POPDEN90 + 
##     MEDINC90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
##     PCT_HSB_19 + PCT_COLGRD + DIST_WATER + DIST_RAILS + DIST_REGRA + 
##     DIST_PASSR + DIST_4LNE_ + DIST_INTER + DIST_PARKS, family = binomial, 
##     data = Chester_L_Final)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3520  -0.2701  -0.1676  -0.0939   3.4293  
## 
## Coefficients: (3 not defined because of singularities)
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.117e+00  1.475e+00   0.757 0.448881    
## FOURLNE300   3.361e-01  3.498e-01   0.961 0.336604    
## INTERST800   2.396e-01  2.780e-01   0.862 0.388747    
## REGRAIL300   3.772e-01  2.561e-01   1.473 0.140744    
## RAILSTN100   5.803e-01  4.174e-01   1.390 0.164464    
## PARKS500M           NA         NA      NA       NA    
## WATER100            NA         NA      NA       NA    
## CITBORO_10   6.089e-01  2.581e-01   2.359 0.018316 *  
## POPDEN90     1.060e-04  8.231e-05   1.288 0.197635    
## MEDINC90    -5.103e-06  1.003e-05  -0.509 0.610901    
## MEDHSEVAL_   2.323e-06  1.947e-06   1.193 0.232967    
## PCT_WHITE_  -2.424e-02  1.326e-02  -1.827 0.067633 .  
## PCT_SFHOME  -9.098e-03  8.260e-03  -1.102 0.270663    
## PCT_POV_90  -7.683e-02  3.281e-02  -2.342 0.019199 *  
## PCT_HSB_19   8.651e-03  7.681e-03   1.126 0.260057    
## PCT_COLGRD          NA         NA      NA       NA    
## DIST_WATER   6.913e-05  3.467e-05   1.994 0.046118 *  
## DIST_RAILS   7.671e-05  1.540e-04   0.498 0.618320    
## DIST_REGRA  -1.572e-04  1.579e-04  -0.996 0.319471    
## DIST_PASSR  -1.790e-04  6.250e-05  -2.865 0.004174 ** 
## DIST_4LNE_  -2.498e-04  9.354e-05  -2.670 0.007583 ** 
## DIST_INTER   3.208e-05  2.264e-05   1.417 0.156609    
## DIST_PARKS  -1.576e-04  4.165e-05  -3.783 0.000155 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1763.5  on 5493  degrees of freedom
## Residual deviance: 1411.5  on 5474  degrees of freedom
##   (1448 observations deleted due to missingness)
## AIC: 1451.5
## 
## Number of Fisher Scoring iterations: 7
```

The AIC is shown to be 1451 with very few significant variables. We then used backward and forward selection methods to give a list of the most relevant variables. Some variables returned NA in the model, which means they are co-linear with other variables. We removed these variables.


```r
#Remove "Park", "Water", "College" variables in the regression.
bi_model <-
  glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_RAILS + DIST_REGRA + DIST_PASSR + DIST_4LNE_ + DIST_INTER + DIST_PARKS + DIST_WATER, family = binomial, data = Chester_L_Final)

summary(bi_model)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + 
##     RAILSTN100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_ + 
##     PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_RAILS + 
##     DIST_REGRA + DIST_PASSR + DIST_4LNE_ + DIST_INTER + DIST_PARKS + 
##     DIST_WATER, family = binomial, data = Chester_L_Final)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3520  -0.2701  -0.1676  -0.0939   3.4293  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.117e+00  1.475e+00   0.757 0.448881    
## FOURLNE300   3.361e-01  3.498e-01   0.961 0.336604    
## INTERST800   2.396e-01  2.780e-01   0.862 0.388747    
## REGRAIL300   3.772e-01  2.561e-01   1.473 0.140744    
## RAILSTN100   5.803e-01  4.174e-01   1.390 0.164464    
## CITBORO_10   6.089e-01  2.581e-01   2.359 0.018316 *  
## POPDEN90     1.060e-04  8.231e-05   1.288 0.197635    
## MEDINC90    -5.103e-06  1.003e-05  -0.509 0.610901    
## MEDHSEVAL_   2.323e-06  1.947e-06   1.193 0.232967    
## PCT_WHITE_  -2.424e-02  1.326e-02  -1.827 0.067633 .  
## PCT_SFHOME  -9.098e-03  8.260e-03  -1.102 0.270663    
## PCT_POV_90  -7.683e-02  3.281e-02  -2.342 0.019199 *  
## PCT_HSB_19   8.651e-03  7.681e-03   1.126 0.260057    
## DIST_RAILS   7.671e-05  1.540e-04   0.498 0.618320    
## DIST_REGRA  -1.572e-04  1.579e-04  -0.996 0.319471    
## DIST_PASSR  -1.790e-04  6.250e-05  -2.865 0.004174 ** 
## DIST_4LNE_  -2.498e-04  9.354e-05  -2.670 0.007583 ** 
## DIST_INTER   3.208e-05  2.264e-05   1.417 0.156609    
## DIST_PARKS  -1.576e-04  4.165e-05  -3.783 0.000155 ***
## DIST_WATER   6.913e-05  3.467e-05   1.994 0.046118 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1763.5  on 5493  degrees of freedom
## Residual deviance: 1411.5  on 5474  degrees of freedom
##   (1448 observations deleted due to missingness)
## AIC: 1451.5
## 
## Number of Fisher Scoring iterations: 7
```

The variance inflation factors (VIF) is calculated to test the co-linearity of the variables. 


```r
vif(bi_model)
```

```
## FOURLNE300 INTERST800 REGRAIL300 RAILSTN100 CITBORO_10   POPDEN90   MEDINC90 
##   3.000066   3.449423   2.710965   1.182235   1.473134   1.313002   4.500551 
## MEDHSEVAL_ PCT_WHITE_ PCT_SFHOME PCT_POV_90 PCT_HSB_19 DIST_RAILS DIST_REGRA 
##   2.501230   1.840629   2.529919   1.867165   2.175050 196.859370 215.603086 
## DIST_PASSR DIST_4LNE_ DIST_INTER DIST_PARKS DIST_WATER 
##   1.417500   3.290017   7.683299   1.677944   1.758936
```

A general rule of thumb is to not use any variables that return VIFs greater than 5 in a regression model. We thus removed DIST_RAILS, DIST_REGRA, DIST_INTER from the set. 


```r
bi_model2 <- glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_+ PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, data = Chester_L_Final)

summary(bi_model2)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + 
##     RAILSTN100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_ + 
##     PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, 
##     data = Chester_L_Final)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3260  -0.2815  -0.1740  -0.0940   3.3884  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.403e+00  1.399e+00   1.003 0.315900    
## FOURLNE300   3.777e-01  3.502e-01   1.079 0.280778    
## INTERST800   1.217e-01  1.891e-01   0.644 0.519807    
## REGRAIL300   8.422e-01  2.135e-01   3.944 8.01e-05 ***
## RAILSTN100   6.001e-01  3.588e-01   1.673 0.094418 .  
## CITBORO_10   6.506e-01  2.487e-01   2.616 0.008890 ** 
## POPDEN90     1.685e-04  7.986e-05   2.109 0.034921 *  
## MEDINC90    -3.588e-06  9.894e-06  -0.363 0.716861    
## MEDHSEVAL_   3.243e-06  1.929e-06   1.682 0.092647 .  
## PCT_WHITE_  -3.229e-02  1.215e-02  -2.657 0.007892 ** 
## PCT_SFHOME  -9.820e-03  8.056e-03  -1.219 0.222845    
## PCT_POV_90  -8.933e-02  3.281e-02  -2.723 0.006473 ** 
## PCT_HSB_19   6.910e-04  7.567e-03   0.091 0.927245    
## DIST_PASSR  -1.973e-04  5.908e-05  -3.340 0.000839 ***
## DIST_4LNE_  -2.416e-04  9.145e-05  -2.642 0.008250 ** 
## DIST_PARKS  -1.457e-04  3.791e-05  -3.844 0.000121 ***
## DIST_WATER   6.918e-05  3.295e-05   2.100 0.035758 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1810.5  on 5517  degrees of freedom
## Residual deviance: 1456.5  on 5501  degrees of freedom
##   (1424 observations deleted due to missingness)
## AIC: 1490.5
## 
## Number of Fisher Scoring iterations: 7
```

We used backward and forward selections are used to select variables that give the best results.


```r
#Backward Selection
step(glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_+ PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, data = na.omit(Chester_L_Final)), direction = "backward")
```

```
## Start:  AIC=1458.02
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_ + PCT_WHITE_ + 
##     PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_PASSR + DIST_4LNE_ + 
##     DIST_PARKS + DIST_WATER
## 
##              Df Deviance    AIC
## - PCT_HSB_19  1   1424.1 1456.1
## - MEDINC90    1   1424.2 1456.2
## - INTERST800  1   1424.5 1456.5
## - PCT_SFHOME  1   1424.8 1456.8
## - FOURLNE300  1   1424.9 1456.9
## <none>            1424.0 1458.0
## - RAILSTN100  1   1426.4 1458.4
## - MEDHSEVAL_  1   1426.5 1458.5
## - POPDEN90    1   1427.7 1459.7
## - DIST_WATER  1   1429.2 1461.2
## - PCT_WHITE_  1   1429.7 1461.7
## - DIST_4LNE_  1   1432.0 1464.0
## - PCT_POV_90  1   1432.3 1464.3
## - CITBORO_10  1   1432.7 1464.7
## - DIST_PASSR  1   1436.3 1468.3
## - REGRAIL300  1   1439.2 1471.2
## - DIST_PARKS  1   1439.8 1471.8
## 
## Step:  AIC=1456.12
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_ + PCT_WHITE_ + 
##     PCT_SFHOME + PCT_POV_90 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + 
##     DIST_WATER
## 
##              Df Deviance    AIC
## - MEDINC90    1   1424.5 1454.5
## - INTERST800  1   1424.7 1454.7
## - PCT_SFHOME  1   1424.8 1454.8
## - FOURLNE300  1   1425.0 1455.0
## <none>            1424.1 1456.1
## - RAILSTN100  1   1426.7 1456.7
## - MEDHSEVAL_  1   1426.9 1456.9
## - POPDEN90    1   1428.1 1458.1
## - DIST_WATER  1   1429.5 1459.5
## - PCT_WHITE_  1   1429.8 1459.8
## - DIST_4LNE_  1   1432.2 1462.2
## - PCT_POV_90  1   1432.5 1462.5
## - CITBORO_10  1   1433.9 1463.9
## - DIST_PASSR  1   1436.3 1466.3
## - DIST_PARKS  1   1440.1 1470.1
## - REGRAIL300  1   1440.2 1470.2
## 
## Step:  AIC=1454.52
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + 
##     PCT_POV_90 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER
## 
##              Df Deviance    AIC
## - INTERST800  1   1425.1 1453.1
## - FOURLNE300  1   1425.4 1453.4
## <none>            1424.5 1454.5
## - RAILSTN100  1   1427.1 1455.1
## - MEDHSEVAL_  1   1427.2 1455.2
## - PCT_SFHOME  1   1427.2 1455.2
## - POPDEN90    1   1428.3 1456.3
## - DIST_WATER  1   1429.9 1457.9
## - PCT_WHITE_  1   1430.4 1458.4
## - DIST_4LNE_  1   1432.3 1460.3
## - PCT_POV_90  1   1432.7 1460.7
## - CITBORO_10  1   1434.6 1462.6
## - DIST_PASSR  1   1436.5 1464.5
## - REGRAIL300  1   1440.2 1468.2
## - DIST_PARKS  1   1440.2 1468.2
## 
## Step:  AIC=1453.09
## CHNG_URB ~ FOURLNE300 + REGRAIL300 + RAILSTN100 + CITBORO_10 + 
##     POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
##     DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER
## 
##              Df Deviance    AIC
## - FOURLNE300  1   1425.9 1451.9
## <none>            1425.1 1453.1
## - RAILSTN100  1   1427.6 1453.6
## - PCT_SFHOME  1   1427.8 1453.8
## - MEDHSEVAL_  1   1428.0 1454.0
## - POPDEN90    1   1428.8 1454.8
## - PCT_WHITE_  1   1430.5 1456.5
## - DIST_WATER  1   1431.1 1457.1
## - DIST_4LNE_  1   1433.2 1459.2
## - PCT_POV_90  1   1433.3 1459.3
## - CITBORO_10  1   1435.0 1461.0
## - DIST_PASSR  1   1436.6 1462.6
## - DIST_PARKS  1   1442.9 1468.9
## - REGRAIL300  1   1448.6 1474.6
## 
## Step:  AIC=1451.92
## CHNG_URB ~ REGRAIL300 + RAILSTN100 + CITBORO_10 + POPDEN90 + 
##     MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_WATER
## 
##              Df Deviance    AIC
## <none>            1425.9 1451.9
## - RAILSTN100  1   1428.3 1452.3
## - PCT_SFHOME  1   1428.7 1452.7
## - MEDHSEVAL_  1   1429.0 1453.0
## - POPDEN90    1   1429.6 1453.6
## - PCT_WHITE_  1   1431.4 1455.4
## - DIST_WATER  1   1432.0 1456.0
## - PCT_POV_90  1   1434.2 1458.2
## - CITBORO_10  1   1436.5 1460.5
## - DIST_PASSR  1   1437.2 1461.2
## - DIST_PARKS  1   1443.5 1467.5
## - REGRAIL300  1   1449.8 1473.8
## - DIST_4LNE_  1   1462.5 1486.5
```

```
## 
## Call:  glm(formula = CHNG_URB ~ REGRAIL300 + RAILSTN100 + CITBORO_10 + 
##     POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
##     DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, 
##     data = na.omit(Chester_L_Final))
## 
## Coefficients:
## (Intercept)   REGRAIL300   RAILSTN100   CITBORO_10     POPDEN90   MEDHSEVAL_  
##   1.581e+00    8.909e-01    6.472e-01    8.148e-01    1.585e-04    2.607e-06  
##  PCT_WHITE_   PCT_SFHOME   PCT_POV_90   DIST_PASSR   DIST_4LNE_   DIST_PARKS  
##  -2.979e-02   -1.034e-02   -8.746e-02   -1.912e-04   -3.217e-04   -1.490e-04  
##  DIST_WATER  
##   8.030e-05  
## 
## Degrees of Freedom: 5493 Total (i.e. Null);  5481 Residual
## Null Deviance:	    1763 
## Residual Deviance: 1426 	AIC: 1452
```

```r
#Forward Selection
fullmod<-glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + POPDEN90 + MEDINC90 + MEDHSEVAL_+ PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + PCT_HSB_19 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, data = na.omit(Chester_L_Final))

intonly<-glm(CHNG_URB ~ 1, family = binomial, data = na.omit(Chester_L_Final))

step(intonly, scope=list(lower=intonly, upper=fullmod), direction="forward")
```

```
## Start:  AIC=1765.48
## CHNG_URB ~ 1
## 
##              Df Deviance    AIC
## + DIST_4LNE_  1   1580.4 1584.4
## + FOURLNE300  1   1612.0 1616.0
## + REGRAIL300  1   1614.2 1618.2
## + DIST_PASSR  1   1653.6 1657.6
## + POPDEN90    1   1715.2 1719.2
## + INTERST800  1   1718.1 1722.1
## + CITBORO_10  1   1723.6 1727.6
## + RAILSTN100  1   1725.0 1729.0
## + DIST_PARKS  1   1725.2 1729.2
## + PCT_POV_90  1   1737.1 1741.1
## + MEDHSEVAL_  1   1738.4 1742.4
## + DIST_WATER  1   1743.3 1747.3
## + MEDINC90    1   1745.3 1749.3
## + PCT_HSB_19  1   1749.9 1753.9
## + PCT_WHITE_  1   1755.3 1759.3
## + PCT_SFHOME  1   1760.5 1764.5
## <none>            1763.5 1765.5
## 
## Step:  AIC=1584.44
## CHNG_URB ~ DIST_4LNE_
## 
##              Df Deviance    AIC
## + REGRAIL300  1   1510.0 1516.0
## + DIST_PASSR  1   1545.6 1551.6
## + CITBORO_10  1   1553.3 1559.3
## + POPDEN90    1   1554.6 1560.6
## + DIST_PARKS  1   1559.0 1565.0
## + RAILSTN100  1   1561.0 1567.0
## + INTERST800  1   1562.3 1568.3
## + PCT_POV_90  1   1572.8 1578.8
## + MEDHSEVAL_  1   1573.8 1579.8
## + DIST_WATER  1   1575.2 1581.2
## + PCT_SFHOME  1   1575.7 1581.7
## <none>            1580.4 1584.4
## + PCT_HSB_19  1   1578.6 1584.6
## + FOURLNE300  1   1578.7 1584.7
## + MEDINC90    1   1579.3 1585.3
## + PCT_WHITE_  1   1580.3 1586.3
## 
## Step:  AIC=1515.98
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300
## 
##              Df Deviance    AIC
## + CITBORO_10  1   1482.1 1490.1
## + DIST_PASSR  1   1492.0 1500.0
## + POPDEN90    1   1492.5 1500.5
## + DIST_PARKS  1   1493.0 1501.0
## + PCT_SFHOME  1   1504.1 1512.1
## + RAILSTN100  1   1504.4 1512.4
## + PCT_HSB_19  1   1506.5 1514.5
## <none>            1510.0 1516.0
## + PCT_POV_90  1   1508.0 1516.0
## + FOURLNE300  1   1508.5 1516.5
## + MEDHSEVAL_  1   1508.8 1516.8
## + PCT_WHITE_  1   1509.2 1517.2
## + INTERST800  1   1509.3 1517.3
## + DIST_WATER  1   1509.5 1517.5
## + MEDINC90    1   1509.6 1517.6
## 
## Step:  AIC=1490.12
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10
## 
##              Df Deviance    AIC
## + DIST_PARKS  1   1466.9 1476.9
## + DIST_PASSR  1   1473.2 1483.2
## + POPDEN90    1   1473.7 1483.7
## + PCT_POV_90  1   1476.0 1486.0
## + RAILSTN100  1   1477.9 1487.9
## + MEDHSEVAL_  1   1478.1 1488.1
## <none>            1482.1 1490.1
## + INTERST800  1   1480.2 1490.2
## + PCT_SFHOME  1   1480.3 1490.3
## + FOURLNE300  1   1481.3 1491.3
## + DIST_WATER  1   1481.4 1491.4
## + MEDINC90    1   1481.8 1491.8
## + PCT_HSB_19  1   1482.1 1492.1
## + PCT_WHITE_  1   1482.1 1492.1
## 
## Step:  AIC=1476.88
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS
## 
##              Df Deviance    AIC
## + DIST_PASSR  1   1457.4 1469.4
## + DIST_WATER  1   1459.9 1471.9
## + POPDEN90    1   1460.1 1472.1
## + RAILSTN100  1   1463.2 1475.2
## + PCT_POV_90  1   1463.5 1475.5
## + MEDHSEVAL_  1   1463.8 1475.8
## + PCT_SFHOME  1   1464.9 1476.9
## <none>            1466.9 1476.9
## + FOURLNE300  1   1465.9 1477.9
## + PCT_WHITE_  1   1466.4 1478.4
## + PCT_HSB_19  1   1466.6 1478.6
## + INTERST800  1   1466.6 1478.6
## + MEDINC90    1   1466.9 1478.9
## 
## Step:  AIC=1469.44
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR
## 
##              Df Deviance    AIC
## + DIST_WATER  1   1447.6 1461.6
## + POPDEN90    1   1451.1 1465.1
## + MEDHSEVAL_  1   1451.2 1465.2
## + PCT_POV_90  1   1452.6 1466.6
## + RAILSTN100  1   1453.3 1467.3
## <none>            1457.4 1469.4
## + INTERST800  1   1456.1 1470.1
## + FOURLNE300  1   1456.3 1470.3
## + PCT_SFHOME  1   1456.7 1470.7
## + MEDINC90    1   1457.0 1471.0
## + PCT_HSB_19  1   1457.0 1471.0
## + PCT_WHITE_  1   1457.3 1471.3
## 
## Step:  AIC=1461.63
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER
## 
##              Df Deviance    AIC
## + POPDEN90    1   1442.6 1458.6
## + PCT_POV_90  1   1443.8 1459.8
## + RAILSTN100  1   1443.9 1459.9
## + MEDHSEVAL_  1   1445.3 1461.3
## <none>            1447.6 1461.6
## + PCT_SFHOME  1   1446.5 1462.5
## + PCT_WHITE_  1   1446.7 1462.7
## + FOURLNE300  1   1446.7 1462.7
## + INTERST800  1   1447.4 1463.4
## + PCT_HSB_19  1   1447.4 1463.4
## + MEDINC90    1   1447.6 1463.6
## 
## Step:  AIC=1458.59
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER + POPDEN90
## 
##              Df Deviance    AIC
## + PCT_POV_90  1   1437.9 1455.9
## + RAILSTN100  1   1439.4 1457.4
## + MEDHSEVAL_  1   1439.8 1457.8
## <none>            1442.6 1458.6
## + FOURLNE300  1   1441.7 1459.7
## + PCT_WHITE_  1   1441.9 1459.9
## + INTERST800  1   1442.2 1460.2
## + PCT_SFHOME  1   1442.3 1460.3
## + MEDINC90    1   1442.6 1460.6
## + PCT_HSB_19  1   1442.6 1460.6
## 
## Step:  AIC=1455.88
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER + POPDEN90 + PCT_POV_90
## 
##              Df Deviance    AIC
## + PCT_WHITE_  1   1433.9 1453.9
## + RAILSTN100  1   1434.7 1454.7
## <none>            1437.9 1455.9
## + PCT_SFHOME  1   1436.0 1456.0
## + MEDHSEVAL_  1   1436.7 1456.7
## + FOURLNE300  1   1437.0 1457.0
## + PCT_HSB_19  1   1437.1 1457.1
## + MEDINC90    1   1437.5 1457.5
## + INTERST800  1   1437.7 1457.7
## 
## Step:  AIC=1453.88
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER + POPDEN90 + PCT_POV_90 + PCT_WHITE_
## 
##              Df Deviance    AIC
## + RAILSTN100  1   1430.8 1452.8
## + PCT_SFHOME  1   1431.3 1453.3
## <none>            1433.9 1453.9
## + MEDHSEVAL_  1   1431.9 1453.9
## + FOURLNE300  1   1433.0 1455.0
## + PCT_HSB_19  1   1433.1 1455.1
## + INTERST800  1   1433.2 1455.2
## + MEDINC90    1   1433.6 1455.6
## 
## Step:  AIC=1452.83
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER + POPDEN90 + PCT_POV_90 + PCT_WHITE_ + 
##     RAILSTN100
## 
##              Df Deviance    AIC
## + MEDHSEVAL_  1   1428.7 1452.7
## <none>            1430.8 1452.8
## + PCT_SFHOME  1   1429.0 1453.0
## + FOURLNE300  1   1429.8 1453.8
## + INTERST800  1   1430.1 1454.1
## + PCT_HSB_19  1   1430.4 1454.4
## + MEDINC90    1   1430.7 1454.7
## 
## Step:  AIC=1452.72
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER + POPDEN90 + PCT_POV_90 + PCT_WHITE_ + 
##     RAILSTN100 + MEDHSEVAL_
## 
##              Df Deviance    AIC
## + PCT_SFHOME  1   1425.9 1451.9
## + MEDINC90    1   1426.2 1452.2
## <none>            1428.7 1452.7
## + FOURLNE300  1   1427.8 1453.8
## + PCT_HSB_19  1   1428.1 1454.1
## + INTERST800  1   1428.2 1454.2
## 
## Step:  AIC=1451.92
## CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + DIST_PARKS + 
##     DIST_PASSR + DIST_WATER + POPDEN90 + PCT_POV_90 + PCT_WHITE_ + 
##     RAILSTN100 + MEDHSEVAL_ + PCT_SFHOME
## 
##              Df Deviance    AIC
## <none>            1425.9 1451.9
## + FOURLNE300  1   1425.1 1453.1
## + INTERST800  1   1425.4 1453.4
## + MEDINC90    1   1425.5 1453.5
## + PCT_HSB_19  1   1425.5 1453.5
```

```
## 
## Call:  glm(formula = CHNG_URB ~ DIST_4LNE_ + REGRAIL300 + CITBORO_10 + 
##     DIST_PARKS + DIST_PASSR + DIST_WATER + POPDEN90 + PCT_POV_90 + 
##     PCT_WHITE_ + RAILSTN100 + MEDHSEVAL_ + PCT_SFHOME, family = binomial, 
##     data = na.omit(Chester_L_Final))
## 
## Coefficients:
## (Intercept)   DIST_4LNE_   REGRAIL300   CITBORO_10   DIST_PARKS   DIST_PASSR  
##   1.581e+00   -3.217e-04    8.909e-01    8.148e-01   -1.490e-04   -1.912e-04  
##  DIST_WATER     POPDEN90   PCT_POV_90   PCT_WHITE_   RAILSTN100   MEDHSEVAL_  
##   8.030e-05    1.585e-04   -8.746e-02   -2.979e-02    6.472e-01    2.607e-06  
##  PCT_SFHOME  
##  -1.034e-02  
## 
## Degrees of Freedom: 5493 Total (i.e. Null);  5481 Residual
## Null Deviance:	    1763 
## Residual Deviance: 1426 	AIC: 1452
```

The best result is given by both the backward and forward selections, with the lowest AIC of 1452. The variables included in the model are DIST_4LNE_, REGRAIL300, CITBORO_10, DIST_PARKS, DIST_PASSR, DIST_WATER, POPDEN90, PCT_POV_90, PCT_WHITE_, RAILSTN100, MEDHSEVAL_, PCT_SFHOME. The forward selection also omitted any row that contains NA, so there are less observations. 


```r
bi_model3 <- glm(CHNG_URB ~ REGRAIL300 + RAILSTN100 + CITBORO_10 + 
POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, data = na.omit(Chester_L_Final))

summary(bi_model3)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ REGRAIL300 + RAILSTN100 + CITBORO_10 + 
##     POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
##     DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, 
##     data = na.omit(Chester_L_Final))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3087  -0.2764  -0.1764  -0.0934   3.4311  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.581e+00  1.333e+00   1.186 0.235462    
## REGRAIL300   8.909e-01  1.787e-01   4.986 6.17e-07 ***
## RAILSTN100   6.472e-01  4.063e-01   1.593 0.111179    
## CITBORO_10   8.148e-01  2.390e-01   3.409 0.000653 ***
## POPDEN90     1.585e-04  7.935e-05   1.998 0.045737 *  
## MEDHSEVAL_   2.607e-06  1.474e-06   1.768 0.076982 .  
## PCT_WHITE_  -2.979e-02  1.217e-02  -2.449 0.014339 *  
## PCT_SFHOME  -1.034e-02  6.054e-03  -1.707 0.087775 .  
## PCT_POV_90  -8.746e-02  3.216e-02  -2.720 0.006529 ** 
## DIST_PASSR  -1.912e-04  5.960e-05  -3.208 0.001334 ** 
## DIST_4LNE_  -3.217e-04  5.720e-05  -5.624 1.87e-08 ***
## DIST_PARKS  -1.490e-04  3.732e-05  -3.993 6.54e-05 ***
## DIST_WATER   8.030e-05  3.271e-05   2.455 0.014098 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1763.5  on 5493  degrees of freedom
## Residual deviance: 1425.9  on 5481  degrees of freedom
## AIC: 1451.9
## 
## Number of Fisher Scoring iterations: 7
```

```r
#Delete the insignificant variable RAILSTN100

bi_model3 <- glm(CHNG_URB ~ REGRAIL300 + CITBORO_10 + 
POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, data = na.omit(Chester_L_Final))

summary(bi_model3)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ REGRAIL300 + CITBORO_10 + POPDEN90 + 
##     MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_WATER, family = binomial, 
##     data = na.omit(Chester_L_Final))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3642  -0.2755  -0.1756  -0.0925   3.4395  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  1.753e+00  1.323e+00   1.324 0.185349    
## REGRAIL300   9.513e-01  1.731e-01   5.497 3.87e-08 ***
## CITBORO_10   8.236e-01  2.380e-01   3.460 0.000539 ***
## POPDEN90     1.627e-04  7.882e-05   2.064 0.039032 *  
## MEDHSEVAL_   2.579e-06  1.467e-06   1.758 0.078815 .  
## PCT_WHITE_  -3.047e-02  1.214e-02  -2.510 0.012082 *  
## PCT_SFHOME  -1.146e-02  5.942e-03  -1.928 0.053873 .  
## PCT_POV_90  -8.999e-02  3.210e-02  -2.804 0.005051 ** 
## DIST_PASSR  -1.857e-04  5.934e-05  -3.129 0.001753 ** 
## DIST_4LNE_  -3.259e-04  5.721e-05  -5.697 1.22e-08 ***
## DIST_PARKS  -1.522e-04  3.740e-05  -4.071 4.69e-05 ***
## DIST_WATER   8.196e-05  3.268e-05   2.508 0.012136 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1763.5  on 5493  degrees of freedom
## Residual deviance: 1428.3  on 5482  degrees of freedom
## AIC: 1452.3
## 
## Number of Fisher Scoring iterations: 7
```

## Goodness of fit

From the model summary above, we know that the degree freedom is 5493. We calculated the model fitness using ChiSq. 


```r
qchisq(.95, df=5493) 
```

```
## [1] 5666.533
```

The critical value is 5666.533. The null deviance value of the model (1763.5) is much lower than the critical value, meaning our predicted results will have no significant difference from the observations.


```r
model3_fitness <- gof(bi_model3, plotROC = FALSE)

model3_fitness$gof
```

```
##          test  stat        val df         pVal
## 1:         HL chiSq  6.2878215  8 6.150261e-01
## 2:        mHL     F  6.1202125  9 1.305332e-08
## 3:       OsRo     Z -0.6968019 NA 4.859268e-01
## 4: SstPgeq0.5     Z  1.8123489 NA 6.993230e-02
## 5:   SstPl0.5     Z  1.9817348 NA 4.750893e-02
## 6:    SstBoth chiSq  7.2118815  2 2.716188e-02
## 7: SllPgeq0.5 chiSq  9.3139124  1 2.274203e-03
## 8:   SllPl0.5 chiSq  4.3522053  1 3.696106e-02
## 9:    SllBoth chiSq 11.4126946  2 3.324795e-03
```

## Model Results 


```r
exp(coef(bi_model3))
```

```
## (Intercept)  REGRAIL300  CITBORO_10    POPDEN90  MEDHSEVAL_  PCT_WHITE_ 
##   5.7697776   2.5891393   2.2787262   1.0001627   1.0000026   0.9699867 
##  PCT_SFHOME  PCT_POV_90  DIST_PASSR  DIST_4LNE_  DIST_PARKS  DIST_WATER 
##   0.9886093   0.9139362   0.9998143   0.9996742   0.9998478   1.0000820
```

```r
100 * (exp(coef(bi_model3))-1)
```

```
##   (Intercept)    REGRAIL300    CITBORO_10      POPDEN90    MEDHSEVAL_ 
##  4.769778e+02  1.589139e+02  1.278726e+02  1.626796e-02  2.579135e-04 
##    PCT_WHITE_    PCT_SFHOME    PCT_POV_90    DIST_PASSR    DIST_4LNE_ 
## -3.001326e+00 -1.139073e+00 -8.606384e+00 -1.856605e-02 -3.258445e-02 
##    DIST_PARKS    DIST_WATER 
## -1.522334e-02  8.196203e-03
```

Several goodness of fit tests, suggest that the model's predicted results are in the reasonable range similar to that of the original data (with the p-values greater than 5%).

According to the model, the most important factors that explains the land use change between 1992 and 2001 are, from greatest to least, 1) if the location is within 300 meters of a SPETA regional rail line, 2) if the location is within 1,000 meters of a city or boro, 3) the location's percent of households living below poverty line in 1990, and 4) the location's percent of white households. These three factors have the largest impact on the possibility of a location being urbanized. 

Every percentage increase in households living below poverty line is associated with a 8% decrease in the odd ratio. The odd ratio is the possibility of success over possibility of failure. A decrease in the odd ratio means that the location will households less chance to turn into a urban area when the percent of households living in poverty increases. 

In the same way, for every percent of increase in white population, there is a 3% decrease in chance of successfully being urbanized.

If a location is within the 300 meters of a SPETA regional railway, it will have 159% increase in the chance of being urbanized comparing to those that are outside of the range. 

If a location is within 1000 meters of another city or boro, the chance of being urbanized is increased by 128%. 

## Model Improvement

The statistic summary shows that majority of Chester County has high income and low poverty rate. This might suggest that the distribution of these variables might be skewed. 


```r
Chester_Numeric %>%
  gather(Variable, Value) %>%
  ggplot(aes(Value)) + 
    geom_histogram(bins = 30, color="blue", fill="blue", alpha=0.2) + 
    facet_wrap(~Variable, scales = 'free')+
    labs(title = "Distribution of Variables") + ylab("Count")  +
  theme(panel.background = element_rect(colour = "grey50", size=3))
```

![](Hu_Duan_Assignment3_April22_files/figure-html/distribution-1.png)<!-- -->

Most of the data are highly skewed. We created some dummy variables to adjust the dataset. 

The thresholds for the new binary variables are based on their median value in the dataset. 


```r
summary(Chester_Numeric)

# REGRAIL300 + CITBORO_10 + 
# POPDEN90 + MEDHSEVAL_ + PCT_WHITE_ + PCT_SFHOME + PCT_POV_90 + 
# DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER

Chester_bi <-
  Chester_L_Final%>%
  mutate(bi_POV_less4 = case_when(PCT_POV_90 < 4 ~ 1, TRUE ~ 0),
         bi_POPDEN_less60 = case_when(POPDEN90 < 60 ~ 1, TRUE ~ 0),
         bi_WHITE_less97 = case_when(PCT_WHITE_ < 97 ~ 1, TRUE ~ 0),
         bi_SFHOME = case_when(PCT_SFHOME < 86 ~ 1, TRUE ~ 0))
```


```r
#Replace log infinite with NA
Chester_bi <- do.call(data.frame,                      
               lapply(Chester_bi,
              function(x) replace(x, is.infinite(x), NA)))

#Model
bi_model_bi <- glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + PARKS500M + WATER100 + 
bi_POPDEN_less60 + MEDHSEVAL_ + bi_WHITE_less97 + bi_SFHOME + bi_POV_less4  + DIST_PASSR + DIST_4LNE_ + DIST_PARKS  + DIST_WATER + DIST_RAILS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE + MEDINC90 , family = binomial, data = na.omit(Chester_bi))

summary(bi_model_bi)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + 
##     RAILSTN100 + CITBORO_10 + PARKS500M + WATER100 + bi_POPDEN_less60 + 
##     MEDHSEVAL_ + bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + 
##     DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER + DIST_RAILS + 
##     DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE + MEDINC90, 
##     family = binomial, data = na.omit(Chester_bi))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.4204  -0.2662  -0.1513  -0.0847   3.2871  
## 
## Coefficients: (2 not defined because of singularities)
##                    Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      -2.645e+00  8.085e-01  -3.272 0.001068 ** 
## FOURLNE300        3.350e-01  3.467e-01   0.966 0.333921    
## INTERST800        2.924e-01  2.768e-01   1.056 0.290790    
## REGRAIL300        3.157e-01  2.605e-01   1.212 0.225590    
## RAILSTN100        4.492e-01  4.272e-01   1.051 0.293093    
## CITBORO_10        4.939e-01  2.603e-01   1.898 0.057735 .  
## PARKS500M                NA         NA      NA       NA    
## WATER100                 NA         NA      NA       NA    
## bi_POPDEN_less60 -7.440e-01  1.974e-01  -3.769 0.000164 ***
## MEDHSEVAL_        7.207e-07  1.889e-06   0.382 0.702785    
## bi_WHITE_less97   6.023e-01  1.946e-01   3.095 0.001970 ** 
## bi_SFHOME         4.004e-01  2.217e-01   1.806 0.070938 .  
## bi_POV_less4      7.059e-01  2.137e-01   3.303 0.000956 ***
## DIST_PASSR       -1.379e-04  6.743e-05  -2.044 0.040908 *  
## DIST_4LNE_       -2.581e-04  9.219e-05  -2.800 0.005107 ** 
## DIST_PARKS       -1.244e-04  4.209e-05  -2.956 0.003121 ** 
## DIST_WATER        1.866e-05  3.576e-05   0.522 0.601786    
## DIST_RAILS        1.821e-04  1.577e-04   1.155 0.248235    
## DIST_REGRA       -2.580e-04  1.622e-04  -1.591 0.111706    
## DIST_INTER        2.856e-05  2.358e-05   1.211 0.225824    
## PCT_HSB_19        1.617e-02  7.314e-03   2.211 0.027047 *  
## SLOPE            -1.123e-01  5.172e-02  -2.171 0.029963 *  
## MEDINC90         -3.646e-06  9.342e-06  -0.390 0.696354    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1763.5  on 5493  degrees of freedom
## Residual deviance: 1376.2  on 5473  degrees of freedom
## AIC: 1418.2
## 
## Number of Fisher Scoring iterations: 8
```

Just by creating dummy variables, even before variable selection, the model's AIC is reduced by 200. Some of the variables are co-linear with each other, we removed them from the final model.


```r
#Backward Selection Log

step(glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + PARKS500M + WATER100 + 
bi_POPDEN_less60 + MEDHSEVAL_ + bi_WHITE_less97 + bi_SFHOME + bi_POV_less4  + DIST_PASSR + DIST_4LNE_ + DIST_PARKS  + DIST_WATER + DIST_RAILS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE + MEDINC90 , family = binomial, data = na.omit(Chester_bi)))
```

```
## Start:  AIC=1418.15
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + PARKS500M + WATER100 + bi_POPDEN_less60 + MEDHSEVAL_ + 
##     bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_WATER + DIST_RAILS + DIST_REGRA + 
##     DIST_INTER + PCT_HSB_19 + SLOPE + MEDINC90
## 
## 
## Step:  AIC=1418.15
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + PARKS500M + bi_POPDEN_less60 + MEDHSEVAL_ + 
##     bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_WATER + DIST_RAILS + DIST_REGRA + 
##     DIST_INTER + PCT_HSB_19 + SLOPE + MEDINC90
## 
## 
## Step:  AIC=1418.15
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + bi_POPDEN_less60 + MEDHSEVAL_ + bi_WHITE_less97 + 
##     bi_SFHOME + bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + 
##     DIST_WATER + DIST_RAILS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + 
##     SLOPE + MEDINC90
## 
##                    Df Deviance    AIC
## - MEDHSEVAL_        1   1376.3 1416.3
## - MEDINC90          1   1376.3 1416.3
## - DIST_WATER        1   1376.4 1416.4
## - FOURLNE300        1   1377.1 1417.1
## - RAILSTN100        1   1377.2 1417.2
## - INTERST800        1   1377.3 1417.3
## - DIST_RAILS        1   1377.5 1417.5
## - REGRAIL300        1   1377.6 1417.6
## - DIST_INTER        1   1377.6 1417.6
## <none>                  1376.2 1418.2
## - DIST_REGRA        1   1378.6 1418.6
## - bi_SFHOME         1   1379.5 1419.5
## - CITBORO_10        1   1379.6 1419.6
## - DIST_PASSR        1   1380.5 1420.5
## - PCT_HSB_19        1   1381.0 1421.0
## - SLOPE             1   1381.1 1421.1
## - DIST_4LNE_        1   1384.4 1424.4
## - DIST_PARKS        1   1385.3 1425.3
## - bi_WHITE_less97   1   1386.1 1426.1
## - bi_POV_less4      1   1387.7 1427.7
## - bi_POPDEN_less60  1   1391.8 1431.8
## 
## Step:  AIC=1416.3
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + bi_POPDEN_less60 + bi_WHITE_less97 + bi_SFHOME + 
##     bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER + 
##     DIST_RAILS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE + 
##     MEDINC90
## 
##                    Df Deviance    AIC
## - MEDINC90          1   1376.3 1414.3
## - DIST_WATER        1   1376.7 1414.7
## - FOURLNE300        1   1377.3 1415.3
## - RAILSTN100        1   1377.3 1415.3
## - INTERST800        1   1377.5 1415.5
## - DIST_RAILS        1   1377.7 1415.7
## - REGRAIL300        1   1377.8 1415.8
## - DIST_INTER        1   1377.8 1415.8
## <none>                  1376.3 1416.3
## - DIST_REGRA        1   1378.8 1416.8
## - CITBORO_10        1   1379.6 1417.6
## - bi_SFHOME         1   1379.9 1417.9
## - DIST_PASSR        1   1380.5 1418.5
## - SLOPE             1   1381.2 1419.2
## - PCT_HSB_19        1   1381.7 1419.7
## - DIST_4LNE_        1   1384.5 1422.5
## - DIST_PARKS        1   1385.6 1423.6
## - bi_WHITE_less97   1   1386.4 1424.4
## - bi_POV_less4      1   1388.6 1426.6
## - bi_POPDEN_less60  1   1392.1 1430.1
## 
## Step:  AIC=1414.35
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + bi_POPDEN_less60 + bi_WHITE_less97 + bi_SFHOME + 
##     bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_WATER + 
##     DIST_RAILS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE
## 
##                    Df Deviance    AIC
## - DIST_WATER        1   1376.7 1412.7
## - FOURLNE300        1   1377.3 1413.3
## - RAILSTN100        1   1377.4 1413.4
## - INTERST800        1   1377.5 1413.5
## - DIST_RAILS        1   1377.7 1413.7
## - REGRAIL300        1   1377.8 1413.8
## - DIST_INTER        1   1377.9 1413.9
## <none>                  1376.3 1414.3
## - DIST_REGRA        1   1378.9 1414.9
## - CITBORO_10        1   1379.8 1415.8
## - DIST_PASSR        1   1380.5 1416.5
## - SLOPE             1   1381.3 1417.3
## - bi_SFHOME         1   1382.8 1418.8
## - PCT_HSB_19        1   1382.8 1418.8
## - DIST_4LNE_        1   1384.5 1420.5
## - DIST_PARKS        1   1385.6 1421.6
## - bi_WHITE_less97   1   1386.5 1422.5
## - bi_POV_less4      1   1388.8 1424.8
## - bi_POPDEN_less60  1   1392.2 1428.2
## 
## Step:  AIC=1412.68
## CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + 
##     CITBORO_10 + bi_POPDEN_less60 + bi_WHITE_less97 + bi_SFHOME + 
##     bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_RAILS + 
##     DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE
## 
##                    Df Deviance    AIC
## - FOURLNE300        1   1377.7 1411.7
## - RAILSTN100        1   1377.7 1411.7
## - INTERST800        1   1378.0 1412.0
## - DIST_INTER        1   1378.2 1412.2
## - REGRAIL300        1   1378.3 1412.3
## - DIST_RAILS        1   1378.4 1412.4
## <none>                  1376.7 1412.7
## - DIST_REGRA        1   1379.7 1413.7
## - CITBORO_10        1   1380.1 1414.1
## - DIST_PASSR        1   1380.6 1414.6
## - SLOPE             1   1382.3 1416.3
## - bi_SFHOME         1   1383.2 1417.2
## - PCT_HSB_19        1   1383.6 1417.6
## - DIST_4LNE_        1   1385.2 1419.2
## - DIST_PARKS        1   1386.3 1420.3
## - bi_WHITE_less97   1   1388.1 1422.1
## - bi_POV_less4      1   1389.9 1423.9
## - bi_POPDEN_less60  1   1392.9 1426.9
## 
## Step:  AIC=1411.7
## CHNG_URB ~ INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + 
##     bi_POPDEN_less60 + bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + 
##     DIST_PASSR + DIST_4LNE_ + DIST_PARKS + DIST_RAILS + DIST_REGRA + 
##     DIST_INTER + PCT_HSB_19 + SLOPE
## 
##                    Df Deviance    AIC
## - RAILSTN100        1   1378.7 1410.7
## - INTERST800        1   1379.1 1411.1
## - REGRAIL300        1   1379.3 1411.3
## - DIST_INTER        1   1379.4 1411.4
## - DIST_RAILS        1   1379.4 1411.4
## <none>                  1377.7 1411.7
## - DIST_REGRA        1   1380.7 1412.7
## - DIST_PASSR        1   1381.4 1413.4
## - CITBORO_10        1   1381.5 1413.5
## - SLOPE             1   1383.2 1415.2
## - bi_SFHOME         1   1384.3 1416.3
## - PCT_HSB_19        1   1384.5 1416.5
## - DIST_PARKS        1   1387.3 1419.3
## - bi_WHITE_less97   1   1389.3 1421.3
## - bi_POV_less4      1   1391.2 1423.2
## - bi_POPDEN_less60  1   1394.0 1426.0
## - DIST_4LNE_        1   1419.1 1451.1
## 
## Step:  AIC=1410.69
## CHNG_URB ~ INTERST800 + REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + 
##     bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_RAILS + DIST_REGRA + DIST_INTER + 
##     PCT_HSB_19 + SLOPE
## 
##                    Df Deviance    AIC
## - DIST_RAILS        1   1380.0 1410.0
## - INTERST800        1   1380.2 1410.2
## - DIST_INTER        1   1380.4 1410.4
## <none>                  1378.7 1410.7
## - REGRAIL300        1   1380.7 1410.7
## - DIST_REGRA        1   1381.3 1411.3
## - DIST_PASSR        1   1382.2 1412.2
## - CITBORO_10        1   1382.4 1412.4
## - SLOPE             1   1384.1 1414.1
## - PCT_HSB_19        1   1386.1 1416.1
## - bi_SFHOME         1   1386.3 1416.3
## - DIST_PARKS        1   1388.5 1418.5
## - bi_WHITE_less97   1   1390.9 1420.9
## - bi_POV_less4      1   1392.7 1422.7
## - bi_POPDEN_less60  1   1395.2 1425.2
## - DIST_4LNE_        1   1420.9 1450.9
## 
## Step:  AIC=1410.04
## CHNG_URB ~ INTERST800 + REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + 
##     bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + 
##     SLOPE
## 
##                    Df Deviance    AIC
## - DIST_INTER        1   1381.4 1409.4
## - INTERST800        1   1381.5 1409.5
## <none>                  1380.0 1410.0
## - REGRAIL300        1   1382.3 1410.3
## - CITBORO_10        1   1383.8 1411.8
## - DIST_PASSR        1   1384.5 1412.5
## - SLOPE             1   1385.7 1413.7
## - PCT_HSB_19        1   1386.7 1414.7
## - bi_SFHOME         1   1387.1 1415.1
## - DIST_REGRA        1   1388.6 1416.6
## - DIST_PARKS        1   1388.8 1416.8
## - bi_WHITE_less97   1   1391.6 1419.6
## - bi_POV_less4      1   1394.2 1422.2
## - bi_POPDEN_less60  1   1396.6 1424.6
## - DIST_4LNE_        1   1422.2 1450.2
## 
## Step:  AIC=1409.36
## CHNG_URB ~ INTERST800 + REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + 
##     bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_REGRA + PCT_HSB_19 + SLOPE
## 
##                    Df Deviance    AIC
## - INTERST800        1   1381.7 1407.7
## <none>                  1381.4 1409.4
## - CITBORO_10        1   1385.3 1411.3
## - REGRAIL300        1   1386.0 1412.0
## - DIST_PASSR        1   1386.5 1412.5
## - bi_SFHOME         1   1387.8 1413.8
## - SLOPE             1   1387.8 1413.8
## - PCT_HSB_19        1   1387.9 1413.9
## - DIST_PARKS        1   1388.9 1414.9
## - DIST_REGRA        1   1391.8 1417.8
## - bi_WHITE_less97   1   1394.7 1420.7
## - bi_POV_less4      1   1394.7 1420.7
## - bi_POPDEN_less60  1   1398.9 1424.9
## - DIST_4LNE_        1   1425.5 1451.5
## 
## Step:  AIC=1407.65
## CHNG_URB ~ REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + bi_WHITE_less97 + 
##     bi_SFHOME + bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + 
##     DIST_REGRA + PCT_HSB_19 + SLOPE
## 
##                    Df Deviance    AIC
## <none>                  1381.7 1407.7
## - CITBORO_10        1   1385.5 1409.5
## - DIST_PASSR        1   1386.6 1410.6
## - REGRAIL300        1   1387.4 1411.4
## - SLOPE             1   1388.0 1412.0
## - bi_SFHOME         1   1388.3 1412.3
## - PCT_HSB_19        1   1388.5 1412.5
## - DIST_PARKS        1   1389.5 1413.5
## - DIST_REGRA        1   1393.8 1417.8
## - bi_WHITE_less97   1   1394.7 1418.7
## - bi_POV_less4      1   1395.9 1419.9
## - bi_POPDEN_less60  1   1399.0 1423.0
## - DIST_4LNE_        1   1426.4 1450.4
```

```
## 
## Call:  glm(formula = CHNG_URB ~ REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + 
##     bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + 
##     DIST_4LNE_ + DIST_PARKS + DIST_REGRA + PCT_HSB_19 + SLOPE, 
##     family = binomial, data = na.omit(Chester_bi))
## 
## Coefficients:
##      (Intercept)        REGRAIL300        CITBORO_10  bi_POPDEN_less60  
##       -2.058e+00         5.374e-01         5.143e-01        -7.720e-01  
##  bi_WHITE_less97         bi_SFHOME      bi_POV_less4        DIST_PASSR  
##        6.455e-01         4.322e-01         7.283e-01        -1.372e-04  
##       DIST_4LNE_        DIST_PARKS        DIST_REGRA        PCT_HSB_19  
##       -3.400e-04        -9.565e-05        -5.521e-05         1.718e-02  
##            SLOPE  
##       -1.233e-01  
## 
## Degrees of Freedom: 5493 Total (i.e. Null);  5481 Residual
## Null Deviance:	    1763 
## Residual Deviance: 1382 	AIC: 1408
```

```r
#Forward Selection log
fullmod2<-glm(glm(CHNG_URB ~ FOURLNE300 + INTERST800 + REGRAIL300 + RAILSTN100 + CITBORO_10 + PARKS500M + WATER100 + 
bi_POPDEN_less60 + MEDHSEVAL_ + bi_WHITE_less97 + bi_SFHOME + bi_POV_less4  + DIST_PASSR + DIST_4LNE_ + DIST_PARKS  + DIST_WATER + DIST_RAILS + DIST_REGRA + DIST_INTER + PCT_HSB_19 + SLOPE + MEDINC90 , family = binomial, data = na.omit(Chester_bi)))

intonly2<-glm(CHNG_URB ~ 1, family = binomial, data = na.omit(Chester_bi))

step(intonly2, scope=list(lower=intonly2, upper=fullmod2), direction="forward")
```

```
## Start:  AIC=1765.48
## CHNG_URB ~ 1
## 
##                    Df Deviance    AIC
## + DIST_4LNE_        1   1580.4 1584.4
## + DIST_REGRA        1   1602.9 1606.9
## + DIST_RAILS        1   1605.1 1609.1
## + FOURLNE300        1   1612.0 1616.0
## + REGRAIL300        1   1614.2 1618.2
## + DIST_PASSR        1   1653.6 1657.6
## + bi_POPDEN_less60  1   1674.7 1678.7
## + DIST_INTER        1   1696.1 1700.1
## + bi_POV_less4      1   1705.5 1709.5
## + INTERST800        1   1718.1 1722.1
## + bi_WHITE_less97   1   1720.0 1724.0
## + CITBORO_10        1   1723.6 1727.6
## + RAILSTN100        1   1725.0 1729.0
## + DIST_PARKS        1   1725.2 1729.2
## + MEDHSEVAL_        1   1738.4 1742.4
## + DIST_WATER        1   1743.3 1747.3
## + MEDINC90          1   1745.3 1749.3
## + PCT_HSB_19        1   1749.9 1753.9
## + bi_SFHOME         1   1756.7 1760.7
## <none>                  1763.5 1765.5
## + SLOPE             1   1763.5 1767.5
## 
## Step:  AIC=1584.44
## CHNG_URB ~ DIST_4LNE_
## 
##                    Df Deviance    AIC
## + DIST_REGRA        1   1500.6 1506.6
## + DIST_RAILS        1   1501.0 1507.0
## + REGRAIL300        1   1510.0 1516.0
## + bi_POPDEN_less60  1   1522.4 1528.4
## + DIST_PASSR        1   1545.6 1551.6
## + DIST_INTER        1   1551.4 1557.4
## + bi_POV_less4      1   1553.0 1559.0
## + CITBORO_10        1   1553.3 1559.3
## + DIST_PARKS        1   1559.0 1565.0
## + RAILSTN100        1   1561.0 1567.0
## + bi_WHITE_less97   1   1562.3 1568.3
## + INTERST800        1   1562.3 1568.3
## + bi_SFHOME         1   1571.2 1577.2
## + MEDHSEVAL_        1   1573.8 1579.8
## + DIST_WATER        1   1575.2 1581.2
## <none>                  1580.4 1584.4
## + PCT_HSB_19        1   1578.6 1584.6
## + FOURLNE300        1   1578.7 1584.7
## + MEDINC90          1   1579.3 1585.3
## + SLOPE             1   1580.3 1586.3
## 
## Step:  AIC=1506.63
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA
## 
##                    Df Deviance    AIC
## + bi_POPDEN_less60  1   1466.0 1474.0
## + CITBORO_10        1   1473.2 1481.2
## + DIST_PASSR        1   1473.4 1481.4
## + bi_WHITE_less97   1   1478.8 1486.8
## + bi_SFHOME         1   1485.0 1493.0
## + REGRAIL300        1   1488.0 1496.0
## + DIST_PARKS        1   1489.8 1497.8
## + MEDINC90          1   1492.7 1500.7
## + RAILSTN100        1   1493.0 1501.0
## + PCT_HSB_19        1   1493.5 1501.5
## + DIST_INTER        1   1495.1 1503.1
## + bi_POV_less4      1   1496.7 1504.7
## <none>                  1500.6 1506.6
## + FOURLNE300        1   1498.8 1506.8
## + SLOPE             1   1498.9 1506.9
## + MEDHSEVAL_        1   1500.1 1508.1
## + DIST_WATER        1   1500.5 1508.5
## + INTERST800        1   1500.5 1508.5
## + DIST_RAILS        1   1500.6 1508.6
## 
## Step:  AIC=1473.97
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60
## 
##                   Df Deviance    AIC
## + CITBORO_10       1   1442.4 1452.4
## + DIST_PASSR       1   1443.5 1453.5
## + bi_WHITE_less97  1   1446.6 1456.6
## + bi_SFHOME        1   1452.4 1462.4
## + PCT_HSB_19       1   1454.3 1464.3
## + REGRAIL300       1   1457.4 1467.4
## + MEDINC90         1   1457.5 1467.5
## + RAILSTN100       1   1460.0 1470.0
## + DIST_PARKS       1   1460.2 1470.2
## + DIST_INTER       1   1462.7 1472.7
## <none>                 1466.0 1474.0
## + FOURLNE300       1   1464.1 1474.1
## + SLOPE            1   1464.4 1474.4
## + bi_POV_less4     1   1464.4 1474.4
## + MEDHSEVAL_       1   1465.2 1475.2
## + DIST_RAILS       1   1465.9 1475.9
## + DIST_WATER       1   1466.0 1476.0
## + INTERST800       1   1466.0 1476.0
## 
## Step:  AIC=1452.41
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10
## 
##                   Df Deviance    AIC
## + DIST_PASSR       1   1429.2 1441.2
## + bi_WHITE_less97  1   1429.8 1441.8
## + bi_SFHOME        1   1432.9 1444.9
## + REGRAIL300       1   1433.3 1445.3
## + RAILSTN100       1   1437.5 1449.5
## + DIST_PARKS       1   1437.8 1449.8
## + bi_POV_less4     1   1438.3 1450.3
## + MEDINC90         1   1439.9 1451.9
## + PCT_HSB_19       1   1440.2 1452.2
## <none>                 1442.4 1452.4
## + SLOPE            1   1440.8 1452.8
## + FOURLNE300       1   1441.3 1453.3
## + DIST_INTER       1   1441.4 1453.4
## + INTERST800       1   1441.8 1453.8
## + DIST_RAILS       1   1441.8 1453.8
## + DIST_WATER       1   1442.3 1454.3
## + MEDHSEVAL_       1   1442.4 1454.4
## 
## Step:  AIC=1441.18
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR
## 
##                   Df Deviance    AIC
## + bi_POV_less4     1   1422.1 1436.1
## + bi_WHITE_less97  1   1422.8 1436.8
## + REGRAIL300       1   1423.9 1437.9
## + DIST_PARKS       1   1423.9 1437.9
## + RAILSTN100       1   1424.3 1438.3
## + bi_SFHOME        1   1424.6 1438.6
## + SLOPE            1   1426.0 1440.0
## + PCT_HSB_19       1   1426.6 1440.6
## + INTERST800       1   1427.1 1441.1
## <none>                 1429.2 1441.2
## + MEDHSEVAL_       1   1427.9 1441.9
## + FOURLNE300       1   1427.9 1441.9
## + DIST_WATER       1   1428.2 1442.2
## + MEDINC90         1   1428.5 1442.5
## + DIST_RAILS       1   1429.1 1443.1
## + DIST_INTER       1   1429.2 1443.2
## 
## Step:  AIC=1436.1
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4
## 
##                   Df Deviance    AIC
## + bi_WHITE_less97  1   1412.7 1428.7
## + bi_SFHOME        1   1413.6 1429.6
## + REGRAIL300       1   1416.1 1432.1
## + RAILSTN100       1   1416.8 1432.8
## + PCT_HSB_19       1   1417.5 1433.5
## + MEDINC90         1   1418.0 1434.0
## + DIST_PARKS       1   1418.7 1434.7
## + SLOPE            1   1419.2 1435.2
## <none>                 1422.1 1436.1
## + FOURLNE300       1   1421.0 1437.0
## + DIST_WATER       1   1421.2 1437.2
## + INTERST800       1   1421.2 1437.2
## + DIST_INTER       1   1421.7 1437.7
## + MEDHSEVAL_       1   1422.1 1438.1
## + DIST_RAILS       1   1422.1 1438.1
## 
## Step:  AIC=1428.72
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97
## 
##              Df Deviance    AIC
## + bi_SFHOME   1   1403.3 1421.3
## + PCT_HSB_19  1   1405.4 1423.4
## + DIST_PARKS  1   1406.7 1424.7
## + MEDINC90    1   1407.4 1425.4
## + REGRAIL300  1   1408.5 1426.5
## + RAILSTN100  1   1408.6 1426.6
## + INTERST800  1   1410.0 1428.0
## + SLOPE       1   1410.4 1428.4
## <none>            1412.7 1428.7
## + FOURLNE300  1   1411.9 1429.9
## + DIST_WATER  1   1412.5 1430.5
## + DIST_INTER  1   1412.5 1430.5
## + DIST_RAILS  1   1412.7 1430.7
## + MEDHSEVAL_  1   1412.7 1430.7
## 
## Step:  AIC=1421.32
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME
## 
##              Df Deviance    AIC
## + DIST_PARKS  1   1397.2 1417.2
## + PCT_HSB_19  1   1398.2 1418.2
## + REGRAIL300  1   1400.3 1420.3
## + SLOPE       1   1400.3 1420.3
## + RAILSTN100  1   1401.2 1421.2
## <none>            1403.3 1421.3
## + INTERST800  1   1401.5 1421.5
## + FOURLNE300  1   1402.5 1422.5
## + MEDHSEVAL_  1   1402.9 1422.9
## + MEDINC90    1   1403.0 1423.0
## + DIST_RAILS  1   1403.1 1423.1
## + DIST_WATER  1   1403.2 1423.2
## + DIST_INTER  1   1403.3 1423.3
## 
## Step:  AIC=1417.19
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + 
##     DIST_PARKS
## 
##              Df Deviance    AIC
## + PCT_HSB_19  1   1392.3 1414.3
## + SLOPE       1   1393.1 1415.1
## + REGRAIL300  1   1393.8 1415.8
## + DIST_WATER  1   1394.3 1416.3
## <none>            1397.2 1417.2
## + RAILSTN100  1   1395.4 1417.4
## + INTERST800  1   1395.9 1417.9
## + FOURLNE300  1   1396.3 1418.3
## + DIST_RAILS  1   1396.4 1418.4
## + DIST_INTER  1   1396.6 1418.6
## + MEDHSEVAL_  1   1396.6 1418.6
## + MEDINC90    1   1396.8 1418.8
## 
## Step:  AIC=1414.35
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + 
##     DIST_PARKS + PCT_HSB_19
## 
##              Df Deviance    AIC
## + SLOPE       1   1387.4 1411.4
## + REGRAIL300  1   1388.0 1412.0
## + DIST_WATER  1   1389.9 1413.9
## <none>            1392.3 1414.3
## + DIST_RAILS  1   1390.9 1414.9
## + RAILSTN100  1   1391.1 1415.1
## + INTERST800  1   1391.3 1415.3
## + FOURLNE300  1   1391.4 1415.4
## + DIST_INTER  1   1391.5 1415.5
## + MEDHSEVAL_  1   1391.8 1415.8
## + MEDINC90    1   1392.3 1416.3
## 
## Step:  AIC=1411.44
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + 
##     DIST_PARKS + PCT_HSB_19 + SLOPE
## 
##              Df Deviance    AIC
## + REGRAIL300  1   1381.7 1407.7
## <none>            1387.4 1411.4
## + DIST_WATER  1   1385.9 1411.9
## + RAILSTN100  1   1385.9 1411.9
## + INTERST800  1   1386.0 1412.0
## + DIST_RAILS  1   1386.1 1412.1
## + FOURLNE300  1   1386.3 1412.3
## + MEDHSEVAL_  1   1386.9 1412.9
## + DIST_INTER  1   1387.0 1413.0
## + MEDINC90    1   1387.4 1413.4
## 
## Step:  AIC=1407.65
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + 
##     DIST_PARKS + PCT_HSB_19 + SLOPE + REGRAIL300
## 
##              Df Deviance    AIC
## <none>            1381.7 1407.7
## + DIST_RAILS  1   1380.6 1408.6
## + FOURLNE300  1   1380.7 1408.7
## + DIST_WATER  1   1380.8 1408.8
## + RAILSTN100  1   1380.9 1408.9
## + MEDHSEVAL_  1   1381.3 1409.3
## + INTERST800  1   1381.4 1409.4
## + DIST_INTER  1   1381.5 1409.5
## + MEDINC90    1   1381.7 1409.7
```

```
## 
## Call:  glm(formula = CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + 
##     CITBORO_10 + DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + 
##     bi_SFHOME + DIST_PARKS + PCT_HSB_19 + SLOPE + REGRAIL300, 
##     family = binomial, data = na.omit(Chester_bi))
## 
## Coefficients:
##      (Intercept)        DIST_4LNE_        DIST_REGRA  bi_POPDEN_less60  
##       -2.058e+00        -3.400e-04        -5.521e-05        -7.720e-01  
##       CITBORO_10        DIST_PASSR      bi_POV_less4   bi_WHITE_less97  
##        5.143e-01        -1.372e-04         7.283e-01         6.455e-01  
##        bi_SFHOME        DIST_PARKS        PCT_HSB_19             SLOPE  
##        4.322e-01        -9.565e-05         1.718e-02        -1.233e-01  
##       REGRAIL300  
##        5.374e-01  
## 
## Degrees of Freedom: 5493 Total (i.e. Null);  5481 Residual
## Null Deviance:	    1763 
## Residual Deviance: 1382 	AIC: 1408
```

```r
CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
    DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + 
    DIST_PARKS + PCT_HSB_19 + SLOPE + REGRAIL300
```

```
## CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + CITBORO_10 + 
##     DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + 
##     DIST_PARKS + PCT_HSB_19 + SLOPE + REGRAIL300
```

```r
CHNG_URB ~ REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + bi_WHITE_less97 + bi_SFHOME + bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + 
  DIST_REGRA + PCT_HSB_19 + SLOPE
```

```
## CHNG_URB ~ REGRAIL300 + CITBORO_10 + bi_POPDEN_less60 + bi_WHITE_less97 + 
##     bi_SFHOME + bi_POV_less4 + DIST_PASSR + DIST_4LNE_ + DIST_PARKS + 
##     DIST_REGRA + PCT_HSB_19 + SLOPE
```

The forward and backward selection methods gave the same set of the most relevant variables for determining probability of urbanization. 


```r
bi_model_bi2 <- glm(formula = CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 +  CITBORO_10 + DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + bi_SFHOME + DIST_PARKS + PCT_HSB_19 + SLOPE + REGRAIL300, family = binomial, data = na.omit(Chester_bi))

summary(bi_model_bi2)
```

```
## 
## Call:
## glm(formula = CHNG_URB ~ DIST_4LNE_ + DIST_REGRA + bi_POPDEN_less60 + 
##     CITBORO_10 + DIST_PASSR + bi_POV_less4 + bi_WHITE_less97 + 
##     bi_SFHOME + DIST_PARKS + PCT_HSB_19 + SLOPE + REGRAIL300, 
##     family = binomial, data = na.omit(Chester_bi))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3609  -0.2676  -0.1516  -0.0838   3.2712  
## 
## Coefficients:
##                    Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      -2.058e+00  4.307e-01  -4.779 1.76e-06 ***
## DIST_4LNE_       -3.400e-04  5.589e-05  -6.084 1.17e-09 ***
## DIST_REGRA       -5.521e-05  1.656e-05  -3.334 0.000857 ***
## bi_POPDEN_less60 -7.720e-01  1.956e-01  -3.948 7.89e-05 ***
## CITBORO_10        5.143e-01  2.555e-01   2.013 0.044165 *  
## DIST_PASSR       -1.372e-04  6.335e-05  -2.166 0.030326 *  
## bi_POV_less4      7.283e-01  1.987e-01   3.666 0.000247 ***
## bi_WHITE_less97   6.455e-01  1.818e-01   3.550 0.000385 ***
## bi_SFHOME         4.322e-01  1.680e-01   2.572 0.010110 *  
## DIST_PARKS       -9.565e-05  3.467e-05  -2.759 0.005796 ** 
## PCT_HSB_19        1.718e-02  6.514e-03   2.637 0.008368 ** 
## SLOPE            -1.233e-01  5.020e-02  -2.455 0.014077 *  
## REGRAIL300        5.374e-01  2.242e-01   2.397 0.016537 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1763.5  on 5493  degrees of freedom
## Residual deviance: 1381.7  on 5481  degrees of freedom
## AIC: 1407.7
## 
## Number of Fisher Scoring iterations: 7
```

```r
vif(bi_model_bi2)
```

```
##       DIST_4LNE_       DIST_REGRA bi_POPDEN_less60       CITBORO_10 
##         1.146723         2.215348         1.074725         1.465559 
##       DIST_PASSR     bi_POV_less4  bi_WHITE_less97        bi_SFHOME 
##         1.364742         1.500934         1.296667         1.243636 
##       DIST_PARKS       PCT_HSB_19            SLOPE       REGRAIL300 
##         1.140865         1.778752         1.127990         2.064320
```

The AIC is 1408 of the final model and the VIF is all well below 5, meaning there are no co-linear variables.


```r
qchisq(.95, df=5493)
```

```
## [1] 5666.533
```

The critical value is 5666.5. The null deviance value of the model (1763) is much lower than the critical value, meaning our predicted results will be in a similar range as the observations. 

*The model with more binary variables is more reliable to predict the results.*


```r
exp(coef(bi_model_bi2))
```

```
##      (Intercept)       DIST_4LNE_       DIST_REGRA bi_POPDEN_less60 
##        0.1276805        0.9996600        0.9999448        0.4620714 
##       CITBORO_10       DIST_PASSR     bi_POV_less4  bi_WHITE_less97 
##        1.6724169        0.9998628        2.0715963        1.9069320 
##        bi_SFHOME       DIST_PARKS       PCT_HSB_19            SLOPE 
##        1.5405673        0.9999044        1.0173247        0.8840269 
##       REGRAIL300 
##        1.7115608
```

```r
100 * (exp(coef(bi_model_bi2))-1)
```

```
##      (Intercept)       DIST_4LNE_       DIST_REGRA bi_POPDEN_less60 
##    -87.231954376     -0.033997550     -0.005521312    -53.792860774 
##       CITBORO_10       DIST_PASSR     bi_POV_less4  bi_WHITE_less97 
##     67.241691701     -0.013719095    107.159627127     90.693204811 
##        bi_SFHOME       DIST_PARKS       PCT_HSB_19            SLOPE 
##     54.056730009     -0.009564258      1.732467015    -11.597306380 
##       REGRAIL300 
##     71.156079555
```

According to the new model, the most important factors that explains the land use change between 1992 and 2001 are, from greatest to least:   
1) if the location has an household poverty below 4%   
2)if the location has an white population below 97%   
3) if the location is located within 300 meters of a SEPTA railway    
4) if the location is within 1000 meters of city and boro.   
These four factors have the largest impact on the possibility of a location being urbanized. 

The fact that an area has less than 4% of the households living below poverty line is associated with a *107% increase* in the odd ratio. The odd ratio is the possibility of success over possibility of failure. A decrease in the odd ratio means that the location will households less chance to turn into a urban area when the percent of households living in poverty increases. 

In the same way, if the area has less than 97% of the white population there is a *91% decrease* in chance of successfully being urbanized.

The fact that an area is located within 300 meters of a SEPTA railway is associated with *71% increase* in chance of successfully being urbanized.

If a location is within 1000 meters of another city or boro, the chance of being urbanized is *increased by 67%*. 

## Other suggestions

Some additional data could be gathered, such as the population density, household income, and median housing value from 2000 census.  The demographic and economic growth rates could be another huge factor for urbanization. These could be more relevant variables to determine probability of land use. 

## Conclusion with Plots and Tables 


```r
#Holding everything else constant, but percent poverty 

## 0 in household poverty below 4%

POV_possibility <- data.frame(bi_POV_less4 = 0, REGRAIL300 = 1, CITBORO_10 = 1, bi_POPDEN_less60 = 1, bi_WHITE_less97 = 1, bi_SFHOME = 1, DIST_4LNE_ = mean(Chester_bi$DIST_4LNE_,na.rm = TRUE), DIST_PARKS = mean(Chester_bi$DIST_PARKS,na.rm = TRUE), DIST_REGRA = mean(Chester_bi$DIST_REGRA,na.rm = TRUE), DIST_PASSR = mean(Chester_bi$DIST_PASSR, na.rm = TRUE), PCT_HSB_19 = mean(Chester_bi$PCT_HSB_19), SLOPE = Chester_bi$SLOPE)

POV_possibility <-
  POV_possibility %>%
  mutate(predict_result = predict(bi_model_bi2,POV_possibility,type = "response"))

## 1 in household poverty below 4%
POV_possibility2 <- data.frame(bi_POV_less4 = 1, REGRAIL300 = 1, CITBORO_10 = 1, bi_POPDEN_less60 = 1, bi_WHITE_less97 = 1, bi_SFHOME = 1, DIST_4LNE_ = mean(Chester_bi$DIST_4LNE_,na.rm = TRUE), DIST_PARKS = mean(Chester_bi$DIST_PARKS,na.rm = TRUE), DIST_REGRA = mean(Chester_bi$DIST_REGRA,na.rm = TRUE), DIST_PASSR = mean(Chester_bi$DIST_PASSR, na.rm = TRUE), PCT_HSB_19 = mean(Chester_bi$PCT_HSB_19), SLOPE = Chester_bi$SLOPE)

POV_possibility2 <-
  POV_possibility2 %>%
  mutate(predict_result = predict(bi_model_bi2,POV_possibility2,type = "response"))

##  0 in household poverty below 4% and 0 in city
POV_possibility3 <- data.frame(bi_POV_less4 = 0, REGRAIL300 = 1, CITBORO_10 = 0, bi_POPDEN_less60 = 1, bi_WHITE_less97 = 1, bi_SFHOME = 1, DIST_4LNE_ = mean(Chester_bi$DIST_4LNE_,na.rm = TRUE), DIST_PARKS = mean(Chester_bi$DIST_PARKS,na.rm = TRUE), DIST_REGRA = mean(Chester_bi$DIST_REGRA,na.rm = TRUE), DIST_PASSR = mean(Chester_bi$DIST_PASSR, na.rm = TRUE), PCT_HSB_19 = mean(Chester_bi$PCT_HSB_19), SLOPE = Chester_bi$SLOPE)

POV_possibility3 <-
  POV_possibility3 %>%
  mutate(predict_result = predict(bi_model_bi2,POV_possibility3,type = "response"))

## 1 in household poverty below % and 0 in city
POV_possibility4 <- data.frame(bi_POV_less4 = 1, REGRAIL300 = 1, CITBORO_10 = 0, bi_POPDEN_less60 = 1, bi_WHITE_less97 = 1, bi_SFHOME = 1, DIST_4LNE_ = mean(Chester_bi$DIST_4LNE_,na.rm = TRUE), DIST_PARKS = mean(Chester_bi$DIST_PARKS,na.rm = TRUE), DIST_REGRA = mean(Chester_bi$DIST_REGRA,na.rm = TRUE), DIST_PASSR = mean(Chester_bi$DIST_PASSR, na.rm = TRUE), PCT_HSB_19 = mean(Chester_bi$PCT_HSB_19), SLOPE = Chester_bi$SLOPE)

POV_possibility4 <-
  POV_possibility4 %>%
  mutate(predict_result = predict(bi_model_bi2,POV_possibility4,type = "response"))


#Combing the results in a new data frame
POV_PRE <- data.frame(SLOPE = POV_possibility$SLOPE, 
HOUSEPOV0_CITY1 = POV_possibility$predict_result, 
HOUSEPOV1_CITY1 = POV_possibility2$predict_result,
HOUSEPOV0_CITY0 = POV_possibility3$predict_result,
HOUSEPOV1_CITY0 = POV_possibility4$predict_result)

#Arrange the data by scenario
dat <- gather(POV_PRE, -SLOPE, key = "Scenario", value = "value")
#Plot the data 

ggplot(dat, aes(x = SLOPE, y = value, colour = Scenario)) + 
        geom_line() + ylim(0,0.2) +
        xlab("% Slope") + ylab("Predicted Probability of Urbanization") + theme_light()
```

![](Hu_Duan_Assignment3_April22_files/figure-html/variables against Slope -1.png)<!-- -->

While holding every other variable constant (with their mean values), the graph above shows the predicting results when changing factor whether the location has less than 4 percent of households living below poverty line and within 1000 meters of a city or boro. 

The purple curve denotes the probability when the location has both more than 4% of the households living in poverty and is within 1000 meters of a of a city or boro. 

The blue curve denotes the probability when the location has more than 4% of the households living below poverty line, but *not* within 1,000 meters of a city or boro.

The green curve denotes the probability when the location is within 1,000 meters of a city or boro, but has *less* than 4% of the households living below poverty line. 

The red curve denotes the probability when the location has both *less* than 4% of the households living below poverty line and also *not* within 1,000 meters if a city or boro. 

All the curves are plotted against the change in slope

The graph above shows that when a location has more households living below poverty line and is 1,000 meters of a city or boro, the likelihood of it being urbanized is much higher. 

The blue curve is higher than the green curve in the graph. This shows that whether the location has more than 4% of the households living below poverty line is a stronger predictor than whether the location is within 1000 meters of a city or boro. 

The graph also shows as the percent slope increases, the predicted probably of urbanization decreases as well. 


```r
#Holding everything else constant, but percent poverty 

## 0 in white

WHI_possibility <- data.frame(bi_POV_less4 = 1, REGRAIL300 = 1, CITBORO_10 = 1, bi_POPDEN_less60 = 1, bi_WHITE_less97 = 0, bi_SFHOME = 1, DIST_4LNE_ = mean(Chester_bi$DIST_4LNE_,na.rm = TRUE), DIST_PARKS = mean(Chester_bi$DIST_PARKS,na.rm = TRUE), DIST_REGRA = mean(Chester_bi$DIST_REGRA,na.rm = TRUE), DIST_PASSR = mean(Chester_bi$DIST_PASSR, na.rm = TRUE), PCT_HSB_19 = mean(Chester_bi$PCT_HSB_19), SLOPE = Chester_bi$SLOPE)

WHI_possibility <-
  POV_possibility %>%
  mutate(predict_result = predict(bi_model_bi2,WHI_possibility,type = "response"))

## 1 in white
WHI_possibility2 <- data.frame(bi_POV_less4 = 1, REGRAIL300 = 1, CITBORO_10 = 1, bi_POPDEN_less60 = 1, bi_WHITE_less97 = 1, bi_SFHOME = 1, DIST_4LNE_ = mean(Chester_bi$DIST_4LNE_,na.rm = TRUE), DIST_PARKS = mean(Chester_bi$DIST_PARKS,na.rm = TRUE), DIST_REGRA = mean(Chester_bi$DIST_REGRA,na.rm = TRUE), DIST_PASSR = mean(Chester_bi$DIST_PASSR, na.rm = TRUE), PCT_HSB_19 = mean(Chester_bi$PCT_HSB_19), SLOPE = Chester_bi$SLOPE)

WHI_possibility2 <-
  POV_possibility2 %>%
  mutate(predict_result = predict(bi_model_bi2,WHI_possibility2,type = "response"))

#Combing the results in a new data frame
WHI_PRE <- data.frame(SLOPE = WHI_possibility$SLOPE, WHITE_ABOVE_97PERCENT = WHI_possibility$predict_result, WHITE_BELOW_97PERCENT = WHI_possibility2$predict_result)

#Arrange the data by scenario
dat <- gather(WHI_PRE, -SLOPE, key = "Scenario", value = "value")
#Plot the data 

ggplot(dat, aes(x = SLOPE, y = value, colour = Scenario)) + 
        geom_line() + ylim(0,0.2) +
        xlab("% Slope") + ylab("Predcted Probabiility of Urbanization") + theme_light()
```

![](Hu_Duan_Assignment3_April22_files/figure-html/variables against Slope-1.png)<!-- -->

The above graph shows the predicted probability of urbanization when the percent of white population is either below or above 97% in a given location in 1990 against percent slope. 

When the location has high poverty among households and is within 1000 meters of a city or boro, and other variables are held constant (with their mean values), whether the percent of white population in a location is below or above 97% shows an huge effect on the predicted probability of urbanization. 

The blue line denotes the probability when an area has less than 97 white population in the area against percent households in poverty.

The red line denotes the probability when an area has more than 97 white population in the area against percent households in poverty.

The graph shows that, in Chester County, those areas that lived with less white population in 1990 had a higher chance of being urbanized in 2001 based on the graph. 







# Part 2: Modelling Commute Mode Choice  

In this report, we model the following using trip data from the Delaware Valley Regional Planning Commission:        
1. Whether a commuter drove to work      
2. Whether a commuter walked or biked to work    
3. Whether a commuter drove to work, carpooled, took public transit, or walked or biked


```r
# Read Chester land use Data and its geometry

trips <- read.csv("HH Travel Survey/trip_pub.csv") %>%
 # filter(ACT1 == 11 | ACT1 ==12) %>% #filter for work trips
  mutate(drove_work = ifelse(TRAN1 == 21, 1, 0),
         bike_walk_work = ifelse(TRAN1 == 11 | TRAN1 == 14, 1, 0),
         transit_work = ifelse(TRAN1 == 41 | TRAN1 == 44 | TRAN1 == 47 | TRAN1 == 51 | TRAN1 == 52 | TRAN1 == 53, 1, 0),
         carpool_work = ifelse(TRAN1 == 31, 1,0),
         )
# %>%
#   dplyr::select(-DVRPC, -SPDFLAG, -OEGRES, -EGRESS, -EXIT, -OTRFS, -FARE3, -PAY3O, -PAY3, -TRFL2, -TRFS2, -FARE2, -PAY2O, -PAY2, -TRFL1, -TRFS1, -TRFR, -FARE1, -PAY1O, -PAY1, -LINE, -OACESS, -ACCESS, -SUBTR, -APDPN, -APDPH, -ADDPN, -ADDPH, -ADDP, -TOLLA, -TOLL, -PRKUO, -NNHTR, -PHHTR, -ADP, -HHVU, -OTRAN, -PLANO, -X, -ACT2, -ACT3, -ACT4, -ACT5, -ACT6, -ACT1O, -ACTO, -TRAN4, -TRAN3, -PARKO, -APDP, -X.1, -TRAN1, -TRAN2)

households <- read.csv("HH Travel Survey/hh_pub_CSV.csv", header = TRUE) %>%
  dplyr::select(ADVLT, TOTVEH, DWELL, YRMOV, RENT, DIARY, ENGL, HHSIZE, NPHON, NOPHO, SHPHN, ETHNC, INCLV, INCOM, INCOME, ASSN, DPHON, NPLAC, NTRIPS, NOWRK, NOSTU, OWNSH, EACCT, CPA, DAYOFWK, HBW, HBO, NHB, MOTTRIP, SAMPN, LISTD, HADDR)

persons <- read.csv("HH Travel Survey/per_pub.csv") %>%
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

## Binary Logit: Driving, Biking, and Walking to Work   
### Model 1: Drive to Work        
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


### Model 2: Walk or Bike to Work   
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
   
1. The more vehicles someone has in their household, the more likely they are to drive and less likely they are to walk or bike. This may be due solely to the fact that someone with access to more cars is less likely to have to compete with another household member for a vehicle. However, it could also reflect the fact that people living in the suburbs tend to have more cars and lower access to other modes such as transit or walking. Below, we can see that when controlling for income and trip duration, people with more vehicles in their household are more likely to drive to work, whereas people with fewer are more likely to bike or walk.  


```r
mod <- glm ( drove_work ~ TOTVEH+TRPDUR+INCOME, data=trips_person_hh, family = binomial)
mod2 <- glm ( bike_walk_work ~ TOTVEH+TRPDUR+INCOME, data=trips_person_hh, family = binomial)


#Scenario 1: 1 vs 3 vehicles
newdat_gg<-data.frame(matrix(ncol = 3, nrow = nrow(trips_person_hh)))
colnames(newdat_gg)<- c("TRPDUR", "INCOME", "TOTVEH")
newdat_gg$TRPDUR <- trips_person_hh$TRPDUR
newdat_gg$INCOME <- 50000
newdat_gg$TOTVEH <- mean(trips_person_hh$TOTVEH)

newdat_gg_1<-data.frame(matrix(ncol = 3, nrow = nrow(trips_person_hh)))
colnames(newdat_gg_1)<- c("TRPDUR", "INCOME", "TOTVEH")
newdat_gg_1$TRPDUR <- trips_person_hh$TRPDUR
newdat_gg_1$INCOME <- 50000
newdat_gg_1$TOTVEH <- 1

newdat_gg_2<-data.frame(matrix(ncol = 3, nrow = nrow(trips_person_hh)))
colnames(newdat_gg_2)<- c("TRPDUR", "INCOME", "TOTVEH")
newdat_gg_2$TRPDUR <- trips_person_hh$TRPDUR
newdat_gg_2$INCOME <- 50000
newdat_gg_2$TOTVEH <- 4

#drove
pred_dat<- data.frame(matrix(ncol = 4, nrow = nrow(trips_person_hh)))
colnames(pred_dat)<- c("TRPDUR", "Pred_2.3Cars_Inc50K", "Pred_1Car_Inc50K", "Pred_4Cars_Inc50K")
pred_dat$TRPDUR<-trips_person_hh$TRPDUR
pred_dat$Pred_2.3Cars_Inc50K<- predict(mod, newdat_gg, type="response")
pred_dat$Pred_1Car_Inc50K<- predict(mod, newdat_gg_1, type="response")
pred_dat$Pred_4Cars_Inc50K<- predict(mod, newdat_gg_2, type="response")
#bike/walk
pred_dat2<- data.frame(matrix(ncol = 4, nrow = nrow(trips_person_hh)))
colnames(pred_dat2)<- c("TRPDUR", "Pred_2.3Cars_Inc50K", "Pred_1Car_Inc50K", "Pred_4Cars_Inc50K")
pred_dat2$TRPDUR<-trips_person_hh$TRPDUR
pred_dat2$Pred_2.3Cars_Inc50K<- predict(mod2, newdat_gg, type="response")
pred_dat2$Pred_1Car_Inc50K<- predict(mod2, newdat_gg_1, type="response")
pred_dat2$Pred_4Cars_Inc50K<- predict(mod2, newdat_gg_2, type="response")

dat <- gather(pred_dat, -TRPDUR, key = "Scenario", value = "value")
dat2 <- gather(pred_dat2, -TRPDUR, key = "Scenario", value = "value")

grid.arrange(
ggplot(dat, aes(x = TRPDUR, y = value, colour = Scenario)) + 
        geom_line() + ylim(0,1) +
  labs(title = "Drive to Work") +
        xlab("Trip Duration") + ylab("Predicted Probability") +
  plotTheme(),
ggplot(dat2, aes(x = TRPDUR, y = value, colour = Scenario)) + 
        geom_line() + ylim(0,1) +
  labs(title = "Bike/Walk to Work") +
        xlab("Trip Duration") + ylab("Predicted Probability")+
plotTheme(), ncol = 1, top = "3 Household Car Scenarios")
```

![](Hu_Duan_Assignment3_April22_files/figure-html/car scenarios-1.png)<!-- -->

2. More workers in a household means a person is less likely to drive, and more likely to bike or walk to work. This supports the theory that mode choice is determined, in part, with whether one has to compete with household members for transportation resources.     
  
3. Trip duration is a predictor for mode because on average, a car commute takes 4 minutes longer than a bike or walking commute. It's possible that this is because people are unlikely to choose biking or walking, more labor intensive modes, for longer commutes.    
  
4. The older someone is, the more likely they are to drive instead of walk or bike. This is expected, as the literature has documented that older populations in the United States tend to prefer automobile transport over other modes. As we see below, when controlling for trip duration and income, older commuters are more likely to drive and less likely to walk or bike compared to younger ones.  


```r
mod <- glm ( drove_work ~ AGE+TRPDUR+INCOME, data=trips_person_hh, family = binomial)
mod2 <- glm ( bike_walk_work ~ AGE+TRPDUR+INCOME, data=trips_person_hh, family = binomial)

#Scenario 2: 20 vs 55 years of age
newdat_gg<-data.frame(matrix(ncol = 3, nrow = nrow(trips_person_hh)))
colnames(newdat_gg)<- c("TRPDUR", "INCOME", "AGE")
newdat_gg$TRPDUR <- trips_person_hh$TRPDUR
newdat_gg$INCOME <- 50000
newdat_gg$AGE <- mean(trips_person_hh$AGE)

newdat_gg_1<-data.frame(matrix(ncol = 3, nrow = nrow(trips_person_hh)))
colnames(newdat_gg_1)<- c("TRPDUR", "INCOME", "AGE")
newdat_gg_1$TRPDUR <- trips_person_hh$TRPDUR
newdat_gg_1$INCOME <- 50000
newdat_gg_1$AGE <- 25

newdat_gg_2<-data.frame(matrix(ncol = 3, nrow = nrow(trips_person_hh)))
colnames(newdat_gg_2)<- c("TRPDUR", "INCOME", "AGE")
newdat_gg_2$TRPDUR <- trips_person_hh$TRPDUR
newdat_gg_2$INCOME <- 50000
newdat_gg_2$AGE <- 55

#drove
pred_dat<- data.frame(matrix(ncol = 4, nrow = nrow(trips_person_hh)))
colnames(pred_dat)<- c("TRPDUR", "Pred_44Years_Inc50K", "Pred_25Years_Inc50K", "Pred_55Years_Inc50K")
pred_dat$TRPDUR<-trips_person_hh$TRPDUR
pred_dat$Pred_44Years_Inc50K<- predict(mod, newdat_gg, type="response")
pred_dat$Pred_25Years_Inc50K<- predict(mod, newdat_gg_1, type="response")
pred_dat$Pred_55Years_Inc50K<- predict(mod, newdat_gg_2, type="response")

pred_dat2<- data.frame(matrix(ncol = 4, nrow = nrow(trips_person_hh)))
colnames(pred_dat2)<- c("TRPDUR", "Pred_44Years_Inc50K", "Pred_25Years_Inc50K", "Pred_55Years_Inc50K")
pred_dat2$TRPDUR<-trips_person_hh$TRPDUR
pred_dat2$Pred_44Years_Inc50K<- predict(mod2, newdat_gg, type="response")
pred_dat2$Pred_25Years_Inc50K<- predict(mod2, newdat_gg_1, type="response")
pred_dat2$Pred_55Years_Inc50K<- predict(mod2, newdat_gg_2, type="response")

dat <- gather(pred_dat, -TRPDUR, key = "Scenario", value = "value")
dat2 <- gather(pred_dat2, -TRPDUR, key = "Scenario", value = "value")

grid.arrange(
ggplot(dat, aes(x = TRPDUR, y = value, colour = Scenario)) + 
        geom_line() + ylim(0,1) +
  labs(title = "Drive to Work") +
        xlab("Trip Duration") + ylab("Predicted Probability") + plotTheme() ,
ggplot(dat2, aes(x = TRPDUR, y = value, colour = Scenario)) + 
        geom_line() + ylim(0,1) +
  labs(title = "Bike/Walk to Work") +
        xlab("Trip Duration") + ylab("Predicted Probability") + plotTheme(), ncol = 1, top = "3 Age Scenarios")
```

![](Hu_Duan_Assignment3_April22_files/figure-html/age scenarios-1.png)<!-- -->

  
Overall, our drive to work model predicts much better than the walk and bike to work model. The drive model has an accuracy rate of 92%, compared to just 6.5% for the walk/bike model. Part of this is likely due to the low number of bike and walk to work trips. In all, there are only 173 observations of either bike or walking trips, compared to 3038 observations of driving trips. Due to these limitations, the bike or walk to work model should not be used for predictive purposes. For future modeling, it would be valuable to explore data sources that feature a higher number of biking and walking trips. 


## Multinomial Logit: drive, carpool, transit, walk, or bike to work      
Now we create a model to predict whether somebody will drive, carpool, ride transit, walk, or bike to work. First, we clean the data and calculate important metrics such as travel time, travel distance, and parking and toll costs for each mode. Driving is the most popular mode by far, with more than 2500 observations. Transit and walking each have less than 200 observations, while biking and carpool each have less than 50.   


```r
trips_person_hh <- trips_person_hh %>%
  mutate(walk_work = case_when (TRAN1 == 11  ~ 1, TRUE ~ 0),
         bike_work = case_when(TRAN1 == 14 ~ 1, TRUE ~ 0))

CommuteTripsClean <- trips_person_hh[which(trips$Dest_PTYE == 2), ] 

#combine modes into a single column so that we can plot
CommuteTripsClean$Commute[CommuteTripsClean$drove_work == 1] <- 1
CommuteTripsClean$Commute[CommuteTripsClean$carpool_work == 1] <- 2
CommuteTripsClean$Commute[CommuteTripsClean$transit_work == 1] <- 3
CommuteTripsClean$Commute[CommuteTripsClean$walk_work == 1] <- 4
CommuteTripsClean$Commute[CommuteTripsClean$bike_work == 1] <- 5

#are there NAs?
table(is.na(CommuteTripsClean$Commute))
```

```
## 
## FALSE  TRUE 
##  2919   457
```

```r
table(CommuteTripsClean$Commute)
```

```
## 
##    1    2    3    4    5 
## 2616   11  144  131   17
```

```r
CommuteTripsClean$hist[CommuteTripsClean$Commute == 1] <- "Drive"
CommuteTripsClean$hist[CommuteTripsClean$Commute == 2] <- "Carpool"
CommuteTripsClean$hist[CommuteTripsClean$Commute == 3] <- "Transit"
CommuteTripsClean$hist[CommuteTripsClean$Commute == 4] <- "Walk"
CommuteTripsClean$hist[CommuteTripsClean$Commute == 5] <- "Bike"
CommuteTripsClean$hist <- as.factor(CommuteTripsClean$hist)
#plot frequency of each mode chosen
ggplot(CommuteTripsClean, aes(x=hist)) +
  labs(title = "Frequency of each mode choice") +
  geom_bar()
```

![](Hu_Duan_Assignment3_April22_files/figure-html/drive carpool transit walk or bike-1.png)<!-- -->

```r
CommuteTripsClean <- subset(CommuteTripsClean, !duplicated(X))

CommuteTripsClean <-CommuteTripsClean %>% filter(!is.na(SAMPN_PER))

#Check for repetition
##Commute_mode <- CommuteTripsClean%>% select(transit_work, drove_work, bike_work, walk_work,carpool_work)
##Commute_mode$check<-
##Commute_mode$transit_work+Commute_mode$drove_work+Commute_mode$bike_work + Commute_mode$walk_work + Commute_mode$carpool_work
##max(Commute_mode$check)

Biking<-CommuteTripsClean[which(CommuteTripsClean$bike_work ==1),]
Walking<-CommuteTripsClean[which(CommuteTripsClean$walk_work ==1),]
Drive<-CommuteTripsClean[which(CommuteTripsClean$drove_work ==1),]
Transit<-CommuteTripsClean[which(CommuteTripsClean$transit_work ==1),]
Carpool <- CommuteTripsClean[which(CommuteTripsClean$carpool_work ==1),]

Drive$distance<-(30/60)*Drive$TRPDUR
Biking$distance<-(12/60)*Biking$TRPDUR
Walking$distance<-(4/60)*Walking$TRPDUR
Transit$distance<-(25/60)*Transit$TRPDUR
Carpool$distance<-(30/60)*Carpool$TRPDUR

dat<-rbind(Biking, Walking, Transit, Carpool, Drive)

dat$time.drove <-dat$distance/30
dat$time.bike <- dat$distance/12
dat$time.transit <- dat$distance/25
dat$time.carpool <- dat$distance/30
dat$time.walk <- dat$distance/4

dat$mode[dat$bike_work == 1] <- "bike"
dat$mode[dat$transit_work == 1] <- "transit"
dat$mode[dat$walk_work == 1] <- "walk"
dat$mode[dat$drove_work == 1] <- "drove"
dat$mode[dat$carpool_work == 1] <- "carpool"

dat2 <- dat %>%
  mutate(with_toll = case_when(TOLLA > 0 ~ 1, TRUE ~ 2),
         with_park = case_when(PARKC > 0 ~ 1, TRUE ~ 2))
  

rownames(dat2) <- NULL 
```

Let's clean the data further to prepare for modelling.  


```r
dat_final <-
  dat2 %>%
  dplyr::select("SAMPN.x", "PERNO.x", "X", "AGE", "INCOME", "SAMPN_PER", "with_toll", "TOLL", "with_park", "PARKU","PARKO" ,"TRPDUR", "drove_work", "transit_work","carpool_work", "GEND", "DISAB", "EDUC", "TOTVEH", "ADVLT", "RENT", "ENGL" , "HHSIZE", "NPHON" , "NOWRK", starts_with("time"),mode)

dat_final[is.na(dat_final)] <- 0

head(dat_final)
```

```
##   SAMPN.x PERNO.x        X AGE INCOME SAMPN_PER with_toll TOLL with_park PARKU
## 1 1009329       3 10093293  16  87000  10093293         2    0         2     0
## 2 1015320       1 10153201  43  87000  10153201         2    0         2     0
## 3 1017282       3 10172823  16  62000  10172823         2    0         2     0
## 4 1027735       3 10277353  17  87000  10277353         2    0         2     0
## 5 1030554       1 10305541  48 137000  10305541         2    0         2     0
## 6 1038864       2 10388642  57 112000  10388642         2    0         2     0
##   PARKO TRPDUR drove_work transit_work carpool_work GEND DISAB EDUC TOTVEH
## 1            4          0            0            0    1     2    1      2
## 2           60          0            0            0    1     2    1      1
## 3            1          0            0            0    1     2    1      3
## 4           60          0            0            0    2     2    1      1
## 5           50          0            0            0    1     2    2      2
## 6           11          0            0            0    1     2    2      1
##   ADVLT RENT ENGL HHSIZE NPHON NOWRK  time.drove  time.bike time.transit
## 1     8    2    2      8     1     2 0.026666667 0.06666667        0.032
## 2     3    2    2      5     1     2 0.400000000 1.00000000        0.480
## 3     3    2    2      4     1     3 0.006666667 0.01666667        0.008
## 4     2    2    2      6     1     3 0.400000000 1.00000000        0.480
## 5     3    2    2      4     2     2 0.333333333 0.83333333        0.400
## 6     1    2    2      2     1     2 0.073333333 0.18333333        0.088
##   time.carpool time.walk mode
## 1  0.026666667      0.20 bike
## 2  0.400000000      3.00 bike
## 3  0.006666667      0.05 bike
## 4  0.400000000      3.00 bike
## 5  0.333333333      2.50 bike
## 6  0.073333333      0.55 bike
```

```r
library(mlogit)
datMNL <- mlogit.data(dat_final, shape="wide", choice="mode", varying=c(26:30))

head(datMNL)
```

```
## ~~~~~~~
##  first 10 observations out of 14595 
## ~~~~~~~
##    SAMPN.x PERNO.x        X AGE INCOME SAMPN_PER with_toll TOLL with_park PARKU
## 1  1009329       3 10093293  16  87000  10093293         2    0         2     0
## 2  1009329       3 10093293  16  87000  10093293         2    0         2     0
## 3  1009329       3 10093293  16  87000  10093293         2    0         2     0
## 4  1009329       3 10093293  16  87000  10093293         2    0         2     0
## 5  1009329       3 10093293  16  87000  10093293         2    0         2     0
## 6  1015320       1 10153201  43  87000  10153201         2    0         2     0
## 7  1015320       1 10153201  43  87000  10153201         2    0         2     0
## 8  1015320       1 10153201  43  87000  10153201         2    0         2     0
## 9  1015320       1 10153201  43  87000  10153201         2    0         2     0
## 10 1015320       1 10153201  43  87000  10153201         2    0         2     0
##    PARKO TRPDUR drove_work transit_work carpool_work GEND DISAB EDUC TOTVEH
## 1             4          0            0            0    1     2    1      2
## 2             4          0            0            0    1     2    1      2
## 3             4          0            0            0    1     2    1      2
## 4             4          0            0            0    1     2    1      2
## 5             4          0            0            0    1     2    1      2
## 6            60          0            0            0    1     2    1      1
## 7            60          0            0            0    1     2    1      1
## 8            60          0            0            0    1     2    1      1
## 9            60          0            0            0    1     2    1      1
## 10           60          0            0            0    1     2    1      1
##    ADVLT RENT ENGL HHSIZE NPHON NOWRK  mode     alt       time chid    idx
## 1      8    2    2      8     1     2  TRUE    bike 0.06666667    1 1:bike
## 2      8    2    2      8     1     2 FALSE carpool 0.02666667    1 1:pool
## 3      8    2    2      8     1     2 FALSE   drove 0.02666667    1 1:rove
## 4      8    2    2      8     1     2 FALSE transit 0.03200000    1 1:nsit
## 5      8    2    2      8     1     2 FALSE    walk 0.20000000    1 1:walk
## 6      3    2    2      5     1     2  TRUE    bike 1.00000000    2 2:bike
## 7      3    2    2      5     1     2 FALSE carpool 0.40000000    2 2:pool
## 8      3    2    2      5     1     2 FALSE   drove 0.40000000    2 2:rove
## 9      3    2    2      5     1     2 FALSE transit 0.48000000    2 2:nsit
## 10     3    2    2      5     1     2 FALSE    walk 3.00000000    2 2:walk
## 
## ~~~ indexes ~~~~
##    chid     alt
## 1     1    bike
## 2     1 carpool
## 3     1   drove
## 4     1 transit
## 5     1    walk
## 6     2    bike
## 7     2 carpool
## 8     2   drove
## 9     2 transit
## 10    2    walk
## indexes:  1, 2
```

We selected variables that are relevant across all modes (i.e. toll or parking are only related to driving, so we excluded them). Below, we create 3 models to start: a model with only decision maker specific variables, a model with alternative and decision maker specific variables, and a model with only alternative specific variables. The model with both alternative and decision maker variables has the highest McFadden R^2. 


```r
#mod 1
mod1 <- mlogit (mode ~ 1 | AGE + INCOME +GEND + EDUC + TOTVEH + RENT + ADVLT + NPHON +NOWRK + HHSIZE, data = datMNL)
summary(mod1)
```

```
## 
## Call:
## mlogit(formula = mode ~ 1 | AGE + INCOME + GEND + EDUC + TOTVEH + 
##     RENT + ADVLT + NPHON + NOWRK + HHSIZE, data = datMNL, method = "nr")
## 
## Frequencies of alternatives:choice
##      bike   carpool     drove   transit      walk 
## 0.0058239 0.0037684 0.8961973 0.0493320 0.0448784 
## 
## nr method
## 8 iterations, 0h:0m:1s 
## g'(-H)^-1g = 8.01E-07 
## gradient close to zero 
## 
## Coefficients :
##                        Estimate  Std. Error z-value  Pr(>|z|)    
## (Intercept):carpool -1.1798e+01  3.5698e+00 -3.3049 0.0009502 ***
## (Intercept):drove   -5.8788e+00  2.0292e+00 -2.8971 0.0037666 ** 
## (Intercept):transit -5.2988e+00  2.0975e+00 -2.5263 0.0115281 *  
## (Intercept):walk    -5.6626e+00  2.1159e+00 -2.6762 0.0074462 ** 
## AGE:carpool          3.6599e-02  3.8211e-02  0.9578 0.3381597    
## AGE:drove            3.1804e-02  2.6654e-02  1.1932 0.2327927    
## AGE:transit          1.5867e-02  2.7516e-02  0.5766 0.5641771    
## AGE:walk             1.6701e-02  2.7544e-02  0.6063 0.5442875    
## INCOME:carpool      -3.9672e-05  1.2580e-05 -3.1536 0.0016126 ** 
## INCOME:drove        -2.5161e-05  6.7305e-06 -3.7384 0.0001852 ***
## INCOME:transit      -3.1979e-05  7.3548e-06 -4.3480 1.374e-05 ***
## INCOME:walk         -1.6328e-05  6.9607e-06 -2.3458 0.0189869 *  
## GEND:carpool         1.9487e+00  8.8750e-01  2.1958 0.0281093 *  
## GEND:drove           1.3414e+00  6.2283e-01  2.1537 0.0312674 *  
## GEND:transit         1.6115e+00  6.3890e-01  2.5222 0.0116610 *  
## GEND:walk            1.5001e+00  6.3882e-01  2.3482 0.0188664 *  
## EDUC:carpool         2.1704e+00  1.2794e+00  1.6965 0.0897997 .  
## EDUC:drove           2.3426e+00  6.4389e-01  3.6383 0.0002745 ***
## EDUC:transit         1.8010e+00  6.8119e-01  2.6439 0.0081954 ** 
## EDUC:walk            2.0309e+00  6.9571e-01  2.9192 0.0035089 ** 
## TOTVEH:carpool       2.6006e+00  5.7009e-01  4.5617 5.073e-06 ***
## TOTVEH:drove         2.7787e+00  4.1573e-01  6.6840 2.326e-11 ***
## TOTVEH:transit       1.0665e+00  4.2483e-01  2.5104 0.0120582 *  
## TOTVEH:walk          8.0928e-01  4.2198e-01  1.9178 0.0551328 .  
## RENT:carpool        -4.1928e-01  1.0321e+00 -0.4063 0.6845574    
## RENT:drove           4.2439e-02  6.7308e-01  0.0631 0.9497244    
## RENT:transit        -2.9839e-01  6.9192e-01 -0.4312 0.6662866    
## RENT:walk           -3.1726e-01  6.9598e-01 -0.4558 0.6484987    
## ADVLT:carpool        2.2158e-01  1.8038e-01  1.2284 0.2192990    
## ADVLT:drove          4.9248e-02  1.3493e-01  0.3650 0.7151181    
## ADVLT:transit        4.1439e-02  1.4119e-01  0.2935 0.7691382    
## ADVLT:walk           1.7586e-02  1.4111e-01  0.1246 0.9008168    
## NPHON:carpool        2.3220e+00  1.1417e+00  2.0339 0.0419664 *  
## NPHON:drove          2.1431e+00  1.0607e+00  2.0204 0.0433401 *  
## NPHON:transit        2.4654e+00  1.0679e+00  2.3087 0.0209591 *  
## NPHON:walk           1.8208e+00  1.0721e+00  1.6984 0.0894396 .  
## NOWRK:carpool       -3.2219e-01  6.6594e-01 -0.4838 0.6285157    
## NOWRK:drove         -5.6472e-01  4.7405e-01 -1.1913 0.2335518    
## NOWRK:transit       -4.4361e-03  4.8998e-01 -0.0091 0.9927763    
## NOWRK:walk           5.6002e-01  4.9286e-01  1.1363 0.2558419    
## HHSIZE:carpool      -9.1118e-02  3.0549e-01 -0.2983 0.7655002    
## HHSIZE:drove        -2.7972e-01  1.8522e-01 -1.5102 0.1309809    
## HHSIZE:transit      -1.0887e-01  1.9216e-01 -0.5665 0.5710243    
## HHSIZE:walk         -3.6530e-01  1.9860e-01 -1.8393 0.0658690 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Log-Likelihood: -1011.4
## McFadden R^2:  0.20707 
## Likelihood ratio test : chisq = 528.24 (p.value = < 2.22e-16)
```

```r
#mod 2 with time
mod2 <-mlogit (mode ~ time | AGE + INCOME +GEND + EDUC + TOTVEH + RENT + ADVLT + NPHON +NOWRK + HHSIZE, data = datMNL)
summary(mod2)
```

```
## 
## Call:
## mlogit(formula = mode ~ time | AGE + INCOME + GEND + EDUC + TOTVEH + 
##     RENT + ADVLT + NPHON + NOWRK + HHSIZE, data = datMNL, method = "nr")
## 
## Frequencies of alternatives:choice
##      bike   carpool     drove   transit      walk 
## 0.0058239 0.0037684 0.8961973 0.0493320 0.0448784 
## 
## nr method
## 10 iterations, 0h:0m:1s 
## g'(-H)^-1g = 1.3E-06 
## successive function values within tolerance limits 
## 
## Coefficients :
##                        Estimate  Std. Error  z-value  Pr(>|z|)    
## (Intercept):carpool -1.4554e+01  3.6232e+00  -4.0169 5.897e-05 ***
## (Intercept):drove   -8.6059e+00  2.1400e+00  -4.0215 5.782e-05 ***
## (Intercept):transit -7.4855e+00  2.2126e+00  -3.3831 0.0007168 ***
## (Intercept):walk    -3.4010e+00  2.1837e+00  -1.5575 0.1193516    
## time                -4.5444e+00  4.0246e-01 -11.2918 < 2.2e-16 ***
## AGE:carpool          3.7832e-02  3.8776e-02   0.9757 0.3292371    
## AGE:drove            3.3210e-02  2.7432e-02   1.2107 0.2260262    
## AGE:transit          1.3813e-02  2.8326e-02   0.4877 0.6257961    
## AGE:walk             1.6436e-02  2.8698e-02   0.5727 0.5668391    
## INCOME:carpool      -3.9146e-05  1.2756e-05  -3.0689 0.0021483 ** 
## INCOME:drove        -2.4562e-05  7.0044e-06  -3.5067 0.0004537 ***
## INCOME:transit      -3.0162e-05  7.5986e-06  -3.9695 7.204e-05 ***
## INCOME:walk         -1.5987e-05  7.1370e-06  -2.2400 0.0250915 *  
## GEND:carpool         2.1394e+00  9.0462e-01   2.3650 0.0180293 *  
## GEND:drove           1.5319e+00  6.4726e-01   2.3667 0.0179472 *  
## GEND:transit         1.7481e+00  6.6288e-01   2.6371 0.0083626 ** 
## GEND:walk            1.5140e+00  6.7128e-01   2.2553 0.0241137 *  
## EDUC:carpool         2.2542e+00  1.3029e+00   1.7301 0.0836153 .  
## EDUC:drove           2.4047e+00  6.9965e-01   3.4371 0.0005881 ***
## EDUC:transit         1.9790e+00  7.3803e-01   2.6815 0.0073294 ** 
## EDUC:walk            1.8607e+00  7.6956e-01   2.4179 0.0156118 *  
## TOTVEH:carpool       2.9275e+00  5.9647e-01   4.9080 9.201e-07 ***
## TOTVEH:drove         3.0980e+00  4.5543e-01   6.8024 1.029e-11 ***
## TOTVEH:transit       1.3267e+00  4.6239e-01   2.8692 0.0041157 ** 
## TOTVEH:walk          9.1036e-01  4.6599e-01   1.9536 0.0507482 .  
## RENT:carpool        -5.1752e-01  1.0236e+00  -0.5056 0.6131385    
## RENT:drove          -5.7644e-02  6.6050e-01  -0.0873 0.9304539    
## RENT:transit        -4.2429e-01  6.8109e-01  -0.6230 0.5333116    
## RENT:walk           -2.4564e-01  6.9426e-01  -0.3538 0.7234812    
## ADVLT:carpool        2.3680e-01  1.8386e-01   1.2879 0.1977638    
## ADVLT:drove          6.5090e-02  1.3948e-01   0.4667 0.6407415    
## ADVLT:transit        6.4466e-02  1.4526e-01   0.4438 0.6571970    
## ADVLT:walk          -1.5422e-02  1.4776e-01  -0.1044 0.9168731    
## NPHON:carpool        2.1631e+00  1.1519e+00   1.8778 0.0604087 .  
## NPHON:drove          1.9793e+00  1.0720e+00   1.8463 0.0648551 .  
## NPHON:transit        2.3431e+00  1.0788e+00   2.1720 0.0298540 *  
## NPHON:walk           1.6365e+00  1.0859e+00   1.5070 0.1318086    
## NOWRK:carpool       -3.7238e-01  6.8668e-01  -0.5423 0.5876189    
## NOWRK:drove         -6.0984e-01  5.0509e-01  -1.2074 0.2272838    
## NOWRK:transit       -1.1311e-01  5.2007e-01  -0.2175 0.8278228    
## NOWRK:walk           6.2782e-01  5.3256e-01   1.1789 0.2384448    
## HHSIZE:carpool      -5.2914e-02  3.0284e-01  -0.1747 0.8612966    
## HHSIZE:drove        -2.3639e-01  1.8102e-01  -1.3058 0.1916109    
## HHSIZE:transit      -7.9270e-02  1.8681e-01  -0.4243 0.6713243    
## HHSIZE:walk         -3.3339e-01  2.0101e-01  -1.6586 0.0971970 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Log-Likelihood: -754.41
## McFadden R^2:  0.40853 
## Likelihood ratio test : chisq = 1042.2 (p.value = < 2.22e-16)
```

```r
#mod 3 only with time
mod3 <-mlogit (mode ~ time | 1, data = datMNL)
summary(mod3)
```

```
## 
## Call:
## mlogit(formula = mode ~ time | 1, data = datMNL, method = "nr")
## 
## Frequencies of alternatives:choice
##      bike   carpool     drove   transit      walk 
## 0.0058239 0.0037684 0.8961973 0.0493320 0.0448784 
## 
## nr method
## 9 iterations, 0h:0m:0s 
## g'(-H)^-1g = 0.000164 
## successive function values within tolerance limits 
## 
## Coefficients :
##                     Estimate Std. Error  z-value  Pr(>|z|)    
## (Intercept):carpool -2.30051    0.40039  -5.7457 9.154e-09 ***
## (Intercept):drove    3.17100    0.26417  12.0038 < 2.2e-16 ***
## (Intercept):transit  0.63920    0.26753   2.3893   0.01688 *  
## (Intercept):walk     4.22558    0.27016  15.6410 < 2.2e-16 ***
## time                -4.46191    0.34687 -12.8632 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Log-Likelihood: -985.13
## McFadden R^2:  0.22764 
## Likelihood ratio test : chisq = 580.71 (p.value = < 2.22e-16)
```

Based on this, we create a more succinct model based on model 2, removing statistically insignificant variables. The list of variables we use includes: INCOME, GEND, EDUC, TOTVEH, NPHON, and HHSIZE. This reduction in variables slightly lowers  the model's McFadden R^2, but it now has a much higher proportion of significant variables. The AIC varies very little between model 2 and model 4 as well. 


```r
#mod 4: with time and decisionmaker specific, insignificant variables removed
mod4 <-mlogit (mode ~ time | INCOME + GEND + EDUC + TOTVEH + NPHON + HHSIZE, data = datMNL)
summary(mod4)
```

```
## 
## Call:
## mlogit(formula = mode ~ time | INCOME + GEND + EDUC + TOTVEH + 
##     NPHON + HHSIZE, data = datMNL, method = "nr")
## 
## Frequencies of alternatives:choice
##      bike   carpool     drove   transit      walk 
## 0.0058239 0.0037684 0.8961973 0.0493320 0.0448784 
## 
## nr method
## 9 iterations, 0h:0m:1s 
## g'(-H)^-1g = 0.000889 
## successive function values within tolerance limits 
## 
## Coefficients :
##                        Estimate  Std. Error  z-value  Pr(>|z|)    
## (Intercept):carpool -1.4271e+01  3.1925e+00  -4.4702 7.815e-06 ***
## (Intercept):drove   -8.4027e+00  1.8398e+00  -4.5672 4.942e-06 ***
## (Intercept):transit -7.7999e+00  1.9141e+00  -4.0750 4.602e-05 ***
## (Intercept):walk    -2.9319e+00  1.8838e+00  -1.5564 0.1196142    
## time                -4.6018e+00  3.9861e-01 -11.5446 < 2.2e-16 ***
## INCOME:carpool      -3.7641e-05  1.2411e-05  -3.0329 0.0024222 ** 
## INCOME:drove        -2.3303e-05  6.6019e-06  -3.5298 0.0004159 ***
## INCOME:transit      -2.9410e-05  7.2032e-06  -4.0830 4.446e-05 ***
## INCOME:walk         -1.4919e-05  6.7679e-06  -2.2045 0.0274921 *  
## GEND:carpool         2.1593e+00  8.9614e-01   2.4096 0.0159718 *  
## GEND:drove           1.5181e+00  6.3793e-01   2.3798 0.0173226 *  
## GEND:transit         1.7317e+00  6.5425e-01   2.6469 0.0081244 ** 
## GEND:walk            1.5615e+00  6.5952e-01   2.3676 0.0179048 *  
## EDUC:carpool         2.7806e+00  1.2052e+00   2.3071 0.0210486 *  
## EDUC:drove           2.9604e+00  6.1872e-01   4.7848 1.712e-06 ***
## EDUC:transit         2.2030e+00  6.5791e-01   3.3485 0.0008126 ***
## EDUC:walk            1.9205e+00  6.7902e-01   2.8283 0.0046797 ** 
## TOTVEH:carpool       2.7390e+00  5.4397e-01   5.0352 4.774e-07 ***
## TOTVEH:drove         2.8518e+00  4.2337e-01   6.7361 1.626e-11 ***
## TOTVEH:transit       1.1663e+00  4.3069e-01   2.7080 0.0067695 ** 
## TOTVEH:walk          1.1614e+00  4.3067e-01   2.6967 0.0070035 ** 
## NPHON:carpool        2.1634e+00  1.1511e+00   1.8794 0.0601861 .  
## NPHON:drove          1.9941e+00  1.0726e+00   1.8591 0.0630119 .  
## NPHON:transit        2.3862e+00  1.0790e+00   2.2116 0.0269964 *  
## NPHON:walk           1.7034e+00  1.0859e+00   1.5687 0.1167251    
## HHSIZE:carpool      -2.0732e-01  2.5820e-01  -0.8030 0.4220003    
## HHSIZE:drove        -4.3716e-01  1.5083e-01  -2.8985 0.0037497 ** 
## HHSIZE:transit      -1.4064e-01  1.5371e-01  -0.9149 0.3602195    
## HHSIZE:walk         -2.6025e-01  1.6488e-01  -1.5784 0.1144669    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Log-Likelihood: -780.35
## McFadden R^2:  0.3882 
## Likelihood ratio test : chisq = 990.28 (p.value = < 2.22e-16)
```

```r
AIC(mod1, mod2, mod3, mod4)
```

```
##      df      AIC
## mod1 44 2110.743
## mod2 45 1598.820
## mod3  5 1980.270
## mod4 29 1618.700
```

Using a chi-square test, we further confirm that adding alternative specific variables (time) and eliminating insignificant variables improves model fit. 


```r
#think back to chisq test we did for binomial
modelChi <- (-2*(-780.35)) - (-2*(-754.41)) 
#-754.4 = log likelihood for mod2
#-780.35 = log likelihood for mod4
#this is the chisq in output

#calculating change in degree of freedom
mod4$logLik
```

```
## 'log Lik.' -780.3502 (df=29)
```

```r
df.mod4 <- 29
mod2$logLik
```

```
## 'log Lik.' -754.41 (df=45)
```

```r
df.mod2 <- 45

chidf <- df.mod4 - df.mod2

#if prob < 0.05, then the final model significantly improves fit
chisq.prob <- 1 - pchisq(modelChi, chidf)
chisq.prob #this is the chisq p-value in the output
```

```
## [1] NaN
```

The results below show the possibilities of choosing any of the 5 modes predicted by our model 4. 

For example, given all the circumstance in observation 1, the possibility of anyone choosing this mode of transportation is 32%.


```r
summary(mod4)
```

```
## 
## Call:
## mlogit(formula = mode ~ time | INCOME + GEND + EDUC + TOTVEH + 
##     NPHON + HHSIZE, data = datMNL, method = "nr")
## 
## Frequencies of alternatives:choice
##      bike   carpool     drove   transit      walk 
## 0.0058239 0.0037684 0.8961973 0.0493320 0.0448784 
## 
## nr method
## 9 iterations, 0h:0m:1s 
## g'(-H)^-1g = 0.000889 
## successive function values within tolerance limits 
## 
## Coefficients :
##                        Estimate  Std. Error  z-value  Pr(>|z|)    
## (Intercept):carpool -1.4271e+01  3.1925e+00  -4.4702 7.815e-06 ***
## (Intercept):drove   -8.4027e+00  1.8398e+00  -4.5672 4.942e-06 ***
## (Intercept):transit -7.7999e+00  1.9141e+00  -4.0750 4.602e-05 ***
## (Intercept):walk    -2.9319e+00  1.8838e+00  -1.5564 0.1196142    
## time                -4.6018e+00  3.9861e-01 -11.5446 < 2.2e-16 ***
## INCOME:carpool      -3.7641e-05  1.2411e-05  -3.0329 0.0024222 ** 
## INCOME:drove        -2.3303e-05  6.6019e-06  -3.5298 0.0004159 ***
## INCOME:transit      -2.9410e-05  7.2032e-06  -4.0830 4.446e-05 ***
## INCOME:walk         -1.4919e-05  6.7679e-06  -2.2045 0.0274921 *  
## GEND:carpool         2.1593e+00  8.9614e-01   2.4096 0.0159718 *  
## GEND:drove           1.5181e+00  6.3793e-01   2.3798 0.0173226 *  
## GEND:transit         1.7317e+00  6.5425e-01   2.6469 0.0081244 ** 
## GEND:walk            1.5615e+00  6.5952e-01   2.3676 0.0179048 *  
## EDUC:carpool         2.7806e+00  1.2052e+00   2.3071 0.0210486 *  
## EDUC:drove           2.9604e+00  6.1872e-01   4.7848 1.712e-06 ***
## EDUC:transit         2.2030e+00  6.5791e-01   3.3485 0.0008126 ***
## EDUC:walk            1.9205e+00  6.7902e-01   2.8283 0.0046797 ** 
## TOTVEH:carpool       2.7390e+00  5.4397e-01   5.0352 4.774e-07 ***
## TOTVEH:drove         2.8518e+00  4.2337e-01   6.7361 1.626e-11 ***
## TOTVEH:transit       1.1663e+00  4.3069e-01   2.7080 0.0067695 ** 
## TOTVEH:walk          1.1614e+00  4.3067e-01   2.6967 0.0070035 ** 
## NPHON:carpool        2.1634e+00  1.1511e+00   1.8794 0.0601861 .  
## NPHON:drove          1.9941e+00  1.0726e+00   1.8591 0.0630119 .  
## NPHON:transit        2.3862e+00  1.0790e+00   2.2116 0.0269964 *  
## NPHON:walk           1.7034e+00  1.0859e+00   1.5687 0.1167251    
## HHSIZE:carpool      -2.0732e-01  2.5820e-01  -0.8030 0.4220003    
## HHSIZE:drove        -4.3716e-01  1.5083e-01  -2.8985 0.0037497 ** 
## HHSIZE:transit      -1.4064e-01  1.5371e-01  -0.9149 0.3602195    
## HHSIZE:walk         -2.6025e-01  1.6488e-01  -1.5784 0.1144669    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Log-Likelihood: -780.35
## McFadden R^2:  0.3882 
## Likelihood ratio test : chisq = 990.28 (p.value = < 2.22e-16)
```

```r
fitted(mod4, outcome = TRUE, 30)   #probability of choosing any of the 4 modes
```

```
##            1            2            3            4            5            6 
## 3.257090e-01 5.268825e-01 1.398276e-02 2.347989e-01 2.176452e-03 1.242007e-01 
##            7            8            9           10           11           12 
## 1.286189e-01 6.377274e-01 1.042962e-01 1.215569e-02 1.543661e-01 2.116141e-02 
##           13           14           15           16           17           18 
## 7.872674e-01 8.256648e-03 9.612379e-02 1.859144e-01 5.761984e-02 5.916523e-02 
##           19           20           21           22           23           24 
## 7.960773e-01 3.023068e-01 5.466525e-02 6.242166e-02 4.898095e-01 7.905499e-01 
##           25           26           27           28           29           30 
## 8.382914e-01 5.556759e-01 2.390233e-01 8.651809e-01 1.704179e-01 7.377515e-01 
##           31           32           33           34           35           36 
## 8.882704e-01 6.592869e-01 4.337190e-02 6.926599e-01 3.716230e-01 5.419654e-01 
##           37           38           39           40           41           42 
## 7.263605e-01 6.589043e-01 7.600836e-01 9.625791e-02 6.536889e-01 9.146065e-01 
##           43           44           45           46           47           48 
## 8.509411e-01 2.883162e-01 1.789491e-01 7.804829e-02 2.845712e-01 2.845712e-01 
##           49           50           51           52           53           54 
## 7.673560e-01 9.223852e-01 2.611159e-01 4.999317e-01 5.827217e-01 5.013421e-01 
##           55           56           57           58           59           60 
## 8.315921e-01 4.167596e-01 4.247527e-01 3.654049e-01 5.462119e-01 1.239392e-01 
##           61           62           63           64           65           66 
## 8.163283e-01 6.203852e-01 7.912750e-01 5.957342e-01 8.995546e-01 8.895458e-01 
##           67           68           69           70           71           72 
## 8.634008e-01 7.771870e-01 8.768087e-01 7.392699e-01 7.392699e-01 8.279689e-01 
##           73           74           75           76           77           78 
## 8.867839e-01 6.613811e-01 8.122970e-01 3.362552e-02 6.172720e-01 6.172720e-01 
##           79           80           81           82           83           84 
## 6.493060e-01 6.835312e-01 6.910284e-01 6.562426e-01 9.077663e-01 7.201531e-01 
##           85           86           87           88           89           90 
## 8.685409e-01 6.671636e-02 2.794650e-01 8.694763e-01 8.694763e-01 7.731747e-01 
##           91           92           93           94           95           96 
## 2.805221e-01 6.121035e-02 1.779224e-03 4.932210e-01 4.871188e-01 5.271791e-01 
##           97           98           99          100          101          102 
## 1.045590e-01 5.332672e-01 1.823039e-01 4.795378e-02 8.105277e-01 8.497249e-01 
##          103          104          105          106          107          108 
## 2.342250e-01 2.769337e-01 6.563485e-01 6.841645e-01 8.246672e-01 8.275164e-01 
##          109          110          111          112          113          114 
## 4.824593e-01 7.417918e-01 1.445611e-01 5.883459e-01 4.962745e-01 4.202438e-01 
##          115          116          117          118          119          120 
## 2.896497e-01 8.029353e-01 2.460099e-01 6.783889e-01 7.057501e-01 3.305793e-01 
##          121          122          123          124          125          126 
## 6.876428e-01 8.254231e-01 4.281244e-01 7.263605e-01 7.251589e-01 7.636655e-01 
##          127          128          129          130          131          132 
## 8.486547e-01 1.037291e-01 8.184207e-01 5.903940e-01 8.827480e-01 7.808495e-01 
##          133          134          135          136          137          138 
## 7.405021e-01 5.646911e-01 4.381738e-01 5.691332e-01 6.613811e-01 4.476266e-01 
##          139          140          141          142          143          144 
## 1.601729e-02 8.871387e-01 4.989876e-01 7.915494e-01 2.641655e-01 5.646911e-01 
##          145          146          147          148          149          150 
## 6.954616e-01 8.254231e-01 4.589566e-01 5.358432e-01 5.769958e-01 1.746026e-02 
##          151          152          153          154          155          156 
## 7.648154e-02 9.782232e-02 6.489488e-02 3.338533e-01 2.484981e-03 3.054326e-02 
##          157          158          159          160          161          162 
## 9.836515e-02 1.859623e-02 5.905489e-02 1.598715e-02 1.277141e-02 8.118640e-02 
##          163          164          165          166          167          168 
## 1.270213e-05 4.701352e-02 9.741628e-02 1.018869e-02 4.938283e-02 1.622628e-02 
##          169          170          171          172          173          174 
## 7.910810e-03 8.847700e-03 1.583937e-02 1.921187e-01 2.008598e-03 1.650847e-01 
##          175          176          177          178          179          180 
## 5.774464e-01 1.470172e-01 3.497224e-01 1.563390e-01 3.538666e-01 3.428210e-01 
##          181          182          183          184          185          186 
## 4.521447e-02 6.179765e-02 1.138120e-01 2.640736e-01 2.198049e-01 4.058318e-01 
##          187          188          189          190          191          192 
## 3.898255e-01 4.543885e-01 6.257100e-01 3.702017e-01 2.681985e-02 5.744985e-01 
##          193          194          195          196          197          198 
## 1.621561e-02 7.669693e-02 1.674350e-02 1.825901e-01 1.171556e-02 1.070864e-02 
##          199          200          201          202          203          204 
## 7.511257e-02 2.583916e-02 3.380138e-03 6.612829e-03 4.435164e-03 9.488721e-02 
##          205          206          207          208          209          210 
## 2.606737e-01 3.480421e-01 1.424956e-01 6.309133e-01 6.763287e-02 4.996468e-01 
##          211          212          213          214          215          216 
## 2.908019e-01 4.064993e-01 3.825691e-02 1.798049e-01 1.634437e-01 6.652861e-01 
##          217          218          219          220          221          222 
## 6.063894e-01 4.441111e-01 1.962467e-02 2.015838e-01 2.308571e-01 3.696783e-01 
##          223          224          225          226          227          228 
## 9.810993e-02 5.444518e-01 6.849842e-02 1.179896e-01 1.482015e-01 2.353812e-01 
##          229          230          231          232          233          234 
## 8.536522e-01 6.467048e-01 5.782482e-02 7.765611e-01 5.898914e-01 1.926000e-01 
##          235          236          237          238          239          240 
## 2.855746e-01 3.262479e-01 3.616634e-01 1.912445e-01 4.062447e-01 3.610451e-02 
##          241          242          243          244          245          246 
## 2.826427e-01 1.709026e-01 8.466600e-02 1.133578e-02 3.912789e-01 2.879718e-03 
##          247          248          249          250          251          252 
## 1.149735e-01 1.640427e-04 1.754201e-01 1.896538e-02 4.435164e-03 1.586004e-01 
##          253          254          255          256          257          258 
## 1.887588e-01 7.444079e-03 1.839524e-02 2.346077e-02 1.839524e-02 8.308625e-03 
##          259          260          261          262          263          264 
## 3.230767e-01 7.772928e-04 6.411101e-03 4.438912e-04 1.209549e-01 7.435301e-02 
##          265          266          267          268          269          270 
## 5.716554e-01 1.171637e-02 2.486863e-01 3.896781e-02 5.480900e-02 5.453626e-01 
##          271          272          273          274          275          276 
## 1.976785e-01 1.731241e-01 4.585323e-01 1.447851e-01 2.763716e-02 1.983679e-03 
##          277          278          279          280          281          282 
## 1.167253e-01 4.324227e-01 3.282446e-02 1.926000e-01 1.243452e-01 9.939840e-03 
##          283          284          285          286          287          288 
## 3.419151e-01 3.931540e-01 5.337410e-01 2.671267e-01 3.616634e-01 6.007988e-02 
##          289          290          291          292          293          294 
## 3.911843e-01 1.639252e-01 5.724843e-02 7.656899e-01 9.569156e-03 3.436416e-03 
##          295          296          297          298          299          300 
## 1.407024e-02 5.407791e-03 4.254173e-03 7.172934e-04 1.022320e-02 3.361370e-03 
##          301          302          303          304          305          306 
## 5.491680e-03 4.254173e-03 3.831658e-03 9.840378e-01 8.470674e-01 9.888434e-01 
##          307          308          309          310          311          312 
## 8.979940e-01 4.752141e-01 8.865898e-01 9.676340e-01 9.475450e-01 9.879976e-01 
##          313          314          315          316          317          318 
## 9.910050e-01 9.386041e-01 9.612137e-01 9.673067e-01 9.430447e-01 9.947872e-01 
##          319          320          321          322          323          324 
## 8.551718e-01 9.470733e-01 7.621856e-01 8.904667e-01 9.798287e-01 5.694822e-01 
##          325          326          327          328          329          330 
## 9.499503e-01 9.847833e-01 9.896158e-01 9.975876e-01 9.954486e-01 9.137416e-01 
##          331          332          333          334          335          336 
## 8.893033e-01 8.638992e-01 9.911549e-01 9.901315e-01 9.129356e-01 8.970206e-01 
##          337          338          339          340          341          342 
## 9.158337e-01 9.454565e-01 9.202971e-01 9.240082e-01 9.594284e-01 9.783584e-01 
##          343          344          345          346          347          348 
## 8.507077e-01 7.196184e-01 9.262202e-01 9.255357e-01 8.326281e-01 8.993108e-01 
##          349          350          351          352          353          354 
## 9.156813e-01 8.449696e-01 9.065930e-01 9.877400e-01 9.852403e-01 9.711946e-01 
##          355          356          357          358          359          360 
## 9.386041e-01 9.846540e-01 9.763081e-01 9.883932e-01 9.962632e-01 9.887931e-01 
##          361          362          363          364          365          366 
## 9.794217e-01 9.794217e-01 9.901519e-01 9.811562e-01 9.892342e-01 9.812513e-01 
##          367          368          369          370          371          372 
## 9.715633e-01 9.129356e-01 9.725358e-01 9.461701e-01 9.325929e-01 9.912366e-01 
##          373          374          375          376          377          378 
## 9.881414e-01 9.984738e-01 9.441203e-01 7.986890e-01 9.173373e-01 9.718708e-01 
##          379          380          381          382          383          384 
## 6.644404e-01 9.233546e-01 9.704814e-01 9.637778e-01 9.978414e-01 9.987366e-01 
##          385          386          387          388          389          390 
## 9.211035e-01 9.960028e-01 9.848521e-01 9.776526e-01 9.881133e-01 9.263138e-01 
##          391          392          393          394          395          396 
## 9.871767e-01 9.890054e-01 9.111141e-01 9.246809e-01 9.398348e-01 8.520950e-01 
##          397          398          399          400          401          402 
## 9.557203e-01 8.053168e-01 9.552824e-01 9.579206e-01 9.812541e-01 9.740194e-01 
##          403          404          405          406          407          408 
## 9.947042e-01 9.040142e-01 9.523554e-01 9.279150e-01 9.882549e-01 9.921947e-01 
##          409          410          411          412          413          414 
## 9.157944e-01 9.928856e-01 9.918782e-01 9.634491e-01 8.795450e-01 9.515268e-01 
##          415          416          417          418          419          420 
## 4.879041e-01 9.465592e-01 9.733091e-01 8.935878e-01 9.780988e-01 9.742462e-01 
##          421          422          423          424          425          426 
## 9.420923e-01 9.643997e-01 9.920568e-01 9.942682e-01 9.472848e-01 9.353161e-01 
##          427          428          429          430          431          432 
## 9.977183e-01 8.023289e-01 9.688010e-01 9.793518e-01 9.780224e-01 9.831917e-01 
##          433          434          435          436          437          438 
## 9.825905e-01 9.692448e-01 9.022999e-01 9.927580e-01 9.784072e-01 9.967915e-01 
##          439          440          441          442          443          444 
## 9.606232e-01 9.623745e-01 9.967619e-01 9.079083e-01 9.795621e-01 5.694822e-01 
##          445          446          447          448          449          450 
## 6.324678e-01 9.437349e-01 9.588437e-01 8.952667e-01 9.780071e-01 9.685982e-01 
##          451          452          453          454          455          456 
## 9.627863e-01 9.840001e-01 9.813030e-01 9.323262e-01 9.486320e-01 9.257399e-01 
##          457          458          459          460          461          462 
## 8.278072e-01 9.345916e-01 9.554416e-01 8.812509e-01 8.831408e-01 8.535393e-01 
##          463          464          465          466          467          468 
## 9.448251e-01 9.255357e-01 8.599819e-01 9.538406e-01 9.439815e-01 9.344756e-01 
##          469          470          471          472          473          474 
## 9.912751e-01 9.535555e-01 9.289832e-01 9.026400e-01 9.840001e-01 9.704814e-01 
##          475          476          477          478          479          480 
## 9.505906e-01 5.055595e-01 5.823571e-01 9.957801e-01 8.477262e-01 9.534549e-01 
##          481          482          483          484          485          486 
## 9.662655e-01 9.585595e-01 1.573870e-01 9.574221e-01 9.981141e-01 8.340448e-01 
##          487          488          489          490          491          492 
## 7.737459e-01 8.239366e-01 9.335751e-01 9.957687e-01 9.933383e-01 9.822380e-01 
##          493          494          495          496          497          498 
## 8.960197e-01 9.908090e-01 9.818006e-01 9.899753e-01 5.520155e-01 8.197793e-01 
##          499          500          501          502          503          504 
## 8.616807e-01 9.930795e-01 4.422188e-01 7.994725e-01 9.575479e-01 9.785219e-01 
##          505          506          507          508          509          510 
## 9.835819e-01 9.149371e-01 9.933946e-01 9.241522e-01 9.539957e-01 9.782184e-01 
##          511          512          513          514          515          516 
## 9.434782e-01 9.974722e-01 9.992787e-01 9.736117e-01 9.808233e-01 9.737114e-01 
##          517          518          519          520          521          522 
## 9.709586e-01 8.198542e-01 9.324282e-01 9.894242e-01 9.933024e-01 8.239366e-01 
##          523          524          525          526          527          528 
## 9.604868e-01 9.775616e-01 9.925516e-01 9.953398e-01 8.792417e-01 9.927974e-01 
##          529          530          531          532          533          534 
## 9.959631e-01 9.947872e-01 9.242219e-01 9.007651e-01 9.886090e-01 9.714295e-01 
##          535          536          537          538          539          540 
## 4.634647e-01 9.649329e-01 9.491826e-01 9.740351e-01 9.767134e-01 9.864286e-01 
##          541          542          543          544          545          546 
## 9.896965e-01 8.923121e-01 9.958787e-01 9.854345e-01 9.435625e-01 9.671423e-01 
##          547          548          549          550          551          552 
## 9.580984e-01 9.689449e-01 9.844400e-01 9.841140e-01 9.738265e-01 8.864019e-01 
##          553          554          555          556          557          558 
## 9.665253e-01 9.386041e-01 9.788517e-01 9.963922e-01 9.948025e-01 9.941387e-01 
##          559          560          561          562          563          564 
## 9.428316e-01 9.916188e-01 9.871516e-01 9.951970e-01 9.948542e-01 9.963615e-01 
##          565          566          567          568          569          570 
## 9.855065e-01 9.960423e-01 9.890652e-01 9.987535e-01 9.138752e-01 8.720263e-01 
##          571          572          573          574          575          576 
## 9.725103e-01 8.953754e-01 9.262526e-01 9.894401e-01 9.317931e-01 7.650643e-01 
##          577          578          579          580          581          582 
## 9.587209e-01 8.971016e-01 9.818674e-01 9.908598e-01 7.627190e-01 9.902418e-01 
##          583          584          585          586          587          588 
## 9.891477e-01 9.891947e-01 9.862982e-01 9.437700e-01 9.793531e-01 9.850110e-01 
##          589          590          591          592          593          594 
## 9.174598e-01 8.447178e-01 9.430447e-01 9.971785e-01 9.980403e-01 9.950081e-01 
##          595          596          597          598          599          600 
## 9.958389e-01 9.618480e-01 9.627863e-01 9.463483e-01 9.499813e-01 9.830449e-01 
##          601          602          603          604          605          606 
## 4.938234e-01 9.460814e-01 9.454248e-01 9.867227e-01 9.732748e-01 8.754289e-01 
##          607          608          609          610          611          612 
## 7.169224e-01 9.665253e-01 9.676340e-01 8.846165e-01 9.838760e-01 9.370993e-01 
##          613          614          615          616          617          618 
## 9.345532e-01 9.626331e-01 9.557368e-01 9.572460e-01 9.773958e-01 8.591197e-01 
##          619          620          621          622          623          624 
## 9.813577e-01 9.849188e-01 9.692448e-01 9.463483e-01 4.425691e-01 9.158337e-01 
##          625          626          627          628          629          630 
## 9.885279e-01 9.853546e-01 9.876972e-01 9.790474e-01 9.932543e-01 9.129569e-01 
##          631          632          633          634          635          636 
## 7.351992e-01 9.836793e-01 9.914558e-01 9.866303e-01 9.867996e-01 7.480452e-01 
##          637          638          639          640          641          642 
## 9.911702e-01 9.853430e-01 9.634423e-01 9.046868e-01 9.834664e-01 9.729440e-01 
##          643          644          645          646          647          648 
## 9.950717e-01 9.939893e-01 5.163286e-01 5.915922e-01 9.964411e-01 9.654989e-01 
##          649          650          651          652          653          654 
## 9.581446e-01 8.925347e-01 9.901519e-01 9.572733e-01 9.942041e-01 9.913836e-01 
##          655          656          657          658          659          660 
## 9.460060e-01 9.125836e-01 9.939328e-01 9.909612e-01 9.837662e-01 9.906922e-01 
##          661          662          663          664          665          666 
## 9.779012e-01 9.546248e-01 9.830297e-01 9.817771e-01 9.949285e-01 9.967954e-01 
##          667          668          669          670          671          672 
## 9.906447e-01 9.902174e-01 8.207474e-01 9.781059e-01 9.538748e-01 9.628614e-01 
##          673          674          675          676          677          678 
## 8.812509e-01 9.954146e-01 9.976817e-01 9.677965e-01 9.911131e-01 9.879596e-01 
##          679          680          681          682          683          684 
## 9.926065e-01 9.844220e-01 9.768528e-01 7.345889e-01 9.628614e-01 9.952380e-01 
##          685          686          687          688          689          690 
## 9.929278e-01 9.966148e-01 9.883014e-01 9.941349e-01 8.780261e-01 9.493590e-01 
##          691          692          693          694          695          696 
## 9.630910e-01 9.897452e-01 9.866489e-01 9.974905e-01 9.963353e-01 9.607268e-01 
##          697          698          699          700          701          702 
## 9.642451e-01 9.959830e-01 9.935231e-01 8.634060e-01 9.786170e-01 9.859479e-01 
##          703          704          705          706          707          708 
## 9.918664e-01 9.908030e-01 9.917699e-01 9.884534e-01 9.886239e-01 9.514847e-01 
##          709          710          711          712          713          714 
## 8.319063e-01 9.878137e-01 9.147310e-01 8.717860e-01 9.904597e-01 9.132077e-01 
##          715          716          717          718          719          720 
## 9.833750e-01 8.856494e-01 9.872731e-01 9.211035e-01 9.235539e-01 9.366052e-01 
##          721          722          723          724          725          726 
## 9.533830e-01 8.170154e-01 9.740351e-01 9.505906e-01 9.735083e-01 8.392286e-01 
##          727          728          729          730          731          732 
## 9.174359e-01 9.745043e-01 9.790474e-01 9.648454e-01 9.521752e-01 9.711543e-01 
##          733          734          735          736          737          738 
## 9.828376e-01 7.452696e-01 9.542507e-01 9.428305e-01 9.935352e-01 8.309440e-01 
##          739          740          741          742          743          744 
## 9.749869e-01 9.780303e-01 9.505906e-01 9.844077e-01 9.492676e-01 9.274793e-01 
##          745          746          747          748          749          750 
## 9.260334e-01 9.851444e-01 9.895918e-01 9.722753e-01 9.330383e-01 9.142351e-01 
##          751          752          753          754          755          756 
## 7.803510e-01 9.861805e-01 9.855065e-01 9.968161e-01 9.438730e-01 9.586744e-01 
##          757          758          759          760          761          762 
## 9.415800e-01 9.601197e-01 9.900412e-01 7.211990e-01 7.481175e-01 9.263956e-01 
##          763          764          765          766          767          768 
## 9.967389e-01 9.945845e-01 9.971595e-01 9.663675e-01 9.912194e-01 9.531537e-01 
##          769          770          771          772          773          774 
## 8.008059e-01 8.525580e-01 9.452874e-01 9.749151e-01 9.627155e-01 9.111141e-01 
##          775          776          777          778          779          780 
## 8.981458e-01 9.848086e-01 9.086023e-01 9.615075e-01 9.430447e-01 9.603328e-01 
##          781          782          783          784          785          786 
## 9.763481e-01 9.810923e-01 9.704814e-01 9.502706e-01 7.810475e-01 9.853546e-01 
##          787          788          789          790          791          792 
## 9.675148e-01 9.525100e-01 9.972362e-01 9.699629e-01 9.560919e-01 9.733554e-01 
##          793          794          795          796          797          798 
## 9.922566e-01 9.748001e-01 9.960132e-01 9.502706e-01 9.919979e-01 8.922120e-01 
##          799          800          801          802          803          804 
## 9.736164e-01 9.909829e-01 9.441332e-01 9.695241e-01 9.647817e-01 9.985027e-01 
##          805          806          807          808          809          810 
## 9.902431e-01 9.089251e-01 9.335751e-01 9.651744e-01 8.071569e-01 7.786212e-01 
##          811          812          813          814          815          816 
## 9.808845e-01 6.558520e-01 8.712842e-01 6.795277e-01 9.406068e-01 8.299252e-01 
##          817          818          819          820          821          822 
## 8.494685e-01 9.850098e-01 9.894548e-01 9.704078e-01 9.721030e-01 8.707635e-01 
##          823          824          825          826          827          828 
## 9.678961e-01 9.310941e-01 4.860141e-01 8.758086e-01 9.422354e-01 5.940061e-01 
##          829          830          831          832          833          834 
## 7.754507e-01 8.045045e-01 9.961410e-01 9.961835e-01 9.384844e-01 8.960197e-01 
##          835          836          837          838          839          840 
## 9.717418e-01 9.704814e-01 9.645250e-01 9.692232e-01 9.665263e-01 9.822453e-01 
##          841          842          843          844          845          846 
## 9.476111e-01 9.323611e-01 8.995874e-01 9.714223e-01 8.436976e-01 9.122618e-01 
##          847          848          849          850          851          852 
## 9.907415e-01 9.948460e-01 9.948690e-01 7.722019e-01 9.595440e-01 9.766633e-01 
##          853          854          855          856          857          858 
## 9.319525e-01 9.929734e-01 9.897354e-01 9.875440e-01 9.956458e-01 9.623477e-01 
##          859          860          861          862          863          864 
## 9.688663e-01 9.831261e-01 9.763481e-01 9.979396e-01 9.978595e-01 9.939631e-01 
##          865          866          867          868          869          870 
## 9.956867e-01 9.916316e-01 9.846540e-01 9.267315e-01 9.924542e-01 9.948947e-01 
##          871          872          873          874          875          876 
## 9.902229e-01 8.447178e-01 9.897671e-01 9.931490e-01 9.066365e-01 8.588096e-01 
##          877          878          879          880          881          882 
## 9.961775e-01 9.960081e-01 6.629254e-01 9.856265e-01 9.620196e-01 9.818518e-01 
##          883          884          885          886          887          888 
## 8.741236e-01 6.348690e-01 9.569111e-01 9.261961e-01 9.612137e-01 9.895851e-01 
##          889          890          891          892          893          894 
## 9.677134e-01 9.847661e-01 9.535555e-01 8.039842e-01 9.806313e-01 9.854248e-01 
##          895          896          897          898          899          900 
## 7.845057e-01 9.902839e-01 9.783903e-01 9.654863e-01 9.675148e-01 9.854176e-01 
##          901          902          903          904          905          906 
## 9.756764e-01 9.698415e-01 8.994729e-01 9.936619e-01 9.941349e-01 9.903324e-01 
##          907          908          909          910          911          912 
## 9.948594e-01 9.705221e-01 8.677240e-01 9.687107e-01 9.876784e-01 9.948787e-01 
##          913          914          915          916          917          918 
## 9.330383e-01 8.838995e-01 9.957990e-01 9.691805e-01 8.694549e-01 9.973841e-01 
##          919          920          921          922          923          924 
## 9.985925e-01 9.985977e-01 9.973878e-01 9.828376e-01 9.700289e-01 9.335751e-01 
##          925          926          927          928          929          930 
## 9.883512e-01 9.813474e-01 9.582302e-01 7.674905e-01 9.848864e-01 9.741694e-01 
##          931          932          933          934          935          936 
## 9.707845e-01 9.901670e-01 9.829778e-01 9.645250e-01 9.854176e-01 9.976568e-01 
##          937          938          939          940          941          942 
## 9.973349e-01 7.182227e-01 9.915754e-01 8.350460e-01 9.943578e-01 9.769598e-01 
##          943          944          945          946          947          948 
## 9.800690e-01 9.829086e-01 9.847447e-01 9.559461e-01 6.888169e-01 8.954712e-01 
##          949          950          951          952          953          954 
## 9.688663e-01 9.264836e-01 2.759517e-01 9.561419e-01 9.555150e-01 9.476255e-01 
##          955          956          957          958          959          960 
## 9.546248e-01 9.642451e-01 9.662655e-01 8.470726e-01 7.092935e-01 9.692448e-01 
##          961          962          963          964          965          966 
## 9.768706e-01 9.931490e-01 9.882858e-01 9.766887e-01 9.894401e-01 9.671423e-01 
##          967          968          969          970          971          972 
## 9.499503e-01 9.968618e-01 9.963939e-01 9.963477e-01 9.967232e-01 9.553276e-01 
##          973          974          975          976          977          978 
## 9.626988e-01 9.918307e-01 9.943979e-01 8.316488e-01 9.897150e-01 9.630979e-01 
##          979          980          981          982          983          984 
## 9.753957e-01 9.526018e-01 9.689306e-01 9.300588e-01 9.950998e-01 9.950461e-01 
##          985          986          987          988          989          990 
## 9.973490e-01 9.973490e-01 9.294055e-01 9.252132e-01 9.212910e-01 9.983872e-01 
##          991          992          993          994          995          996 
## 9.971724e-01 9.971724e-01 9.970220e-01 9.984465e-01 9.968273e-01 9.526018e-01 
##          997          998          999         1000         1001         1002 
## 9.327057e-01 9.838225e-01 9.937885e-01 9.967891e-01 9.792417e-01 9.512128e-01 
##         1003         1004         1005         1006         1007         1008 
## 9.431163e-01 9.868877e-01 9.875726e-01 9.482262e-01 9.941595e-01 9.875190e-01 
##         1009         1010         1011         1012         1013         1014 
## 8.167233e-01 9.821082e-01 9.897191e-01 9.026400e-01 9.931490e-01 9.675652e-01 
##         1015         1016         1017         1018         1019         1020 
## 9.418547e-01 9.747311e-01 9.699211e-01 9.131483e-01 8.769121e-01 7.959704e-01 
##         1021         1022         1023         1024         1025         1026 
## 9.940044e-01 9.943339e-01 8.836072e-01 9.817700e-01 9.353881e-01 9.569693e-01 
##         1027         1028         1029         1030         1031         1032 
## 9.739052e-01 9.930932e-01 8.669969e-01 8.808908e-01 9.810574e-01 9.884396e-01 
##         1033         1034         1035         1036         1037         1038 
## 9.929874e-01 9.955135e-01 9.955389e-01 9.683867e-01 6.893459e-01 9.204696e-01 
##         1039         1040         1041         1042         1043         1044 
## 8.866097e-01 9.964510e-01 9.872313e-01 8.695048e-01 9.532687e-01 9.683499e-01 
##         1045         1046         1047         1048         1049         1050 
## 9.289675e-01 9.623201e-01 9.950556e-01 9.859496e-01 9.366245e-01 9.585291e-01 
##         1051         1052         1053         1054         1055         1056 
## 9.482945e-01 9.707845e-01 8.334795e-01 9.589631e-01 9.075894e-01 6.610963e-01 
##         1057         1058         1059         1060         1061         1062 
## 9.637843e-01 8.299252e-01 9.897354e-01 9.691243e-01 9.690639e-01 8.961873e-01 
##         1063         1064         1065         1066         1067         1068 
## 9.619386e-01 9.829862e-01 9.954951e-01 9.877293e-01 9.556218e-01 9.316707e-01 
##         1069         1070         1071         1072         1073         1074 
## 9.899906e-01 9.662655e-01 9.701405e-01 9.801746e-01 9.740807e-01 9.574684e-01 
##         1075         1076         1077         1078         1079         1080 
## 9.653524e-01 9.574273e-01 9.693689e-01 9.119659e-01 9.377292e-01 8.695821e-01 
##         1081         1082         1083         1084         1085         1086 
## 4.363940e-01 9.534659e-01 8.206438e-01 8.309344e-01 9.619338e-01 9.800690e-01 
##         1087         1088         1089         1090         1091         1092 
## 9.931235e-01 9.993103e-01 9.972643e-01 9.959122e-01 9.458567e-01 9.864993e-01 
##         1093         1094         1095         1096         1097         1098 
## 9.965656e-01 9.966612e-01 8.299252e-01 9.704814e-01 9.931553e-01 9.111141e-01 
##         1099         1100         1101         1102         1103         1104 
## 7.418918e-01 9.686622e-01 9.900420e-01 8.728352e-01 8.689785e-01 9.974465e-01 
##         1105         1106         1107         1108         1109         1110 
## 9.942366e-01 9.950589e-01 9.886552e-01 9.924888e-01 9.947895e-01 9.662655e-01 
##         1111         1112         1113         1114         1115         1116 
## 9.801862e-01 9.825905e-01 9.746345e-01 9.817013e-01 8.308315e-01 9.489146e-01 
##         1117         1118         1119         1120         1121         1122 
## 9.610868e-01 9.663735e-01 9.785219e-01 9.645619e-01 9.102528e-01 9.021492e-01 
##         1123         1124         1125         1126         1127         1128 
## 8.155256e-01 9.635504e-01 9.969117e-01 9.969117e-01 9.947201e-01 9.807588e-01 
##         1129         1130         1131         1132         1133         1134 
## 9.974035e-01 9.952965e-01 7.706874e-01 9.894726e-01 9.293058e-01 8.290154e-01 
##         1135         1136         1137         1138         1139         1140 
## 2.295842e-01 9.588529e-01 9.849648e-01 9.909714e-01 9.909569e-01 9.372194e-01 
##         1141         1142         1143         1144         1145         1146 
## 9.886774e-01 9.385174e-01 9.945636e-01 9.714545e-01 9.630910e-01 8.863891e-01 
##         1147         1148         1149         1150         1151         1152 
## 9.494251e-01 9.879209e-01 9.892508e-01 8.993263e-01 9.631037e-01 9.539957e-01 
##         1153         1154         1155         1156         1157         1158 
## 9.402808e-01 9.492465e-01 9.441443e-01 8.363170e-01 9.475693e-01 9.684037e-01 
##         1159         1160         1161         1162         1163         1164 
## 8.372808e-01 8.255304e-01 9.916046e-01 9.502706e-01 7.387600e-01 9.747106e-01 
##         1165         1166         1167         1168         1169         1170 
## 9.860922e-01 9.828925e-01 9.899709e-01 9.636918e-01 9.837946e-01 9.167168e-01 
##         1171         1172         1173         1174         1175         1176 
## 9.100597e-01 9.741694e-01 9.900420e-01 9.281547e-01 9.312367e-01 9.734772e-01 
##         1177         1178         1179         1180         1181         1182 
## 9.463483e-01 9.439168e-01 9.554797e-01 9.502649e-01 9.718708e-01 9.918935e-01 
##         1183         1184         1185         1186         1187         1188 
## 9.773315e-01 8.783955e-01 9.934869e-01 9.694525e-01 9.678765e-01 9.346728e-01 
##         1189         1190         1191         1192         1193         1194 
## 9.929003e-01 9.915158e-01 9.958226e-01 9.984975e-01 9.972881e-01 9.947223e-01 
##         1195         1196         1197         1198         1199         1200 
## 9.084647e-01 7.994725e-01 7.818225e-01 9.905837e-01 8.845406e-01 9.753902e-01 
##         1201         1202         1203         1204         1205         1206 
## 9.488195e-01 9.957384e-01 9.958288e-01 9.282635e-01 9.856704e-01 8.768074e-01 
##         1207         1208         1209         1210         1211         1212 
## 5.915922e-01 9.886090e-01 9.836793e-01 9.062695e-01 9.570612e-01 9.475330e-01 
##         1213         1214         1215         1216         1217         1218 
## 7.645857e-01 9.154609e-01 9.963381e-01 9.966149e-01 9.627863e-01 9.000870e-01 
##         1219         1220         1221         1222         1223         1224 
## 9.861829e-01 9.910369e-01 9.059809e-01 9.746897e-01 9.532687e-01 8.907415e-01 
##         1225         1226         1227         1228         1229         1230 
## 9.418547e-01 8.764324e-01 9.526018e-01 9.742336e-01 9.721415e-01 9.393163e-01 
##         1231         1232         1233         1234         1235         1236 
## 9.312693e-01 9.560155e-01 9.863004e-01 9.726212e-01 9.822371e-01 9.950168e-01 
##         1237         1238         1239         1240         1241         1242 
## 7.085965e-01 9.941984e-01 9.909106e-01 9.658074e-01 9.533830e-01 9.668444e-01 
##         1243         1244         1245         1246         1247         1248 
## 9.860287e-01 6.482787e-01 6.647104e-01 8.806965e-01 8.812509e-01 9.526018e-01 
##         1249         1250         1251         1252         1253         1254 
## 9.590492e-01 9.868263e-01 6.076346e-01 9.663735e-01 9.670668e-01 8.912204e-01 
##         1255         1256         1257         1258         1259         1260 
## 8.672603e-01 9.825825e-01 7.902409e-01 9.132077e-01 7.418918e-01 9.180920e-01 
##         1261         1262         1263         1264         1265         1266 
## 9.008208e-01 9.719914e-01 7.832870e-01 8.447178e-01 9.743555e-01 9.595440e-01 
##         1267         1268         1269         1270         1271         1272 
## 8.144195e-01 4.323803e-01 9.156813e-01 9.660760e-01 8.394468e-01 9.750636e-01 
##         1273         1274         1275         1276         1277         1278 
## 9.692790e-01 8.895548e-01 8.995874e-01 9.944481e-01 9.947490e-01 9.958180e-01 
##         1279         1280         1281         1282         1283         1284 
## 8.856469e-01 7.270486e-01 9.736534e-01 9.833518e-01 9.205857e-01 9.499503e-01 
##         1285         1286         1287         1288         1289         1290 
## 9.390651e-01 9.400118e-01 8.815447e-01 9.929721e-01 9.909612e-01 9.707845e-01 
##         1291         1292         1293         1294         1295         1296 
## 7.325856e-01 9.301003e-01 9.570612e-01 9.524707e-01 9.607539e-01 9.931721e-01 
##         1297         1298         1299         1300         1301         1302 
## 9.000506e-01 8.262434e-01 8.591180e-01 8.350460e-01 9.108589e-01 9.602167e-01 
##         1303         1304         1305         1306         1307         1308 
## 9.709997e-01 8.788596e-01 9.902383e-01 9.778929e-01 9.692448e-01 7.803726e-01 
##         1309         1310         1311         1312         1313         1314 
## 7.920150e-01 9.118383e-01 9.910329e-01 9.406068e-01 9.780303e-01 9.645250e-01 
##         1315         1316         1317         1318         1319         1320 
## 9.236863e-01 9.726505e-01 9.266159e-01 9.806434e-01 9.762595e-01 9.932908e-01 
##         1321         1322         1323         1324         1325         1326 
## 9.885472e-01 9.885472e-01 9.885472e-01 9.519289e-01 9.546248e-01 9.667169e-01 
##         1327         1328         1329         1330         1331         1332 
## 9.897354e-01 9.912732e-01 9.875106e-01 9.912732e-01 9.867540e-01 9.783021e-01 
##         1333         1334         1335         1336         1337         1338 
## 9.903806e-01 9.920891e-01 9.019473e-01 9.735912e-01 9.640877e-01 9.951281e-01 
##         1339         1340         1341         1342         1343         1344 
## 7.270486e-01 9.003927e-01 9.822453e-01 8.669563e-01 9.870330e-01 9.898122e-01 
##         1345         1346         1347         1348         1349         1350 
## 9.869554e-01 9.707391e-01 9.843961e-01 9.619635e-01 7.129508e-01 8.719550e-01 
##         1351         1352         1353         1354         1355         1356 
## 8.803710e-01 5.912133e-01 9.357083e-01 8.545063e-01 9.680762e-01 9.539855e-01 
##         1357         1358         1359         1360         1361         1362 
## 9.502706e-01 8.319063e-01 9.003927e-01 9.886982e-01 9.877029e-01 9.898122e-01 
##         1363         1364         1365         1366         1367         1368 
## 9.657611e-01 8.457293e-01 9.825420e-01 6.078871e-01 9.956407e-01 9.418547e-01 
##         1369         1370         1371         1372         1373         1374 
## 9.527481e-01 9.909408e-01 9.850141e-01 6.615020e-01 9.521752e-01 9.774699e-01 
##         1375         1376         1377         1378         1379         1380 
## 9.986056e-01 9.422042e-01 9.854176e-01 9.915158e-01 9.579297e-01 9.866058e-01 
##         1381         1382         1383         1384         1385         1386 
## 9.903554e-01 9.741503e-01 9.394445e-01 9.519494e-01 9.935832e-01 9.972189e-01 
##         1387         1388         1389         1390         1391         1392 
## 9.596119e-01 9.792622e-01 9.868972e-01 9.602106e-01 9.925826e-01 9.903712e-01 
##         1393         1394         1395         1396         1397         1398 
## 9.803514e-01 9.929278e-01 9.037311e-01 9.633101e-01 9.937228e-01 9.876394e-01 
##         1399         1400         1401         1402         1403         1404 
## 9.915598e-01 9.789427e-01 9.624401e-01 8.954712e-01 9.785846e-01 9.664187e-01 
##         1405         1406         1407         1408         1409         1410 
## 9.974204e-01 9.949326e-01 9.993898e-01 9.989573e-01 9.546248e-01 8.838928e-01 
##         1411         1412         1413         1414         1415         1416 
## 8.498500e-01 8.605053e-01 6.614126e-01 9.443683e-01 9.796663e-01 9.668444e-01 
##         1417         1418         1419         1420         1421         1422 
## 9.954912e-01 8.788596e-01 9.780819e-01 9.763481e-01 9.916046e-01 7.082798e-01 
##         1423         1424         1425         1426         1427         1428 
## 9.697186e-01 8.702354e-01 8.373196e-01 9.260492e-01 9.612137e-01 8.058779e-01 
##         1429         1430         1431         1432         1433         1434 
## 9.585593e-01 9.266566e-01 7.251317e-01 9.581224e-01 9.969778e-01 9.976110e-01 
##         1435         1436         1437         1438         1439         1440 
## 9.814942e-01 8.381714e-01 9.561419e-01 9.796226e-01 9.278909e-01 9.810923e-01 
##         1441         1442         1443         1444         1445         1446 
## 9.839348e-01 7.015705e-01 9.211035e-01 9.074073e-01 8.525580e-01 9.246166e-01 
##         1447         1448         1449         1450         1451         1452 
## 9.808499e-01 8.529537e-01 9.805537e-01 8.731863e-01 9.835865e-01 9.821364e-01 
##         1453         1454         1455         1456         1457         1458 
## 9.658579e-01 9.980153e-01 9.962361e-01 9.569650e-01 9.564985e-01 9.226610e-01 
##         1459         1460         1461         1462         1463         1464 
## 9.261732e-01 9.475330e-01 9.386041e-01 9.966456e-01 8.301292e-01 9.576701e-01 
##         1465         1466         1467         1468         1469         1470 
## 9.946668e-01 9.640877e-01 9.661456e-01 9.780303e-01 9.526384e-01 9.278670e-01 
##         1471         1472         1473         1474         1475         1476 
## 9.696949e-01 9.612137e-01 9.746431e-01 9.704078e-01 9.822608e-01 9.462150e-01 
##         1477         1478         1479         1480         1481         1482 
## 9.367149e-01 7.732743e-01 6.134541e-01 9.785369e-01 9.724241e-01 7.297350e-01 
##         1483         1484         1485         1486         1487         1488 
## 9.726212e-01 5.946010e-01 5.539667e-01 9.958376e-01 9.931338e-01 9.929874e-01 
##         1489         1490         1491         1492         1493         1494 
## 9.929874e-01 9.907928e-01 9.532687e-01 9.941672e-01 9.971166e-01 9.975201e-01 
##         1495         1496         1497         1498         1499         1500 
## 9.334593e-01 9.522851e-01 9.390378e-01 7.850944e-01 9.790907e-01 9.995078e-01 
##         1501         1502         1503         1504         1505         1506 
## 8.909504e-01 9.207356e-01 8.784786e-01 9.810923e-01 9.889147e-01 9.872282e-01 
##         1507         1508         1509         1510         1511         1512 
## 9.558730e-01 9.574684e-01 9.693731e-01 9.339862e-01 9.576434e-01 9.197555e-01 
##         1513         1514         1515         1516         1517         1518 
## 9.117115e-01 9.941349e-01 9.928395e-01 9.474501e-01 7.373637e-01 9.232306e-01 
##         1519         1520         1521         1522         1523         1524 
## 8.844627e-01 8.207474e-01 8.138271e-01 9.825755e-01 9.709185e-01 9.560847e-01 
##         1525         1526         1527         1528         1529         1530 
## 6.390796e-01 9.406068e-01 9.897797e-01 8.561883e-01 9.598567e-01 8.642345e-01 
##         1531         1532         1533         1534         1535         1536 
## 6.083418e-01 9.776328e-01 7.445516e-01 9.924293e-01 8.618415e-01 8.340809e-01 
##         1537         1538         1539         1540         1541         1542 
## 7.151614e-01 9.654863e-01 6.513093e-01 8.350460e-01 9.054740e-01 9.508483e-01 
##         1543         1544         1545         1546         1547         1548 
## 8.103976e-01 8.210877e-01 5.720953e-01 9.356207e-01 8.648815e-01 9.119659e-01 
##         1549         1550         1551         1552         1553         1554 
## 9.947593e-01 9.646235e-01 9.728957e-01 9.707845e-01 9.749869e-01 9.749359e-01 
##         1555         1556         1557         1558         1559         1560 
## 9.091817e-01 9.833750e-01 9.387227e-01 9.960423e-01 8.800903e-01 8.068839e-01 
##         1561         1562         1563         1564         1565         1566 
## 7.528497e-01 7.549715e-01 7.924894e-01 9.952823e-01 9.894726e-01 9.681602e-01 
##         1567         1568         1569         1570         1571         1572 
## 7.258400e-01 9.712274e-01 9.383625e-01 9.211035e-01 5.108265e-01 9.809802e-01 
##         1573         1574         1575         1576         1577         1578 
## 8.449468e-01 9.214031e-01 7.673879e-01 8.155256e-01 9.727125e-01 9.525700e-01 
##         1579         1580         1581         1582         1583         1584 
## 7.754507e-01 9.716295e-01 9.330383e-01 8.871690e-01 9.726239e-01 9.415549e-01 
##         1585         1586         1587         1588         1589         1590 
## 9.966126e-01 9.981766e-01 9.606232e-01 9.628614e-01 9.808845e-01 9.805727e-01 
##         1591         1592         1593         1594         1595         1596 
## 9.439815e-01 9.640348e-01 9.932991e-01 8.782337e-01 9.947678e-01 8.744516e-01 
##         1597         1598         1599         1600         1601         1602 
## 9.290857e-01 8.743801e-01 9.805537e-01 9.944544e-01 9.921994e-01 9.612137e-01 
##         1603         1604         1605         1606         1607         1608 
## 9.188104e-01 9.161110e-01 9.953034e-01 9.918953e-01 4.232643e-01 8.721352e-01 
##         1609         1610         1611         1612         1613         1614 
## 9.065930e-01 9.085382e-01 9.550406e-01 9.968464e-01 9.920595e-01 9.581180e-01 
##         1615         1616         1617         1618         1619         1620 
## 9.094146e-01 9.964496e-01 9.709739e-01 9.561419e-01 8.535080e-01 9.268531e-01 
##         1621         1622         1623         1624         1625         1626 
## 9.915660e-01 9.943886e-01 9.541844e-01 9.565089e-01 9.889431e-01 9.953435e-01 
##         1627         1628         1629         1630         1631         1632 
## 9.800498e-01 9.123988e-01 9.945060e-01 8.866340e-01 8.530769e-01 8.895766e-01 
##         1633         1634         1635         1636         1637         1638 
## 9.808845e-01 9.600179e-01 9.756321e-01 8.843118e-01 9.878045e-01 9.526018e-01 
##         1639         1640         1641         1642         1643         1644 
## 9.014355e-01 9.956226e-01 9.810923e-01 9.726239e-01 9.302442e-01 9.889185e-01 
##         1645         1646         1647         1648         1649         1650 
## 9.796686e-01 9.751097e-01 9.645250e-01 9.742212e-01 9.545018e-01 9.570612e-01 
##         1651         1652         1653         1654         1655         1656 
## 9.746432e-01 9.529423e-01 9.499503e-01 9.557203e-01 9.724863e-01 8.933204e-01 
##         1657         1658         1659         1660         1661         1662 
## 8.196908e-01 8.336901e-01 9.645619e-01 9.431163e-01 9.922443e-01 9.675426e-01 
##         1663         1664         1665         1666         1667         1668 
## 9.400460e-01 9.705030e-01 9.932151e-01 9.689959e-01 9.491895e-01 8.301483e-01 
##         1669         1670         1671         1672         1673         1674 
## 9.974755e-01 9.915814e-01 7.726981e-01 9.196435e-01 9.457079e-01 9.950648e-01 
##         1675         1676         1677         1678         1679         1680 
## 2.093449e-01 2.479830e-01 9.731142e-01 9.929721e-01 9.922877e-01 9.683499e-01 
##         1681         1682         1683         1684         1685         1686 
## 8.449696e-01 3.022240e-01 9.548547e-01 9.439168e-01 9.641038e-01 9.812385e-01 
##         1687         1688         1689         1690         1691         1692 
## 9.394538e-01 9.800498e-01 9.876784e-01 9.749581e-01 7.387600e-01 9.905981e-01 
##         1693         1694         1695         1696         1697         1698 
## 9.876972e-01 7.092935e-01 7.026072e-01 9.475330e-01 8.682655e-01 9.638786e-01 
##         1699         1700         1701         1702         1703         1704 
## 9.921252e-01 9.677965e-01 9.801641e-01 9.597947e-01 9.668444e-01 8.363115e-01 
##         1705         1706         1707         1708         1709         1710 
## 9.916533e-01 9.784840e-01 9.644300e-01 5.539667e-01 9.503481e-01 9.963631e-01 
##         1711         1712         1713         1714         1715         1716 
## 9.810397e-01 9.917236e-01 9.371524e-01 9.828925e-01 9.922245e-01 9.921994e-01 
##         1717         1718         1719         1720         1721         1722 
## 9.909714e-01 9.579447e-01 9.165808e-01 9.800612e-01 9.793375e-01 9.709997e-01 
##         1723         1724         1725         1726         1727         1728 
## 9.974446e-01 8.698425e-01 9.368219e-01 9.829285e-01 9.925008e-01 9.880641e-01 
##         1729         1730         1731         1732         1733         1734 
## 4.990655e-01 9.623161e-01 9.338174e-01 9.922877e-01 9.900935e-01 9.699815e-01 
##         1735         1736         1737         1738         1739         1740 
## 9.914050e-01 9.510827e-01 7.578391e-01 9.300648e-01 9.718708e-01 9.780303e-01 
##         1741         1742         1743         1744         1745         1746 
## 9.644681e-01 9.941874e-01 9.772559e-01 9.943803e-01 9.805537e-01 9.278685e-01 
##         1747         1748         1749         1750         1751         1752 
## 9.829615e-01 7.284392e-01 9.886239e-01 9.488355e-01 8.888811e-01 9.747485e-01 
##         1753         1754         1755         1756         1757         1758 
## 9.623745e-01 9.524127e-01 9.385846e-01 9.914183e-01 8.235624e-01 9.415573e-01 
##         1759         1760         1761         1762         1763         1764 
## 9.726212e-01 9.111141e-01 9.302442e-01 9.922682e-01 9.771391e-01 9.945693e-01 
##         1765         1766         1767         1768         1769         1770 
## 9.884534e-01 9.838390e-01 9.889849e-01 9.802944e-01 9.947895e-01 9.904653e-01 
##         1771         1772         1773         1774         1775         1776 
## 9.780303e-01 9.767134e-01 9.423511e-01 9.924293e-01 9.993764e-01 9.805537e-01 
##         1777         1778         1779         1780         1781         1782 
## 9.897093e-01 9.732836e-01 9.725209e-01 7.800099e-01 9.601197e-01 9.593173e-01 
##         1783         1784         1785         1786         1787         1788 
## 9.901894e-01 7.387600e-01 9.505906e-01 9.347145e-01 9.171146e-01 9.188104e-01 
##         1789         1790         1791         1792         1793         1794 
## 9.980278e-01 9.970369e-01 9.813577e-01 9.768368e-01 8.262172e-01 9.887328e-01 
##         1795         1796         1797         1798         1799         1800 
## 9.284207e-01 9.066365e-01 5.501749e-01 9.574684e-01 9.892978e-01 8.198099e-01 
##         1801         1802         1803         1804         1805         1806 
## 9.925904e-01 9.958776e-01 8.988008e-01 8.122492e-01 8.529537e-01 9.383625e-01 
##         1807         1808         1809         1810         1811         1812 
## 8.530769e-01 9.894401e-01 8.334795e-01 9.787354e-01 9.435241e-01 8.372808e-01 
##         1813         1814         1815         1816         1817         1818 
## 9.718708e-01 9.864637e-01 9.830736e-01 9.457026e-01 9.252121e-01 9.712737e-01 
##         1819         1820         1821         1822         1823         1824 
## 9.749869e-01 9.245044e-01 9.898213e-01 9.614096e-01 9.777727e-01 9.617514e-01 
##         1825         1826         1827         1828         1829         1830 
## 9.780303e-01 6.811026e-01 9.784840e-01 8.278072e-01 9.880319e-01 9.637841e-01 
##         1831         1832         1833         1834         1835         1836 
## 8.442511e-01 9.662655e-01 7.996683e-01 9.707211e-01 8.393573e-01 9.529526e-01 
##         1837         1838         1839         1840         1841         1842 
## 8.808908e-01 9.886090e-01 9.942601e-01 9.574576e-01 9.649726e-01 9.637957e-01 
##         1843         1844         1845         1846         1847         1848 
## 9.499503e-01 9.609273e-01 9.854399e-01 9.902101e-01 4.162445e-01 9.538406e-01 
##         1849         1850         1851         1852         1853         1854 
## 9.595440e-01 9.902001e-01 9.189364e-01 9.392924e-01 9.179358e-01 9.918093e-01 
##         1855         1856         1857         1858         1859         1860 
## 9.953237e-01 9.858482e-01 9.799153e-01 8.910159e-01 9.919070e-01 9.937812e-01 
##         1861         1862         1863         1864         1865         1866 
## 9.793648e-01 9.543122e-01 9.514134e-01 8.249167e-01 9.567535e-01 9.864297e-01 
##         1867         1868         1869         1870         1871         1872 
## 9.921536e-01 9.837989e-01 9.808845e-01 9.790030e-01 9.603328e-01 9.981518e-01 
##         1873         1874         1875         1876         1877         1878 
## 9.866173e-01 9.895560e-01 9.821082e-01 9.602288e-01 9.836086e-01 9.766175e-01 
##         1879         1880         1881         1882         1883         1884 
## 9.645250e-01 9.142167e-01 9.508483e-01 9.128366e-01 9.344402e-01 9.532687e-01 
##         1885         1886         1887         1888         1889         1890 
## 9.653524e-01 9.676340e-01 9.321186e-01 9.431240e-01 8.079232e-01 9.546872e-01 
##         1891         1892         1893         1894         1895         1896 
## 5.251488e-01 9.726239e-01 9.878045e-01 7.758931e-01 9.967059e-01 9.164854e-01 
##         1897         1898         1899         1900         1901         1902 
## 8.775105e-01 9.855788e-01 9.978471e-01 8.511633e-01 8.933204e-01 9.645250e-01 
##         1903         1904         1905         1906         1907         1908 
## 9.704814e-01 9.938519e-01 9.949081e-01 8.185265e-01 9.936225e-01 9.961718e-01 
##         1909         1910         1911         1912         1913         1914 
## 9.132077e-01 9.973110e-01 9.960602e-01 9.532687e-01 9.649329e-01 9.446168e-01 
##         1915         1916         1917         1918         1919         1920 
## 9.585595e-01 9.907877e-01 9.749869e-01 9.754613e-01 9.493731e-01 8.773770e-01 
##         1921         1922         1923         1924         1925         1926 
## 9.903554e-01 9.690639e-01 9.271140e-01 9.780214e-01 9.359130e-01 9.629671e-01 
##         1927         1928         1929         1930         1931         1932 
## 9.691049e-01 7.852915e-01 9.397198e-01 9.675426e-01 9.939655e-01 9.678080e-01 
##         1933         1934         1935         1936         1937         1938 
## 9.408184e-01 9.747311e-01 9.728851e-01 8.665396e-01 9.899906e-01 9.976003e-01 
##         1939         1940         1941         1942         1943         1944 
## 9.770599e-01 9.774530e-01 9.768007e-01 9.932137e-01 9.916183e-01 9.602167e-01 
##         1945         1946         1947         1948         1949         1950 
## 9.689449e-01 9.801641e-01 9.787450e-01 9.386573e-01 9.196435e-01 9.943281e-01 
##         1951         1952         1953         1954         1955         1956 
## 9.966148e-01 9.900787e-01 9.930911e-01 9.726239e-01 2.557813e-01 9.493649e-01 
##         1957         1958         1959         1960         1961         1962 
## 9.635716e-01 9.013294e-01 9.192281e-01 9.938160e-01 9.893595e-01 9.459163e-01 
##         1963         1964         1965         1966         1967         1968 
## 9.854637e-01 9.719150e-01 9.968118e-01 9.932915e-01 9.689765e-01 9.656146e-01 
##         1969         1970         1971         1972         1973         1974 
## 9.707845e-01 8.278072e-01 9.875440e-01 9.915210e-01 8.864019e-01 9.793508e-01 
##         1975         1976         1977         1978         1979         1980 
## 9.925774e-01 9.947988e-01 9.931730e-01 9.944281e-01 9.968482e-01 9.836190e-01 
##         1981         1982         1983         1984         1985         1986 
## 9.822380e-01 9.505906e-01 9.704976e-01 9.595287e-01 8.949097e-01 9.869554e-01 
##         1987         1988         1989         1990         1991         1992 
## 9.565089e-01 9.422354e-01 8.796625e-01 9.897156e-01 9.956966e-01 9.903231e-01 
##         1993         1994         1995         1996         1997         1998 
## 9.805383e-01 9.257830e-01 9.915356e-01 9.947297e-01 9.912732e-01 9.740351e-01 
##         1999         2000         2001         2002         2003         2004 
## 9.712523e-01 8.923168e-01 7.638407e-01 9.315847e-01 9.780303e-01 9.726853e-01 
##         2005         2006         2007         2008         2009         2010 
## 9.918664e-01 9.808560e-01 9.353493e-01 9.645250e-01 9.780303e-01 9.953513e-01 
##         2011         2012         2013         2014         2015         2016 
## 9.934747e-01 9.908825e-01 9.950124e-01 9.899194e-01 9.672974e-01 9.976693e-01 
##         2017         2018         2019         2020         2021         2022 
## 9.834944e-01 9.939321e-01 9.686946e-01 6.269934e-01 9.704814e-01 9.645250e-01 
##         2023         2024         2025         2026         2027         2028 
## 9.661068e-01 9.793046e-01 9.925834e-01 9.928508e-01 9.891804e-01 9.905934e-01 
##         2029         2030         2031         2032         2033         2034 
## 9.565089e-01 9.654863e-01 9.665703e-01 9.850078e-01 9.919197e-01 9.971684e-01 
##         2035         2036         2037         2038         2039         2040 
## 9.692448e-01 9.768706e-01 8.631447e-01 9.538406e-01 9.883500e-01 9.918584e-01 
##         2041         2042         2043         2044         2045         2046 
## 9.913869e-01 9.765644e-01 9.636310e-01 9.739718e-01 9.808845e-01 9.532133e-01 
##         2047         2048         2049         2050         2051         2052 
## 9.889431e-01 9.953965e-01 9.938948e-01 9.937530e-01 9.816969e-01 8.400822e-01 
##         2053         2054         2055         2056         2057         2058 
## 9.462150e-01 9.661665e-01 9.196435e-01 9.676340e-01 9.448141e-01 8.783894e-01 
##         2059         2060         2061         2062         2063         2064 
## 9.173569e-01 8.595069e-01 9.672061e-01 9.895346e-01 9.435325e-01 9.525383e-01 
##         2065         2066         2067         2068         2069         2070 
## 9.749359e-01 8.017634e-01 9.680070e-01 9.800950e-01 9.950444e-01 9.908656e-01 
##         2071         2072         2073         2074         2075         2076 
## 8.561216e-01 9.971022e-01 9.775926e-01 9.395695e-01 9.423363e-01 8.901391e-01 
##         2077         2078         2079         2080         2081         2082 
## 9.758644e-01 9.865057e-01 9.956417e-01 9.415549e-01 9.397198e-01 9.092438e-01 
##         2083         2084         2085         2086         2087         2088 
## 9.879580e-01 9.895982e-01 9.667650e-01 9.953182e-01 9.955350e-01 7.167832e-01 
##         2089         2090         2091         2092         2093         2094 
## 9.065930e-01 8.354054e-01 9.945739e-01 9.908047e-01 9.910355e-01 8.880519e-01 
##         2095         2096         2097         2098         2099         2100 
## 9.865475e-01 9.829778e-01 9.501986e-01 9.931721e-01 9.615896e-01 9.441171e-01 
##         2101         2102         2103         2104         2105         2106 
## 8.525177e-01 9.704622e-01 9.489636e-01 9.412086e-01 9.859250e-01 9.772381e-01 
##         2107         2108         2109         2110         2111         2112 
## 9.671423e-01 8.691158e-01 9.525700e-01 9.984984e-01 9.021492e-01 8.770768e-01 
##         2113         2114         2115         2116         2117         2118 
## 8.537261e-01 9.508483e-01 9.911183e-01 9.962632e-01 9.850673e-01 9.593678e-01 
##         2119         2120         2121         2122         2123         2124 
## 8.891289e-01 8.073535e-01 8.985732e-01 9.417704e-01 8.443240e-01 9.888696e-01 
##         2125         2126         2127         2128         2129         2130 
## 9.891967e-01 9.781059e-01 9.734772e-01 9.134185e-01 9.882858e-01 9.882858e-01 
##         2131         2132         2133         2134         2135         2136 
## 7.231477e-01 9.068239e-01 6.723454e-01 9.336526e-01 8.549216e-01 7.658767e-01 
##         2137         2138         2139         2140         2141         2142 
## 9.805727e-01 7.980418e-01 3.107057e-01 8.508335e-01 8.350460e-01 9.828177e-01 
##         2143         2144         2145         2146         2147         2148 
## 9.465073e-01 9.519514e-01 9.347039e-01 8.788596e-01 9.970807e-01 9.984376e-01 
##         2149         2150         2151         2152         2153         2154 
## 9.984580e-01 9.971021e-01 9.619048e-01 9.531621e-01 5.855369e-01 9.498067e-01 
##         2155         2156         2157         2158         2159         2160 
## 9.912366e-01 7.861107e-01 9.430316e-01 9.774530e-01 9.736117e-01 9.117728e-01 
##         2161         2162         2163         2164         2165         2166 
## 9.746431e-01 9.753606e-01 9.561419e-01 9.828893e-01 9.779012e-01 9.812399e-01 
##         2167         2168         2169         2170         2171         2172 
## 9.923704e-01 9.450975e-01 9.709185e-01 9.294918e-01 9.370993e-01 9.258606e-01 
##         2173         2174         2175         2176         2177         2178 
## 9.595440e-01 9.848086e-01 8.578499e-01 9.259457e-01 9.466555e-01 9.559368e-01 
##         2179         2180         2181         2182         2183         2184 
## 9.921365e-01 9.407148e-01 9.355938e-01 8.940393e-01 8.278072e-01 9.599006e-01 
##         2185         2186         2187         2188         2189         2190 
## 9.535784e-01 9.274793e-01 9.096744e-01 9.336376e-01 9.597953e-01 9.749869e-01 
##         2191         2192         2193         2194         2195         2196 
## 8.937353e-01 9.974755e-01 9.915814e-01 9.948867e-01 9.784840e-01 7.387600e-01 
##         2197         2198         2199         2200         2201         2202 
## 9.979367e-01 9.626947e-01 8.545063e-01 9.606232e-01 7.559483e-01 9.726212e-01 
##         2203         2204         2205         2206         2207         2208 
## 9.546248e-01 9.740351e-01 9.558563e-01 9.173815e-01 9.938658e-01 9.874188e-01 
##         2209         2210         2211         2212         2213         2214 
## 9.906569e-01 9.849854e-01 9.889849e-01 9.711624e-01 9.111596e-01 9.977157e-01 
##         2215         2216         2217         2218         2219         2220 
## 9.970106e-01 9.551077e-01 9.482949e-01 8.828528e-01 8.331557e-01 9.040142e-01 
##         2221         2222         2223         2224         2225         2226 
## 9.631037e-01 9.969001e-01 9.981327e-01 9.508407e-01 9.476111e-01 9.216725e-01 
##         2227         2228         2229         2230         2231         2232 
## 9.719150e-01 7.562547e-01 9.780303e-01 9.511222e-01 9.763481e-01 9.944552e-01 
##         2233         2234         2235         2236         2237         2238 
## 9.912732e-01 9.947576e-01 9.803959e-01 9.026400e-01 9.307498e-01 7.917161e-01 
##         2239         2240         2241         2242         2243         2244 
## 7.811154e-01 9.692535e-01 9.930652e-01 9.667719e-01 9.345909e-01 7.664801e-01 
##         2245         2246         2247         2248         2249         2250 
## 9.871767e-01 9.637617e-01 9.840001e-01 9.571017e-01 9.931566e-01 9.894726e-01 
##         2251         2252         2253         2254         2255         2256 
## 9.561545e-01 9.745996e-01 8.381714e-01 9.851311e-01 9.810923e-01 9.806026e-01 
##         2257         2258         2259         2260         2261         2262 
## 9.614860e-01 9.554508e-01 9.615478e-01 9.920080e-01 7.387940e-01 9.941697e-01 
##         2263         2264         2265         2266         2267         2268 
## 6.470690e-01 8.881019e-01 9.864993e-01 9.507450e-01 9.686622e-01 9.579297e-01 
##         2269         2270         2271         2272         2273         2274 
## 9.735912e-01 8.649909e-01 7.788040e-01 9.962770e-01 9.979831e-01 9.956508e-01 
##         2275         2276         2277         2278         2279         2280 
## 9.733173e-01 9.857691e-01 8.551892e-01 9.829683e-01 8.835216e-01 8.578429e-01 
##         2281         2282         2283         2284         2285         2286 
## 8.951511e-01 8.599819e-01 5.539667e-01 9.394750e-01 9.773469e-01 9.579206e-01 
##         2287         2288         2289         2290         2291         2292 
## 9.713967e-01 9.601197e-01 9.488195e-01 9.026400e-01 9.900692e-01 9.965795e-01 
##         2293         2294         2295         2296         2297         2298 
## 8.759278e-01 7.712439e-01 9.550406e-01 9.941525e-01 9.893317e-01 9.331601e-01 
##         2299         2300         2301         2302         2303         2304 
## 9.501066e-01 9.795385e-01 9.167970e-01 8.623014e-01 8.543756e-01 9.807138e-01 
##         2305         2306         2307         2308         2309         2310 
## 9.677965e-01 9.726212e-01 9.692448e-01 9.283998e-01 9.806434e-01 8.603713e-01 
##         2311         2312         2313         2314         2315         2316 
## 8.315758e-01 9.323262e-01 9.486320e-01 9.312671e-01 9.546248e-01 9.845223e-01 
##         2317         2318         2319         2320         2321         2322 
## 9.934313e-01 9.568982e-01 9.447903e-01 9.978396e-01 9.949326e-01 9.959097e-01 
##         2323         2324         2325         2326         2327         2328 
## 9.862280e-01 9.913217e-01 9.431607e-01 9.945636e-01 9.626804e-01 9.669768e-01 
##         2329         2330         2331         2332         2333         2334 
## 9.688622e-01 7.141405e-01 9.944416e-01 8.878028e-01 8.394299e-01 9.635716e-01 
##         2335         2336         2337         2338         2339         2340 
## 8.554000e-01 5.268592e-01 9.512056e-01 9.931566e-01 9.904822e-01 9.077847e-01 
##         2341         2342         2343         2344         2345         2346 
## 5.175829e-01 9.951697e-01 9.968193e-01 9.532687e-01 9.606232e-01 8.144195e-01 
##         2347         2348         2349         2350         2351         2352 
## 9.551077e-01 9.820471e-01 9.669580e-01 9.574273e-01 9.415664e-01 9.734772e-01 
##         2353         2354         2355         2356         2357         2358 
## 9.756760e-01 5.788663e-01 9.047392e-01 9.399320e-01 9.811425e-01 9.785846e-01 
##         2359         2360         2361         2362         2363         2364 
## 8.451945e-01 9.640149e-01 7.090763e-01 8.292994e-01 8.864019e-01 8.012473e-01 
##         2365         2366         2367         2368         2369         2370 
## 8.495836e-01 8.952667e-01 9.888763e-01 9.867830e-01 9.177188e-01 9.217279e-01 
##         2371         2372         2373         2374         2375         2376 
## 8.960197e-01 9.826778e-01 8.215061e-01 8.826166e-01 9.736514e-01 9.132077e-01 
##         2377         2378         2379         2380         2381         2382 
## 8.961271e-01 4.741401e-01 9.480752e-01 9.241522e-01 8.001985e-01 8.677240e-01 
##         2383         2384         2385         2386         2387         2388 
## 9.698068e-01 9.812776e-01 9.762729e-01 9.560919e-01 8.299252e-01 9.668444e-01 
##         2389         2390         2391         2392         2393         2394 
## 9.726212e-01 9.426893e-01 6.925400e-01 9.609216e-01 9.611699e-01 9.726212e-01 
##         2395         2396         2397         2398         2399         2400 
## 9.463483e-01 9.882960e-01 9.188104e-01 9.475330e-01 9.768706e-01 9.727674e-01 
##         2401         2402         2403         2404         2405         2406 
## 9.799627e-01 9.830751e-01 9.802331e-01 9.501828e-01 8.599819e-01 5.694822e-01 
##         2407         2408         2409         2410         2411         2412 
## 5.811442e-01 9.019473e-01 9.475330e-01 9.878661e-01 9.955995e-01 9.857597e-01 
##         2413         2414         2415         2416         2417         2418 
## 9.960662e-01 9.888739e-01 9.759095e-01 9.307457e-01 9.193851e-01 9.768706e-01 
##         2419         2420         2421         2422         2423         2424 
## 9.692448e-01 9.858482e-01 9.786780e-01 9.794850e-01 7.483796e-01 9.383693e-01 
##         2425         2426         2427         2428         2429         2430 
## 9.899436e-01 9.925008e-01 9.910050e-01 8.881019e-01 8.255304e-01 9.677660e-01 
##         2431         2432         2433         2434         2435         2436 
## 8.642321e-01 9.714545e-01 8.880519e-01 9.677965e-01 9.822380e-01 8.144195e-01 
##         2437         2438         2439         2440         2441         2442 
## 9.381734e-01 9.914558e-01 8.899455e-01 9.792934e-01 9.704814e-01 9.677965e-01 
##         2443         2444         2445         2446         2447         2448 
## 6.932859e-01 9.597953e-01 8.812509e-01 9.884835e-01 9.762521e-01 9.482949e-01 
##         2449         2450         2451         2452         2453         2454 
## 9.381734e-01 9.765550e-01 9.818197e-01 2.031704e-01 9.748532e-01 9.532687e-01 
##         2455         2456         2457         2458         2459         2460 
## 9.976482e-01 9.263956e-01 9.410428e-01 9.837515e-01 9.826138e-01 9.433682e-01 
##         2461         2462         2463         2464         2465         2466 
## 9.914558e-01 9.919309e-01 8.960398e-01 9.734535e-01 9.627863e-01 8.669563e-01 
##         2467         2468         2469         2470         2471         2472 
## 9.888696e-01 9.860287e-01 9.776203e-01 9.843043e-01 9.956746e-01 9.693935e-01 
##         2473         2474         2475         2476         2477         2478 
## 9.143703e-01 9.983240e-01 9.980403e-01 9.920676e-01 9.940169e-01 9.973586e-01 
##         2479         2480         2481         2482         2483         2484 
## 9.644141e-01 9.628614e-01 9.707845e-01 7.421174e-01 9.823001e-01 9.559116e-01 
##         2485         2486         2487         2488         2489         2490 
## 9.441203e-01 9.142167e-01 9.299825e-01 9.113882e-01 8.529537e-01 6.556275e-01 
##         2491         2492         2493         2494         2495         2496 
## 8.795450e-01 9.421536e-01 9.936036e-01 9.974074e-01 9.949285e-01 9.646766e-01 
##         2497         2498         2499         2500         2501         2502 
## 9.026400e-01 9.770799e-01 9.784840e-01 9.747727e-01 9.902418e-01 9.967366e-01 
##         2503         2504         2505         2506         2507         2508 
## 7.722019e-01 7.645857e-01 9.983229e-01 9.913372e-01 9.973626e-01 9.697179e-01 
##         2509         2510         2511         2512         2513         2514 
## 9.330383e-01 9.975512e-01 9.209775e-01 9.918884e-01 9.943679e-01 9.507240e-01 
##         2515         2516         2517         2518         2519         2520 
## 9.677965e-01 6.965053e-01 9.658792e-01 9.574684e-01 9.638343e-01 9.954625e-01 
##         2521         2522         2523         2524         2525         2526 
## 9.947853e-01 9.950168e-01 9.185287e-01 8.543756e-01 9.714223e-01 8.712520e-01 
##         2527         2528         2529         2530         2531         2532 
## 9.070018e-01 9.565089e-01 9.897146e-01 9.950326e-01 9.964130e-01 9.117118e-01 
##         2533         2534         2535         2536         2537         2538 
## 9.502706e-01 9.928029e-01 9.950497e-01 9.865736e-01 9.841486e-01 9.827953e-01 
##         2539         2540         2541         2542         2543         2544 
## 9.129569e-01 9.034445e-01 9.920064e-01 8.878282e-01 9.874814e-01 9.966456e-01 
##         2545         2546         2547         2548         2549         2550 
## 9.815202e-01 9.565089e-01 9.734804e-01 9.831807e-01 9.446984e-01 9.735912e-01 
##         2551         2552         2553         2554         2555         2556 
## 9.642451e-01 9.822380e-01 9.538748e-01 9.021492e-01 9.863952e-01 9.864637e-01 
##         2557         2558         2559         2560         2561         2562 
## 9.770203e-01 9.072453e-01 9.868275e-01 9.610868e-01 9.772749e-01 8.843118e-01 
##         2563         2564         2565         2566         2567         2568 
## 9.773457e-01 9.687107e-01 9.532687e-01 9.568672e-01 9.746739e-01 9.826138e-01 
##         2569         2570         2571         2572         2573         2574 
## 9.426893e-01 9.853374e-01 9.712083e-01 7.897638e-01 9.646235e-01 9.818197e-01 
##         2575         2576         2577         2578         2579         2580 
## 9.872731e-01 9.908598e-01 9.866268e-01 6.847671e-01 9.797495e-01 7.722019e-01 
##         2581         2582         2583         2584         2585         2586 
## 9.787619e-01 9.935077e-01 9.935228e-01 9.426504e-01 9.299306e-01 9.922826e-01 
##         2587         2588         2589         2590         2591         2592 
## 9.910780e-01 9.966119e-01 9.916935e-01 9.825418e-01 9.850354e-01 9.768073e-01 
##         2593         2594         2595         2596         2597         2598 
## 9.460060e-01 9.232145e-01 9.915662e-01 9.524962e-01 9.417704e-01 9.965537e-01 
##         2599         2600         2601         2602         2603         2604 
## 9.947498e-01 9.619061e-01 7.861107e-01 9.898122e-01 9.863571e-01 9.927165e-01 
##         2605         2606         2607         2608         2609         2610 
## 9.944359e-01 9.598805e-01 9.281397e-01 7.761679e-01 8.628710e-01 9.216302e-01 
##         2611         2612         2613         2614         2615         2616 
## 9.439815e-01 9.687662e-01 9.909444e-01 9.919418e-01 7.803510e-01 9.861805e-01 
##         2617         2618         2619         2620         2621         2622 
## 7.445516e-01 7.505655e-01 9.689449e-01 9.645619e-01 9.598929e-01 9.575479e-01 
##         2623         2624         2625         2626         2627         2628 
## 9.747548e-01 7.880975e-01 8.170233e-01 9.613830e-01 9.454174e-01 8.954712e-01 
##         2629         2630         2631         2632         2633         2634 
## 9.955910e-01 6.863949e-01 9.890891e-01 9.914756e-01 9.591197e-01 9.876102e-01 
##         2635         2636         2637         2638         2639         2640 
## 9.691498e-01 7.899129e-01 7.945140e-01 8.436615e-01 9.709185e-01 9.642451e-01 
##         2641         2642         2643         2644         2645         2646 
## 8.007029e-01 9.646537e-01 9.875440e-01 9.975398e-01 9.941508e-01 9.940769e-01 
##         2647         2648         2649         2650         2651         2652 
## 9.835688e-01 9.853546e-01 9.040142e-01 8.103976e-01 9.646537e-01 9.928029e-01 
##         2653         2654         2655         2656         2657         2658 
## 9.863084e-01 9.847400e-01 9.661456e-01 9.962563e-01 9.211035e-01 9.861805e-01 
##         2659         2660         2661         2662         2663         2664 
## 9.764112e-01 9.400059e-01 9.498067e-01 9.876765e-01 9.932279e-01 8.359167e-01 
##         2665         2666         2667         2668         2669         2670 
## 9.333687e-01 9.454653e-01 9.505906e-01 9.458567e-01 9.749456e-01 9.677965e-01 
##         2671         2672         2673         2674         2675         2676 
## 9.602167e-01 9.533829e-01 8.886812e-01 7.987400e-01 9.942994e-01 9.937243e-01 
##         2677         2678         2679         2680         2681         2682 
## 9.606232e-01 9.647271e-01 9.694213e-01 9.843113e-01 9.719827e-01 9.833750e-01 
##         2683         2684         2685         2686         2687         2688 
## 5.287784e-01 9.972303e-01 9.947184e-01 9.942660e-01 8.777089e-01 9.492676e-01 
##         2689         2690         2691         2692         2693         2694 
## 9.647909e-01 9.438201e-01 9.344661e-01 9.516569e-01 9.391048e-01 9.629347e-01 
##         2695         2696         2697         2698         2699         2700 
## 9.710980e-01 9.961441e-01 9.505906e-01 9.821737e-01 9.527901e-01 9.183536e-01 
##         2701         2702         2703         2704         2705         2706 
## 9.727668e-01 9.876765e-01 9.183957e-01 9.848986e-01 7.562547e-01 9.793947e-01 
##         2707         2708         2709         2710         2711         2712 
## 9.257399e-01 9.187616e-01 5.635978e-01 9.565089e-01 9.969134e-01 9.719880e-01 
##         2713         2714         2715         2716         2717         2718 
## 9.034900e-01 9.800498e-01 9.686621e-01 9.501828e-01 9.763481e-01 9.810923e-01 
##         2719         2720         2721         2722         2723         2724 
## 9.840607e-01 9.914756e-01 9.974995e-01 9.984022e-01 9.861250e-01 9.728842e-01 
##         2725         2726         2727         2728         2729         2730 
## 9.726212e-01 9.763481e-01 9.923344e-01 9.884298e-01 9.681614e-01 9.907702e-01 
##         2731         2732         2733         2734         2735         2736 
## 9.218013e-01 9.839348e-01 8.293838e-01 8.799350e-01 9.561419e-01 9.989636e-01 
##         2737         2738         2739         2740         2741         2742 
## 9.494326e-01 9.982142e-01 9.982142e-01 9.983879e-01 9.944004e-01 9.909396e-01 
##         2743         2744         2745         2746         2747         2748 
## 9.962370e-01 9.912566e-01 9.510924e-01 9.451498e-01 9.923503e-01 9.505906e-01 
##         2749         2750         2751         2752         2753         2754 
## 9.762343e-01 9.876765e-01 9.852747e-01 9.692448e-01 9.726212e-01 8.530769e-01 
##         2755         2756         2757         2758         2759         2760 
## 9.756321e-01 7.387600e-01 9.502706e-01 7.387600e-01 9.954912e-01 9.933031e-01 
##         2761         2762         2763         2764         2765         2766 
## 9.354325e-01 9.726212e-01 9.726239e-01 9.063461e-01 6.202317e-01 9.950326e-01 
##         2767         2768         2769         2770         2771         2772 
## 9.809802e-01 9.505906e-01 8.904667e-01 8.923663e-01 9.612137e-01 9.638343e-01 
##         2773         2774         2775         2776         2777         2778 
## 9.638100e-01 9.885784e-01 9.117799e-01 9.346344e-01 9.087284e-01 9.975350e-01 
##         2779         2780         2781         2782         2783         2784 
## 8.017730e-01 9.733173e-01 9.740486e-01 9.581180e-01 9.780303e-01 7.096411e-01 
##         2785         2786         2787         2788         2789         2790 
## 9.534659e-01 9.928681e-01 9.875183e-01 9.526018e-01 9.810923e-01 9.885623e-01 
##         2791         2792         2793         2794         2795         2796 
## 9.697431e-01 8.676523e-01 7.526259e-01 9.532133e-01 9.898019e-01 9.755696e-01 
##         2797         2798         2799         2800         2801         2802 
## 7.705069e-01 9.936228e-01 9.902418e-01 9.747311e-01 9.098566e-01 8.236067e-01 
##         2803         2804         2805         2806         2807         2808 
## 7.665873e-01 9.962381e-01 9.872391e-01 9.726212e-01 9.763481e-01 9.556389e-01 
##         2809         2810         2811         2812         2813         2814 
## 9.400297e-01 9.695569e-01 9.900822e-01 9.934538e-01 6.611187e-01 4.574930e-01 
##         2815         2816         2817         2818         2819         2820 
## 7.579155e-01 9.466626e-01 9.617765e-01 9.392924e-01 9.481211e-01 8.448668e-01 
##         2821         2822         2823         2824         2825         2826 
## 8.788596e-01 8.823281e-01 9.155990e-01 9.782873e-01 9.685771e-01 9.307457e-01 
##         2827         2828         2829         2830         2831         2832 
## 9.499503e-01 9.675426e-01 9.686946e-01 9.859985e-01 9.859985e-01 9.642266e-01 
##         2833         2834         2835         2836         2837         2838 
## 8.827778e-01 5.948268e-01 9.498067e-01 8.952695e-01 8.792608e-01 9.837490e-01 
##         2839         2840         2841         2842         2843         2844 
## 9.912138e-01 9.808943e-01 9.695569e-01 9.807138e-01 9.655145e-01 7.245645e-01 
##         2845         2846         2847         2848         2849         2850 
## 8.469689e-01 8.502812e-01 9.910369e-01 9.977754e-01 9.960846e-01 9.962780e-01 
##         2851         2852         2853         2854         2855         2856 
## 9.962997e-01 7.671739e-01 9.706189e-01 9.875440e-01 7.705069e-01 8.815447e-01 
##         2857         2858         2859         2860         2861         2862 
## 9.260492e-01 9.984360e-01 9.818518e-01 9.912919e-01 9.976659e-01 9.508483e-01 
##         2863         2864         2865         2866         2867         2868 
## 9.792354e-01 8.938743e-01 9.727674e-01 9.654863e-01 9.685420e-01 9.876587e-01 
##         2869         2870         2871         2872         2873         2874 
## 9.851487e-01 9.752437e-01 9.675426e-01 9.908282e-01 9.876146e-01 9.919676e-01 
##         2875         2876         2877         2878         2879         2880 
## 1.473532e-01 7.061432e-01 9.532133e-01 9.741694e-01 8.891709e-01 8.756690e-01 
##         2881         2882         2883         2884         2885         2886 
## 9.263956e-01 9.660493e-01 9.766583e-01 9.675426e-01 8.311191e-01 5.539667e-01 
##         2887         2888         2889         2890         2891         2892 
## 2.970729e-01 9.536423e-01 9.694804e-01 9.728851e-01 7.994579e-01 8.808908e-01 
##         2893         2894         2895         2896         2897         2898 
## 9.657344e-01 9.941595e-01 9.887328e-01 9.975221e-01 9.986912e-01 9.967764e-01 
##         2899         2900         2901         2902         2903         2904 
## 9.940945e-01 9.941292e-01 9.924977e-01 9.211035e-01 8.731863e-01 9.625834e-01 
##         2905         2906         2907         2908         2909         2910 
## 9.078819e-01 9.771518e-01 9.949155e-01 9.475450e-01 9.810923e-01 9.810923e-01 
##         2911         2912         2913         2914         2915         2916 
## 9.881717e-01 7.803510e-01 9.613830e-01 9.471858e-01 8.717860e-01 8.997009e-01 
##         2917         2918         2919 
## 9.753890e-01 9.485772e-01 9.312671e-01
```


## Conclusion  
### Model results   

The table below shows the model summary:


```r
library(stargazer)
stargazer(mod2, mod4, type = "text")
```

```
## 
## ===============================================================
##                                 Dependent variable:            
##                     -------------------------------------------
##                                        mode                    
##                              (1)                   (2)         
## ---------------------------------------------------------------
## (Intercept):carpool       -14.554***            -14.271***     
##                            (3.623)               (3.192)       
##                                                                
## (Intercept):drove         -8.606***             -8.403***      
##                            (2.140)               (1.840)       
##                                                                
## (Intercept):transit       -7.485***             -7.800***      
##                            (2.213)               (1.914)       
##                                                                
## (Intercept):walk            -3.401                -2.932       
##                            (2.184)               (1.884)       
##                                                                
## time                      -4.544***             -4.602***      
##                            (0.402)               (0.399)       
##                                                                
## AGE:carpool                 0.038                              
##                            (0.039)                             
##                                                                
## AGE:drove                   0.033                              
##                            (0.027)                             
##                                                                
## AGE:transit                 0.014                              
##                            (0.028)                             
##                                                                
## AGE:walk                    0.016                              
##                            (0.029)                             
##                                                                
## INCOME:carpool           -0.00004***           -0.00004***     
##                           (0.00001)             (0.00001)      
##                                                                
## INCOME:drove             -0.00002***           -0.00002***     
##                           (0.00001)             (0.00001)      
##                                                                
## INCOME:transit           -0.00003***           -0.00003***     
##                           (0.00001)             (0.00001)      
##                                                                
## INCOME:walk               -0.00002**            -0.00001**     
##                           (0.00001)             (0.00001)      
##                                                                
## GEND:carpool               2.139**               2.159**       
##                            (0.905)               (0.896)       
##                                                                
## GEND:drove                 1.532**               1.518**       
##                            (0.647)               (0.638)       
##                                                                
## GEND:transit               1.748***              1.732***      
##                            (0.663)               (0.654)       
##                                                                
## GEND:walk                  1.514**               1.561**       
##                            (0.671)               (0.660)       
##                                                                
## EDUC:carpool                2.254*               2.781**       
##                            (1.303)               (1.205)       
##                                                                
## EDUC:drove                 2.405***              2.960***      
##                            (0.700)               (0.619)       
##                                                                
## EDUC:transit               1.979***              2.203***      
##                            (0.738)               (0.658)       
##                                                                
## EDUC:walk                  1.861**               1.920***      
##                            (0.770)               (0.679)       
##                                                                
## TOTVEH:carpool             2.927***              2.739***      
##                            (0.596)               (0.544)       
##                                                                
## TOTVEH:drove               3.098***              2.852***      
##                            (0.455)               (0.423)       
##                                                                
## TOTVEH:transit             1.327***              1.166***      
##                            (0.462)               (0.431)       
##                                                                
## TOTVEH:walk                 0.910*               1.161***      
##                            (0.466)               (0.431)       
##                                                                
## RENT:carpool                -0.518                             
##                            (1.024)                             
##                                                                
## RENT:drove                  -0.058                             
##                            (0.660)                             
##                                                                
## RENT:transit                -0.424                             
##                            (0.681)                             
##                                                                
## RENT:walk                   -0.246                             
##                            (0.694)                             
##                                                                
## ADVLT:carpool               0.237                              
##                            (0.184)                             
##                                                                
## ADVLT:drove                 0.065                              
##                            (0.139)                             
##                                                                
## ADVLT:transit               0.064                              
##                            (0.145)                             
##                                                                
## ADVLT:walk                  -0.015                             
##                            (0.148)                             
##                                                                
## NPHON:carpool               2.163*                2.163*       
##                            (1.152)               (1.151)       
##                                                                
## NPHON:drove                 1.979*                1.994*       
##                            (1.072)               (1.073)       
##                                                                
## NPHON:transit              2.343**               2.386**       
##                            (1.079)               (1.079)       
##                                                                
## NPHON:walk                  1.637                 1.703        
##                            (1.086)               (1.086)       
##                                                                
## NOWRK:carpool               -0.372                             
##                            (0.687)                             
##                                                                
## NOWRK:drove                 -0.610                             
##                            (0.505)                             
##                                                                
## NOWRK:transit               -0.113                             
##                            (0.520)                             
##                                                                
## NOWRK:walk                  0.628                              
##                            (0.533)                             
##                                                                
## HHSIZE:carpool              -0.053                -0.207       
##                            (0.303)               (0.258)       
##                                                                
## HHSIZE:drove                -0.236              -0.437***      
##                            (0.181)               (0.151)       
##                                                                
## HHSIZE:transit              -0.079                -0.141       
##                            (0.187)               (0.154)       
##                                                                
## HHSIZE:walk                -0.333*                -0.260       
##                            (0.201)               (0.165)       
##                                                                
## ---------------------------------------------------------------
## Observations                2,919                 2,919        
## R2                          0.409                 0.388        
## Log Likelihood             -754.410              -780.350      
## LR Test             1,042.160*** (df = 45) 990.280*** (df = 29)
## ===============================================================
## Note:                               *p<0.1; **p<0.05; ***p<0.01
```

The model takes mode "biking" as a reference mode. As travel times increases,  people are less likely to take transit, drive, carpool, or walk compare to biking. 

The change in another variables (given as a coefficients) is associated with the change in odd ratio of the specific mode against the odd ratio of biking while keeping other variables constant. 

For example, let's look at "HHSIZE: transit". An unit increase in household size is associated with a 13% decrease in the odds of people taking transit compared to biking. This means, people who have larger houses have higher chance of being bikers than transit users.   

```r
100 * (exp(coef(mod4))-1)
```

```
## (Intercept):carpool   (Intercept):drove (Intercept):transit    (Intercept):walk 
##       -9.999994e+01       -9.997757e+01       -9.995902e+01       -9.467047e+01 
##                time      INCOME:carpool        INCOME:drove      INCOME:transit 
##       -9.899658e+01       -3.764029e-03       -2.330300e-03       -2.941006e-03 
##         INCOME:walk        GEND:carpool          GEND:drove        GEND:transit 
##       -1.491933e-03        7.665055e+02        3.563725e+02        4.650259e+02 
##           GEND:walk        EDUC:carpool          EDUC:drove        EDUC:transit 
##        3.765841e+02        1.512922e+03        1.830635e+03        8.051913e+02 
##           EDUC:walk      TOTVEH:carpool        TOTVEH:drove      TOTVEH:transit 
##        5.824054e+02        1.447124e+03        1.631979e+03        2.210074e+02 
##         TOTVEH:walk       NPHON:carpool         NPHON:drove       NPHON:transit 
##        2.194328e+02        7.700416e+02        6.345684e+02        9.872388e+02 
##          NPHON:walk      HHSIZE:carpool        HHSIZE:drove      HHSIZE:transit 
##        4.492755e+02       -1.872417e+01       -3.541344e+01       -1.311964e+01 
##         HHSIZE:walk 
##       -2.291427e+01
```

## Model performance

According to **Behavioral Travel Modelling**, edited by David Hensher and Peter Stopher in 1979, a R2 between 0.2-0.4 represents an excellent fit. Our model has a great fit with an R2 of 0.39.

Let's now predict the results based on different time. 

```r
str(datMNL)
```

```
## Classes 'dfidx_mlogit', 'dfidx', 'mlogit.data' and 'data.frame':	14595 obs. of  30 variables:
##  $ SAMPN.x     : 'xseries_mlogit' int  1009329 1009329 1009329 1009329 1009329 1015320 1015320 1015320 1015320 1015320 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ PERNO.x     : 'xseries_mlogit' int  3 3 3 3 3 1 1 1 1 1 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ X           : 'xseries_mlogit' int  10093293 10093293 10093293 10093293 10093293 10153201 10153201 10153201 10153201 10153201 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ AGE         : 'xseries_mlogit' int  16 16 16 16 16 43 43 43 43 43 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ INCOME      : 'xseries_mlogit' int  87000 87000 87000 87000 87000 87000 87000 87000 87000 87000 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ SAMPN_PER   : 'xseries_mlogit' chr  "10093293" "10093293" "10093293" "10093293" ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ with_toll   : 'xseries_mlogit' num  2 2 2 2 2 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ TOLL        : 'xseries_mlogit' num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ with_park   : 'xseries_mlogit' num  2 2 2 2 2 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ PARKU       : 'xseries_mlogit' num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ PARKO       : 'xseries_mlogit' chr  "" "" "" "" ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ TRPDUR      : 'xseries_mlogit' int  4 4 4 4 4 60 60 60 60 60 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ drove_work  : 'xseries_mlogit' num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ transit_work: 'xseries_mlogit' num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ carpool_work: 'xseries_mlogit' num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ GEND        : 'xseries_mlogit' int  1 1 1 1 1 1 1 1 1 1 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ DISAB       : 'xseries_mlogit' int  2 2 2 2 2 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ EDUC        : 'xseries_mlogit' int  1 1 1 1 1 1 1 1 1 1 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ TOTVEH      : 'xseries_mlogit' int  2 2 2 2 2 1 1 1 1 1 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ ADVLT       : 'xseries_mlogit' int  8 8 8 8 8 3 3 3 3 3 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ RENT        : 'xseries_mlogit' int  2 2 2 2 2 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ ENGL        : 'xseries_mlogit' int  2 2 2 2 2 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ HHSIZE      : 'xseries_mlogit' int  8 8 8 8 8 5 5 5 5 5 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ NPHON       : 'xseries_mlogit' int  1 1 1 1 1 1 1 1 1 1 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ NOWRK       : 'xseries_mlogit' int  2 2 2 2 2 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ mode        : 'xseries_mlogit' logi  TRUE FALSE FALSE FALSE FALSE TRUE ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ alt         : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ time        : 'xseries_mlogit' num  0.0667 0.0267 0.0267 0.032 0.2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ chid        : 'xseries_mlogit' int  1 1 1 1 1 2 2 2 2 2 ...
##   ..- attr(*, "idx")=Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   .. ..$ chid: int [1:14595] 1 1 1 1 1 2 2 2 2 2 ...
##   .. ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   .. ..- attr(*, "ids")= num [1:2] 1 2
##  $ idx         :Classes 'idx' and 'data.frame':	14595 obs. of  2 variables:
##   ..$ chid: int  1 1 1 1 1 2 2 2 2 2 ...
##   ..$ alt : Factor w/ 5 levels "bike","carpool",..: 1 2 3 4 5 1 2 3 4 5 ...
##   ..- attr(*, "ids")= num [1:2] 1 2
##  - attr(*, "reshapeLong")=List of 4
##   ..$ varying:List of 1
##   .. ..$ time: chr [1:5] "time.drove" "time.bike" "time.transit" "time.carpool" ...
##   .. ..- attr(*, "v.names")= chr "time"
##   .. ..- attr(*, "times")= chr [1:5] "drove" "bike" "transit" "carpool" ...
##   ..$ v.names: chr "time"
##   ..$ idvar  : chr "chid"
##   ..$ timevar: chr "alt"
##  - attr(*, "clseries")= chr [1:2] "xseries_mlogit" "xseries"
##  - attr(*, "choice")= chr "mode"
```

```r
dtime <- data.frame(time = datMNL$time, GEND=1,INCOME=mean(dat$INCOME), EDUC = 1, TOTVEH = mean(datMNL$TOTVEH), NPHON = mean(datMNL$NPHON), HHSIZE = mean(datMNL$HHSIZE))

pp.time <- cbind(dtime, predict(mod4, newdata = dtime, type = "probs", se = TRUE)) %>%
  select(time, drove,bike,walk,transit, carpool) 

  pp.time %>%
  gather(Varible, Value, -time) %>%
  ggplot(aes(x = time, y = Value, color = Varible)) + geom_line() +  theme_light() + ylab("Probability") + xlab("Travel Time") + labs(title = "Probability of Mode Choice against Travel Time", color = "Mode")
```

![](Hu_Duan_Assignment3_April22_files/figure-html/time scenarios-1.png)<!-- -->

The graph above shows that people would always prefer driving regardless of time. When travel time is below 10 minutes, some people prefer walking; but when the travel time is greater than 10 minutes, the rate of walking sharply decreased, lower than the probability of transit, and about the same as biking.
We can also see that when travel time is beyond 10 minutes, the probably of driving is higher and more consistent.

The model performs the worst on walking, because the variation is just so large among the prediction results with a range between 0.00 - 0.75. This makes sense, because we have few observations on walking, which makes the results more inconsistent. 

## Model limitations   

The model could be improved if we incorporated the estimated cost of each trip by different modes. This is a little difficult to calculate, since the transit cost per mile might vary depending on the distance.  

