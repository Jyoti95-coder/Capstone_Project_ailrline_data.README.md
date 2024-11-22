use project_2;

select * from airline_data;

# 1.How many records are there in airline_data
select count(*) from airline_data;
select count(distinct Id) as Total_No_Passengers from airline_data;

# 2.How many distinct customer type data is there?
select distinct customer_type from airline_data;

# 3.How many distinct type of travel data is present?
select distinct type_of_travel from airline_data;

# 4.How many distinct customer class data is present?
select distinct customer_class from airline_data;

# 5.How many passengers are travelling from business class?  (where clause)
select count(Id) as No_of_passenger from airline_data
where customer_class = 'Business';

# 6.How many male passengers are travelling from each class? (group by)
select count(Id) as male_count,Gender,type_of_travel from airline_data
group by type_of_travel,Gender
having Gender = 'Male';

# 7.Rename the column 
alter table airline_data
rename column MyUnknownColumn to Id;

# 8.How many male and female are from each class?   
select count(Id) as No_of_passengers,Gender,customer_class from airline_data
group by customer_class,Gender
order by customer_class ;

# 9.How many male and female are travelling from each class? 
select count(Id) as No_of_passengers,Gender,type_of_travel from airline_data
group by type_of_travel,Gender
order by Gender ;

/* 10.Give the average service rating to each passenger based on cleanliness,seat comfort,food and 
drink,baggage handling ,inflight service and inflight entertainment? (Using CTE) */

with XYZ as
(select Id,Gender,round((`cleanliness` + `seat_comfort` + `food_and_drink` + `baggage_handling`
  +`inflight_service` + `inflight_entertainment`)/6,2) as Average_Service_Rating from airline_data)
select * from XYZ;


# 11.Window function 
#Assign rank to the male passengers based on their average service rating.

with ABC as
(
with XYZ as
      (
       select Id,Gender,round((`cleanliness` + `seat_comfort` + `food_and_drink` + `baggage_handling`
	    +`inflight_service` + `inflight_entertainment`)/6,2) as Average_Service_Rating from airline_data
	  )
	   select *, Row_number() over (partition by Gender order by Average_Service_Rating desc) as Ranks from XYZ
       
)
       select * from ABC
       where Gender = 'Male';

# 12.Assign rank to the Business class female passengers based on their average service rating.

with ABC as
(
with XYZ as
      (
       select Id,customer_class,Gender,round((`cleanliness` + `seat_comfort` + `food_and_drink` + `baggage_handling`
	    +`inflight_service` + `inflight_entertainment`)/6,2) as Average_Service_Rating from airline_data
	  )
	   select *, Row_number() over (partition by customer_class,Gender order by Average_Service_Rating desc) as Ranks from XYZ
       
)
       select * from ABC
       where customer_class = 'Business' and Gender = 'Female';
       
# 13.Get first 5 male and  5 female passengers based on their average service rating.     
 
 
 with ABC as
(
 with XYZ as
      (
       select Id,Gender,round((`cleanliness` + `seat_comfort` + `food_and_drink` + `baggage_handling`
	    +`inflight_service` + `inflight_entertainment`)/6,2) as Average_Service_Rating from airline_data
	  )
	   select *, Row_number() over (partition by Gender order by Average_Service_Rating desc) as Ranks from XYZ
       
)
       select * from ABC
       where Ranks<=5;
       
# 14.Get number of female passengers whose average service rating is 5.  
       
   
  with XYZ as
      (
       select Id,Gender,round((`cleanliness` + `seat_comfort` + `food_and_drink` + `baggage_handling`
	    +`inflight_service` + `inflight_entertainment`)/6,2) as Average_Service_Rating from airline_data
	  )
	   select Average_Service_Rating,count(Gender) as Male_Count from XYZ
       where Average_Service_Rating = 5 and Gender = 'Female';

# 15.Get the number of male and female satisfied and dissatisfied passenger in airline data

select count(distinct Id) as Count,satisfaction,Gender from airline_data
group by satisfaction,Gender;


select count(*) from airline_data;