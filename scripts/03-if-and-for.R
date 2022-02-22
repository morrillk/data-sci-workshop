
##### for loop structure #####
for (item in list_of_items) {
  do_something(items)
}

### Examples ####

# takes each element in vector and prints the element * 2.6 * element^0.9)

volumes <- c(1.5, 3, 8)
for (volume in volumes) {
  print(2.6 * volume^ 0.9)
}

for (volume in volumes) {
  mass <- 2.6 * volume^0.9
  mass_lb <- mass*2.2
  print(mass_lb)
}

volumes <- c(1.6, 3, 8)
for (i in 1: length(volumes)) {
  mass<-2.6* volumes[i] ^ 0.9
  print(mass)
}

masses<-c()  #create empty vector to store mass values from for loop
 
#OR you can create vector of length of volumes of correct length
masses<- c(length = length(volumes))

## you can write for loop with indexing "i" using index values of volumes vector

for (i in 1: length(volumes)) {
  mass<-2.6 * volumes[i] ^ 0.9
  masses[i] <- mass
}

# or you can write one this way

masses_2<-c()
for (volume in volumes) {
  mass <-2.6 * volume ^ 0.9
  masses_2 <- c(masses_2, mass)
}

radius <- c(1.3, 2.1, 3.5)
areas <- vector(mode = "numeric", length = length(radius))
for (i in 1:length(radius)){
  areas[i] <- pi * radius[i] ^ 2
}
areas

download.file("http://www.datacarpentry.org/semester-biology/data/location.zip", 
              "data_raw/location.zip")
unzip("data_raw/locations.zip", exdir = "data_raw")

data_files <- list.files(path = "data_raw", pattern = "locations-*", full.names = TRUE)

for (data_file in data_files) {
  data <- read.csv(data_file)
  count <- nrow(data) 
  print(count)
}
