# FIT3164-CAD-Project
The aim of this project is to create a predictive model using patient features to analyze and predict the occurrence of coronary artery disease (CAD) and identify the predictors with the most impact. This is achieved through the use of machine learning algorithms and a user-friendly website created using R Shiny. The website allows users to input health information and receive a prediction on whether they are likely to have CAD or not. The goal of the project is to provide a cheaper and more efficient solution to identify CAD within patients, as it is currently detected through expensive and hard to obtain x-rays.

Neural Network model was used and created using the top 10 variables. The accuracy of the model was tested by splitting the dataset into training and testing sets and running the model 50 times. The results showed an average accuracy of 85% with a range between 81% and 90%. The model was also tested with a different dataset, and it produced an accuracy of 83%. The code was designed to be robust and applicable to various datasets with similar features. Overall, the predictive model can accurately predict CAD and can be applied to different datasets.


Access the application
Copy and paste the url into a web browser and press ‘Enter’ on the keyboard to access
the application url. The url is https://cadpred.shinyapps.io/FIT3164-CAD-Project/
![Screenshot 2023-03-30 at 14 59 45](https://user-images.githubusercontent.com/69461406/228725703-4787ef55-3beb-4288-b856-f747e2abf5ae.png)


Show/Hide menu bar
- Click to hide the menu bar
![Screenshot 2023-03-30 at 15 01 05](https://user-images.githubusercontent.com/69461406/228725998-207f5721-a630-4a8c-954f-777dafc89751.png)


● CAD Introduction menu
- Click to access the information page, which shows a general introduction
about CAD. The first part shows ‘what is CAD’ and the second part shows ‘Suggestions to lower the risk of CAD’
![Screenshot 2023-03-30 at 15 01 23](https://user-images.githubusercontent.com/69461406/228726023-f91db254-32d7-4152-982d-7fddcaf30432.png)


● Prediction menu
- Click to access the prediction page
![Screenshot 2023-03-30 at 15 01 28](https://user-images.githubusercontent.com/69461406/228726055-9246c0a9-a22e-40df-923e-1f9b645185b0.png)

- Click the box to enter the patient name (optional)
![Screenshot 2023-03-30 at 15 01 35](https://user-images.githubusercontent.com/69461406/228726078-e5f4d2c2-5a68-441c-aa36-aa14be4a2726.png)

- For the categorical variables, click the corresponding choice to do selection
![Screenshot 2023-03-30 at 15 01 40](https://user-images.githubusercontent.com/69461406/228726131-7420d619-1384-450c-9731-0fd06e0c2aa3.png)

- For the numerical variables, there are default values in the four boxes, which need to be changed according to the patient’s body index. The user needs to delete the default values first and then enter the actual numbers in all four boxes. All the numerical variables are required fields, the prediction button is not active (clickable) if there is an empty field
![Screenshot 2023-03-30 at 15 01 47](https://user-images.githubusercontent.com/69461406/228726224-5ed773e3-8b31-4620-94dd-6345c8e32d27.png)

- After filling in all categorical and numerical variables, click ‘Predict’ button to obtain the result
![Screenshot 2023-03-30 at 15 01 52](https://user-images.githubusercontent.com/69461406/228726256-e1e0dd06-6ea3-425a-808f-ecbae618bd77.png)

- The result will show in the result box
![Screenshot 2023-03-30 at 15 01 57](https://user-images.githubusercontent.com/69461406/228726270-dc240a6c-d565-4cf3-a75d-05f67e4136d0.png)

- If an error message shows in the result box, it means that the variable mentioned in the error message is out of range, change the corresponding variable by deleting it first and entering the actual numbers. Finally, click the ‘Predict’ button again.
![Screenshot 2023-03-30 at 15 02 04](https://user-images.githubusercontent.com/69461406/228726295-5ac9102b-fc0b-454a-91b0-e947d4c29d30.png)
