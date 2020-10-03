##########library##########

install.packages("readxl")
install.packages("entropy")
install.packages("rsample")

library(corrplot)
library(randomForest)
library(neuralnet)
library(readxl)
library(caret)
library(stringr)
library(entropy)
library(dplyr)

#Reading the dataset
Predictive_data <- read_excel("Dataset.xlsx")

#Remove the NULL value in the dataset
Predictive_data = na.omit(Predictive_data)

#Removing column with only a single value
Predictive_data <- Predictive_data %>% select_if(~n_distinct(.) > 1)

#Changing type to factor
cols.to.factor <- sapply( Predictive_data, function(col) length(unique(col)) < 10)
Predictive_data[cols.to.factor] <- lapply(Predictive_data[ cols.to.factor] , factor)


#Removing variables with small variance
removeList = vector()
for (f in 1:ncol(Predictive_data)) {
  x = entropy(Predictive_data[[f]])
  if (x<=0.2){
    removeList <- c(removeList, colnames(Predictive_data[f]))
  }
}

if (length(removeList)>0){
  for (i in 1:length(removeList)){
    Predictive_data[removeList[i]] <- list(NULL)
  }
}

#Renaming variables
names(Predictive_data) <- str_replace_all(names(Predictive_data), c(" " = "." , "-" = "."))

#Creating binary variables for every factor and categorical variables
temp_df= as.data.frame(subset(Predictive_data, select=1))
df_cad = as.data.frame(model.matrix(~., data = temp_df))
df_cad[1] <- list(NULL)

for (f in 2:ncol(Predictive_data)) {
  temp_df = as.data.frame(subset(Predictive_data, select=f))
  df_temp = as.data.frame(model.matrix(~., data = temp_df))
  df_temp[1] <- list(NULL)
  df_cad = cbind(df_cad,df_temp)
}

#Changing type back to factor
cols.to.factor <- sapply( df_cad, function(col) length(unique(col)) < 10)
df_cad[cols.to.factor] <- lapply(df_cad[ cols.to.factor] , factor)

#Changing the labels within the factor, so it can work with the neuralnet
feature.names=names(df_cad)
for (f in feature.names) {
  if (class(df_cad[[f]])=="factor") {
    levels <- unique(c(df_cad[[f]]))
    df_cad[[f]] <- factor(df_cad[[f]],
                          labels=make.names(levels))
  }
}

#Creating training and testing data
train.row = sample(1:nrow(df_cad), 0.7*nrow(df_cad))
CAD.train = df_cad[train.row,]
CAD.test = df_cad[-train.row,]

#training control for the model
numFolds <- trainControl(method = 'cv', number = 35, classProbs = TRUE, verboseIter = TRUE, summaryFunction = twoClassSummary, preProcOptions = list(thresh = 0.75, ICAcomp = 3, k = 5))

#Creation of the model
predict_model = train(CAD.train[,1:ncol(CAD.train)-1],CAD.train[,ncol(CAD.train)],method = 'nnet',trControl = numFolds,  preProcess = c('center', 'scale'))

#Checking the accuracy and performance of the model
result = predict(predict_model, newdata = CAD.test)
model_CI = confusionMatrix(result,CAD.test[[ncol(CAD.test)]],positive = NULL)
model_CI

#Finding the most important variables
variable_list <-varImp(model1)
variable_list = variable_list$importance
variable_list$varName = row.names(variable_list)
top10 = variable_list[order(-variable_list$Overall),][1:10,]
var = top10$varName

var

#Create a dataframe with only top 10 most important variables
CAD_revised = df_cad[var]
CAD_revised = cbind(CAD_revised,df_cad[,ncol(df_cad)])
name = colnames(df_cad[ncol(df_cad)])

#Rename the last column
k = ncol(CAD_revised)
colnames(CAD_revised)[k] = name

#Creating training and testing data
train.row = sample(1:nrow(CAD_revised), 0.7*nrow(CAD_revised))
CAD.train = CAD_revised[train.row,]
CAD.test = CAD_revised[-train.row,]

#Revised predictive model using 10 most-important predictor
numFolds <- trainControl(method = 'repeatedcv', number = 25, classProbs = TRUE, verboseIter = TRUE, summaryFunction = twoClassSummary, preProcOptions = list(thresh = 0.75, ICAcomp = 3, k = 5))

model_revised = train(CAD.train[,1:ncol(CAD.train)-1],CAD.train[,ncol(CAD.train)],method = 'nnet',trControl = numFolds,  preProcess = c('center', 'scale'))

result = predict(model_revised, newdata = CAD.test)

model_CI = confusionMatrix(result,CAD.test[[ncol(CAD.test)]],positive = NULL)
model_CI
