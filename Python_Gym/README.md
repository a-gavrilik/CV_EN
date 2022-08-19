# **Building a Model Predicting Customers Churn & Client Clustering Model**

### Stack:
Python 
- Pandas
- Numpy
- Matplotlib
- Seaborn
- Sklearn
  - GridSearchCV
  - StandardScaler
  - LogisticRegression
  - QuadraticDiscriminantAnalysis
  - RandomForestClassifier
  - AdaBoostClassifier
  - GradientBoostingClassifier
  - KMeans

### Task Description:

It is necessary to analyze DataFrame (gym.csv) with anonymised data of fitness center customers to solve 2 tasks:
1. Construct a model that forecasts customer outflow next month.
2. Build client clustering model on groups.

### Description of the DataFrame fields:

- **Churn** - the fact of clients outflow in the current month;
- Customer data for the previous month before checking the fact of outflow:
  - **gender** - gender;
  - **Near_Location** - living or working in the area where the fitness center is located;
  - **Partner** - employee of the partner company of the club (cooperation with companies whose employees can receive discounts on the subscription - in this case, the fitness center stores information about the client’s employer);
  - **Promo_friends** - the fact of the initial entry as part of the campaign «bring a friend» (used a promotional code from a friend when paying the first season ticket);
  - **Phone** - the presence of a contact phone;
  - **Age** - age;
  - **Lifetime** - the time since the first visit to the fitness center (in months).
- Information on the basis of the log of visits, purchases and information on the current status of the client’s subscription:
  - **Contract_period** - duration of the current valid season ticket (month, 3 months, 6 months, year);
  - **Month_to_end_contract** - the term until the end of the current valid subscription (in months);
  - **Group_visits** - the fact of attending group classes;
  - **Avg_class_frequency_total** - is the average frequency of visits per week since the subscription began;
  - **Avg_class_frequency_current_month** - average frequency of visits per week for the previous month;
  - **Avg_additional_charges_total** - total revenue from other fitness center services: cafes, sports goods, cosmetic and massage salon.

### Solution Description:
Several classification models were built to predict next month's customer churn. To do this:
- The data was divided into a training and a test one using "train_test_split".
- The functionality of the selected model was imported.
- The model was trained on the training sample using the "fit" method
a forecast was made on the test sample using the "predict" method.
- The comparison of actual data and predicted data was made. The accuracy of the model was also evaluated using the "f1_score" metric.

Several models from the "Sklearn" library were approximated, namely:
- LogisticRegression
- QuadraticDiscriminantAnalysis
- RandomForestClassifier
- AdaBoostClassifier
- GradientBoostingClassifier

For each model, the "GridSearchCV" grid-based parameter enumeration was implemented. In order to speed up the selection of optimal parameters, some parameters were omitted. The accuracy of each model was then evaluated using the "f1_score" metric and the best model was selected

Then a model for clustering clients into groups based on continuous attributes was built. The "KMeans" method was used for implementation. As a result, all customers were divided into 3 clusters.

Then the percentage of churn and the average values of continuous attributes in the context of each cluster were calculated. As a result, the cluster of clients with the highest percentage of churn and the average values of continuous attributes of clients in this cluster were identified.

