library(cluster)
library(archetypes)
library(readr)

bondingUser <- read_csv("bondingUser.csv",
                     col_types = cols(attemptCountsWriteFormula = col_number(), 
                                      attemptCountsWriteFormulas.attemptsWriteFormulaCF4 = col_number(), 
                                      attemptCountsWriteFormulas.attemptsWriteFormulaCH4 = col_number(), 
                                      attemptCountsWriteFormulas.attemptsWriteFormulaCaCl2 = col_number(), 
                                      attemptCountsWriteFormulas.attemptsWriteFormulaH2O = col_number(), 
                                      attemptCountsWriteFormulas.attemptsWriteFormulaHCl = col_number(),
                                      attemptCountsWriteFormulas.attemptsWriteFormulaKBr = col_number(),
                                      attemptCountsWriteFormulas.attemptsWriteFormulaNaCl = col_number(), 
                                      attemptCountsWriteFormulas.attemptsWriteFormulaNaF = col_number(),     
                                      chooseBond.chooseBondCF4 = col_character(),
                                      chooseBond.chooseBondCH4 = col_character(),
                                      chooseBond.chooseBondCaCl2 = col_character(),
                                      chooseBond.chooseBondH2O.0 = col_character(),
                                      chooseBond.chooseBondH2O.1 = col_character(),
                                      chooseBond.chooseBondHCl = col_character(),
                                      chooseBond.chooseBondKBr = col_character(),
                                      chooseBond.chooseBondNaCl.0 = col_character(),
                                      chooseBond.chooseBondNaF = col_character(),                             
                                      completionCountChooseBond = col_number(),
                                      completionCountWriteFormula = col_number(),      
                                      periodicTableCount = col_number(),     
                                      userId = col_character(),   
                                      writeFormula.writeFormulaCF4 = col_character(),
                                      writeFormula.writeFormulaCH4 = col_character(),
                                      writeFormula.writeFormulaCaCl2 = col_character(),
                                      writeFormula.writeFormulaH2O.0 = col_character(),
                                      writeFormula.writeFormulaHCl = col_character(),
                                      writeFormula.writeFormulaKBr = col_character(),
                                      writeFormula.writeFormulaNaCl.0 = col_character(),
                                      writeFormula.writeFormulaNaF = col_character()))                                   


#trim down to required lines
bondingUser <- bondingUser[c("attemptCountsWriteFormulas.attemptsWriteFormulaCF4",
                          "attemptCountsWriteFormulas.attemptsWriteFormulaCH4", 
                          "attemptCountsWriteFormulas.attemptsWriteFormulaCaCl2", 
                          "attemptCountsWriteFormulas.attemptsWriteFormulaH2O", 
                          "attemptCountsWriteFormulas.attemptsWriteFormulaHCl",
                          "attemptCountsWriteFormulas.attemptsWriteFormulaKBr",
                          "attemptCountsWriteFormulas.attemptsWriteFormulaNaCl",
                          "attemptCountsWriteFormulas.attemptsWriteFormulaNaF",
                          "chooseBond.chooseBondCF4",
                          "chooseBond.chooseBondCH4",
                          "chooseBond.chooseBondCaCl2",
                          "chooseBond.chooseBondH2O.0", 
                          "chooseBond.chooseBondH2O.1",
                          "chooseBond.chooseBondHCl",
                          "chooseBond.chooseBondKBr",
                          "chooseBond.chooseBondNaCl.0",
                          "chooseBond.chooseBondNaF",
                          "writeFormula.writeFormulaCF4",
                          "writeFormula.writeFormulaCH4",
                          "writeFormula.writeFormulaCaCl2",
                          "writeFormula.writeFormulaH2O.0",
                          "writeFormula.writeFormulaHCl",
                          "writeFormula.writeFormulaKBr",
                          "writeFormula.writeFormulaNaCl.0",
                          "writeFormula.writeFormulaNaF",
                          "userId")]

#Cluster wind data and generate information for web pages.
#noMissing <- bondingUser[complete.cases(bondingUser),] 

noMissing <- bondingUser
noMissing[is.na(noMissing <- bondingUser)] <- 0


#bondingUser


#NEEDED: A list containing the 10 indices of the chosen students
#unique id is called userId

# Prepare the tables for display in HTML
totalStudents <- nrow(noMissing)
noStudentsToShow <- totalStudents

# noStudentsToShow <- 10


#search for indices of chosen userIds
#todo: check if this makes sense?
displayIds <- match(noMissing$userId, noMissing$userId)
#chosenNames <- c(displayIds)

userNames <- noMissing$userId
chosenNames <- userNames

displayed <- noMissing

#note: chooseBond.chooseBondH2O.1 being ignored here

transposed_attempt = NULL
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaHCl)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaH2O)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaNaF)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaNaCl)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaKBr)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaCH4)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaCaCl2)
transposed_attempt = rbind(transposed_attempt, displayed$attemptCountsWriteFormulas.attemptsWriteFormulaCF4)


transposed_write = NULL
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaCF4)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaCH4)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaCaCl2)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaH2O.0)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaHCl)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaKBr)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaNaCl.0)
transposed_write = rbind(transposed_write, displayed$writeFormula.writeFormulaNaF)

transposed_overall = NULL
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaCF4)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaCH4)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaCaCl2)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaH2O.0)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaHCl)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaKBr)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaNaCl.0)
transposed_overall = rbind(transposed_overall, displayed$writeFormula.writeFormulaNaF)

#ignoring h20_1
transposed_choose = NULL
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondHCl)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondH2O.0)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondNaF)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondNaCl.0)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondKBr)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondCH4)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondCaCl2)
transposed_choose = rbind(transposed_choose, displayed$chooseBond.chooseBondCF4)


STUDENT_NAMES <- paste("'",paste(as.character(chosenNames), collapse = "','"),"'")
names(transposed_attempt) <- STUDENT_NAMES
attempt_output <- ""
choose_output <- ""
score_output <- ""

for(i in 1:totalStudents){
  header <- c("<tr>",paste("<td>",chosenNames[i],"</td>",sep=""))	
  temp <- ""
  
  for(j in 1:nrow(transposed_attempt[])){
  	attempt <- as.character(transposed_attempt[j,i])
  	success <- as.character(transposed_write[j,i])
  	if (is.null(attempt) || (attempt == "[]")){
  		temp <- paste(temp, "<td></td>")
  		transposed_overall[j,i] <- -1
  	}
  	else if ((attempt == "0")){
  		temp <- paste(temp, "<td></td>")
  		transposed_overall[j,i] <- -1
  	}
  	else{
  		if (is.null(success)){
  			temp <- paste(temp, "<td><i class='fa fa-times text-danger'></i></td>")
  			transposed_overall[j,i] <- 0
  		}
  		else if ((success == "[]")){
  			temp <- paste(temp, "<td><i class='fa fa-times text-danger'></i></td>")
  			transposed_overall[j,i] <- 0
  		}
  		else {
  			temp <- paste(temp, "<td><i class='fa fa-check text-success'></i></td>")
  			# TODO: Remove this 'duplicate' code?
  			temp2 <- gsub("\\[|\\]", "", success)
			tempArr <- as.numeric(as.character(unlist(strsplit(temp2, ","))))	
			# Calculate NUMBER of multiple values -> success
			# At the same time, perform overall: success/attempts
			transposed_overall[j,i] <- as.character(as.numeric(length(tempArr)) / as.numeric(attempt))
  			#transposed_overall[j,i] <- (mean(tempArr) * 0.001)
  		}
  	}	
  }
  footer <- "</tr>"
  attempt_output <- c(attempt_output,header,temp,footer)
}
            
for(i in 1:totalStudents){
  temp <- paste(as.character(transposed_overall[,i]), collapse=",")
  score_output <- paste(score_output,"[",temp,"],")
}

for(i in 1:totalStudents){
  header <- c("<tr>",paste("<td>",chosenNames[i],"</td>",sep=""))
  temp <- ""
  
  for(j in 1:nrow(transposed_choose[])){
  	x <- as.character(transposed_choose[j,i])
  	if (is.null(x)){
  		temp <- paste(temp, "<td></td>")
  	}
  	else if ((x == "[]") || (x == "0")){
  		temp <- paste(temp, "<td></td>")
  	}
  	else temp <- paste(temp, "<td><i class='fa fa-check text-success'></i></td>")
  }
  
  footer <- "</tr>"
  choose_output <- c(choose_output,header,temp,footer)
}

for(i in 1:totalStudents){
  header <- c("<tr>",paste("<td>",chosenNames[i],"</td>",sep=""))
  temp <- ""
  
  for(j in 1:nrow(transposed_write[])){
  	x <- as.character(transposed_write[j,i])
  	if (is.null(x)){
  		transposed_write[j,i] <- "0"
  	}
  	else if ((x == "[]") || (x == "0")){
  		transposed_write[j,i] <- "0"
  	}
  	else {
  		temp <- gsub("\\[|\\]", "", transposed_write[j,i])
		tempArr <- as.numeric(as.character(unlist(strsplit(temp, ","))))	
		# Calculate mean of multiple values, then convert to secondss
  		transposed_write[j,i] <- (mean(tempArr) * 0.001)
  	}
  }
  
  footer <- "</tr>"
}


# Prepare summary data for HTML
NO_STUDENTS_TO_SHOW <- noStudentsToShow
TOTAL_STUDENTS <- totalStudents
STUDENT_NAMES <- paste("'",paste(as.character(chosenNames), collapse = "','"),"'")
ATTEMPT_TABLES <- paste(attempt_output, collapse = "")
CHOOSE_TABLES <- paste(choose_output, collapse = "")
STUDENT_SCORES <- paste(score_output, collapse = "")

WRITE_CF4 <- paste(as.character(transposed_write[1,]), collapse=",")
WRITE_CH4 <- paste(as.character(transposed_write[2,]), collapse=",")
WRITE_CACL2 <- paste(as.character(transposed_write[3,]), collapse=",")
WRITE_H2O <- paste(as.character(transposed_write[4,]), collapse=",")
WRITE_HCL <- paste(as.character(transposed_write[5,]), collapse=",")
WRITE_KBR <- paste(as.character(transposed_write[6,]), collapse=",")
WRITE_NACL <- paste(as.character(transposed_write[7,]), collapse=",")
WRITE_NAF <- paste(as.character(transposed_write[8,]), collapse=",")


# Load the HTML
templateHTML <- read_file(file = "ChemistryTemplate.html")
outputHTML <- templateHTML
outputHTML <- gsub(x = outputHTML, pattern = "NO_STUDENTS_TO_SHOW", replacement = NO_STUDENTS_TO_SHOW, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "TOTAL_STUDENTS", replacement = TOTAL_STUDENTS, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "STUDENT_NAMES", replacement = STUDENT_NAMES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "ATTEMPT_TABLES", replacement = ATTEMPT_TABLES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "CHOOSE_TABLES", replacement = CHOOSE_TABLES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "STUDENT_SCORES", replacement = STUDENT_SCORES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)


outputHTML <- gsub(x = outputHTML, pattern = "WRITE_CF4", replacement = WRITE_CF4, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_CH4", replacement = WRITE_CH4, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_CACL2", replacement = WRITE_CACL2, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_HCL", replacement = WRITE_HCL, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_H2O", replacement = WRITE_H2O, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_NAF", replacement = WRITE_NAF, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_KBR", replacement = WRITE_KBR, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
outputHTML <- gsub(x = outputHTML, pattern = "WRITE_NACL", replacement = WRITE_NACL, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)

write_file(outputHTML, path = "ChemistryDashboard.html")


# Load the tool HTML
templateToolHTML <- read_file(file = "ChemistryToolTemplate.html")
outputToolHTML <- templateToolHTML
outputToolHTML <- gsub(x = outputToolHTML, pattern = "STUDENT_SCORES", replacement = STUDENT_SCORES, ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
write_file(outputToolHTML, path = "ChemistryToolDashboard.html")