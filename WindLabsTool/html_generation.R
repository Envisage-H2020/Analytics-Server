library(archetypes)
library(readr)

fileName <- 'ann.json'
ANN_DATA <- readChar(fileName, file.info(fileName)$size)

output <- ""
color_output <- ""
color_output <- gsub("1","green", color_output)
color_output <- gsub("2","yellow", color_output)
color_output <- gsub("3","orange", color_output)
color_output <- gsub("4","red", color_output)

# Prepare summary data for HTML
#CLUSTER_COUNTS <- paste(as.character(one),as.character(two),as.character(three),as.character(four),sep = ",")
CHART_COLORS <- paste(color_output)

# Load the HTML
templateHTML <- read_file(file = "WindTemplate.html")
outputHTML <- templateHTML
outputHTML <- gsub(x = outputHTML, pattern = "CHART_COLORS", replacement = CHART_COLORS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "ANN_DATA", replacement = ANN_DATA, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)

write_file(outputHTML, path = "WindDashboardTool.html")