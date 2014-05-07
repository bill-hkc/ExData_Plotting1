#use data.table library to speedup
library(data.table)

# before execution, first download and unzip the dataset,
# then set working directory to the folder of dataset

# output file name
output.file <- "plot4.png"

# read data file as a data.table
dt1 <- fread('household_power_consumption.txt',sep=";", header=T, na.string="?",
             colClasses=rep("character",9))        

# filter the required dates
dt2 <- dt1[Date == "1/2/2007" | Date == "2/2/2007"]

# convert to numeric, for the Sub_metering_X columns
cols <- paste0("Sub_metering_",1:3)
dt2[,(cols):=lapply(.SD, as.numeric), .SDcols=cols]
          
# turn-off the local time format, avoid creating non-English output
Sys.setlocale("LC_TIME","C")

# concat Date & Time strings, then covert to date-time object
# in POSIXct format in a new column DateTime
dt2[, DateTime := as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S")]

# prefined colors and line type
color_seq = c("black","red","blue")
lty = "solid"

#define a helper function for a subplot
f.subplot <- function(columns) {
  # if having multiple columns to draw
  if (length(columns) > 1) {
    # a dummy plot to setup canvas
    plot(x=dt2[,DateTime],
         y=dt2[[ columns[1] ]],
         type="n",xlab="",ylab="")  
    # plot multiple lines with prefined colors and line type
    matlines(x=dt2[,DateTime], y=dt2[,.SD, .SDcols=columns],
             col=color_seq, lty=lty)
    legend("topright",legend=columns,
           col=color_seq, lty=lty,cex=1.0,bt="n")
  }
  else { 
    # draw single line
    plot(x=dt2[,DateTime],
         y=dt2[[ columns[1] ]],
         type="l",xlab="",ylab="")     
  }  
}


# open png file, with transparent background
png(output.file, width = 480, height = 480, units = "px",
    bg='transparent')

# set 2 x 2 subplots
par(mfcol=c(2,2))

# subplot (1,1)
f.subplot(c("Global_active_power"))
title(ylab="Global Active Power")
# subplot (2,1)
f.subplot(paste0("Sub_metering_",1:3))
title(ylab="Energy sub metering")
# subplot (1,2)
f.subplot(c("Voltage"))
title(ylab="Voltage",xlab="datetime")
# subplot (2,2)
f.subplot(c("Global_reactive_power"))
title(ylab="Global_reactive_power",xlab="datetime")

# close png file
dev.off()
