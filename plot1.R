#use data.table library to speedup
library(data.table)

# before execution, first download and unzip the dataset,
# then set working directory to the folder of dataset

# output file name
output.file <- "plot1.png"

# read data file as a data.table
dt1 <- fread('household_power_consumption.txt',sep=";", header=T, na.string="?",
             colClasses=rep("character",9))        

# filter the required dates
dt2 <- dt1[Date == "1/2/2007" | Date == "2/2/2007"]

# convert to numeric
dt2[,Global_active_power := as.numeric(Global_active_power)]

# open png file, with white background
png(output.file, width = 480, height = 480, units = "px",
    bg='white')
# plot histogram
with(dt2, hist(Global_active_power, breaks=12, col="red", 
               main="Global Active Power",
               xlab="Global Active Power (kilowatts)"))

# close output png file
dev.off()
                