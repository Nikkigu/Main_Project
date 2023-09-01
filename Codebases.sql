show databases;
use project_aug;
 
select * from dim_cities;
select * from dim_repondents;
select * from fact_survey_responses 


## a.	Who prefers energy drink more
select count(Gender) from dim_repondents 
where gender = 'male';

# b.	Which age group prefers energy drinks more
 select b.age , b.num from (select  count(*) as num , age  from dim_repondents 
  group by age)b
  where b.num = (select max(a.num) from (select  count(*) as num , age  from dim_repondents 
  group by age) as a);

 # b.What are the typical consumption situations for energy drinks among respondents? 
 select D.age ,B.Typical_Consumption_Situations,count(*) as Total
from Dim_repondents D inner join 
fact_survey_responses B 
on D.Respondent_ID = B.Respondent_ID
group by 1,2;
  
  # b.	Which age group prefers energy drinks more by windows function
select b.age , b.num,rank() over(order by b.num desc) as dup
 from (select  count(*) as num , age  from dim_repondents 
  group by age)b  ;
  
  
# # marketing reaches the most Youth (15-30)
select D.age ,B.Marketing_channels,count(*) as Total
from Dim_repondents D inner join 
fact_survey_responses B 
on D.Respondent_ID = B.Respondent_ID
group by 1,2;
  
  
  # # a.	What are the preferred ingredients of energy drinks among respondents
  select a.Ingredients_expected ,a.Num_of_consumption ,consume_reason 
  from (select Ingredients_expected ,count(Ingredients_expected) as Num_of_consumption , consume_reason from fact_survey_responses
  group by 1 order by 2 desc)a;
  
  # # b.	What packaging preferences do respondents have for energy drinks
  select Packaging_preference, count(*) as num from fact_survey_responses
  group by 1 order by num desc;
   
   # question 3 a 
 # select current_brands ,max(P.market_leaders) 
 # from( select *,count(current_brands) as market_leaders from fact_survey_responses ) P;
 
#a.	Who are the current market leaders
select P.current_brands ,P.market_leaders
from( select Current_brands,count(current_brands) as market_leaders,rank() over(order by count(current_brands) desc) as rnk
from fact_survey_responses group by 1 ) P;
  
  
 #b.	What are the primary reasons consumers prefer those brands over ours
select P.current_brands ,P.market_leaders ,P.Reasons_for_choosing_brands
from( select current_brands, Reasons_for_choosing_brands,count(*) as market_leaders
 from fact_survey_responses group by 1,2 order by count(*) desc ) P;

# b.	What are the primary reasons consumers prefer those brands over ours
select P.marketing_channels
from ( select marketing_channels ,rank() over(order by count(*) desc ) as rnk 
 from fact_survey_responses group by 1 ) P
 where P.rnk =1;

select P.marketing_channels , D.age ,P.num
from ( select marketing_channels, Respondent_Id ,count(*) as num ,rank() over(order by count(*) desc ) as rnk 
 from fact_survey_responses group by 1 ) P
inner join dim_repondents D
on D.Respondent_Id = P.Respondent_Id;

# b.	How effective are different marketing strategies and channels in reaching our customers
select General_perception, consume_frequency ,marketing_channels , count(*) from fact_survey_responses
group by 3 order by count(*) desc;

# a.	What do people think about our brand? (overall rating) 
select avg(Taste_experience) as Rating
 from fact_survey_responses;

# b.	Which cities do we need to focus more on
select B.City ,A.Brand_perception
from Dim_repondents C inner join
fact_survey_responses A 
on A.Respondent_Id = C.Respondent_Id
inner join dim_cities B 
on C.city_Id = B.city_Id 
group by 1 , 2;

# b.	Which cities do we need to focus more on 
select current_brands , Purchase_location , count(*) from fact_survey_responses 
group by 2;

# b.	What are the typical consumption situations for energy drinks among respondents
select D.age,A.Consume_reason ,count(*) as total from fact_survey_responses A
inner join dim_repondents D on D.respondent_Id = A.respondent_id 
 group by 1 order by count(*) desc;
 
 # c.	What factors influence respondents' purchase decisions, such as price range and limited edition packaging
 select L.current_brands ,L.price_range,L.num  
 from (select current_brands ,price_range ,count(*) as num from fact_survey_responses group by 2 order by count(*) desc)L ;

# Metrix
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


 
