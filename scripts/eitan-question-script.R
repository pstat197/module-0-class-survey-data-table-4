library(tidyverse)

CSV <- "./data/merged-clean.csv"
df  <- readr::read_csv(CSV)


canon <- \(x) x |> stringr::str_to_lower() |> stringr::str_squish()
int_long <- df %>%
  mutate(row_id = row_number()) %>%
  separate_rows(area, sep = ";") %>%
  mutate(area = canon(area)) %>%
  filter(area != "") %>%
  distinct(row_id, area)
