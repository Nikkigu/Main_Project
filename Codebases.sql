show databases;
use project_aug;
 
select * from dim_cities;
select * from dim_repondents;
select * from fact_survey_responses 


# question 01.a and 01.a
select count(Gender) from dim_repondents 
where gender = 'male';

# question 1 b
select b.age , b.num from (select  count(*) as num , age  from dim_repondents 
  group by age)b
  where b.num = (select max(a.num) from (select  count(*) as num , age  from dim_repondents 
  group by age) as a);
  
select b.age , b.num,rank() over(order by b.num desc) as dup
 from (select  count(*) as num , age  from dim_repondents 
  group by age)b  ;
  
  
  # question 1 c
  select D.age , B.Marketing_channels,count(*) as num
  from   Dim_repondents D inner join 
   fact_survey_responses B 
   on D.Respondent_ID = B.Respondent_ID
  group by 1;
  
  # Question 2 a
  select a.Ingredients_expected ,a.Num_of_consumption ,consume_reason 
  from (select Ingredients_expected ,count(Ingredients_expected) as Num_of_consumption , consume_reason from fact_survey_responses
  group by 1 order by 2 desc)a;
  
  # question 2 b
  select Packaging_preference, count(*) as num from fact_survey_responses
  group by 1 order by num desc;
   
   # question 3 a 
 # select current_brands ,max(P.market_leaders) 
 # from( select *,count(current_brands) as market_leaders from fact_survey_responses ) P;
  
select P.current_brands ,P.market_leaders
from( select Current_brands,count(current_brands) as market_leaders,rank() over(order by count(current_brands) desc) as rnk
 from fact_survey_responses group by 1 ) P
  where P.rnk = 1;
  
 # question 3 b
#select current_brands, Consume_reason ,max(P.market_leaders) 
#from( select *,count(current_brands) as market_leaders from fact_survey_responses ) P;

select current_brands ,count(*), 
count(*)*100/ sum( select count(*) from fact_survey_responses where Reasons_for_choosing_brands = 'Effectiveness') as num
from fact_survey_responses  group by 1


# question 4 a 
select P.marketing_channels, max(P.marketing_channels_leader) from
( select marketing_channels ,count(Marketing_channels) as marketing_channels_leader from fact_survey_responses ) P;

select P.marketing_channels
from ( select marketing_channels ,rank() over(order by count(*) desc ) as rnk 
 from fact_survey_responses group by 1 ) P
 where P.rnk =1;

# question 4 b 
select General_perception, consume_frequency ,marketing_channels from fact_survey_responses
group by 1;

# question 5 a
select Current_brands , Taste_experience as Rating_out_of_5
 from fact_survey_responses
group by 2 order by 2 desc;

# Question 5 b
select B.City ,A.Current_brands, A.Consume_frequency, 
 A.Reasons_preventing_trying, A.Price_range,
A.Marketing_channels, A.purchase_location
from Dim_repondents C inner join
fact_survey_responses A 
on A.Respondent_Id = C.Respondent_Id
inner join dim_cities B 
on C.city_Id = B.city_Id 
where consume_frequency = 'Rarely'
group by 1;

# question 6 a 
select current_brands , Purchase_location , count(*) from fact_survey_responses 
group by 2;

# question 6 b
select D.age,A.Consume_reason ,count(*) as total from fact_survey_responses A
inner join dim_repondents D on D.respondent_Id = A.respondent_id 
 group by 1 order by count(*) desc;
 
 # question 6 c 
 select L.current_brands ,L.price_range,L.num  
 from (select current_brands ,price_range ,count(*) as num from fact_survey_responses group by 2 order by count(*) desc)L ;

 
 # question 7 a 
 select current_brands,taste_experience,Consume_reason,purchase_location from fact_survey_responses 
 group by 1
 