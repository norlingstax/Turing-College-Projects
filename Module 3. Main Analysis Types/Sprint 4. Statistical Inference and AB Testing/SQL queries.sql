# dataset summary
  -- 10 markets (2 large, 6 medium, 2 small)
  -- 3 promotions
  -- 4 week-experiment
  -- 137 locations

# data for sample ratio mismatch test
select 
  promotion, 
  count(distinct location_id) as location_count
from turing_data_analytics.wa_marketing_campaign
group by promotion;

# aggregated data for statistical tests
select 
  location_id, 
  promotion, 
  round(sum(sales_in_thousands), 2) as total_sales, 
  round(avg(sales_in_thousands), 2) as average_sales_per_week
from turing_data_analytics.wa_marketing_campaign
group by location_id, promotion;