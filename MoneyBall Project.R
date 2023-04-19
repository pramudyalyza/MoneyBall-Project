#========================================== DATA ==========================================
#Load Batting Dataset

df <- read.csv("~/pramudya/R/Udemy/Training Exercises/Capstone and Data Viz Projects/Capstone Project/Batting.csv")

#Check the first 6 rows of the Dataset

head(df)

#Check the Structure of the Dataset

str(df)

#Call the head() of AB column

head(df$AB)

#Call the head() of X2B column

head(df$X2B)

#======================================= Feature Engineering =======================================
#Create a new column called BA (Batting Average) which equals to H (Hits) divided by AB (At Base)

df$BA <- df$H / df$AB
tail(df$BA)

#Create a new column called OBP (On Base Percentage)
#OBP = (H + BB + HBP) / (AB + BB + HBP + SF)
#H = Hits
#BB = Bases on Balls
#HBP = Hit By Pitch
#AB = At Bat
#SF = Sacrifice Fly

df$OBP <- (df$H + df$BB + df$HBP) / (df$AB + df$BB + df$HBP + df$SF)
tail(df$OBP)

#Create a new column called SLG (Slugging Percentage)
#SLG = ((1B) + (2 x 2B) + (3 x 3B) + (4 x HR)) / AB
#1B = Singles = H - 2B - 3B - HR
#2B = Doubles
#3B = Triples
#4B = Home Runs
#AB = At Bat

df$X1B <- df$H - df$X2B - df$X3B - df$HR
df$SLG <- ((1 * df$X1B) + (2 * df$X2B) + (3 * df$X3B) + (4 * df$HR)) / df$AB
tail(df$SLG)

#Check again the structure of the dataframe

str(df)

#=============================== Merging Salary Data with Batting Data ================================
#We know we don't just want the best players, we want the most undervalued players, 
#meaning we will also need to know current salary information! We have salary information in the csv file 'Salaries.csv'

#Load Salaries.csv
sal <- read.csv("~/pramudya/R/Udemy/Training Exercises/Capstone and Data Viz Projects/Capstone Project/Salaries.csv")

#Check the summary of the salary dataset and the batting dataset

#Batting Dataset
summary(df)

cat("\n\n\n========================================================================================\n")
#Salary Dataset
summary(sal)

#from the summary above we can see that the min year in the batting dataset is 1871 
#but in salaries dataset the min year is 1985, meaning we need to remove the batting data that occured before 1985 
#if we want to merge the dataset

df <- subset(df, yearID >= 1985)
summary(df)

#merge() function to merge the batting and sal data frames by c('playerID','yearID')

merged <- merge(df, sal, by = c("playerID", "yearID"))

#==================================== Analyzing the Lost Players ====================================

#As previously mentioned, the Oakland A's lost 3 key players during the off-season. 
#We'll want to get their stats to see what we have to replace. 
#The players lost were: first baseman 2000 AL MVP Jason Giambi (giambja01) to the New York Yankees, 
#outfielder Johnny Damon (damonjo01) to the Boston Red Sox and infielder Rainer Gustavo "Ray" Olmedo ('saenzol01')

#get a data frame called lost_players from the combo data frame consisting of those 3 players using subset()

lp <- c("giambja01", "damonjo01", "saenzol01")
lost_player <- subset(merged, playerID %in% lp)
lost_player

#Since all these players were lost in after 2001 in the offseason, let's only concern ourselves with the data from 2001

#grab the rows where the yearID was 2001

lost_player <- subset(lost_player, yearID == 2001)

#Reduce the lost_players data frame to the following columns: playerID,H,X2B,X3B,HR,OBP,SLG,BA,AB
lost_player <- lost_player[,c('playerID', 'H', 'X2B', 'X3B', 'HR', 'OBP', 'SLG', 'BA', 'AB')]
lost_player

#======================================== Replacement Players ========================================

#Find Replacement Players for the key three players we lost
#constraints:
#1. The total combined salary of the three players can not exceed 15 million dollars
#2. Their combined number of At Bats (AB) needs to be equal to or greater than the lost players
#3. Their mean OBP had to equal to or greater than the mean OBP of the lost players

library(dplyr)
library(ggplot2)
library(plotly)

players2001 <- subset(merged, yearID == 2001)
players2001

plot1 <- ggplot(players2001, aes(x=OBP, y=salary)) + geom_point(color = "Blue")
plot1 <- ggplotly(plot1)
plot1

#if the salary combination of the three players shouldn't be above 15 million, 
#then we will cut off the players with salary above 5 million. We will also cut off the plyers with OBP = 0

players2001 <- subset(players2001, salary<= 5000000, OBP>0)
players2001

#their combined number of At Bats (AB) needs to be equal to or greater than the lost players
#the combined AB of the lost players = 1469
#meaning we need to cut off (1469/3 = 490) players with AB < 490

players2001 <- subset(players2001, AB > 490)
players2001

#Their mean OBP had to equal to or greater than the mean OBP of the lost players
OBPlost <- mean(lost_player$OBP)
OBPlost

#lost players mean OBP = 0.3638687
#meaning we have to cut off all the players with OBP less than 0.37

players2001 <- subset(players2001, OBP > 0.37)
players2001

#now we have all the players that have met the criteria
#the next step we will try to find the players with smallest salary but highest OBP and AB

sorted <- arrange(players2001, desc(AB), desc(OBP), salary)
sorted

#now we pick the first 3 row of the players
picked <- sorted[1:3,]
picked[, c('playerID', 'OBP', 'AB', 'salary')]

#check the recruirement

#combined salary have to < 15 million dollars
print(paste("Combined Salary:", sum(picked$salary)))

#combined AB have to > 1469
print(paste("Combined AB:", sum(picked$AB)))

#mean(OBP) have to > 0.3638687
print(paste("mean OBP:", mean(picked$OBP)))
