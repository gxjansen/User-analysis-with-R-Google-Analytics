# Load the libraries
library(googleAnalyticsR)
library(knitr)
library(ggplot2)
library(tidyr)
library(highcharter)

# Authenticate with GA
ga_auth()

# Set the GA viewID
view_id <- 110870352

# Get the data. Use the "pivots" parameter to get columns of medium sessions.
trend_data <- google_analytics_4(view_id,
                                 date_range = c(Sys.Date() - 400, Sys.Date()),
                                 dimensions = c("date"),
                                 metrics = "sessions",
                                 pivots = pivot_ga4("medium","sessions"),
                                 max = -1)

names(trend_data) <- c("Date","Total","Organic","None","Affiliates","Partner","Referral")
trend_long <- gather(trend_data, Channel, Sessions, -Date)


hchart(trend_long, type = "line", hcaes(x = Date, y = Sessions, group = Channel)) %>%
  hc_title(text = "Sessions") %>%
  hc_subtitle(text = "Past 400 days") %>%
  hc_add_theme(hc_theme_darkunica())
       
