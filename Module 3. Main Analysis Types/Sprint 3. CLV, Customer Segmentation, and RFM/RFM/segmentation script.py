import pandas as pd
import itertools

# generate all possible combinations of 3-digit numbers with digits 1-4
combinations = [''.join(p) for p in itertools.product('1234', repeat=3)]

# create a DataFrame from the combinations
RFMdf = pd.DataFrame(combinations, columns=['score'])
#print(RFMdf)

# split the combinations into separate R, F, and M columns
RFMdf['R'] = RFMdf['score'].str[0].astype(int)
RFMdf['F'] = RFMdf['score'].str[1].astype(int)
RFMdf['M'] = RFMdf['score'].str[2].astype(int)
#print(RFMdf)

# define the function for loyalty groups
def segmentation(r):
    if (r['R'] == 4 and r['F'] == 4 and r['M'] == 4):
        return 'Platinum'  # has all 4s
    elif (r['R'] >= 3 and r['F'] >= 3 and r['M'] >= 3): 
        return 'Gold'  # has at least 3 in each category
    elif (r['R'] >= 2 and r['F'] >= 2 and r['M'] >= 2) or (r['R'] >= 1 and r['F'] == 4 and r['M'] >= 1):
        return 'Silver'  # loyal customers have moderate F/M scores, represent a dependable majority
    elif (r['R'] >= 1 and r['F'] >= 2 and r['M'] == 2) or (r['R'] >= 1 and r['F'] >= 2 and r['M'] == 3):
        return 'Churn Risk'  # moderate M with low R/F
    elif (r['R'] <= 2 and r['F'] >= 1 and r['M'] >= 3):
        return 'High-Spend'  # high M and low R/F
    elif (r['R'] >= 3 and r['F'] >= 1 and r['M'] >= 1):
        return 'New'  # high R, new customers
    else: 
        return 'Churning'  # customers with the lowest R/F values

# apply the function to the DataFrame
RFMdf['segment'] = RFMdf.apply(segmentation, axis=1)

# select only the 'score' and 'segment' columns
RFMdf_output = RFMdf[['score', 'segment']]
print(RFMdf_output)

# export the DataFrame to a CSV file
#RFMdf_output.to_csv('segments.csv', index=False)