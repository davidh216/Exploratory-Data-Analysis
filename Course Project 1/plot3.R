library(data.table)

URL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filepath = "household.zip"

if (!file.exists(filepath)) {
        download.file(URL, filepath, method = "curl")
}

if (!file.exists("household")) {
        unzip(filepath)
}

householdData <- read.table("household/household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", 
                            colClasses = c('character', 'character', 'numeric', 'numeric', 'numeric', 
                                           'numeric', 'numeric', 'numeric', 'numeric'))

householdData$Date <- as.Date(householdData$Date, "%d/%m/%Y")

subset <- subset(householdData, Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

subset <- subset[complete.cases(subset),]

dateTime <- paste(subset$Date, subset$Time)
dateTime <- setNames(dateTime, "DateTime")
subset <- subset[ ,!(names(subset) %in% c("Date","Time"))]
subset <- cbind(dateTime, subset)
subset$dateTime <- as.POSIXct(dateTime)

with(subset, {
        plot(Sub_metering_1~dateTime, type="l",
             ylab="Global Active Power (kilowatts)", xlab="")
        lines(Sub_metering_2~dateTime,col='purple')
        lines(Sub_metering_3~dateTime,col='gold')
})
legend("topright", col=c("black", "purple", "gold"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()