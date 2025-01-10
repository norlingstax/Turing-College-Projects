# Module 4, Sprint 3: Data Visualisation with Python

This project involved analysing the Coursera Course Dataset using Python libraries (Pandas, NumPy, Matplotlib, and Seaborn) to answer key business questions and explore patterns in course ratings, student enrollment, and provider performance. The analysis was conducted in a Jupyter Notebook to ensure clear explanations and effective communication of findings. 

If there are issues with notebook preview, it is also accessible via this [link](https://colab.research.google.com/drive/1gjPOU76KGdCKrcDiChbwsbiRzLcA6Gkg).

---

## 📋 Project Overview

### Objectives
1. **Data Cleaning:**
   - Check for missing values and duplicates.
   - Clean numerical data.
3. **Exploratory Data Analysis (EDA):**
   - Identify key statistics about the dataset, such as the number of courses, providers, and represented genres.
   - Determine the best-performing courses, providers, and genres.
   - Explore distribution and relationships between key features like ratings, enrollments, and difficulty levels.
   - Adjust ratings using Bayesian methods to account for sample size differences.
4. **Data Visualisation:**
   - Use visualisations to reveal insights into course distribution, popularity, and performance.
5. **Reporting:**
   - Provide a structured, insightful, and visually appealing analysis in the notebook.
   - Propose actionable recommendations based on findings.

---

## 🛠️ Key Skills Acquired

### 1. Data Cleaning and Manipulation
- **Loading and Inspecting Data:**
  - Used `pd.read_csv()` to load data and functions like `.info()`, `.describe()`, and `.head()` to inspect structure and content.
- **Data Cleaning:**
  - Converted string-based enrollment counts into numeric format for analysis.
  - Identified and handled duplicated data as needed.
- **Filtering and Aggregation:**
  - Used `groupby()` to aggregate data and compute metrics like the number of courses or students per provider.
  - Filtered data to answer specific questions, e.g., identifying the most popular organisations or top-rated courses.

### 2. Bayesian Average Ratings
- Addressed bias in ratings by implementing a Bayesian average adjustment:
  - Combined global mean with course/provider-specific metrics to create a fairer ranking system.
  - Balanced differences in sample size (e.g., a single course with a 5.0 rating vs. large providers with many courses).

### 3. Visualisation and Comparative Analysis
- **Matplotlib and Seaborn:**
  - Used bar charts, stacked bar charts, and violin plots to compare metrics across categories such as certificate types and difficulty levels.
- **Exploration of Course Metrics:**
  - Compared distribution of students for different certificate types and difficulties.
  - Explored trends in course popularity and their relationships with ratings and enrollment.

### 4. Reporting and Communication
- Documented each step of the analysis with markdown cells to explain:
  - Goals of each analysis step.
  - Methods and reasoning behind code implementations.
  - Insights derived from the results.
- Presented findings in an accessible way for stakeholders, with clear visualisations and plain-language explanations.

---

## 🌟 Key Takeaways

This sprint refined my ability to:
- **Perform EDA:** Explore datasets effectively and uncover key insights.
- **Use Python Libraries for Data Visualisation:** Create informative and visually engaging plots using Matplotlib and Seaborn.
- **Apply Bayesian Adjustments:** Address biases in data and improve the accuracy of rankings or ratings.
- **Develop Insightful Reports:** Communicate findings clearly and propose actionable recommendations.
- **Developing Analytical Narratives**: Demonstrated the ability to independently define a narrative and key areas of exploration for a free-form project, prioritising relevant insights and structuring the analysis to answer impactful business questions.
