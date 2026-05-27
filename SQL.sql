
truncate Zomato;

Desc Zomato;
Alter table Zomato modify column `Datekey/Opening` date;

Select * from Zomato;

SHOW VARIABLES LIKE 'secure_file_priv';

#     C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\Zomato

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomato/Zomato.csv' into table Zomato
FIELDS TERMINATED by ','
optionally  enclosed by '"'
lines terminated by '\r\n'
IGNORE 1 rows;



# Zomato KPIs:


# Total no. of restaurants
Select count(restaurantname) as Total_Count_of_the_restaurants from zomato;
------------------------------------------------------------------------------------------------------------------------------------

# Total cities in operations
Select count(distinct(city)) as Total_Cities from zomato;
------------------------------------------------------------------------------------------------------------------------------------

# Average rated restaurant count
Select count(`Rating Category`) as Average_rated_count from zomato where `Rating Category`="Average";
------------------------------------------------------------------------------------------------------------------------------------

# Top 5 most reviewed restaurant
With CTE as (Select RestaurantName,dense_rank() over (order by votes desc) as Most_Reviewed_Restaurants from Zomato) select RestaurantName
from CTE where Most_Reviewed_Restaurants in (1,2,3,4,5);

# Or,
Select Restaurantname from zomato order by votes desc limit 5;

------------------------------------------------------------------------------------------------------------------------------------

# Total restaurants counts globally opened by year and months
Delimiter $$
Create procedure years(IN res_years int, IN res_months int,OUT rest_count int)
Begin
Select count(RestaurantName) into rest_count from Zomato where `Year Opening`=res_years and `Month Opening`=res_months;
End $$
Delimiter ;

call years('2012','10',@rest_count);
Select @rest_count as Restaurants_Count;
------------------------------------------------------------------------------------------------------------------------------------

# % of Online Delivery
Select Has_Online_delivery,round(100* count(*) / (select count(*) from zomato), 2)
as Percentage from zomato group by Has_Online_delivery;
------------------------------------------------------------------------------------------------------------------------------------

# % of Table Booking
Select Has_table_booking, round(100* count(*) / (select count(*) from zomato), 2)
as Percentage from zomato group by Has_table_booking;
------------------------------------------------------------------------------------------------------------------------------------