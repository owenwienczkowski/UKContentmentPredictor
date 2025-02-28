# The data provided (in the UKContenment.csv file, taken from the UK governmental website data.gov.uk) relates to
# indicators of social health across England. Adult residents in 353 local areas within England were asked four no
# questions:
# 1) “Do you feel able to influence decisions made in your local area?”
# 2) “Do you believe people from different backgrounds get on well together in your local area?”
# 3) “Do you feel you belong to your neighbourhood?”
# 4) “Do you consider drug use and/or drug selling to be a problem in the local area?”
# 5) “Overall, are you satisfied living in your local area?”
# Each data point in the .csv file corresponds to one of the 353 local areas. The percentage of respondents who answered
# each question “yes” is given, as is the larger area within England within which the local area lies.

# import the dataset
base_data <- read.csv("C:/Users/wxyzo/OneDrive/Desktop/Durham/Stats/Final/UKContentment.csv")

# Explore the 5 number summaries of the different variables.
summary(base_data)

# Check the dataset for null values.
sum(is.na(data))

# Store the contents of the dataset. 
base_data<-UKContentment
base_data
summary(base_data)

# Ensure proper column names are assigned for ease of reference.
ID = base_data$Influence_Decisions
GOW = base_data$Get_On_Well
BL = base_data$Belong
DUS = base_data$Drug_Use_And_Selling
OVR = base_data$Overall

# Identify outliers.
summary(ID)
boxplot(ID) # outliers at 37.9 and above
summary(GOW)
boxplot(GOW) # outliers at 62.5 and below
summary(BL)
boxplot(BL) # no outliers
summary(DUS)
boxplot(DUS) # outliers at 51.8 and above
summary(OVR)
boxplot(OVR) # outliers at 56.6 and below

# Imagine your group has been hired by local government officials in County Durham. They want to spend the next year
# working on improving their score for Question 5: “Overall, are you satisfied living in your local area?”. They are looking
# for advice from you regarding where they should be focusing their efforts in order to do just that. Should they focus on
# how much people feel they can influence decisions, how much people feel those from different backgrounds get on well,
# how much people feel they belong to their neighbourhood, or how much people consider drug-related behvaviour to be a
# problem? Should they focus on more than one thing, and if so, what should be the priority or priorities?

# analyse the correlation between variables via a correlation matrix and plots. No need for 'use = "complete.obs"' as there are no null values.
cor_matrix <- cor(base_data[ , c(2, 3, 4, 5, 7)])
print(cor_matrix)

cor(OVR, ID) # 0.102171 very weak, positive correlation
plot(OVR, ID, main = "Overall Satisfaction vs Influence Decisions")
cor(OVR, GOW) # 0.7867989 strong, positive correlation
plot(OVR, GOW, main = "Overall Satisfaction vs Get On Well")
cor(OVR, BL) # 0.6202603 strong, positive correlation
plot(OVR, BL, main = "Overall Satisfaction vs Belong")
cor(OVR, DUS) # -0.8462228 very strong, negative correlation
plot(OVR, DUS, main = "Overall Satisfaction vs Drug Use And Selling")
cor(DUS, GOW) # -0.6892565 strong, negative correlation
plot(DUS, GOW, main = "Drug Use And Selling vs Get On Well")

# Check which combination of correlated variables yields the greatest adjusted r^2.
bss<-regsubsets(OVR~ID+GOW+BL+DUS,data=base_data,method="exhaustive",nvmax=p)
summary(bss)
summary(bss)$adjr2
which.max(summary(bss)$adjr2)

# Create a multiple linear regression model to predict Overall Satisfaction based on correlated variables.
# The best model predicts Overall Satisfaction using the results of Influence Decisions, Get On Well, Belong, and Drug Use And Selling.
model_all<-lm(OVR~ID+GOW+BL+DUS, data=base_data)
summary(model_all)

# Test to see if the sample likely comes from a normally distributed population.
shapiro_test <- shapiro.test(residuals(model_all))
print(shapiro_test)

# Conduct hypothesis testing by calculating Variance Inflation Factor (VIF) and comparing the model against the four simple linear regression assumptions.
library(car)
vif(model_all)
# ID: 1.088852 - minimal to no multicollinearity with other predictors
# GOW: 2.053438  - acceptable multicollinearity. While it's slightly higher than 1, it does not raise any serious concerns.
# BL: 1.324505 low VIF value, indicating low multicollinearity
# DUS: 2.156892 - slightly higher but still below 5, which indicates moderate multicollinearity but nothing critical.
# All values are below 5, therefore multicollinearity is not a significant issue. 

plot(model_all)
# Plot 1 displays that linearity is clearly holding as the average value of the residuals is nearly zero across the range of fitted values. There is no discernible pattern in the plot. Assumption 1 holds.
# Plot 2 shows evidence that the residuals are at least roughly normally distributed. However, there are minor deviations at the tails of the graph which may suggest outliers, skewness, or kurtosis. Assumption 2 holds. 
# Plot 3 shows no evidence of heteroscadisticity - the residuals are relatively scattered without a clear funnel or systematic pattern. Assumption 3 holds.
# Plot 4 shows no evidence of any points having significant leverage over the results of the model - there are no points with a Cook's distance of 0.5 or greater. Assumption 4 holds. 

# We predict improvements in Drug Use And Selling to lead to significant improvements in Get On Well (and in other values but not by as much).