library(rsconnect)
setwd("D:\\R projects\\week 15\\Presentation Folder\\10_shiny_dashboard")
deployApp(
  appDir = ".",
  appName = "military-salary-estimator",
  account = "mbubulka",
  forceUpdate = TRUE
)
