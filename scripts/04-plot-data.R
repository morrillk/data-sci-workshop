## Plotting cleaned portal survey data ###

library(dplyr)
library(readr)
library(ggplot2)


# Read in data
survey_complete <- read_csv("data_clean/surveys_complete.csv")

## Basic ggplot format
ggplot(data = survey_complete, 
       mapping = aes(x = weight, 
                     y = hindfoot_length)) + 
  geom_point(alpha = 0.1, ##controls translucency of the points 
             color = "coral") 

## add color as an axis representing genus
ggplot(data = survey_complete, 
       mapping = aes(x = weight, 
                     y = hindfoot_length, 
                     color = genus)) + 
  geom_point(alpha = 0.1)      

ggplot(data = survey_complete, 
       mapping = aes(x = species_id, 
                     y = weight, 
                     color = as.factor(species_id))) + 
  geom_jitter(alpha = 0.1)+ ## spreads the points out some 
  geom_boxplot(alpha = 0, 
               color = "black")


## Plotting change over time ###

yearly_counts <- surveys_complete %>% 
  group_by(year, genus) %>%
  summarize(n = n())

#OR 

# yearly_counts <- surveys_complete %>% 
  # count(year, genus)

ggplot(data = yearly_counts, 
       mapping = aes(x = year, 
                      y = n, 
                      group = genus)) + ### can also color instead of group which will automatically group them
  geom_line()




  