# Start the Shiny app
library(shiny)

# Set working directory to app location
setwd("d:/R projects/week 15/Presentation Folder/10_shiny_dashboard")

# Run the app
runApp("app.R", port = 8102, host = "127.0.0.1", launch.browser = TRUE)
