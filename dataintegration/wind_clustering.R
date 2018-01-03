#----------------------------------------------
# Load libraries
#----------------------------------------------
library(lattice)
library(cluster)
library(archetypes)
library(ggplot2)
library(reshape2)
library(stringr)
library(RColorBrewer)
library(FactoMineR)
library(mice)

library(readr)
envisage_windUser <- read_csv("~/DevProjects/envisage_viz/envisage.windUser.csv", 
                              col_types = cols(addTurbine = col_logical(), 
                                               changedPower = col_logical(), changedSimSpeed = col_logical(), 
                                               changedWind = col_logical(), correctPower = col_logical(), 
                                               powerStats.correct = col_number(), 
                                               powerStats.medianTimeOnTask = col_number(), 
                                               powerStats.over = col_number(), powerStats.under = col_number(), 
                                               repairedTurbine = col_logical(), 
                                               turbineOnOff = col_logical()))
View(envisage_windUser)

clusterSet = envisage_windUser[7:10]
completeIndices <- complete.cases(clusterSet)
allWindComplete <- envisage_windUser[completeIndices,]

noMissing <- clusterSet[complete.cases(clusterSet),]
imputing <- mice(clusterSet)
imputed <- complete(imputing,1)
activeData <- noMissing

pcaFit <- PCA(X = activeData, scale.unit = TRUE, ncp = 4)
summary(pcaFit)
plot(pcaFit$eig[,2],type="b", main = "Screeplot, PCA", xlab = "Component", ylab="Variance explained")

#----------------------------------------------
# kMeans clustering with player scores aggregated across maps
#----------------------------------------------
#K-means clustering
wss <- (nrow(activeData)-1)*sum(apply(activeData,2,var))
for (i in 2:4){
  wss[i] <- sum(kmeans(activeData, centers=i)$withinss)
}
rm(i)
plot(1:4, wss, type="b", xlab="Number of kMeans Clusters", ylab="Within groups sum of squares")
rm(wss)
# K-Means Cluster Analysis
kMeansFit <- kmeans(activeData, 4)
clusplot(activeData, kMeansFit$cluster, color=TRUE, shade=FALSE, labels=1, lines=0, main="kMeans clusters")

# get cluster means
aggregate(activeData,by=list(kMeansFit$cluster),FUN=mean)

# append cluster assignment to each player
user_kMeans_cluster <- kMeansFit$cluster
table(user_kMeans_cluster)
activeData <- data.frame(activeData, user_kMeans_cluster)

kMeans_profile <- kMeansFit$centers

#----------------------------------------------
# Archetypal analysis with player scores aggregated across maps 
#----------------------------------------------
#Archetypes in player summary statistics
aa_candidates <- stepArchetypes(data = activeData, k = 1:4, verbose = FALSE, nrep = 4)
screeplot(aa_candidates)
aa4 <- bestModel(aa_candidates[[4]])

pcplot(aa4, activeData)
#barplot(player_aa5, player_summary_statistics[2:(ncol(player_summary_statistics)-1)])

#Find archetype for each player
user_aa4_cluster<-max.col(coef(aa4))
#Append to dataset
activeData <- data.frame(activeData,user_aa4_cluster)
names(activeData)[ncol(activeData)] <- "Archetype"
#Archetype counts
table(user_aa4_cluster)
#Saving archetype information for plotting
aa_profile<-parameters(aa4)

#----------------------------------------------
# Plotting clusters and archetypes
#----------------------------------------------
names(activeData) <- c("Correct power","Time-on-Task","Over power","Under power","","")

#plots K-means
plot(pcaFit$ind$coord[,1:2], type="n", xlim=(c(-4,4)), ylim=c(-2,3))
text(pcaFit$ind$coord[,1:2], col=kMeansFit$cluster, labels=kMeansFit$cluster)
arrows(0, 0, 7*pcaFit$var$coord[,1], 7*pcaFit$var$coord[,2], col = "chocolate", angle = 20, length = 0.18)
text(2*pcaFit$var$coord[,1], 2*pcaFit$var$coord[,2]+0.1, labels=names(activeData))

#plots archetypes
plot(pcaFit$ind$coord[,1:2], type="n", xlim=(c(-10,10)), ylim=c(-10,10))
text(pcaFit$ind$coord[,1:2][13:22,], col=user_aa4_cluster[13:22], labels=user_aa4_cluster[13:22])
arrows(0, 0, 7*pcaFit$var$coord[,1], 7*pcaFit$var$coord[,2], col = "chocolate", angle = 20, length = 0.18)
text(2*pcaFit$var$coord[,1], 2*pcaFit$var$coord[,2]+0.1, labels=names(activeData))