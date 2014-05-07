#use data.table library to speedup
library(data.table)

# before execution, first download and unzip the dataset,
# then set working directory to the folder of dataset

# output file name
output.file <- "plot3.png"

# read data file as a data.table
dt1 <- fread('household_power_consumption.txt',sep=";", header=T, na.string="?",
             colClasses=rep("character",9))        

# filter the required dates
dt2 <- dt1[Date == "1/2/2007" | Date == "2/2/2007"]

# convert to numeric, for the Sub_metering_X columns
columns <- paste0("Sub_metering_",1:3)
dt2[,(columns):=lapply(.SD, as.numeric), .SDcols=columns]
          
# turn-off the local time format, avoid creating non-English output
Sys.setlocale("LC_TIME","C")

# concat Date & Time strings, then covert to date-time object
# in POSIXct format in a new column DateTime
dt2[, DateTime := as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S")]

# open png file, with transparent background
png(output.file, width = 480, height = 480, units = "px",
    bg='transparent')

# pre-defined colors and line type
color_seq = c("black","red","blue")
lty = "solid"
# a dummpy plot to setup canvas
with(dt2, plot(x=DateTime,y=Sub_metering_1,type="n",
               main="", xlab = "",
               ylab="Energy sub metering"))
# add multiple lines
matlines(x=dt2[,DateTime], y=dt2[,.SD, .SDcols=columns],
         col=color_seq, lty=lty)
legend("topright",legend=columns,
       col=color_seq, lty=lty,cex=1.0)

# close png file
dev.off()

