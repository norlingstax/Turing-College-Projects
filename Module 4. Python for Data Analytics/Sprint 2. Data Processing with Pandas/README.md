# Module 4, Sprint 2: Data Processing with Pandas

This project involved exploring and analysing Spotify's **Top 50 Tracks of 2020** dataset using **Pandas** in Jupyter Notebook. The goal was to answer a range of analytical questions about hit songs while demonstrating data cleaning, exploratory data analysis (EDA), and reporting skills. If there are problems with notebook preview, it is also accessible via this [link](https://drive.google.com/file/d/1ezh3IN8l7trPYcxkYgi7x4n2bDce3iSU/view?usp=sharing)

---

## 📋 Project Overview

### Objectives
1. Perform **data cleaning**:
   - Handle missing values.
   - Remove duplicate records and features.
   - Address outliers.

2. Conduct **exploratory data analysis**:
   - Provide insights into the dataset, such as track and artist popularity, genre representation, and feature distributions.
   - Identify relationships between numeric features using correlation analysis.
   - Compare key metrics like **danceability**, **loudness**, and **acousticness** across genres.

3. Present findings in a **clear and structured report**:
   - Use Jupyter Notebook to combine Python code, outputs, and explanations.
   - Ensure results are easy to follow and informative for non-technical audiences.

---

## 🛠️ Key Skills Acquired

### 1. **Data Manipulation with Pandas**
- **Data Loading and Inspection**:
  - Loaded the dataset using `pd.read_csv` and inspected its structure with `.info()`, `.head()`, and `.describe()`.
  - Identified numeric and categorical columns.

- **Data Cleaning**:
  - Treated outliers in numeric columns by applying threshold-based filtering.

- **Data Queries**:
  - Used conditional filtering (`df[df['column'] > value]`) to answer questions such as:
    - Tracks with danceability above 0.7 or below 0.4.
    - Tracks with loudness above -5 or below -8.
    - Longest and shortest tracks.

- **Aggregation and Grouping**:
  - Identified artists and albums with multiple popular tracks using `.groupby()` and aggregation functions (`.count()`, `.sum()`).
  - Counted unique artists and genres in the dataset.

### 2. **Exploratory Data Analysis (EDA)**
- **Descriptive Analysis**:
  - Determined the most popular artist, genre, and album based on counts and aggregations.

- **Correlation Analysis**:
  - Used `.corr()` to compute feature correlations.
  - Identified strong positive, negative, and non-correlated feature pairs.

- **Comparative Analysis by Genre**:
  - Compared **danceability**, **loudness**, and **acousticness** scores across genres such as Pop, Hip-Hop/Rap, Dance/Electronic, and Alternative/Indie using `.groupby()` and visualisations.

### 3. **Notebook Structure and Reporting**
  - Documented each step with markdown cells to explain the logic behind the code and the meaning of the results.
  - Presented findings using plain language, ensuring accessibility for stakeholders unfamiliar with data science.

---

## 🌟 Key Takeaways

This sprint honed my ability to:
- Work with datasets using **Pandas** for filtering, aggregation, and analysis.
- Perform thorough **EDA** to answer analytical questions and uncover hidden patterns.
- Communicate findings clearly through well-documented **Jupyter Notebooks**.


