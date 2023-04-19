# MoneyBall Project
This project is based on Michael Lewis' 2003 book "Moneyball: The Art of Winning an Unfair Game," which tells the story of how the 2002 Oakland A's used data and analytics to field a competitive team despite having a smaller payroll than their larger-market rivals.

**Data**<br>
The data for this project was taken from Sean Lahaman's website. There are two datasets we will be working with: Batting.csv and Salaries.csv.

**Batting.csv**<br>
This dataset contains information on player statistics for each season, including games played, at-bats, runs, hits, and more.
* playerID: Player ID code
* yearID: Year
* stint: Player's stint (order of appearances within a season)
* teamID: Team
* lgID: League
* G: Games
* G_batting: Game as batter
* AB: At Bats
* R: Runs
* H: Hits
* X2B: Doubles
* X3B: Triples
* HR: Homeruns
* RBI: Runs Batted In
* SB: Stolen Bases
* CS: Caught Stealing
* BB: Base on Balls
* SO: Strikeouts
* IBB: Intentional walks
* HBP: Hit by pitch
* SH: Sacrifice hits
* SF: Sacrifice flies
* GIDP: Grounded into double plays
* G_Old: Old version of games (deprecated)

**Salaries.csv**<br>
This dataset contains information on player salaries for each season.
* yearID: Year
* teamID: Team
* lgID: League
* playerID: Player ID code
* salary: Salary

**Goal**<br>
In this project, we'll work with the data with the goal of trying to find replacement players for the ones lost at the start of the off-season - During the 2001–02 offseason, the team lost three key free agents to larger market teams: 2000 AL MVP Jason Giambi to the New York Yankees, outfielder Johnny Damon to the Boston Red Sox, and closer Jason Isringhausen to the St. Louis Cardinals. We will use R to perform data analysis on the datasets provided in this repository. The repository contains both the dataset files and the .Rmd file used for analysis.
