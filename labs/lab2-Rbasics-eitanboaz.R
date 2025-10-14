4.5
str(4.5)
is.double(4.5)

4L
str(4L)

TRUE
str(TRUE)
TRUE + FALSE
str(FALSE + FALSE)

'yay'
str('yay')
# '4' + '1'           # won't work
as.numeric('4') + as.numeric('1')

factor(1, levels = c(1, 2), labels = c('blue', 'red'))
factor('blue', levels = c('blue', 'red'))
str(factor('blue', levels = c('blue', 'red')))

c(1, 4, 7)
c('blue', 'red')
c(1, 4, 7)[1]
c(1, 4, 7)[2]
c(1, 4, 7)[3]
c(1, 4, 7)[2:3]
c(1, 4, 7)[c(1, 3)]

my_vec <- c(1, 4, 7)
str(my_vec)

my_ary <- array(data = c(1,2,3,4,5,6,7,8), dim = c(2,4))
my_ary
str(my_ary)

my_oth_ary <- array(data = c(1,2,3,4,5,6,7,8), dim = c(2,2,2))
my_oth_ary
str(my_oth_ary)

my_ary[1, 2]
my_oth_ary[1, 2, 1]
my_ary[2, ]
my_oth_ary[ , , 1]

list('cat', c(1,4,7), TRUE)
list(animal = 'cat', numbers = c(1,4,7), short = TRUE)

my_lst <- list(animal = 'cat', numbers = c(1,4,7), short = TRUE)
str(my_lst)
my_lst[[1]]
my_lst$animal

my_df <- data.frame(animal = c('cat','hare','tortoise'),
                    has.fur = c(TRUE, TRUE, FALSE),
                    weight.lbs = c(9.1, 8.2, 22.7))
str(my_df)
my_df


library(tidyverse)

url <- 'https://raw.githubusercontent.com/pstat197/pstat197a/main/materials/labs/lab2-tidyverse/data/'

background <- paste(url, 'background-clean.csv', sep = '') %>% read_csv()
interest   <- paste(url, 'interest-clean.csv',   sep = '') %>% read_csv()
metadata   <- paste(url, 'survey-metadata.csv',  sep = '') %>% read_csv()

background


my_vec <- c(1, 2, 5)
str(my_vec)
my_vec %>% str()

background %>%
  filter(math.comf > 3)

background %>%
  select(math.comf)

background %>%
  pull(rsrch)

background %>%
  mutate(avg.comf = (math.comf + prog.comf + stat.comf)/3)

background %>%
  filter(stat.prof == 'adv') %>%
  mutate(avg.comf = (math.comf + prog.comf + stat.comf)/3) %>%
  select(avg.comf, rsrch)


## exercise


background %>%
  filter(rsrch == TRUE, updv.num == '6-8') %>%
  select(contains('.prof'))

background %>%
  filter(rsrch == FALSE, updv.num == '6-8') %>%
  select(contains('.prof'))



background %>%
  filter(stat.prof == 'adv') %>%
  mutate(avg.comf = (math.comf + prog.comf + stat.comf)/3) %>%
  select(avg.comf, rsrch) %>%
  summarize(prop.rsrch = mean(rsrch))

background %>%
  filter(stat.prof == 'adv') %>%
  mutate(avg.comf = (math.comf + prog.comf + stat.comf)/3) %>%
  select(avg.comf, rsrch) %>%
  pull(rsrch) %>%
  mean()

background %>%
  filter(stat.prof == 'adv') %>%
  mutate(avg.comf = (math.comf + prog.comf + stat.comf)/3) %>%
  select(avg.comf, rsrch) %>%
  summarize(prop.rsrch = mean(rsrch),
            med.comf  = median(avg.comf))

background %>%
  select(contains('comf')) %>%
  summarise_all(.funs = mean)

# group_by examples
background %>% group_by(stat.prof)

background %>%
  group_by(stat.prof) %>%
  count()

background %>%
  group_by(stat.prof) %>%
  select(contains('.comf')) %>%
  summarize_all(.funs = mean)


## exercise

background %>%
  select(contains('comf')) %>%
  summarise_all(.funs = median)

background %>%
  group_by(updv.num) %>%
  select(contains('comf')) %>%
  summarize_all(.funs = median)


comf_sum <- background %>%
  select(contains('comf')) %>%
  summarise_all(.funs = list(mean = mean,
                             median = median,
                             min = min,
                             max = max))

comf_sum %>% gather(stat, val)

comf_sum %>%
  gather(stat, val) %>%
  separate(stat, into = c('variable', 'stat'), sep = '_')

comf_sum %>%
  gather(stat, val) %>%
  separate(stat, into = c('variable', 'stat'), sep = '_') %>%
  spread(stat, val)

classes <- background %>%
  select(11:28) %>%
  mutate(across(everything(), ~ ifelse(.x == 1, "yes", "no"))) %>%
  mutate(across(everything(), ~ factor(.x, levels = c("no", "yes")))) %>%
  summarize(across(everything(), ~ mean(as.numeric(.x) - 1, na.rm = TRUE))) %>%
  gather(class, proportion)


classes %>%
  ggplot(aes(x = proportion, y = class)) +
  geom_point()

fig <- classes %>%
  ggplot(aes(x = proportion, y = reorder(class, proportion))) +
  geom_point()

fig

fig + labs(x = 'proportion of class', y = '')
