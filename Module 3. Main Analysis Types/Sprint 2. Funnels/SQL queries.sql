# get familiar with data

select count(*)
from turing_data_analytics.raw_events; -- 4,295,584 rows in all dataset

select count(distinct user_pseudo_id)
from turing_data_analytics.raw_events; -- 270,154 unique users

select distinct event_name
from turing_data_analytics.raw_events; -- 17 types of events

select 
  min(event_date), -- 2020-11-01
  max(event_date)  -- 2021-01-31
from turing_data_analytics.raw_events;



# eliminate duplicates by choosing min date and min timestamp

with distinct_events as (  -- 1,388,010 rows
  select
    user_pseudo_id,
    event_name,
    min(event_date) as event_date,
    min(event_timestamp) as event_timestamp
  from turing_data_analytics.raw_events
  group by user_pseudo_id, event_name
  )
select *
from turing_data_analytics.raw_events as raw_events
join distinct_events
using(user_pseudo_id, event_name, event_date, event_timestamp);




# filter further by leaving out unnecessary columns
# count unique users for each event (all-time / by month)

with filtered_events as (
  select -- 1,388,010 rows
    min(event_date) as event_date,
    min(event_timestamp) as event_timestamp,
    event_name,
    user_pseudo_id
  from turing_data_analytics.raw_events
  group by all
),
funnel as ( -- all-time funnel
  select
    event_name,
    count(distinct user_pseudo_id) as no_users
  from filtered_events
  where event_name in ('session_start', 'scroll', 'view_item', 'add_to_cart', 'purchase')
    -- and event_date between '20201101' and '20201130' -- november funnel
    -- and event_date between '20201201' and '20201231' -- december funnel
    -- and event_date between '20210101' and '20210131' -- january funnel
  group by all
)
select * from funnel
order by no_users desc;



# count unique users by event in top 3 countries by number of events (all-time / by month)

with filtered_events as (
  select
    min(event_date) as event_date,
    min(event_timestamp) as event_timestamp,
    event_name,
    user_pseudo_id,
    country
  from turing_data_analytics.raw_events
  group by all
),
funnel as (
  select
    event_name,
    country,
    count(distinct user_pseudo_id) as no_users
  from filtered_events
  where event_name in ('session_start', 'scroll', 'view_item', 'add_to_cart', 'purchase')
    -- and event_date between '20201101' and '20201130' -- november funnel
    -- and event_date between '20201201' and '20201231' -- december funnel
    -- and event_date between '20210101' and '20210131' -- january funnel
  group by all
),
top_countries as (
  select country
  from filtered_events
  group by country
  order by count(distinct user_pseudo_id) desc
  limit 3
),
filtered_funnel as (
  select *
  from funnel
  where country in (select country from top_countries)
),
pivoted_funnel as (
  select
    event_name,
    max(case when country = (select country from top_countries limit 1 offset 0) then no_users else 0 end) as `United States`,
    max(case when country = (select country from top_countries limit 1 offset 1) then no_users else 0 end) as `India`,
    max(case when country = (select country from top_countries limit 1 offset 2) then no_users else 0 end) as `Canada`
  from filtered_funnel
  group by all
)
select
  event_name,
  `United States`,
  `India`,
  `Canada`
from pivoted_funnel
order by 
  case event_name
    when 'session_start' then 1
    when 'scroll' then 2
    when 'view_item' then 3
    when 'add_to_cart' then 4
    else 5
  end;