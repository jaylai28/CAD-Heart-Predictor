##########library##########
library(corrplot)
library(glmnet)
library(e1071)
library(randomForest)
library(caret)
library(dplyr)
library(caret)


rm(list = ls())
CAD4 = read.csv("CAD4.csv")


##########Data Cleaning
options(digits = 5)

#get the summary of the CAD4 dataset
summary(CAD4)

#look at the type of each variable in the dataset
str(CAD4)

#remove the NULL value in the dataset
new_CAD4 = na.omit(CAD4)
new_CAD4


#get all the categorical attributes and remove the NA values
CAD4_cat = subset(new_CAD4, select = c(Sex,Obesity,CRF,CVA,`Airway.disease`,`Thyroid.Disease`,CHF,DLP,
                                       `Weak.Peripheral.Pulse`,`Lung.rales`,`Systolic.Murmur`,`Diastolic.Murmur`,Dyspnea,Atypical,Nonanginal,
                                       `Exertional.CP`,`LowTH.Ang`,LVH,`Poor.R.Progression`,BBB,VHD,Cath))


#get all the real-valued attributes and remove the NA values
CAD4_num = subset(new_CAD4, select = -c(Sex,Obesity,CRF,CVA,`Airway.disease`,`Thyroid.Disease`,CHF,DLP,
                                        `Weak.Peripheral.Pulse`,`Lung.rales`,`Systolic.Murmur`,`Diastolic.Murmur`,Dyspnea,Atypical,Nonanginal,
                                        `Exertional.CP`,`LowTH.Ang`,LVH,`Poor.R.Progression`,BBB,VHD,Cath))

CAD4_num


#plot a heatmap to see the correlation of all the variables
factor_vars <- names(which(sapply(CAD4_num, class) == "factor"))
numeric_vars <- setdiff(colnames(CAD4_num), factor_vars)
numeric_vars <- setdiff(numeric_vars, "Cath")
numeric_vars
numeric_vars_mat <- as.matrix(CAD4_num[, numeric_vars, drop=FALSE])
numeric_vars_cor <- cor(numeric_vars_mat)
numeric_vars_cor
corrplot(numeric_vars_cor)



#convert the character to factor
new_CAD4[sapply(new_CAD4, is.character)] = lapply(new_CAD4[sapply(new_CAD4, is.character)],
                                                   as.factor)


#split the dataset into training set and testing set
train.row = sample(1:nrow(new_CAD4), 0.7*nrow(new_CAD4))
CAD4.train = new_CAD4[train.row,]
CAD4.test = new_CAD4[-train.row,]
CAD4.test
CAD4.train


#Random Forest
CAD4_randomforest = randomForest(Cath ~., data = CAD4.train, importance = TRUE)

#Random Forest
#Calculate the accuracy for Random Forest
CAD4_pred_randomforest = predict(CAD4_randomforest, CAD4.test)

#Create confusion matrix
randomforest_confusion = table(Predicted = CAD4_pred_randomforest, Actual = CAD4.test$Cath)
randomforest_confusion

#calculate the accuracy of random forest with confusion matrix
table = confusionMatrix(CAD4_pred_randomforest,CAD4.test$Cath)
confusion_value = table$overall['Accuracy']
confusion_value


# define the control using a random forest selection function
control = rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(new_CAD4[,1:55], new_CAD4[,56], sizes=c(1:8), rfeControl=control)

# summarize the results
results
# list the chosen features
predictors(results)


library(ROCR)
#Random Forest
CAD4_pred_RF_test = predict(CAD4_randomforest, CAD4.test, type="prob")
CAD4_pred_RF = prediction( CAD4_pred_RF_test[,2], CAD4.test$Cath)

#Look at the performance of random forest
CAD4_perf_RF = performance(CAD4_pred_RF,"tpr","fpr")
#Plot a simple ROC curve
plot(CAD4_perf_RF, col = "darkgreen")



#Computing AUC for Random Forest
CAD4_AUC_RF = performance(CAD4_pred_RF, "auc")
value = as.numeric(CAD4_AUC_RF@y.values)
value



# estimate variable importance for Random Forest
importance = varImp(CAD4_randomforest)
importance[order(importance[,1]),]
#Plot a barchart of the variable importance
barplot(CAD4_randomforest$importance[order(CAD4_randomforest$importance, decreasing = TRUE)],
        ylim = c(0, 10), main = "Variables Relative Importance",
        col = "lightblue")


#Perform cross validation for random forest
CAD4_rfcv = rfcv(trainx = CAD4.train[,-c(19)],	trainy = CAD4.train[,c(19)],	cv.fold=10,	scale="log",	step=0.5)
CAD4_rfcv
CAD4_cvrandomforest = randomForest(Cath~., data = CAD4.train, na.action = na.exclude, ntree=500, mtry=20)
CAD4_cvrandomforest
CAD4_pred_cvRF = predict(CAD4_cvrandomforest, CAD4.test)

#calculate the accuracy of random forest for cross validation with confusion matrix
RF_confusion_matrix = table(Predicted_Class = CAD4_pred_cvRF, Actual_Class = CAD4.test$Cath)
c1 = (RF_confusion_matrix[1,1]+RF_confusion_matrix[2,2])/
  sum(RF_confusion_matrix)

c1


# CAD4.test = subset(CAD4.test, select = -c(Obesity,LDL,Weight,Na,WBC,Length,CVA,`Airway.disease`,CHF,DLP,
#                                         `Systolic.Murmur`,BMI,HDL,Neut,Edema,`EX.Smoker`,LVH,`Exertional.CP`,
#                                         `LowTH.Ang`))
# 
# CAD4.train = subset(CAD4.train, select = -c(Obesity,LDL,Weight,Na,WBC,Length,CVA,`Airway.disease`,CHF,DLP,
#                                            `Systolic.Murmur`,BMI,HDL,Neut,Edema,`EX.Smoker`,LVH,`Exertional.CP`,
#                                            `LowTH.Ang`))


