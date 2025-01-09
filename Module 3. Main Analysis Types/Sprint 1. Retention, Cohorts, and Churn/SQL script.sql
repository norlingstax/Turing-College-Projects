with cohorts as (
  select
    user_pseudo_id,
    subscription_start,
    subscription_end,
    date_trunc(subscription_start, week) as cohort_start
  from turing_data_analytics.subscriptions
),
active_users as (
  select
    cohort_start,
    count(user_pseudo_id) as week_0_active,

    countif(subscription_start <= date_add(cohort_start, interval 1 week) 
      and (subscription_end is null or subscription_end > date_add(cohort_start, interval 1 week)) 
      and date_add(cohort_start, interval 1 week) <= (select max(subscription_start) from cohorts)) 
    as week_1_active,

    countif(subscription_start <= date_add(cohort_start, interval 2 week) 
      and (subscription_end is null or subscription_end > date_add(cohort_start, interval 2 week)) 
      and date_add(cohort_start, interval 2 week) <= (select max(subscription_start) from cohorts)) 
    as week_2_active,

    countif(subscription_start <= date_add(cohort_start, interval 3 week) 
      and (subscription_end is null or subscription_end > date_add(cohort_start, interval 3 week)) 
      and date_add(cohort_start, interval 3 week) <= (select max(subscription_start) from cohorts)) 
    as week_3_active,

    countif(subscription_start <= date_add(cohort_start, interval 4 week) 
      and (subscription_end is null or subscription_end > date_add(cohort_start, interval 4 week)) 
      and date_add(cohort_start, interval 4 week) <= (select max(subscription_start) from cohorts)) 
    as week_4_active,

    countif(subscription_start <= date_add(cohort_start, interval 5 week) 
      and (subscription_end is null or subscription_end > date_add(cohort_start, interval 5 week)) 
      and date_add(cohort_start, interval 5 week) <= (select max(subscription_start) from cohorts)) 
    as week_5_active,

    countif(subscription_start <= date_add(cohort_start, interval 6 week) 
      and (subscription_end is null or subscription_end > date_add(cohort_start, interval 6 week)) 
      and date_add(cohort_start, interval 6 week) <= (select max(subscription_start) from cohorts)) 
    as week_6_active

  from cohorts
  where cohort_start < (select max(subscription_start) from cohorts)
  group by cohort_start  
),
retention as (
  select
    cohort_start,
    100 as week_0,
    round(week_1_active / week_0_active * 100, 1) as week_1,
    round(week_2_active / week_0_active * 100, 1) as week_2,
    round(week_3_active / week_0_active * 100, 1) as week_3,
    round(week_4_active / week_0_active * 100, 1) as week_4,
    round(week_5_active / week_0_active * 100, 1) as week_5,
    round(week_6_active / week_0_active * 100, 1) as week_6
  from active_users
)
select * from active_users;
-- select * from retention;

