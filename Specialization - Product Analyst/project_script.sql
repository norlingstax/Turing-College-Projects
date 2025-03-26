### GENERAL DYNAMIC DAILY DURATION ANALYSIS

-- CTE to get the first event for each user on each day
with first_event as (
  select
      user_pseudo_id,
      event_date,
      min(event_timestamp) as first_event_time
  from turing_data_analytics.raw_events
  group by user_pseudo_id, event_date
),

-- CTE to get the first purchase event for each user on each day
first_purchase as (
  select
      user_pseudo_id,
      event_date,
      min(event_timestamp) as first_purchase_time
  from turing_data_analytics.raw_events
  where event_name = 'purchase'
  group by user_pseudo_id, event_date
)

-- final query to calculate the duration from first event to first purchase
select
    parse_date('%Y%m%d', cast(event_date as string)) as event_date,
    round(avg(timestamp_diff(
        timestamp_seconds(cast(fp.first_purchase_time / 1000000 as int64)),
        timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
        minute
    ))) as avg_duration_min
from first_event fe
join first_purchase fp
    using(user_pseudo_id, event_date)
group by fe.event_date
order by fe.event_date;


### PLATFORM SPLIT ANALYSIS

-- CTE to get the first event for each user on each day
with first_event as (
  select
      user_pseudo_id,
      event_date,
      min(event_timestamp) as first_event_time,
      category as platform
  from turing_data_analytics.raw_events
  group by user_pseudo_id, event_date, platform
),

-- CTE to get the first purchase event for each user on each day
first_purchase as (
  select
      user_pseudo_id,
      event_date,
      min(event_timestamp) as first_purchase_time,
      category as platform
  from turing_data_analytics.raw_events
  where event_name = 'purchase'
  group by user_pseudo_id, event_date, platform
)

-- final query to calculate the duration for mobile and desktop separately
select
  parse_date('%Y%m%d', cast(event_date as string)) as event_date,

  -- average duration for desktop users
  round(avg(case when fe.platform = 'desktop' then 
      timestamp_diff(
          timestamp_seconds(cast(fp.first_purchase_time / 1000000 as int64)),
          timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
          minute
      ) else null end)) as avg_duration_desktop,

  -- average duration for mobile users
  round(avg(case when fe.platform = 'mobile' then 
      timestamp_diff(
          timestamp_seconds(cast(fp.first_purchase_time / 1000000 as int64)),
          timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
          minute
      ) else null end)) as avg_duration_mobile

from first_event fe
join first_purchase fp
    using(user_pseudo_id, event_date)
group by fe.event_date
order by fe.event_date;


### WEEKDAY DYNAMIC DAILY DURATION ANALYSIS

-- CTE to get the first event for each user on each day
with first_event as (
  select
      user_pseudo_id,
      event_date,
      min(event_timestamp) as first_event_time
  from turing_data_analytics.raw_events
  group by user_pseudo_id, event_date
),

-- CTE to get the first purchase event for each user on each day
first_purchase as (
  select
      user_pseudo_id,
      event_date,
      min(event_timestamp) as first_purchase_time
  from turing_data_analytics.raw_events
  where event_name = 'purchase'
  group by user_pseudo_id, event_date
)

-- final query to calculate the duration grouped by weekday
select
    format_date('%A', parse_date('%Y%m%d', cast(fe.event_date as string))) as weekday,  -- extract weekday name
    round(avg(timestamp_diff(
        timestamp_seconds(cast(fp.first_purchase_time / 1000000 as int64)),
        timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
        minute
    )), 2) as avg_duration_min
from first_event fe
join first_purchase fp
    using(user_pseudo_id, event_date)
group by weekday
order by
    case
        when weekday = 'Monday' then 1
        when weekday = 'Tuesday' then 2
        when weekday = 'Wednesday' then 3
        when weekday = 'Thursday' then 4
        when weekday = 'Friday' then 5
        when weekday = 'Saturday' then 6
        when weekday = 'Sunday' then 7
    end;


### RETURNING VS. NEW USERS ANALYSIS

-- get sample sizes for returning and new users
select
    case when purchase_cnt = 1 then 'new'
         else 'returning' end as user_type,
    count(user_pseudo_id) as user_count
from (
    -- get purchase count for each user
    select 
        user_pseudo_id,
        count(*) as purchase_cnt
    from turing_data_analytics.raw_events
    where event_name = 'purchase'
    group by user_pseudo_id
) user_purchases
group by user_type;



-- get the first event for each user on each day
with first_event as (
    select
        user_pseudo_id,
        event_date,
        min(event_timestamp) as first_event_time
    from turing_data_analytics.raw_events
    group by user_pseudo_id, event_date
),

-- get the first purchase event for each user on each day
daily_purchase as (
    select
        user_pseudo_id,
        event_date as purchase_date,
        min(event_timestamp) as first_purchase_time
    from turing_data_analytics.raw_events
    where event_name = 'purchase'
    group by user_pseudo_id, event_date
),

-- get the date of each user's first-ever purchase
first_purchase as (
    select
        user_pseudo_id,
        min(purchase_date) as first_purchase_date
    from daily_purchase
    group by user_pseudo_id
)

-- final query to calculate the average time to conversion for returning and new users
select
    parse_date('%Y%m%d', cast(dp.purchase_date as string)) as purchase_date,

    -- average time to convert for returning users
    round(avg(case when dp.purchase_date > fp.first_purchase_date then 
        timestamp_diff(
            timestamp_seconds(cast(dp.first_purchase_time / 1000000 as int64)),
            timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
            minute
        ) else null end), 2) as avg_duration_returning,

    -- average time to convert for new users
    round(avg(case when dp.purchase_date = fp.first_purchase_date then 
        timestamp_diff(
            timestamp_seconds(cast(dp.first_purchase_time / 1000000 as int64)),
            timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
            minute
        ) else null end), 2) as avg_duration_non_returning

from daily_purchase dp
join first_event fe
  on dp.user_pseudo_id = fe.user_pseudo_id and dp.purchase_date = fe.event_date
join first_purchase fp
  on dp.user_pseudo_id = fp.user_pseudo_id
group by dp.purchase_date
order by dp.purchase_date;


### RANDOMLY SAMPLED NEW USERS TO COUNTER SAMPLE SIZE IMBALANCE

-- get the first event for each user on each day
with first_event as (
    select
        user_pseudo_id,
        event_date,
        min(event_timestamp) as first_event_time
    from turing_data_analytics.raw_events
    group by user_pseudo_id, event_date
),

-- get the first purchase event for each user on each day
daily_purchase as (
    select
        user_pseudo_id,
        event_date as purchase_date,
        min(event_timestamp) as first_purchase_time
    from turing_data_analytics.raw_events
    where event_name = 'purchase'
    group by user_pseudo_id, event_date
),

-- get the date of each user's first-ever purchase
first_purchase as (
    select
        user_pseudo_id,
        min(purchase_date) as first_purchase_date
    from daily_purchase
    group by user_pseudo_id
),

-- randomly sample 775 new users (users who made only one purchase)
sampled_new_users as (
    select user_pseudo_id
    from first_purchase fp
    where not exists (
        select 1
        from daily_purchase dp
        where dp.user_pseudo_id = fp.user_pseudo_id
        and dp.purchase_date > fp.first_purchase_date
    )
    order by rand()  -- randomly order users
    limit 775  -- select 775 new users
)

-- final query to calculate the average time to conversion for returning and sampled new users
select
    parse_date('%Y%m%d', cast(dp.purchase_date as string)) as purchase_date,

    -- average time to convert for returning users
    round(avg(case when dp.purchase_date > fp.first_purchase_date then 
        timestamp_diff(
            timestamp_seconds(cast(dp.first_purchase_time / 1000000 as int64)),
            timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
            minute
        ) else null end), 2) as avg_duration_returning,

    -- average time to convert for sampled new users
    round(avg(case when dp.purchase_date = fp.first_purchase_date and dp.user_pseudo_id in (select user_pseudo_id from sampled_new_users) then 
        timestamp_diff(
            timestamp_seconds(cast(dp.first_purchase_time / 1000000 as int64)),
            timestamp_seconds(cast(fe.first_event_time / 1000000 as int64)),
            minute
        ) else null end), 2) as avg_duration_non_returning

from daily_purchase dp
join first_event fe
  on dp.user_pseudo_id = fe.user_pseudo_id 
	and dp.purchase_date = fe.event_date
join first_purchase fp
  on dp.user_pseudo_id = fp.user_pseudo_id
group by dp.purchase_date
order by dp.purchase_date;