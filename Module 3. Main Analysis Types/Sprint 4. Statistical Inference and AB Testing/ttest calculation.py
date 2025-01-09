import pandas as pd
import numpy as np
from scipy.stats import t
import matplotlib.pyplot as plt

# load the CSV data
data = pd.read_csv('ab_test.csv')

# extract average sales per week for each promotion
promo_1 = data[data['promotion'] == 1]['average_sales_per_week'].tolist()
promo_2 = data[data['promotion'] == 2]['average_sales_per_week'].tolist()
promo_3 = data[data['promotion'] == 3]['average_sales_per_week'].tolist()

# function to calculate t-statistic, p-value, and degrees of freedom
def calculate_t_test(sample1, sample2):
    # calculate means
    mean1 = np.mean(sample1)
    mean2 = np.mean(sample2)
    
    # calculate variances
    var1 = np.var(sample1, ddof=1)
    var2 = np.var(sample2, ddof=1)
    
    # calculate sample sizes
    n1 = len(sample1)
    n2 = len(sample2)
    
    # calculate t-statistic
    t_stat = (mean1 - mean2) / np.sqrt(var1/n1 + var2/n2)
    
    # calculate degrees of freedom
    df = ((var1/n1 + var2/n2)**2) / (((var1/n1)**2)/(n1 - 1) + ((var2/n2)**2)/(n2 - 1))
    
    # calculate two-tailed p-value
    p_value = t.sf(np.abs(t_stat), df) * 2
    
    return t_stat, p_value, df

# calculate t-test results for each pairwise comparison
t_stat_1_2, p_val_1_2, df_1_2 = calculate_t_test(promo_1, promo_2)
t_stat_1_3, p_val_1_3, df_1_3 = calculate_t_test(promo_1, promo_3)
t_stat_2_3, p_val_2_3, df_2_3 = calculate_t_test(promo_2, promo_3)

results = {
    "comparison": ["promo 1 vs promo 2", "promo 1 vs promo 3", "promo 2 vs promo 3"],
    "t-statistic": [t_stat_1_2, t_stat_1_3, t_stat_2_3],
    "p-value": [p_val_1_2, p_val_1_3, p_val_2_3],
    "degrees of freedom": [df_1_2, df_1_3, df_2_3]
}

results_df = pd.DataFrame(results)

print(results_df)




# calculate means and confidence intervals for visualisations
means = [np.mean(promo_1), np.mean(promo_2), np.mean(promo_3)]
conf_intervals = [
    1.96 * np.sqrt(np.var(promo_1, ddof=1) / len(promo_1)),
    1.96 * np.sqrt(np.var(promo_2, ddof=1) / len(promo_2)),
    1.96 * np.sqrt(np.var(promo_3, ddof=1) / len(promo_3))
]

# create bar chart
plt.figure(figsize=(10, 6))
plt.bar(['Promotion 1', 'Promotion 2', 'Promotion 3'], 
        means, 
        yerr=conf_intervals, 
        capsize=5, 
        color=['#8fbc8f', '#b94e48', '#ffb300'])
plt.title('Average Sales per Week by Promotion')
plt.ylabel('Average Sales in Thousands USD')
plt.show()

# create box plot
plt.figure(figsize=(10, 6))
plt.boxplot([promo_1, promo_2, promo_3], 
            patch_artist=True,
            boxprops=dict(facecolor='#8fbc8f'),
            medianprops=dict(color='#ff9f00', linewidth=3))
plt.xticks([1, 2, 3], ['Promotion 1', 'Promotion 2', 'Promotion 3'])
plt.title('Sales Distribution by Promotion')
plt.ylabel('Sales in Thousands USD')
plt.show()
