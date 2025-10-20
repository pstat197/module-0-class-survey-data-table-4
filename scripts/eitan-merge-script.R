library(dplyr)

background <- read.csv("./data/background-clean.csv")
interest <- read.csv("./data/interest-clean.csv")


merged_data <- inner_join(background, interest, by = "response_id")

removed_background <- nrow(background) - nrow(merged_data)
removed_interest <- nrow(interest) - nrow(merged_data)

cat("Merged dataset created.\n")
cat("Rows in background:", nrow(background), "\n")
cat("Rows in interest:", nrow(interest), "\n")
cat("Rows after merge:", nrow(merged_data), "\n")
cat("Removed from background:", removed_background, "\n")
cat("Removed from interest:", removed_interest, "\n\n")

cat("Summary of merged data:\n")
print(summary(merged_data))

write.csv(merged_data, "./data/merged-clean.csv", row.names = FALSE)


