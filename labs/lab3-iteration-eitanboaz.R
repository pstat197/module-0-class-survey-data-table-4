library(tidyverse)
# install.packages('infer') # execute once then comment out

# data location
url <- 'https://raw.githubusercontent.com/pstat197/pstat197a/main/materials/labs/lab3-iteration/data/biomarker-clean.csv'

# function for outlier trimming
trim_fn <- function(x){
  x[x > 3] <- 3
  x[x < -3] <- -3
  
  return(x)
}

# read in and preprocess data
asd <- read_csv(url) %>%
  select(-ados) %>%
  # log transform
  mutate(across(.cols = -group, log10)) %>%
  # center and scale
  mutate(across(.cols = -group, ~ scale(.x)[, 1])) %>%
  # trim outliers
  mutate(across(.cols = -group, trim_fn))

#action 1

n_tests <- 50
rslt <- tibble(protein = colnames(asd)[2:(n_tests + 1)],
               p = NA,
               diff = NA)
for(i in 1:n_tests){
  x <- asd %>% filter(group == 'ASD') %>% pull(i + 1)
  y <- asd %>% filter(group == 'TD') %>% pull(i + 1)
  rslt$p[i] <- t.test(x, y, var.equal = F)$p.value
  rslt$diff <- tt$estimate[[1]] - tt$estimate[[2]]
}


