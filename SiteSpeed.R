# Load required libraries
library(treemap)
library(googleAnalyticsR)
library(portfolio)
library(ggplot2)
library(data.table)

# Authenticate with GA
# ga_auth()

# Set the GA viewID
view_id <- 110870352

# Get the data. Use the "pivots" parameter to get columns of medium sessions.
ga_data <- google_analytics_4(
  view_id,
  date_range = c(Sys.Date() - 100, Sys.Date()),
  dimensions = c("datehour"),
  metrics = c("transactionsPerSession", "pageLoadTime", "bounceRate","pageviewsPerSession"),
  max = -1,
  anti_sample = TRUE
)

# Remove rows where PageLoadTime == 0
ga_data2 <-
  setDT(ga_data)[, .SD[!any(.SD[, -1, with = F] == 0)], by = datehour]

####################################
### Transactions versus Pageload ###

# Correlation between pageload and bouncerate
cor.test(((ga_data2$pageLoadTime / 1000) / 60), ga_data2$transactionsPerSession)

# Create dataframe and plot results
speedy1 <-
  data.frame(((ga_data2$pageLoadTime / 1000) / 60), ga_data2$transactionsPerSession)
colnames(speedy1) <- c("PageLoadTime", "TransactionsPerSession")
p <-
  ggplot(speedy1, aes(PageLoadTime, TransactionsPerSession)) + geom_point()
p + geom_smooth(method = "lm", se = FALSE)

####################################
### Transactions versus Pageload ###

# Correlation between pageload and bouncerate
cor.test(((ga_data2$pageLoadTime / 1000) / 60), ga_data2$bounceRate)

# Create dataframe and plot results
speedy2 <-
  data.frame(((ga_data2$pageLoadTime / 1000) / 60), ga_data2$bounceRate)
# Nicer graph

theme_set(theme_bw())  # pre-set the bw theme.
data("speedy2", package = "ggplot2")

# Scatterplot
gg1 <- ggplot(ga_data2, aes(x=pageLoadTime, y=bounceRate)) + 
  geom_point(aes(col=bounceRate)) + 
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 25)) + 
  ylim(c(0, 100)) + 
  labs(subtitle="Pageload Vs Bouncerate", 
       y="Bouncerate (%)", 
       x="Pageload Time (ms)", 
       title="Scatterplot", 
       caption = "Source: GA")

plot(gg1)

####################################
### Transactions versus Pageviews ###

# Correlation between pageload and bouncerate
cor.test(ga_data2$transactionsPerSession, ga_data2$pageviewsPerSession)

# Create dataframe and plot results
speedy3 <-
  data.frame(ga_data2$transactionsPerSession), ga_data2$pageviewsPerSession)
colnames(speedy3) <- c("transactionsPerSession", "pageviewsPerSession")
#p <- ggplot(speedy2, aes(PageLoadTime, pageviewsPerSession)) + geom_point()
#p + geom_smooth(method = "lm", se = FALSE)

# Nicer graph

theme_set(theme_bw())  # pre-set the bw theme.
data("speedy3", package = "ggplot2")

# Scatterplot
gg2 <- ggplot(speedy3, aes(x=transactionsPerSession, y=pageviewsPerSession)) + 
  geom_point(aes(col=pageviewsPerSession)) + 
  geom_smooth(method="loess", se=F) + 
  xlim(c(0, 25)) + 
  ylim(c(0, 100)) + 
  labs(subtitle="transactionsPerSession Vs pageviewsPerSession", 
       y="pageviewsPerSession", 
       x="Pageload Time (ms)", 
       title="Scatterplot", 
       caption = "Source: GA")

plot(gg2)
