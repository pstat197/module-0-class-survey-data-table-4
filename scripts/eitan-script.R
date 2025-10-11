library(dplyr)

background <- read.csv("../data/background-clean.csv")
interest <- read.csv("../data/interest-clean.csv")

merged_data <- inner_join(background, interest, by = "Response.ID")

removed_background <- nrow(background) - nrow(merged_data)
removed_interest <- nrow(interest) - nrow(merged_data)

print(summary(merged_data))

write.csv(merged_data, "../results/merged_clean.csv", row.names = FALSE)

