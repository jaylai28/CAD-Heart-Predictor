##########library##########
library(corrplot)
library(randomForest)








##########Data Cleaning
options(digits = 5)

#get the summary of the CAD4 dataset
summary(CAD4)

#look at the type of each variable in the dataset
str(CAD4)

#remove the NULL value in the dataset
new_CAD4 = na.omit(CAD4)
new_CAD4

#Factor the categorical vaariables
new_CAD4$Sex = factor(new_CAD4$Sex)
new_CAD4$Obesity = factor(new_CAD4$Obesity)
new_CAD4$CRF = factor(new_CAD4$CRF)
new_CAD4$CVA = factor(new_CAD4$CVA)
new_CAD4$`Airway disease` = factor(new_CAD4$`Airway disease`)
new_CAD4$`Thyroid Disease` = factor(new_CAD4$`Thyroid Disease`)
new_CAD4$CHF = factor(new_CAD4$CHF)
new_CAD4$Obesity = factor(new_CAD4$Obesity)
new_CAD4$DLP = factor(new_CAD4$DLP)
new_CAD4$`Weak Peripheral Pulse` = factor(new_CAD4$`Weak Peripheral Pulse`)
new_CAD4$`Lung rales` = factor(new_CAD4$`Lung rales`)
new_CAD4$`Systolic Murmur` = factor(new_CAD4$`Systolic Murmur`)
new_CAD4$`Diastolic Murmur` = factor(new_CAD4$`Diastolic Murmur`)
new_CAD4$Dyspnea = factor(new_CAD4$Dyspnea)
new_CAD4$Atypical = factor(new_CAD4$Atypical)
new_CAD4$Nonanginal = factor(new_CAD4$Nonanginal)
new_CAD4$`Exertional CP` = factor(new_CAD4$`Exertional CP`)
new_CAD4$`LowTH Ang` = factor(new_CAD4$`LowTH Ang`)
new_CAD4$LVH = factor(new_CAD4$LVH)
new_CAD4$`Poor R Progression` = factor(new_CAD4$`Poor R Progression`)
new_CAD4$BBB = factor(new_CAD4$BBB)
new_CAD4$VHD = factor(new_CAD4$VHD)
new_CAD4$Cath = factor(new_CAD4$Cath)





#get all the real-valued attributes and remove the NA values
new_CAD4_1 = subset(new_CAD4, select = c(Age, Weight, Length, BMI, DM, HTN))
new_CAD4_1


#plot a heatmap to see the correlation of all the variables
factor_vars <- names(which(sapply(new_CAD4_1, class) == "factor"))
numeric_vars <- setdiff(colnames(new_CAD4_1), factor_vars)
numeric_vars <- setdiff(numeric_vars, "Cath")
numeric_vars
numeric_vars_mat <- as.matrix(new_CAD4_1[, numeric_vars, drop=FALSE])
numeric_vars_cor <- cor(numeric_vars_mat)
corrplot(numeric_vars_cor)


#split the dataset into training set and testing set
train.row = sample(1:nrow(new_CAD4), 0.7*nrow(new_CAD4))
CAD4.train = new_CAD4[train.row,]
CAD4.test = new_CAD4[-train.row,]
CAD4.test
CAD4.train


#Random Forest
CAD4_randomforest = randomForest(Cath ~. , data = CAD4.train, na.action = na.exclude)











