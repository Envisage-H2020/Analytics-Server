library(cluster)
library(archetypes)
library(readr)

windUser <- read_csv("windUser.csv", 
                     col_types = cols(addTurbine = col_logical(), 
                                      changedPower = col_logical(), changedSimSpeed = col_logical(), 
                                      changedWind = col_logical(), correctPower = col_logical(), 
                                      powerStats.correct = col_number(), 
                                      powerStats.medianTimeOnTask = col_number(), 
                                      powerStats.over = col_number(), powerStats.under = col_number(), 
                                      repairedTurbine = col_logical(), 
                                      turbineOnOff = col_logical(), userId = col_character()))
#Cluster wind data and generate information for web pages.
noMissing <- windUser[complete.cases(windUser),]
activeData <- noMissing[c("powerStats.correct","powerStats.medianTimeOnTask","powerStats.over","powerStats.under")]
kMeansFit <- kmeans(activeData, 4)
#noMissing <- sample(x = noMissing, size = 10, replace = FALSE)
one <- length(which(kMeansFit$cluster == 1))
two <- length(which(kMeansFit$cluster == 2))
three <- length(which(kMeansFit$cluster == 3))
four <- length(which(kMeansFit$cluster == 4))

# Prepare the tables for display in HTML
noStudentsToShow <- 10
totalStudents <- nrow(noMissing)

displayed <- noMissing
displayed <- displayed[sample(nrow(displayed), size = noStudentsToShow, replace = FALSE),]
studentNames <- c("Peter","Maria","Lea","Giannis","Mathias","Else", "Anna", "Spiros", "Carl", "Bo")
chosenNames <- sample(x = studentNames, size = nrow(displayed), replace = TRUE)
transposed = data.frame()
transposed = rbind(transposed, displayed$correctPower)
transposed = rbind(transposed, displayed$addTurbine)
transposed = rbind(transposed, displayed$turbineOnOff)
transposed = rbind(transposed, displayed$repairedTurbine)
transposed = rbind(transposed, displayed$changedWind)
transposed = rbind(transposed, displayed$changedPower)
transposed = rbind(transposed, displayed$changedSimSpeed)
STUDENT_NAMES <- paste("'",paste(as.character(chosenNames), collapse = "','"),"'")
names(transposed) <- STUDENT_NAMES
output <- ""
for(i in 1:length(transposed)){
  header <- c("<tr>",paste("<td>",chosenNames[i],"</td>",sep=""))
  temp <- as.character(transposed[,i])
  temp <- gsub("TRUE", "<td><i class='fa fa-check text-success'></i></td>", temp)
  temp <- gsub("FALSE", "<td></td>", temp)
  footer <- "</tr>"
  output <- c(output,header,temp,footer)
}

# Prepare summary data for HTML
NO_STUDENTS_TO_SHOW <- noStudentsToShow
TOTAL_STUDENTS <- totalStudents
STUDENT_NAMES <- paste("'",paste(as.character(chosenNames), collapse = "','"),"'")
WIND_TABLES <- paste(output, collapse = "")
CLUSTER_COUNTS <- paste(as.character(one),as.character(two),as.character(three),as.character(four),sep = ",")
COMMON_MEDIAN <- paste(as.character(rep(median(displayed$powerStats.medianTimeOnTask), nrow(displayed))), collapse = ",")
INDIVIDUAL_MEDIAN <- paste(as.character(round(displayed$powerStats.medianTimeOnTask,0)), collapse=",")
CORRECT <- paste(as.character(round(displayed$powerStats.correct*100,0)), collapse=",")
UNDER <- paste(as.character(round(displayed$powerStats.under*100,0)), collapse=",")
OVER <- paste(as.character(round(displayed$powerStats.over*100,0)), collapse=",")

# Load the HTML
templateHTML <- read_file(file = "WindTemplate.html")
outputHTML <- templateHTML
outputHTML <- gsub(x = outputHTML, pattern = "NO_STUDENTS_TO_SHOW", replacement = NO_STUDENTS_TO_SHOW, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "TOTAL_STUDENTS", replacement = TOTAL_STUDENTS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "STUDENT_NAMES", replacement = STUDENT_NAMES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WIND_TABLES", replacement = WIND_TABLES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CLUSTER_COUNTS", replacement = CLUSTER_COUNTS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "COMMON_MEDIAN", replacement = COMMON_MEDIAN, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "INDIVIDUAL_MEDIAN", replacement = INDIVIDUAL_MEDIAN, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CORRECT", replacement = CORRECT, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "UNDER", replacement = UNDER, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "OVER", replacement = OVER, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
write_file(outputHTML, path = "WindDashBoard.html")
