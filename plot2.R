#use data.table library to speedup
library(data.table)

# before execution, first download and unzip the dataset,
# then set working directory to the folder of dataset

# output file name
output.file <- "plot2.png"

# read data file as a data.table
dt1 <- fread('household_power_consumption.txt',sep=";", header=T, na.string="?",
             colClasses=rep("character",9))        

# filter the required dates
dt2 <- dt1[Date == "1/2/2007" | Date == "2/2/2007"]

# convert to numeric
dt2[,Global_active_power := as.numeric(Global_active_power)]

# turn-off the local time format, avoid creating non-English output
Sys.setlocale("LC_TIME","C")

# concat Date & Time strings, then covert to date-time object
# in POSIXct format in a new column DateTime
dt2[, DateTime := as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S")]

# open png file, with transparent background
png(output.file, width = 480, height = 480, units = "px",
    bg='transparent')
# plot line
with(dt2, plot(x=DateTime,y=Global_active_power,type="l",
               main="", xlab = "",
               ylab="Global Active Power (kilowatts)"))

# close png file
dev.off()
