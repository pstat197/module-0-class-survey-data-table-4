library(tidyverse)
library(GGally)


# retrieve class survey data
url <- 'https://raw.githubusercontent.com/pstat197/pstat197a/main/materials/labs/lab2-tidyverse/data/'

background <- paste(url, 'background-clean.csv', sep = '') %>%
  read_csv()

interest <- paste(url, 'interest-clean.csv', sep = '') %>%
  read_csv()

metadata <- paste(url, 'survey-metadata.csv', sep = '') %>%
  read_csv()

background %>%
  group_by(Major) %>%
  summarize(num_courses = n_distinct(Course)) %>%
  ggplot(aes(x = reorder(Major, num_courses), y = num_courses, fill = Major)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Number of Courses Taken by Major",
    x = "Major",
    y = "Number of Courses Taken"
  ) +
  theme_minimal()


interest %>%
  pivot_longer(cols = c(Stat_interest, Prog_interest, Math_interest),
               names_to = "Field",
               values_to = "Rating") %>%
  left_join(background, by = "StudentID") %>%
  ggplot(aes(x = Major, y = Rating, fill = Field)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21) +
  labs(
    title = "Distribution of Stat / Prog / Math Ratings by Major",
    x = "Major",
    y = "Rating"
  ) +
  theme_minimal() +
  coord_flip()


interest %>%
  pivot_longer(cols = c(Stat_level, Prog_level, Math_level),
               names_to = "Field",
               values_to = "Level") %>%
  left_join(background, by = "StudentID") %>%
  ggplot(aes(x = Major, fill = Level)) +
  geom_bar(position = "fill") +
  facet_wrap(~Field) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Proportion of Students by Skill Level and Major",
    x = "Major",
    y = "Proportion"
  ) +
  theme_minimal() +
  coord_flip()



interest %>%
  left_join(background, by = "StudentID") %>%
  select(Major, Stat_interest, Prog_interest, Math_interest) %>%
  group_by(Major) %>%
  summarize(across(where(is.numeric), mean, na.rm = TRUE)) %>%
  column_to_rownames("Major") %>%
  GGally::ggcorr(low = "white", high = "steelblue",
                 label = TRUE, label_round = 2) +
  ggtitle("Correlation among Stat / Prog / Math Interest Means by Major")