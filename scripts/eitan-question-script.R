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

# top interests plot
top_n <- 10
top_interests <- int_long %>%
  count(area, sort = TRUE) %>%
  slice_head(n = top_n)

ggplot(top_interests, aes(x = reorder(area, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top interests (overall)", x = NULL, y = "Count")



course_df <- df %>%
  mutate(row_id = row_number()) %>%
  select(row_id, `PSTAT120`, CS16, PSTAT131, CS130) %>%
  mutate(across(-row_id, ~{
    v <- suppressWarnings(as.numeric(.x))
    v[is.na(v)] <- 0
    as.integer(pmin(1, pmax(0, round(v))))
  }))

# Only show these exact courses (which I though would be the most interesting)
courses_to_show <- c("PSTAT120", "CS16", "PSTAT131", "CS130")
