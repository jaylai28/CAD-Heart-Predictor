##########library##########
library(corrplot)
library(randomForest)
library(glmnet)




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

#Factor the categorical vaariables
new_CAD4$Sex = factor(new_CAD4$Sex)
new_CAD4$Obesity = factor(new_CAD4$Obesity)
new_CAD4$CRF = factor(new_CAD4$CRF)
new_CAD4$CVA = factor(new_CAD4$CVA)
new_CAD4$`Airway disease` = factor(new_CAD4$`Airway.disease`)
new_CAD4$`Thyroid Disease` = factor(new_CAD4$`Thyroid.Disease`)
new_CAD4$CHF = factor(new_CAD4$CHF)
new_CAD4$Obesity = factor(new_CAD4$Obesity)
new_CAD4$DLP = factor(new_CAD4$DLP)
new_CAD4$`Weak Peripheral Pulse` = factor(new_CAD4$`Weak.Peripheral.Pulse`)
new_CAD4$`Lung rales` = factor(new_CAD4$`Lung.rales`)
new_CAD4$`Systolic Murmur` = factor(new_CAD4$`Systolic.Murmur`)
new_CAD4$`Diastolic Murmur` = factor(new_CAD4$`Diastolic.Murmur`)
new_CAD4$Dyspnea = factor(new_CAD4$Dyspnea)
new_CAD4$Atypical = factor(new_CAD4$Atypical)
new_CAD4$Nonanginal = factor(new_CAD4$Nonanginal)
new_CAD4$`Exertional CP` = factor(new_CAD4$`Exertional.CP`)
new_CAD4$`LowTH Ang` = factor(new_CAD4$`LowTH.Ang`)
new_CAD4$LVH = factor(new_CAD4$LVH)
new_CAD4$`Poor R Progression` = factor(new_CAD4$`Poor.R.Progression`)
new_CAD4$BBB = factor(new_CAD4$BBB)
new_CAD4$VHD = factor(new_CAD4$VHD)
new_CAD4$Cath = factor(new_CAD4$Cath)


#get all the categorical attributes and remove the NA values
CAD4_cat = subset(new_CAD4, select = c(Sex,Obesity,CRF,CVA,`Airway.disease`,`Thyroid.Disease`,CHF,DLP,
        `Weak.Peripheral.Pulse`,`Lung.rales`,`Systolic.Murmur`,`Diastolic.Murmur`,Dyspnea,Atypical,Nonanginal,
        `Exertional.CP`,`LowTH.Ang`,LVH,`Poor.R.Progression`,BBB,VHD,Cath))


#get all the real-valued attributes and remove the NA values
CAD4_num = subset(new_CAD4, select = -c(Sex,Obesity,CRF,CVA,`Airway.disease`,`Thyroid.Disease`,CHF,DLP,
                                       `Weak.Peripheral.Pulse`,`Lung.rales`,`Systolic.Murmur`,`Diastolic.Murmur`,Dyspnea,Atypical,Nonanginal,
                                       `Exertional.CP`,`LowTH.Ang`,LVH,`Poor.R.Progression`,BBB,VHD,Cath))

CAD4_num

#chi-square test
chisq = chisq.test(CAD4_cat$CVA,CAD4_cat$Cath) 
chisq$observed
chisq
round(chisq$expected,2)


#plot a heatmap to see the correlation of all the variables
factor_vars <- names(which(sapply(CAD4_num, class) == "factor"))
numeric_vars <- setdiff(colnames(CAD4_num), factor_vars)
numeric_vars <- setdiff(numeric_vars, "Cath")
numeric_vars
numeric_vars_mat <- as.matrix(CAD4_num[, numeric_vars, drop=FALSE])


numeric_vars_cor <- cor(numeric_vars_mat)
numeric_vars_cor
corrplot(numeric_vars_cor)


new_CAD4[sapply(new_CAD4, is.character)] <- lapply(new_CAD4[sapply(new_CAD4, is.character)], 
                                                   as.factor)

CAD4_num$Cath = CAD4_cat$Cath
#split the dataset into training set and testing set
train.row = sample(1:nrow(CAD4_num), 0.7*nrow(CAD4_num))
CAD4.train = CAD4_num[train.row,]
CAD4.test = CAD4_num[-train.row,]
CAD4.test
CAD4.train

lambdas = 10^seq(2, -2, by = -.1)

x = model.matrix(Cath~.,CAD4.train)[,-1]

y = ifelse(CAD4.train$Cath == "Cad", 1, 0)


glmnet(x, y, family = "binomial", alpha = 1, lambda = NULL)


cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 1, family = "binomial",
                lambda = cv.lasso$lambda.min)
# Display regression coefficients
coef(model)
# Make predictions on the test data
x.test <- model.matrix(Cath ~., CAD4.test)[,-1]
probabilities <- model %>% predict(newx = x.test)
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy
observed.classes <- CAD4.test$Cath
mean(predicted.classes == observed.classes)                        


cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
plot(cv.lasso)

cv.lasso$lambda.min

cv.lasso$lambda.1se

coef(cv.lasso, cv.lasso$lambda.min)

coef(cv.lasso, cv.lasso$lambda.1se)





x_vars <- model.matrix(Cath~. , CAD4_num)[,-1]
y_var <- CAD4_num$Cath
lambda_seq <- 10^seq(2, -2, by = -.1)

# Splitting the data into test and train
set.seed(29634431)
train = sample(1:nrow(x_vars), nrow(x_vars)/2)
x_test = (-train)
y_test = y_var[x_test]

cv_output <- cv.glmnet(x_vars[train,], y_var[train],
                       alpha = 1, lambda = lambda_seq, 
                       nfolds = 5, family = "binomial")

# identifying best lamda
best_lam <- cv_output$lambda.min
best_lam


# Rebuilding the model with best lamda value identified
lasso_best <- glmnet(x_vars[train,], y_var[train], alpha = 1, lambda = best_lam, family="binomial")
pred <- predict(lasso_best, s = best_lam, newx = x_vars[x_test,])


coef(lasso_best)





#Random Forest
CAD4_randomforest = randomForest(Cath ~., data = CAD4.train, na.action = na.exclude)











