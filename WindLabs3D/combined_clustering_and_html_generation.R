library(cluster)
library(archetypes)
library(readr)

windUser <- read_csv("windUser.csv", 
                     col_types = cols(results.profit = col_logical(), 
                                      changedSimSpeed = col_logical(), 
                                      correctPower = col_logical(), 
                                      results.correct = col_number(), 
                                      results.medianTimeOnTask = col_number(), 
                                      results.over = col_number(),
                                      results.under = col_number(),
                                      results.score = col_number(), 
                                      repairedTurbine = col_logical(), 
                                      turbineOnOff = col_logical(),
                                      results.name = col_character(),
                                      userId = col_character()))

#Cluster wind data and generate information for web pages.
noMissing <- windUser[complete.cases(windUser),]
#activeData <- noMissing[c("results.correct","results.score","results.over","results.under")]
#activeData <- noMissing[c("results.score")]
#kMeansFit <- kmeans(activeData, 4)
activeData <- noMissing[c("results.correct","results.score","results.over","results.under")]

#reorder the clusters by HIGHEST score first.
#relabel <- c(4,3,2,1)
#kMeansFit$cluster <- relabel[kMeansFit$cluster]

displayed <- noMissing
scores <- displayed$results.score
displayClusters <- scores


for(i in 1:length(displayClusters)){
	if (scores[i] > 7){
		displayClusters[i] <- 1
	}
	else if (scores[i] > 4){
		displayClusters[i] <- 2
	}
	else if (scores[i] > 1){
		displayClusters[i] <- 3
	}
	else {
		displayClusters[i] <- 4
	}
}
 

#NEEDED: A list containing the 10 indices of the chosen students
#unique id is called userId

# Prepare the tables for display in HTML
totalStudents <- nrow(noMissing)
noStudentsToShow <- totalStudents
# noStudentsToShow <- 10


#displayed <- displayed[sample(nrow(displayed), size = noStudentsToShow, replace = FALSE),]
#studentNames <- c("Peter","Maria","Lea","Giannis","Mathias","Else", "Anna", "Spiros", "Carl", "Bo")
#chosenNames <- sample(x = studentNames, size = nrow(displayed), replace = FALSE)

#search for indices of chosen userIds
displayIds <- match(displayed$userId, noMissing$userId)
chosenNames <- c(displayIds)

#displayClusters <- kMeansFit$cluster[chosenNames]

userNames <- displayed$results.name


one <- length(which(displayClusters == 1))
two <- length(which(displayClusters == 2))
three <- length(which(displayClusters == 3))
four <- length(which(displayClusters == 4))

transposed = data.frame()
transposed = rbind(transposed, displayed$correctPower)
transposed = rbind(transposed, displayed$results.profit)
transposed = rbind(transposed, displayed$turbineOnOff)
transposed = rbind(transposed, displayed$repairedTurbine)
transposed = rbind(transposed, displayed$changedSimSpeed)
STUDENT_NAMES <- paste("'",paste(as.character(chosenNames), collapse = "','"),"'")
names(transposed) <- STUDENT_NAMES
output <- ""
color_output <- ""
for(i in 1:length(transposed)){
  if (userNames[i] != "None"){
  	#display a username if one was provided
  	chosenNames[i] = userNames[i]
  }
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
CLUSTER_COUNTS <- paste(as.character(one),as.character(two),as.character(three),as.character(four),sep = ",")
COMMON_MEDIAN <- paste(as.character(rep(median(noMissing$results.medianTimeOnTask), nrow(displayed))), collapse = ",")
INDIVIDUAL_MEDIAN <- paste(as.character(round(displayed$results.score,0)), collapse=",")
CORRECT <- paste(as.character(round(displayed$results.correct,digits=1)), collapse=",")
UNDER <- paste(as.character(round(displayed$results.under,digits=1)), collapse=",")
OVER <- paste(as.character(round(displayed$results.over,digits=1)), collapse=",")
CHART_COLORS <- paste(color_output)

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
outputHTML <- gsub(x = outputHTML, pattern = "CHART_COLORS", replacement = CHART_COLORS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
write_file(outputHTML, path = "WindDashboard3D.html")
