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

#NEEDED: A list containing the 10 indices of the chosen students
#unique id is called userId

# Prepare the tables for display in HTML
noStudentsToShow <- 10
totalStudents <- nrow(noMissing)

displayed <- noMissing
displayed <- displayed[sample(nrow(displayed), size = noStudentsToShow, replace = FALSE),]
#studentNames <- c("Peter","Maria","Lea","Giannis","Mathias","Else", "Anna", "Spiros", "Carl", "Bo")
#chosenNames <- sample(x = studentNames, size = nrow(displayed), replace = FALSE)

#create dummy data
turbines <- sample(1:6, size = noStudentsToShow, replace = TRUE)

displayA=list()
displayB=list()

for(i in 1:noStudentsToShow){
	if (displayed[i,]$correctPower) turbines[i] <- turbines[i]+1
	if (displayed[i,]$repairedTurbine) turbines[i] <- turbines[i]+1
	
	#divide clustering results by turbine
	if (turbines[i] < 5){
		displayA <- c(displayA, displayed[i,]$userId)
	}
	else {
		displayB <- c(displayB, displayed[i,]$userId)
	}
}


#search for indices of chosen userIds
displayIds <- match(displayed$userId, noMissing$userId)
chosenNames <- c(displayIds)
displayClusters <- kMeansFit$cluster[chosenNames] 

displayIdsA <- match(displayA, noMissing$userId)
chosenNamesA <- c(displayIdsA)
displayClustersA <- kMeansFit$cluster[chosenNamesA] 

displayIdsB <- match(displayB, noMissing$userId)
chosenNamesB <- c(displayIdsB)
displayClustersB <- kMeansFit$cluster[chosenNamesB] 



oneA <- length(which(displayClustersA == 1))
twoA <- length(which(displayClustersA == 2))
threeA <- length(which(displayClustersA == 3))
fourA <- length(which(displayClustersA == 4))

oneB <- length(which(displayClustersB == 1))
twoB <- length(which(displayClustersB == 2))
threeB <- length(which(displayClustersB == 3))
fourB <- length(which(displayClustersB == 4))

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
color_output <- ""
for(i in 1:length(transposed)){
  header <- c("<tr>",paste("<td>",chosenNames[i],"</td>",sep=""))
  temp <- as.character(transposed[,i])
  temp <- gsub("TRUE", "<td><i class='fa fa-check text-success'></i></td>", temp)
  temp <- gsub("FALSE", "<td></td>", temp)
  footer <- "</tr>"
  output <- c(output,header,temp,footer)
  color_output <- paste(color_output,'window.chartColors.',displayClusters[i],',');
}
color_output <- gsub("1","green", color_output)
color_output <- gsub("2","yellow", color_output)
color_output <- gsub("3","orange", color_output)
color_output <- gsub("4","red", color_output)

# Prepare summary data for HTML
NO_STUDENTS_TO_SHOW <- noStudentsToShow
TOTAL_STUDENTS <- totalStudents
STUDENT_NAMES <- paste("'",paste(as.character(chosenNames), collapse = "','"),"'")
WIND_TABLES <- paste(output, collapse = "")
CLUSTER_COUNTS_A <- paste(as.character(oneA),as.character(twoA),as.character(threeA),as.character(fourA),sep = ",")
CLUSTER_COUNTS_B <- paste(as.character(oneB),as.character(twoB),as.character(threeB),as.character(fourB),sep = ",")
COMMON_MEDIAN <- paste(as.character(rep(median(noMissing$powerStats.medianTimeOnTask), nrow(displayed))), collapse = ",")
INDIVIDUAL_MEDIAN <- paste(as.character(round(displayed$powerStats.medianTimeOnTask,0)), collapse=",")
CORRECT <- paste(as.character(round(displayed$powerStats.correct*100,0)), collapse=",")
UNDER <- paste(as.character(round(displayed$powerStats.under*100,0)), collapse=",")
OVER <- paste(as.character(round(displayed$powerStats.over*100,0)), collapse=",")
CHART_COLORS <- paste(color_output)

# Load the HTML
templateHTML <- read_file(file = "WindTemplate.html")
outputHTML <- templateHTML
outputHTML <- gsub(x = outputHTML, pattern = "NO_STUDENTS_TO_SHOW", replacement = NO_STUDENTS_TO_SHOW, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "TOTAL_STUDENTS", replacement = TOTAL_STUDENTS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "STUDENT_NAMES", replacement = STUDENT_NAMES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WIND_TABLES", replacement = WIND_TABLES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CLUSTER_COUNTS_A", replacement = CLUSTER_COUNTS_A, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CLUSTER_COUNTS_B", replacement = CLUSTER_COUNTS_B, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "COMMON_MEDIAN", replacement = COMMON_MEDIAN, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "INDIVIDUAL_MEDIAN", replacement = INDIVIDUAL_MEDIAN, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CORRECT", replacement = CORRECT, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "UNDER", replacement = UNDER, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "OVER", replacement = OVER, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CHART_COLORS", replacement = CHART_COLORS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
write_file(outputHTML, path = "WindDashBoard.html")
