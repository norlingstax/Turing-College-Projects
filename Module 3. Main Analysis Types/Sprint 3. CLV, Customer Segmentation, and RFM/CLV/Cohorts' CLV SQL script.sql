with cohorts as ( -- identify each user's registration date and cohort start week based on their first visit
  select
    user_pseudo_id,
    min(parse_date('%Y%m%d', event_date)) as registration_date,
    date_trunc(min(parse_date('%Y%m%d', event_date)), week) as cohort_start
  from turing_data_analytics.raw_events
  group by user_pseudo_id
),

revenue as ( -- calculate the total revenue for each purchase date by user  
  select
    distinct user_pseudo_id,
    parse_date('%Y%m%d', event_date) as purchase_date,
    sum(purchase_revenue_in_usd) as revenue
  from turing_data_analytics.raw_events
  where event_name = 'purchase'
  group by user_pseudo_id, purchase_date
),

registrations as ( -- count the number of registrations (first visits) for each cohort start week  
  select
    cohort_start,
    count(user_pseudo_id) as registrations
  from cohorts
  group by cohort_start
),

cohort_week_revenue as ( -- calculate the revenue for each cohort for each week since the cohort start  
  select
    c.cohort_start,
    date_diff(r.purchase_date, c.cohort_start, week) as week_number,
    sum(r.revenue) as revenue
  from cohorts c
  join revenue r
  using(user_pseudo_id)
  where r.purchase_date >= c.cohort_start
  group by c.cohort_start, week_number
),

cohort_revenue_divided as ( -- divide the weekly revenue by the total number of registrations for that cohort start week  
  select
    cwr.cohort_start,
    cwr.week_number,
    cwr.revenue / r.registrations as revenue_per_registration
  from cohort_week_revenue cwr
  join registrations r
  using(cohort_start)
),

cohorts_avg_revenue as ( -- pivot the data to create columns for each week number
  select *
  from (
    select
      cohort_start,
      week_number,
      revenue_per_registration
    from cohort_revenue_divided
  )
  pivot (
    sum(revenue_per_registration) for week_number in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
  )
  where cohort_start < (select max(registration_date) from cohorts)
  order by cohort_start
),

cmltv_revenue as ( -- calculate the cumulative sum of revenue per registration for each cohort week-by-week  
  select
    cohort_start,
    week_number,
    revenue_per_registration,
    sum(revenue_per_registration) over (partition by cohort_start order by week_number) as cumulative_revenue
  from cohort_revenue_divided
),

cohorts_cumulative_sum as ( -- pivot the cumulative sum data to create columns for each week number  
  select *
  from (
    select
      cohort_start,
      week_number,
      cumulative_revenue
    from cmltv_revenue
  )
  pivot (
    sum(cumulative_revenue) for week_number in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
  )
  where cohort_start < (select max(registration_date) from cohorts)
  order by cohort_start
)

-- select the revenue per registration for all week numbers
select * from cohorts_avg_revenue;

-- select the cumulative sum of revenue per registration for all week numbers
-- select * from cohorts_cumulative_sum;