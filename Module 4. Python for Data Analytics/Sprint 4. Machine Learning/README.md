# Module 4, Sprint 4: Machine Learning

This project focused on predicting the 10-year risk of coronary heart disease (CHD) using logistic regression. It involved data cleaning, exploratory data analysis (EDA), model development, and evaluation, highlighting key challenges like class imbalance and feature selection.

## 📋 Project Overview

### Objectives
- Perform data cleaning:
  - Handle missing values using KNN imputation.
  - Remove outliers with threshold-based filtering.
- Conduct exploratory data analysis (EDA) to understand feature distributions, correlations, and multicollinearity.
- Develop and evaluate logistic regression models:
  - Establish a baseline model.
  - Address class imbalance and improve recall.
  - Determine the optimal decision threshold based on appropriate classification metrics.
- Provide insights and recommendations for improving predictive performance.

---

## 🛠️ Key Skills Acquired

### 1. **Data Cleaning**
- **Handling Missing Values**: Applied KNN imputation to fill approximately 15% missing data, ensuring no significant information loss.
- **Outlier Treatment**: Removed extreme values based on domain knowledge and thresholds to improve data quality.
- **Feature Selection**: Addressed multicollinearity by removing correlated features (e.g., systolic/diastolic BP, smoking status and cigarettes per day).

### 2. **Exploratory Data Analysis (EDA)**
- Explored distributions and relationships of 15 features (e.g. age, smoking, cholesterol levels, glucose).
- Used correlation matrices to identify weak correlations with the target variable (ranging from -0.1 to 0.2).
- Summarised feature importance and identified patterns influencing CHD risk.

### 3. **Logistic Regression Modeling**
#### Version 1: Baseline Model
- **Approach**: Used all features without addressing class imbalance.
- **Metrics**:
  - Accuracy: 86%
  - Recall (CHD risk): 3%
  - Precision (CHD risk): 50%
- **Observation**: High accuracy but failed to identify most at-risk patients due to poor recall.

#### Version 2: Balanced Model
- **Approach**: Applied `class_weight='balanced'` to handle class imbalance.
- **Metrics**:
  - Accuracy: 64%
  - Recall (CHD risk): 62%
  - Precision (CHD risk): 22%
- **Observation**: Recall improved significantly, capturing more true positives but with some loss in precision.

#### Version 3: Threshold-Adjusted Model
- **Approach**: Adjusted decision threshold to 0.4 to further improve recall.
- **Metrics**:
  - Accuracy: 52%
  - Recall (CHD risk): 77%
  - Precision (CHD risk): 19%
- **Observation**: Recall maximised, prioritizing identification of at-risk patients at the cost of higher false positives.

### 4. **Model Evaluation**
- Selected recall as the key metric given the high cost of failing to identify at-risk patients.
- Adjusted the decision threshold to balance recall and precision based on project objectives.
- Provided a structured comparison of models to highlight trade-offs between accuracy, recall, and precision.

---

## 🌟 Key Takeaways
- **Mastery of Logistic Regression**: Developed three models to address baseline performance, class imbalance, and decision threshold optimisation.
- **Data-Driven Decision Making**: Chose recall as the critical metric, emphasising capturing at-risk patients for early intervention.
- **Exploratory Insights**: Identified weak individual feature correlations, underscoring the complexity of CHD risk prediction.
- **Feature Selection and Data Preprocessing**: Successfully addressed multicollinearity and data imputation challenges, enhancing model reliability.
- **Analytical Narrative Development**: Demonstrated the ability to balance recall, precision, and accuracy, tailoring the model to meet the project’s objectives.
- **Exploration of Advanced Techniques**: Highlighted the need for larger datasets and more sophisticated models (e.g., ensemble methods) to improve performance further.

---

## 🔍 Recommendations and Future Steps
1. **Larger Dataset**: Incorporate a more extensive dataset to improve learning capacity and model performance.
2. **Advanced Modeling**: Explore non-linear models (e.g., Random Forest, Gradient Boosting) for better handling of complex relationships.
3. **Feature Engineering**: Develop new features or interactions based on domain expertise to enhance predictive accuracy.
4. **Metric Customisation**: Tailor evaluation metrics to real-world objectives, such as minimising false negatives in high-risk patient identification.
