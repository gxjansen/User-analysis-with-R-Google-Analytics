# Install (if needed) the Libraries if not installed already
if(!require(googleAnalyticsR)) install.packages("googleAnalyticsR")
if(!require(lubridate)) install.packages("lubridate")
if(!require(googlesheets)) install.packages("googlesheets")
if(!require(forecast)) install.packages("forecast")

# Load the libraries
library(googleAnalyticsR)
library(lubridate)
library(googlesheets)
library(forecast)

# Authenticate with GA
ga_auth()

# Set the GA viewID
my_id <- 110870352 

# Set timeframe
StartDate <- today()-8
EndDate <- today()-1

# Now, query for some basic data, assigning the data to a 'data frame' object called 'web_data'
web_data <- google_analytics_4(my_id, 
                               date_range = c(StartDate, EndDate),
                               metrics = c("sessions","pageviews",
                                           "entrances","bounces"),
                               dimensions = c("day","deviceCategory",
                                              "channelGrouping"),
                               anti_sample = TRUE)


                               