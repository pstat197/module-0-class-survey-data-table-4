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

# ---- small interest-wide: just the top interests ----
int_wide_small <- tibble(row_id = seq_len(nrow(df))) %>%
  left_join(
    int_long %>%
      filter(area %in% top_interests$area) %>%
      mutate(val = 1L) %>%
      pivot_wider(names_from = area, values_from = val, values_fill = 0L),
    by = "row_id"
  ) %>%
  mutate(across(-row_id, ~ replace_na(.x, 0L)))

# ---- build rates: % with interest for takers vs non-takers, per course ----
rates <- map_dfr(courses_to_show, function(crs) {
  course_df %>%
    select(row_id, took = all_of(crs)) %>%
    left_join(int_wide_small, by = "row_id") %>%
    mutate(group = if_else(took == 1L, "took", "didn't")) %>%
    select(-row_id, -took) %>%
    pivot_longer(-group, names_to = "interest", values_to = "has_interest") %>%
    group_by(group, interest) %>%
    summarise(pct = mean(has_interest), .groups = "drop") %>%
    mutate(course = crs)
})

# ---- plot ----
ggplot(rates, aes(x = interest, y = pct, fill = group)) +
  geom_col(position = "dodge") +
  facet_wrap(~ course, scales = "free_x") +
  scale_y_continuous(labels = scales::percent_format()) +
  coord_flip() +
  labs(
    title = "Do courses line up with interests?",
    subtitle = "Share selecting each interest, among students who took vs didn't take the course",
    x = NULL, y = "% of students", fill = NULL
  ) +
  theme(legend.position = "top")