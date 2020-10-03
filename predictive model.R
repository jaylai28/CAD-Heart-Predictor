#Load libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(randomForest)
library(Metrics)
#Importing datasets
CAD4

bike <- read.csv('bike_sharing.csv')
bike$yr <- as.factor(bike$yr)
bike$mnth <- factor(bike$mnth, levels = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
bike$weekday <- factor(bike$weekday, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'))
bike$season <- factor(bike$season, levels = c('Spring', 'Summer', 'Fall', 'Winter'))
train_set <- read.csv('bike_train.csv')
train_set$hr <- as.factor(train_set$hr)
test_set <- read.csv('bike_test.csv')
test_set$hr <- as.factor(test_set$hr)
levels(test_set$mnth) <- levels(train_set$mnth)
levels(test_set$hr) <- levels(train_set$hr)
levels(test_set$holiday) <- levels(train_set$holiday)
levels(test_set$weekday) <- levels(train_set$weekday)
levels(test_set$weathersit) <- levels(train_set$weathersit)
#Importing model
model_rf <- readRDS(file = './rf.rda')
model_rf
y_pred = predict(model_rf, newdata = test_set)
mae_rf = mae(test_set[[10]], y_pred)
rmse_rf = rmse(test_set[[10]], y_pred)



#Prediction tab content
tabItem('pred',
        #Filters for categorical variables
        box(title = 'Categorical variables', 
            status = 'primary', width = 12, 
            splitLayout(
              tags$head(tags$style(HTML(".shiny-split-layout > div {overflow: visible;}"))),
              cellWidths = c('0%', '19%', '4%', '19%', '4%', '19%', '4%', '19%', '4%', '8%'),
              selectInput( 'p_gender', 'Gender', c('Male', 'Female')))),
        #Filters for numeric variables
        box(title = 'Numerical variables',
            status = 'primary', width = 12,
            splitLayout(cellWidths = c('22%', '4%','21%', '4%', '21%', '4%', '21%'),
                        # sliderInput( 'p_hum', 'Humidity (%)', min = 0, max = 100, value = 0),
                        # div(),
                        numericInput( 'p_age', 'Age', 0),
                        div(),
                        numericInput( 'p_bp', 'Blood Pressure', 0),
                        div(),
                        numericInput( 'p_heartrate', 'Heart Rate', 0))),
        #Box to display the prediction results
        box(title = 'Prediction result',
            status = 'success', 
            solidHeader = TRUE, 
            width = 4, height = 260,
            div(h5('Result:')),
            verbatimTextOutput("value", placeholder = TRUE),
            actionButton('cal','Calculate', icon = icon('calculator'))),
        #Box to display information about the model
        box(title = 'Model explanation',
            status = 'success', 
            width = 8, height = 260,
            helpText('The following model will predict the total number of bikes rented on a specific day of the week, hour, and weather conditions.'),
            helpText(sprintf('The prediction is based on a random forest supervised machine learning model. Furthermore, the models deliver a mean absolute error (MAE) of %s total number of registrations, and a root mean squared error (RMSE) of %s total number of registrations.', round(mae_rf, digits = 0), round(rmse_rf, digits = 0)))))
