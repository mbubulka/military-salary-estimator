# Check what ranks are in the data
data <- read.csv("../04_results/02_training_set_CLEAN.csv")

cat("Unique ranks in training data:\n")
ranks <- sort(unique(data$rank))
print(ranks)

cat("\n\nRank frequency:\n")
print(table(data$rank))

cat("\n\nTotal records:", nrow(data), "\n")
