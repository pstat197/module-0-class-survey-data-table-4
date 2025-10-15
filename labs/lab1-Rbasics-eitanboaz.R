library(tidyverse)

# load data
pollution <- read_csv('data/pollution.csv')

# examine scatterplot with SLR fit
ggplot(pollution,
       aes(x = log(SO2), y = Mort)) +
  geom_point() +
  geom_smooth(method = 'lm')