##########library##########
library(corrplot)
library(glmnet)
library(e1071)
library(randomForest)
library(caret)
library(dplyr)


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

# #Factor the categorical vaariables
# new_CAD4$Sex = factor(new_CAD4$Sex)
# new_CAD4$Obesity = factor(new_CAD4$Obesity)
# new_CAD4$CRF = factor(new_CAD4$CRF)
# new_CAD4$CVA = factor(new_CAD4$CVA)
# new_CAD4$`Airway disease` = factor(new_CAD4$`Airway.disease`)
# new_CAD4$`Thyroid Disease` = factor(new_CAD4$`Thyroid.Disease`)
# new_CAD4$CHF = factor(new_CAD4$CHF)
# new_CAD4$Obesity = factor(new_CAD4$Obesity)
# new_CAD4$DLP = factor(new_CAD4$DLP)
# new_CAD4$`Weak Peripheral Pulse` = factor(new_CAD4$`Weak.Peripheral.Pulse`)
# new_CAD4$`Lung rales` = factor(new_CAD4$`Lung.rales`)
# new_CAD4$`Systolic Murmur` = factor(new_CAD4$`Systolic.Murmur`)
# new_CAD4$`Diastolic Murmur` = factor(new_CAD4$`Diastolic.Murmur`)
# new_CAD4$Dyspnea = factor(new_CAD4$Dyspnea)
# new_CAD4$Atypical = factor(new_CAD4$Atypical)
# new_CAD4$Nonanginal = factor(new_CAD4$Nonanginal)
# new_CAD4$`Exertional CP` = factor(new_CAD4$`Exertional.CP`)
# new_CAD4$`LowTH Ang` = factor(new_CAD4$`LowTH.Ang`)
# new_CAD4$LVH = factor(new_CAD4$LVH)
# new_CAD4$`Poor R Progression` = factor(new_CAD4$`Poor.R.Progression`)
# new_CAD4$BBB = factor(new_CAD4$BBB)
# new_CAD4$VHD = factor(new_CAD4$VHD)
# new_CAD4$Cath = factor(new_CAD4$Cath)


#get all the categorical attributes and remove the NA values
CAD4_cat = subset(new_CAD4, select = c(Sex,Obesity,CRF,CVA,`Airway.disease`,`Thyroid.Disease`,CHF,DLP,
        `Weak.Peripheral.Pulse`,`Lung.rales`,`Systolic.Murmur`,`Diastolic.Murmur`,Dyspnea,Atypical,Nonanginal,
        `Exertional.CP`,`LowTH.Ang`,LVH,`Poor.R.Progression`,BBB,VHD,Cath))


#get all the real-valued attributes and remove the NA values
CAD4_num = subset(new_CAD4, select = -c(Sex,Obesity,CRF,CVA,`Airway.disease`,`Thyroid.Disease`,CHF,DLP,
                                       `Weak.Peripheral.Pulse`,`Lung.rales`,`Systolic.Murmur`,`Diastolic.Murmur`,Dyspnea,Atypical,Nonanginal,
                                       `Exertional.CP`,`LowTH.Ang`,LVH,`Poor.R.Progression`,BBB,VHD,Cath))

CAD4_num


#convert the character to factor
new_CAD4[sapply(new_CAD4, is.character)] <- lapply(new_CAD4[sapply(new_CAD4, is.character)],
                                                   as.factor)

#split the dataset into training set and testing set
train.row = sample(1:nrow(new_CAD4), 0.7*nrow(new_CAD4))
CAD4.train = new_CAD4[train.row,]
CAD4.test = new_CAD4[-train.row,]
CAD4.test
CAD4.train


#Random Forest
CAD4_randomforest = randomForest(Cath ~., data = CAD4.train, importance = TRUE)
CAD4_randomforest

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

library(ROCR)
#Random Forest
CAD4_pred_RF_test = predict(CAD4_randomforest, CAD4.test, type="prob")
CAD4_pred_RF = prediction( CAD4_pred_RF_test[,2], CAD4.test$Cath)
CAD4_perf_RF = performance(CAD4_pred_RF,"tpr","fpr")
plot(CAD4_perf_RF, add=TRUE, col = "darkgreen")
# Add a legend to the plot
legend("bottomright",legend=c("Decision Tree", "Naive Bayes", "Bagging", "Boosting", "Random Forest"), 
       fill=c('orange','blue','violet','red','darkgreen'),cex=0.8, text.font=4)


#Computing AUC for Random Forest
CAD4_AUC_RF = performance(CAD4_pred_RF, "auc")
value = as.numeric(CAD4_AUC_RF@y.values)
value


#Random Forest
CAD4_randomforest$importance
barplot(CAD4_randomforest$importance[order(CAD4_randomforest$importance, decreasing = TRUE)],
        ylim = c(0, 10), main = "Variables Relative Importance",
        col = "lightblue")


CAD4_rfcv = rfcv(trainx = CAD4.train[,-c(19)],	trainy = CAD4.train[,c(19)],	cv.fold=5,	scale="log",	step=0.5)
CAD4_rfcv

CAD4_cvrandomforest = randomForest(Cath~., data = CAD4.train, na.action = na.exclude, ntree=500, mtry=18)
CAD4_cvrandomforest
CAD4_pred_cvRF = predict(CAD4_cvrandomforest, CAD4.test)
RF_confusion_matrix = table(Predicted_Class = CAD4_pred_cvRF, Actual_Class = CAD4.test$Cath)
c1 = (RF_confusion_matrix[1,1]+RF_confusion_matrix[2,2])/
  sum(RF_confusion_matrix)

c1





