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
  tt <- t.test(x, y)  # Welch by default
  rslt$p[i] <- tt$p.value
  rslt$diff <- tt$estimate[[1]] - tt$estimate[[2]]
}

rslt

# ---- action 2 ----
tt_fn <- function(i){
  x <- asd %>% filter(group == "ASD") %>% pull(i + 1)
  y <- asd %>% filter(group == "TD")  %>% pull(i + 1)
  tt <- t.test(x, y)
  c(
    p    = tt$p.value,
    diff = unname(tt$estimate[1] - tt$estimate[2]),
    se   = unname(tt$stderr)
  )
}

rslt <- sapply(1:n_tests, tt_fn) %>%
  t() %>%
  as_tibble() %>%
  mutate(
    protein = colnames(asd)[2:(n_tests + 1)],
    .before = 1
  )

rslt

# ---- action 3: multiple testing ----
alpha <- 0.01

adj <- rslt %>%
  mutate(
    p_bh   = p.adjust(p, method = "BH"),
    p_bonf = p * n_tests
  ) %>%
  arrange(p_bh)

sig_bh <- adj %>% filter(p_bh <= alpha)

head(adj, 10)
sig_bh

# ---- action 4: run all 1317 proteins ----

# automatically detect number of protein columns (excluding 'group')
n_tests <- ncol(asd) - 1

# run t-tests for all proteins
tt_fn <- function(i){
  x <- asd %>% filter(group == "ASD") %>% pull(i + 1)
  y <- asd %>% filter(group == "TD")  %>% pull(i + 1)
  tt <- t.test(x, y)
  c(
    p    = tt$p.value,
    diff = unname(tt$estimate[1] - tt$estimate[2]),
    se   = unname(tt$stderr)
  )
}

# apply across all 1317
rslt_all <- sapply(1:n_tests, tt_fn) %>%
  t() %>%
  as_tibble() %>%
  mutate(protein = colnames(asd)[2:(n_tests + 1)], .before = 1)

# multiple-testing correction
rslt_all <- rslt_all %>%
  mutate(
    p_bh   = p.adjust(p, method = "BH"),
    p_bonf = p * n_tests
  ) %>%
  arrange(p_bh)

# significant at 1% FDR
sig_bh_all <- rslt_all %>% filter(p_bh <= 0.01)

# view top results
head(rslt_all, 10)
sig_bh_all
