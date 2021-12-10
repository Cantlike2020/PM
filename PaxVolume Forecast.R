#otexts.com
library(fpp2)
library(readxl)

#1. Load Data 
TenYears <- read_excel("C:/#PATH#/13yrs.xlsx")

#2. Findg trend & Explain LF
Paxvolts<-ts(TenYears[,6],start=c(2009,1), frequency = 12)
plot(Paxvolts, ylab="Pax Vol by 1000s", xlab="Years", main="Time Series Plot for Pax Volume")
abline(reg=lm(Paxvolts~time(Paxvolts)))

ggseasonplot(Paxvolts, year.labels = TRUE, year.labels.left = TRUE)+
  ggtitle("Seasonal plot: Monthly Pax Vol From 2009 to 2019") +
  ylab("Pax Vol by the 1000s")

#3. Declare Time Series by using LF
PaxLF <- ts(TenYears[,5],start=c(2009,1), frequency = 12)

ggseasonplot(PaxLF, year.labels = TRUE, year.labels.left = TRUE) + 
  ggtitle("Seasonal Plot: Change in Monthly Load Factor")+
  ylab("Pax Load Factor")

#4. Remove Outliers 2020 to establish training set
# during process we discovered SD residual higher and less accurate
PaxLF_No2020 <- ts(TenYears[,5],start=c(2009,1), end=c(2019,1), frequency = 12)

ggseasonplot(PaxLF_No2020, year.labels = TRUE, year.labels.left = TRUE) + 
  ggtitle("Seasonal Plot: Change in Monthly Load Factor")+
  ylab("Pax Load Factor")

#5. Arima works best with Monthly Volume Forecast based on historical data
#Arima model had the lowest SD residuals #sigma^2 estimated as 0.0004928 SD=0.02231 
#comparing to other models EST Snaive
arima_LF <- auto.arima(PaxLF_No2020, d=1,D=1,stepwise=FALSE, approximation = FALSE, trace=TRUE)
#Best model: ARIMA(1,1,1)(0,1,1)[12]                    
checkresiduals(arima_LF)
#Residual numbers are the leftover numbers after fitting our model
#the goal is to have ACF fit within two blue dotted lines
#which mean they are lack of correlations -> good model

forecast_LF <- forecast(arima_LF, h=47)
autoplot(forecast_LF,include = 60)
forecast_LF

##################################################### Weekly & Hourly Models#####Training Set Begin

#Load Data 
Weekly <- read_excel("C:/#PATH#/ByWeek.xlsx")
#2009 to 2021 historical DoW volume in a month
#On a Sunday in Jan in 2009, the average LF was 62.48%
#Declare Time Series 

PaxLF_Week <- ts(Weekly[,6],start=c(2009,1), frequency = 7*12)

#Visualize the pattern of Seasonality by DoW
ggseasonplot(PaxLF_Week,  year.labels = TRUE, year.labels.left = TRUE)+
  ggtitle("seasonal plot: Weekly Pax Vol 2009 to 2021") +
  ylab("Pax LF")

#Time plot in one line

########################################NO 2020 DATA ####

Week_No2020 <- ts(Weekly[,6],start=c(2009,1), end=c(2019,1), frequency = 7*12)

#explain LF then possible bias, in final model will try to use Mean and compare

ggseasonplot(Week_No2020, year.labels = TRUE, year.labels.left = TRUE) + 
  ggtitle("seasonal plot: Weekly LF 2009 to 2019") +
  ylab("Pax LF")

#########################################NO 2020 DATA END #####
####### We will not use ETS model for weekly & hourly

#Although Arima model had more accurate results and smaller residuals, Snaive was much more efficient and time saving
fit_LF <- snaive(Week_No2020) 
print(summary(fit_LF)) #residual sd 0.0475 
checkresiduals(fit_LF)

forecast_LF <- forecast(fit_LF, h=24*7) #154 for dow 
autoplot(forecast_LF,include = 84)
forecast_LF
#in Forecast, the first 2019.012 number indicates the first 2 or Monday of January 
# Patterns are very similar after comparing 2019, 2020, 2021, 2022
####################################
#Hourly Pax Load in a particular month
Hour <- read_excel("C:/#PATH#/Hour.xlsx")
Hourly <- ts(Hour[,6],start=c(2009,1), end=c(2019,1), frequency = 12*16) #

ggseasonplot(Hourly, year.labels = TRUE, year.labels.left = TRUE) + 
  ggtitle("seasonal plot: Hourly LF 2009 to 2019") +
  ylab("Pax LF")

#########################################NO 2020 DATA END #####

Hour_LF <- snaive(Hourly) 
print(summary(Hour_LF)) #residual sd 0.0601
checkresiduals(fit_LF)

forecast_HourLF <- forecast(Hour_LF, h=12*16)
autoplot(forecast_HourLF,include = 384)
options(max.print = 1000000)
forecast_HourLF

