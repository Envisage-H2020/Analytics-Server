library(cluster)
library(archetypes)
library(readr)

windUser <- read_csv("windUser.csv", 
                     col_types = cols(state.environment = col_character(),
                     				  state.map = col_character(),
                     				  state.turbine = col_character(),
                     				  state.binary = col_character(),
                     				  results.profit = col_logical(), 
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
activeData <- split(noMissing,noMissing$state.binary)

#clear file
close( file( "trainingData.txt", open="w" ) )

o <- lapply(1:length(activeData), function(j) {
    #str(names(activeData[i]))
    #str(activeData[i])
    #str(activeData[[i]]$results.score)
    
    #we have divided the dataset by unique binary codes
	#cluster the results in each group
	
	#displayed <- activeData[j]
	scores <- activeData[[j]]$results.score
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

	one <- length(which(displayClusters == 1))
	two <- length(which(displayClusters == 2))
	three <- length(which(displayClusters == 3))
	four <- length(which(displayClusters == 4))
	total <- one + two + three + four
	
	one <- one/total
	two <- two/total
	three <- three/total
	four <- four/total
	
	#training data needs to look like:
	#{input: [1, 0], output: [1, 0, 0]},
	screw_r <- paste("{input: [",activeData[[j]]$state.binary[[1]],"], output: [",one,",",two,",",three,",",four,"]},",sep = "")
	str(screw_r)
	#str(bin)
	#str(one)
	#str(two)
	#str(three)
	#str(four)
	
	write(screw_r, file = "trainingData.txt", append = TRUE)
})
out <- as.data.frame(do.call(rbind, o))
#write.csv(output, file = "training_data.csv",row.names=FALSE)
