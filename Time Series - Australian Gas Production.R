
install.packages("forecast")
install.packages("timeSeries")
library(forecast)
library(timeSeries)
##Reading the File

gas

head(gas)
tail(gas)
class(gas)

start(gas)
end(gas)
#graph
plot.ts(gas)
str(gas)

#checck for missing data
sum(is.na(gas))
#check for outliers
boxplot(gas)


library(psych)
describe(gas)


frequency(gas)
summary(gas)

#time series object

gastimeseries<-ts(gas, start = c(1956,1), end=c(1995,8), frequency = 12)
plot(gastimeseries)

#
monthplot(gastimeseries)
cycle(gastimeseries)
boxplot(gastimeseries~cycle(gastimeseries))

#decompose
gastimeseries_Sea <- stl(gastimeseries, s.window="p") #constant seasonality
plot(gastimeseries_Sea)


#Dseasonalise the time series
gastimeseries_Sea$time.series
series_names <- c('Deseasoned', 'Actual')

Deseason_gas <- (gastimeseries_Sea$time.series[,2] + gastimeseries_Sea$time.series[,3]) 
ts.plot(gastimeseries, Deseason_gas, col=c("red", "blue"), main="Production of gas vs De seasoned production of gas")

##Predictions
#splitting data in train and test

DataTrain <- window(gastimeseries, start=c(1956,1), end=c(1994,8), frequency = 12)
DataTest <- window(gastimeseries, start=c(1994,9),end = c(1995,8), frequency=12)

#decompose train data
plot(DataTrain)
gastrain <- stl(DataTrain, s.window="p")
plot(gastrain)

#forecast for 12 months
fcst.gas.stl <- forecast(gastrain, method="rwdrift", h=12) 
plot(fcst.gas.stl)

#comparing test data with mean of forecasted data
VecA<- cbind(DataTest,fcst.gas.stl$mean) 
VecA
plot.ts(VecA)

par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 1, 0), las=0)
ts.plot(VecA, col=c("blue", "red"),xlab="year", ylab="production", main="Monthly production of gas: Actual vs Forecast")

##Box-Ljung test:
#H0: Residuals are Independent/ models do not show lack of fit
#Ha: Residuals are not Independent/ models show lack of fit
Box.test(fcst.gas.stl$residuals, lag=10, type="Ljung-Box")
#p value indicates alternative hypothesis is true, thus models show lack of fit
#model has seasonality and trend


#test of accuracy
MAPEgas <- mean(abs(VecA[,1]-VecA[,2])/VecA[,1]) 
MAPEgas
##Error is 18.9%, erroe is decent adn accuracy is decent, but the model is not so good.


#let us do holt winters method as data has trend as well as seasonality
hwgas<-HoltWinters(as.ts(DataTrain), seasonal = "additive")
hwgas

hwgasForecast <- forecast(hwgas, h=12) 
Vec1 <- cbind(DataTest,hwgasForecast)
plot(Vec1)

par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 1, 0), las=0)
ts.plot(Vec1[,1],Vec1[,2], col=c("blue","red"),xlab="year", ylab="production", main="Production: Actual vs Forecast")
#nothinh much can be concluded from plot
#this is plot of test data and forecasted value but better than previous one
#very close and hand on hand

Box.test(hwgasForecast$residuals, lag=10, type="Ljung-Box")
#we fail to reject null hypothesis, hence model show fit and residuals are independent.
#this is good fit
#Accuracy
MAPE1 <- mean(abs(Vec1[,1]-Vec1[,2])/Vec1[,1]) 
MAPE1
#there are 3.8% error, 
#from graph also we can say it is god fit with less error


library(tseries) 
adf.test(gastimeseries)
#H0:Series is not stationary
#Ha:Series is stationary
#p value is 0.2>0.05 thus we fail to reject null hypothesis
#series is not stationary



#differencing to make series stationary
diff_gastimeseries <- diff(gastimeseries) 
plot(diff_gastimeseries)

adf.test(diff_gastimeseries)
#p value is less than alpha, we reject null hypothesis and nnow this series is stationary.


#let us check ACF and PACF
acf(gastimeseries)
acf(gastimeseries,lag=15)
#observations are correlated 
acf(diff_gastimeseries, lag=15)
#correlations has been significantly dropped and at certain points also not correlated
#regular patterns are observed due to seasonality

#to check seasonality we are increasing number of lags
acf(gastimeseries,lag=30)
acf(diff_gastimeseries, lag=30)

#we are increasing lag to check and confirm the presence of seasonality
#Checking with Lag 50
acf(gastimeseries,lag=50)
acf(diff_gastimeseries, lag=50)
#pattern has been observed due to seasonality

acf(gastimeseries,lag=80)
acf(diff_gastimeseries, lag=80)
#so now it is confirmed that seasonality is present and hence we will do Seasonal ARIMA
#q=5


pacf(gastimeseries)
pacf(diff_gastimeseries, lag = 15)
pacf(diff_gastimeseries, lag = 30)
pacf(diff_gastimeseries, lag = 50)
#from this also we can say seasona component is present and correlation exist
#p=1, lag after 1

##ARIMA, 
#here there is one difference hence d = 1
gas.arima.fit.train <- auto.arima(DataTrain, seasonal=TRUE)
gas.arima.fit.train
###Model comes to be (1,1,5) here d=1 as we took only one difference.

plot(gas.arima.fit.train$residuals)

#let us compare the results
plot(gas.arima.fit.train$x,col="blue") 
lines(gas.arima.fit.train$fitted, col="red")
plot(gas.arima.fit.train$fitted, gas.arima.fit.train$x, col=c("red","blue"), main = "Production: Actual vs forecast")

library("Metrics")
mape(gas.arima.fit.train$fitted, gas.arima.fit.train$x)

#3.8% error and from graph they are nicely fitted


Box.test(gas.arima.fit.train$residuals, lag = 10, type = c("Ljung-Box"), fitdf = 0)
#pvalue is greater than alpha, Ho model if fit , going with null hypo thus model is fit
#good fit with 3.8% error better than holtz winter as in holtz winter there was 5.3% error


#forecast
Arimafcastgas <- forecast(gas.arima.fit.train, h=20) 
Vec2 <- cbind(DataTest,Arimafcastgas)
par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 1, 0), las=0)
ts.plot(Vec2[,1],Vec2[,2], col=c("blue","red"),xlab="year", ylab="production", main="production of gas: Actual vs Forecast")


