library(rJava)
library(RMongo)
library(cluster)
library(archetypes)

# Connect to the local mongo-database and load the data
mongo <- mongoDbConnect('envisage', 'localhost', 27017)
windUser <- dbGetQuery(mongo, "windUser", '{}')
bondingUser <- dbGetQuery(mongo, "bondingUser", '{}')
# Disconnect from the local database
dbDisconnect(mongo)

#Cluter wind data and generate information for web pages.
noMissing <- windUser[complete.cases(windUser),]
activeData <- noMissing
kMeansFit <- kmeans(activeData, 4)
clusterCounts <- table(kMeansFit$cluster)

paste(as.character(rep(median(noMissing$powerStats.medianTimeOnTask), 10)), collapse = ",")
paste(as.character(round(noMissing$powerStats.medianTimeOnTask[13:22],0)), collapse=",")
paste(as.character(round(noMissing$powerStats.correct[13:22]*100,0)), collapse=",")
paste(as.character(round(noMissing$powerStats.under[13:22]*100,0)), collapse=",")
paste(as.character(round(noMissing$powerStats.over[13:22]*100,0)), collapse=",")

user_aa4_cluster[13:22]

displayed <- allWindComplete[13:22,]

displayed$correctPower

studentNames <- c("Peter","Maria","Lea","Giannis","Mathias","Else", "Anna", "Spiros", "Carl", "Bo")
transposed = data.frame()
transposed = rbind(transposed, displayed$correctPower)
transposed = rbind(transposed, displayed$addTurbine)
transposed = rbind(transposed, displayed$turbineOnOff)
transposed = rbind(transposed, displayed$repairedTurbine)
transposed = rbind(transposed, displayed$changedWind)
transposed = rbind(transposed, displayed$changedPower)
transposed = rbind(transposed, displayed$changedSimSpeed)
names(transposed) <- studentNames

output <- ""
for(i in 1:length(transposed)){
  header <- c("<tr>",paste("<td>",studentNames[i],"</td>",sep=""))
  temp <- as.character(transposed[,i])
  temp <- gsub("TRUE", "<td><i class='fa fa-check text-success'></i></td>", temp)
  temp <- gsub("FALSE", "<td></td>", temp)
  footer <- "</tr>"
  output <- c(output,header,temp,footer)
}
write(paste(output, collapse = ";"), file = "wind_tables.txt")



