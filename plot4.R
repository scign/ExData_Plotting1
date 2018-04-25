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
png(filename = "plot4.png")

# set up a 2 by 2 multi-plot panel
par(mfcol = c(2, 2))

# top left plot
plot(data2$DateTime, data2$Global_active_power,
  type = "l",
  xlab = "",
  ylab = "Global Active Power"
)

# bottom left plot
with(data2, {
  plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  points(DateTime, Sub_metering_2, type = "l", col = "red")
  points(DateTime, Sub_metering_3, type = "l", col = "blue")
})
legend("topright", col = c("black", "red", "blue"), lty = 1, bty = "n",
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# top right plot
with(data2, plot(DateTime, Voltage, type="l"))

# bottom right plot
with(data2, plot(DateTime, Global_reactive_power, type="l"))

# close the device file
dev.off()
