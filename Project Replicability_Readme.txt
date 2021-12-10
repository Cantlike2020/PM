


Project Replicability
Jye Gou and Elvira Donuk 
The College of Emergency Preparedness, Homeland Security and Cybersecurity
University at Albany
CINF 624: Predictive Modeling
Professor Carol Cuzano
December 10, 2021
	









README FILE
Passenger Volume Forecast LaGuardia (LGA) Airport in New York City
For Year 2022
By Jye Guo and Elvira Donuk

	The purpose of this project is to build an accurate passenger volume forecast for airline companies, airport management, and stakeholders based on historical data of passenger throughput. Forecasting models with superior quality is the primary factor in creating accurate passenger volume report that the airport management and companies could use in order to plan an efficient daily operation. Therefore, in this project, Time-Series Forecasting method was used to accurately process passenger volume specifically for the Airline ABC in LaGuardia to mitigate daily operational challenges they incessantly encounter during the airport constructions which will be completed by the end of 2024. This forecast excepted the 2020 data due to forecast inefficiency, thus, the impact of Covid Pandemic in 2020 assumed to be nonexistence in the forecast models.
      The models used to obtain training and testing sets to determine the accuracy of the predictions were Exponential Smoothing, ARIMA, and Seasonal Naive models, consequently, it was determined that ARIMA model was more accurate and efficient for Yearly and monthly forecasts and Seasonal Naive Model was more system efficient for Day of Week and Hourly predictions, however, slightly less accurate than ARIMA model. The project is utilizing R Studio to build predicting models for yearly, monthly, day of week, and hourly passenger volume using the load factor which is the quotient of the aircraft seat capacity by the historical passenger count. 
      The historical data provided by Airline ABC between January 2009 and November 2021 was exhaustively huge, and therefore explored and cleaned up during the loading process in R Studio before building the predictive models. This project is comprised of three datasets which includes monthly, day of week, hourly. Each dataset contained variables for the year, month, day of week, hour of day, passenger count, aircraft seat capacity, and calculated load factor. 
      How to install and use the project files including validation/evaluation
1) Datasets for training/testing must be downloaded into your computer 
(Disclaimer: Due to confidentiality issue the passenger counts were altered for replicability purpose.) 
> ByMonth.xlsx
> ByWeek.xlsx
> ByHour.xlsx

2) Download free R Studio software package into your computer from below link
https://cran.r-project.org/web/packages/ISLR/index.html

3) Perform steps below for training, testing, and predictive models using the following codes 

> Install fpp2 and readxl libraries in R Studio (Handyman, 2018)
Library(fpp2)
Library(readxl)
> Load all datasets files in R Studio 
TenYears <- read_excel("C:/PATH/ ByMonth.xlsx")
ByWeek <- read_excel("C:/PATH/ ByWeek.xlsx")
ByHour <- read_excel("C:/PATH/ ByHour.xlsx")

4) Finding and understanding monthly trend for load factor 
> Declare time series for monthly load factor data by year in R Studio from 2009, 12 months in a year for frequency 
PaxLF <- ts(TenYears[,5],start=c(2009,1), frequency = 12)
> Plot the graph for the time series load factor data 
ggseasonplot(PaxLF, year.labels = TRUE, year.labels.left = TRUE) + 
ggtitle("Seasonal Plot: Change in Monthly Load Factor")+
ylab("Pax Load Factor")

5) Steps to forecast Monthly Load Factor
> Declare Arima Model
arima_LF <- auto.arima(TenYears, d=1,D=1,stepwise=FALSE, approximation = FALSE, trace=TRUE)
> Declare forecast for Load Factor
forecast_LF <- forecast(arima_LF, h=47)
> Plot the graph for the forecasted Load Factor
autoplot(forecast_LF,include = 60)
> View forecasted Load Factor for Training and Testing sets
Forecast_LF

6) Build forecast table for Weekly using Seasonal Naive Model (use the same principle for Hourly forecast model)
PaxLF_Week <- ts(Weekly[,6],start=c(2009,1), frequency = 7*12)
ggseasonplot(PaxLF_Week,  year.labels = TRUE, year.labels.left = TRUE)+
 	ggtitle("seasonal plot: Weekly Pax Vol 2009 to 2021") + ylab("Pax LF")
 
7) Fitting Load Factor model for day of week for the Month
fit_LF <- SNaive(Week_No2020) 
print(summary(fit_LF)
checkresiduals(fit_LF)
forecast_LF <- forecast(fit_LF, h=24*7) 
autoplot(forecast_LF,include = 84)
forecast_LF

8) Build forecast table for Hourly using Seasonal Naive Model (use the same principle for Hour <- read_excel("C:/PATH/Hour.xlsx")
Hourly <- ts(Hour[,6],start=c(2009,1), end=c(2019,1), frequency = 12*16) 
ggseasonplot(Hourly, year.labels = TRUE, year.labels.left = TRUE) + 
 		ggtitle("seasonal plot: Hourly LF 2009 to 2019") + ylab("Pax LF")

9) Fitting Load Factor model for hourly forecast
Hour_LF <- SNaive(Hourly) 
print(summary(Hour_LF)) #residual sd 0.0601
checkresiduals(fit_LF)
forecast_HourLF <- forecast(Hour_LF, h=12*16)
autoplot(forecast_HourLF,include = 384)

10) To enable print more than 384, the options() function needs to be used
options(max.print = 1000000)
forecast_HourLF
      The predicted load factor generated using ARIMA method and Seasonal Naive method were used to project the predicted passenger volume for airline ABC. Augmenting monthly predicted load factor with the total capacity of the aircraft by month produces the monthly passenger volume. Applying the same principle for predicted weekly load factor and hourly load factor to the total capacity of the aircraft will generate the weekly passenger volume and hourly passenger volume by the day. For example, to predict Tuesday at 6AM in May 2022 by using forecasting results, with the full capacity being 1,800 for the hour, the LF is forecasted to be 74.0%, and the passenger volume for the hour would be 1,332 (1,800 x 74%).



Reference
Hyndman, R. J & Athanasopoulos, G. (2018) “Forecasting: Principles and Practice” 2nd edition,  
 	OTexts: Melbourne, Australia.  Otexts.com/fpp2


