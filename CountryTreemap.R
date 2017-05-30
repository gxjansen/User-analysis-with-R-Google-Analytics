# Update packages if needed
# update.packages(ask = FALSE)

# Load required libraries
  library(treemap)
  library(googleAnalyticsR)
  library(portfolio)
  library(RColorBrewer)
  
# Authenticate with GA
ga_auth()

# Set the GA viewID
view_id <- 110870352

# Get the data. Use the "pivots" parameter to get columns of medium sessions.
ga_data <- google_analytics_4(
  view_id,
  date_range = c(Sys.Date() - 365, Sys.Date()),
  dimensions = c("country", "deviceCategory"),
  metrics = c("sessions", "transactions", "transactionRevenue"),
  anti_sample_batches = "auto"
)

treemap(
  ga_data,
  index = c(
    "deviceCategory",
    "sessions",
    "transactions",
    "transactionRevenue"
  ),
  vSize = "sessions",
  vColor = "transactions",
  type = "value",
  title = "Sessions and Transactions",
  title.legend = "Legend",
  sortID = "transactionRevenue",
  palette = "Greens",
  fontcolor.labels = "white",
  inflate.labels = TRUE,
  bg.labels = "#00000000",
  border.col = "white",
  border.lwds = "1",
  position.legend = "right",
  force.print.labels = FALSE
)
