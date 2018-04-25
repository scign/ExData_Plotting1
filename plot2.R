library(readr)
library(dplyr)
library(lubridate)

fileurl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zf = "data\\household_power_consumption.zip"

# download the source file if not already downloaded
if(!file.exists(".\\data")) {dir.create(".\\data")}
if(!file.exists(zf)) {download.file(fileurl, zf)}

# read the first line to get the column names
names <- unname(unlist(read.table(
  unz(zf, "household_power_consumption.txt"),
  sep=";", nrows=1, colClasses="character")))

# we know that the data we need is on rows 66638 to 69517 inclusive
# skip = 66637; nrows = 2880

# read the data from the file
data <- read_delim(
  unz(zf, "household_power_consumption.txt"),
  delim = ";", col_names = names, col_types = "ccnnnnnnn",
  na = "?", skip = 66637, n_max = 2880, comment = ""
)

# convert the date and time columns appropriately
data2 <- data %>% mutate(
  DateTime=as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")
)

# open png file device
png(filename = "plot2.png")

# create the plot and send to the current device
plot(data2$DateTime, data2$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)"
)

# close the device file
dev.off()
