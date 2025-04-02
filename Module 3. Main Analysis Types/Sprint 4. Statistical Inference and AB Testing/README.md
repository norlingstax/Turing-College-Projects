# Module 3, Sprint 4: Statistical Inference and A/B Testing 

This project focused on applying statistical inference to analyse an A/B test. The task involved evaluating three different marketing campaigns to identify the best-performing one and making recommendations for future marketing strategies.

If there is an issues with file preview, it is also accessible via this [link](https://drive.google.com/file/d/1FJwoPlEGYjrU1Y1Jw1wfOfpuDJanNBWJ/view?usp=sharing).

---

## Project Overview

### Objective
- Analyse an A/B test to compare the effectiveness of three marketing campaigns on weekly sales.
- Perform statistical tests to determine whether observed differences in sales are statistically significant.
- Provide actionable recommendations based on the results of the analysis.

### Tasks
1. **Data Preparation**:
   - Aggregated sales data by `LocationID` and `PromotionID` using SQL.
   - Verified sample ratio balance across promotions to rule out sampling issues.
   - Calculated average weekly sales for each campaign.

2. **Statistical Analysis**:
   - Conducted pairwise comparisons between promotions using **t-tests**.
   - Adjusted significance level to 99% to account for the multiple testing problem.
   - Reported t-statistics, p-values, and confidence intervals for each comparison.

3. **Visualisation**:
   - Created bar charts and box plots to visualise the average sales and sales distribution across promotions.
   - Used error bars to represent confidence intervals, highlighting performance differences.

4. **Recommendations**:
   - Identified the best-performing campaign based on statistical and visual analysis.
   - Suggested actionable next steps to refine and optimise future marketing efforts.

---

## Key Skills Acquired

### Statistical Inference
- Applied **t-tests** for pairwise comparisons of average weekly sales.
- Used a 99% confidence level to mitigate the risk of type I errors in multiple testing.
- Interpreted test results to make data-driven decisions.

### SQL and Python Integration
- **SQL**:
  - Extracted and aggregated data from the `wa_marketing_campaign` table.
  - Verified sample distribution and prepared data for statistical testing.
- **Python**:
  - Conducted statistical tests and visualised the results.
  - Used libraries like `pandas`, `numpy`, `scipy.stats`, and `matplotlib`.

### Analytical and Communication Skills
- Provided clear and concise interpretations of statistical results.
- Delivered actionable recommendations backed by data and visuals.
- Documented the analysis in a structured and professional format.

### Soft Skills
- Defended the project during peer and Senior Team Lead reviews, demonstrating analytical thinking and clear communication.
- Provided and incorporated constructive feedback during reviews.

---

## Key Takeaways
This sprint enhanced my ability to:
- Apply statistical inference techniques to real-world business problems.
- Design robust A/B tests, accounting for issues like multiple comparisons and confidence levels.
- Combine SQL and Python to streamline data analysis workflows.
