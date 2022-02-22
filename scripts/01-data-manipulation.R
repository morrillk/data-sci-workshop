# Data manipulation with dplyr and tidyr

# Load libraries 
library(readr)
library(dplyr)
library(udunits2) #for converting units 
library (tidyr)

#Read in csv
surveys <- readr::read_csv("data_raw/portal_data_joined.csv")

#Restrict rows with filter()
filter(surveys, genus == "Neotoma")

# Restrict columns with select()
select(surveys, record_id, species_id, weight)

select (surveys, -record_id, -species_id, -day) #drops these columns

# Linking together functions with piping 
surveys_1995 <- surveys %>%
    filter(year == 1995) %>%
    select(-record_id, -species_id, -day)

# Make a new calculated column with mutate()
surveys %>% 
    select(-record_id, -month, -day, -plot_id, -taxa, -plot_type) %>%
   filter(!is.na(weight)) %>% ##remove na in the weight column
   mutate(weight_kg = weight/1000, 
          weight_lb = ud.convert(weight, "g", "lb")) ##you can keep adding columns this way

# Make a new data drame from surveys that contains only the species_id column and a new
# column called hindfoot_cm containing hindfoot_length values in mm converted to cm and
# call this hindfoot_cm, make sure there are no nas and all values are less than 3

surveys %>%
  select(species_id, hindfoot_length) %>%
   mutate(hindfoot_cm = hindfoot_length/10) %>%
  filter(!is.na(hindfoot_cm), ##REMOVE na in hindfoot_cm column and make sure all values are less than 3
         hindfoot_cm<3) %>%
 select(-hindfoot_length) ##take out a column 

##Splot-apply-combine with group_by() and summarize()

##group_by = which columns should we consider groups
#mutate keeps the same number of rows so here in the code below,
#we're gonna have a different number of rows
#with group_by and summarize(), changing dimensions of what you're going to get where 
#as with mutate() you are keeping the same number of rows 

surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight),  
            sd_weight = sd(weight), 
            max_weight = max(weight), 
            n = n()) %>% ## n tells us how many observations for each
  arrange(desc(max_weight))

# A few options for counting
surveys %>%
  count(sex) ##like using table function in Base R, tells you counts of sex

surveys %>% ##gives you an actual table now cuz two columns
  count(sex, species_id)

## Reshaping data with pivot_wider() and pivot_longer() with tidyr()

surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))

surveys_wide <- surveys_gw %>%
  tidyr::pivot_wider(names_from = genus, ##names of columns 
                     values_from = mean_weight) #contents of columns

surveys_long <- surveys_wide %>%
  tidyr::pivot_longer(-plot_id, 
                    names_to = "genus", 
                    values_to = "mean_weight") ## use everything in surveys wide EXCEPT for the first column, but take the rest and do pivot_longer 

## Challenge: 
surveys_year <- surveys %>%
  group_by(plot_id, year) %>%
  summarize(genera_count=n_distinct(genus))

surveys_year_wide <- surveys_year %>%
  tidyr:: pivot_wider(names_from = year, 
                     values_from = genera_count)

## Exporting filtered data
# Goal: data set to plot change in species abundance over time 
surveys_complete <- surveys %>% 
  filter(!is.na(weight), 
         !is.na(hindfoot_length), 
         !is.na(sex))

#most common species
species_counts <- surveys_complete %>% 
  count(species_id) %>% ##makes a column "n"
  filter(n > 50) ## gives you only counts of species > 50

# Only keep the most common species
surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_counts$species_id)

