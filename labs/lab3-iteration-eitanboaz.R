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

# read in and preproc ess data
asd <- read_csv(url) %>%
  select(-ados) %>%
  # log transform
  mutate(across(.cols = -group, log10)) %>%
  # center and scale
  mutate(across(.cols = -group, ~ scale(.x)[, 1])) %>%
  # trim outliers
  mutate(across(.cols = -group, trim_fn))

head(  x <- asd %>% filter(group == 'TD') %>% pull(51))

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

rslt

# action 2

n_tests <- 50

tt_fn <- function(i){
  x <- asd %>% filter(group == "ASD") %>% pull(i + 1)
  y <- asd %>% filter(group == "TD")  %>% pull(i + 1)
  tt <- t.test(x, y)
  
  c(
    diff = tt$estimate[1] - tt$estimate[2],
    se   = tt$stderr
  )
}

rslt <- sapply(1:n_tests, tt_fn)

rslt <- rslt %>%
  t() %>%
  as_tibble() %>%
  mutate(protein = colnames(asd)[2:(n_tests + 1)], .before = 1)

rslt