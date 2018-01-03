library(plyr)
library(readr)
bonding <- read_delim("~/DevProjects/envisage_viz/Bonding.json.csv", "\t", escape_double = FALSE, col_types = cols(user_id = col_character()), trim_ws = TRUE)
naming <- read_delim("~/DevProjects/envisage_viz/NamingMoleculeData.json.csv", "\t", escape_double = FALSE, col_types = cols(user_id = col_character()), trim_ws = TRUE)
organic <- read_delim("~/DevProjects/envisage_viz/OrganicData.json.csv", "\t", escape_double = FALSE, col_types = cols(user_id = col_character()), trim_ws = TRUE)
wind <- read_delim("~/DevProjects/envisage_viz/WindData.json.csv", "\t", escape_double = FALSE, col_types = cols(user_id = col_character()), trim_ws = TRUE)

bonding <- cbind("bonding",bonding)
names(bonding)[1] <- "lab"
naming <- cbind("naming",naming)
names(naming)[1] <- "lab"
organic <- cbind("organic",organic)
names(organic)[1] <- "lab"
wind <- cbind("wind",wind)
names(wind)[1] <- "lab"

allLabs <- rbind.fill(bonding,naming,organic,wind)
eventTypes <- unique(c(unique(bonding$event),unique(naming$event),unique(organic$event),unique(wind$event)))
table(wind$event)

write(paste(unique(bonding$event), collapse = ","), file = "eventsBonding.txt")
write(paste(unique(naming$event), collapse = ","), file = "eventsNaming.txt")
write(paste(unique(organic$event), collapse = ","), file = "eventsOrganic.txt")
write(paste(unique(wind$event), collapse = ","), file = "eventsWind.txt")

eventValuesBonding <- unique(bonding[c("event","event_id","event_value")])
eventValuesBonding <- eventValuesBonding[order(eventValuesBonding$event),]
write.table(eventValuesBonding,"eventValuesBonding.txt", sep="\t", row.names = FALSE, col.names = TRUE)

eventValuesNaming <- unique(naming[c("event","event_id","event_value")])
eventValuesNaming <- eventValuesNaming[order(eventValuesNaming$event),]
write.table(eventValuesNaming,"eventValuesNaming.txt", sep="\t", row.names = FALSE, col.names = TRUE)

eventValuesOrganic <- unique(organic[c("event","event_id","event_value")])
eventValuesOrganic <- eventValuesOrganic[order(eventValuesOrganic$event),]
write.table(eventValuesOrganic,"eventValuesOrganic.txt", sep="\t", row.names = FALSE, col.names = TRUE)

eventValuesWind <- unique(wind[c("event","event_id","event_value")])
eventValuesWind <- eventValuesWind[order(eventValuesWind$event),]
write.table(eventValuesWind,"eventValuesWind.txt", sep="\t", row.names = FALSE, col.names = TRUE)

allEvents <- table(allLabs$event,allLabs$lab)
write.table(allEvents,"allEvents.txt",sep = "\t",row.names = TRUE, col.names = TRUE)