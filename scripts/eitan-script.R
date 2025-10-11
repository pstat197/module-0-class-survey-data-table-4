library(tidyverse)

background <- read_csv('data/background-clean.csv')
interest <- read_csv('data/interest-clean.csv')

## individual variable summaries
###############################

# one variable, one summary
summary(background)