# Time-Series---Forecasting-gas-production
The given project focuses on the problem – forecasting the production of natural gas in Australia.
The data has been taken from the forecast package.
Library(forecast)
The given data is monthly production of gas.


Time Series consists of following components:
• Secular Trend or Long term Movement
• Periodic Changes or Short term Fluctuations
o Seasonal Variations and
o Cyclical Variations (We are not considering this component in our module)
• Random or Irregular Movements
The value of a time series Yt at any time t is regarded as the resultant of the combined effect of above components

Some Insights from the results:
- The given time series data was provided from the year 1956 January to 1995 August.
- The periodicity of the data is 12 as it is monthly production of gas data.
- The given data is non stationary and hence one difference was made to make it stationary.
- This time series has Seasonal, Trend and Random Component, its fits the additive model. And it in general shows upward trend. The series has also been deseasonalised.
- The upward trend in the data could be due to various conditions like increasing population which lead to increase in use of all resources.
- The mode is built to forecast the monthly production of gas for next 12 years.
- ARIMA as well as Holtz winter model fits the data best, but it is recommended to use ARIMA model.
- This forecast can help the government to make necessary policies, the authorities should check if this meets the demand or not. If necessary they can make steps in order to develop this area more and may also make changes in the subsidy or tax or any other required steps as it deem fits.
