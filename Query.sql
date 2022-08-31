use fnup_sql_project;
select * from superstore;
############################################################################################################################################
#1.Questions for SQL Project ● Which is the most loss making category in the East region?
SELECT Category
FROM 
(SELECT Category,SUM(Profit),
RANK() OVER(ORDER BY SUM(Profit)) as LOSS_CATEGORY_FROM_EAST
FROM superstore
WHERE Profit < 0 AND Region ='East'
GROUP BY Category) AS superstore1
where LOSS_CATEGORY_FROM_EAST = 1;
############################################################################################################################################
#2.Questions for SQL Project ● Give me the top 3 product ids by most returns? 
SELECT `Product ID`
FROM(SELECT `Product ID`,COUNT(`returns`.`ï»¿Returned`),
RANK() OVER(ORDER BY COUNT(`returns`.`ï»¿Returned`) DESC,`Product ID` DESC) AS ProductId_Window 
FROM `returns` join superstore on `superstore`.`Order ID`=`returns`.`Order ID` 
GROUP BY `Product ID`) AS ProductID
WHERE ProductId_Window<=3;
############################################################################################################################################
#3.Questions for SQL Project  ● In which city the most number of returns are being recorded?
SELECT City,City_Returns
FROM
(SELECT`location`.`city`,COUNT(`returns`.`ï»¿Returned`) AS City_Returns
,RANK() OVER(ORDER BY COUNT(`returns`.`ï»¿Returned`) DESC) AS City_Window
FROM `location`
JOIN `superstore`
ON `location`.`Postal Code` = `superstore`.`Postal Code`
JOIN `returns` 
ON `superstore`.`Order ID` = `returns`.`Order ID`
GROUP BY `location`.`city`) AS CITY
WHERE City_Window = 1;
############################################################################################################################################
#4.Questions for SQL Project  ●  Find the relationship between days between order date , ship date and profit? 
SELECT DIFFERANCE,SUM(`Profit`) AS PROFIT
FROM
(
SELECT (`Ship Date`-`Order Date`) AS DIFFERANCE,`Profit`
FROM superstore
) AS RELN
GROUP BY DIFFERANCE;
############################################################################################################################################
#5.Questions for SQL Project  ●   Find the region wise profits for all the regions and give the output of the most profitable region
SELECT Region,SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC;
SELECT Region,SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC
LIMIT 1;
############################################################################################################################################
#6.Questions for SQL Project  ● Which month observe the highest number of orders placed and return placed for each year?
SELECT YEAR,MONTH,COUNT(`Order ID`) AS Order_Placed
FROM(SELECT YEAR(`Order Date`) AS YEAR,MONTH(`Order Date`) AS MONTH,`Order ID`
FROM superstore) AS s1
GROUP BY YEAR,MONTH
ORDER BY Order_Placed DESC
LIMIT 1;
SELECT Year,COUNT(`returns`.`ï»¿Returned`) AS RETURN_PLACED
FROM(
SELECT Year(`superstore`.`Order Date`) AS Year,`superstore`.`Order ID`
from superstore
) AS superstore
JOIN `returns`
on `superstore`.`Order ID` = `returns`.`Order ID`
group by Year
ORDER BY RETURN_PLACED desc
LIMIT 1;
############################################################################################################################################
#7.Questions for SQL Project ● Calculate percentage change in sales for the entire dataset? X axis should be year_month Y axis percent change Find out if any sales pattern exists for all the region?
SELECT Year,Month,Total_Sales,Compare,Round(Percentage) AS Percentage
FROM(
SELECT Year,Month,Total_Sales,Compare,100*(Total_Sales-Compare)/Compare AS Percentage
FROM(
SELECT Year,Month,Total_Sales,lag(Total_Sales) over() AS Compare
FROM(
SELECT Year(`Order Date`) AS Year,Month(`Order Date`) AS Month,ROUND(SUM(`Sales`))as Total_Sales
FROM fnup_sql_project.superstore
GROUP BY Year,Month
ORDER BY Year,Month
)AS superstore1
)AS superstore2
)AS superstore3;
############################################################################################################################################
#8.Questions for SQL Project  ● Top and bottom selling product for each region 
select *
from(select `Product Name`,Region,W2,Rank()Over(Partition By Region Order By W2 DESC) As W1
from(select `Product Name`,Region,sum(Quantity)AS W2
from superstore group by `Product Name`,Region Order By Region)AS t1 )AS t2
where W1=1
UNION
select *
from(select `Product Name`,Region,W2,Rank()Over(Partition By Region Order By W2 ASC) As W1
from(select `Product Name`,Region,sum(Quantity)AS W2
from superstore group by `Product Name`,Region Order By Region)AS t1 )AS t2
where W1=1;
############################################################################################################################################
#9.Questions for SQL Project  ● Why are returns initiated? Are there any specific characteristics for all the returns? Hint: Find return across all categories to observe any pattern 
SELECT `category`,`sub-category`,`product id`,`region`,SUM(`ï»¿Returned`),
RANK() OVER(PARTITION BY `region`,`category`,`sub-category` ORDER BY SUM(`ï»¿Returned`)) as pattern
FROM `returns` LEFT JOIN `superstore` ON `returns`.`order id` = `superstore`.`order id`
GROUP BY `region`,`category`,`sub-category`
ORDER BY sum(`ï»¿Returned`);
##############################################################################################################################################################
#10.Questions for SQL Project  ● Create a table having two columns ( date and sales), Date should start with the min date of data and end at max date - in between we need all the dates If date is available show sales for that date else show date and NA as sale
create table fnup_sql_project.sales_date(`Day` datetime,`Sales` double);
insert into fnup_sql_project.sales_date(`Day` ,`Sales`)
select cast(`Order Date` as date),`Sales` from fnup_sql_project.superstore group by `Order Date`,`Sales` 
order by `Order Date`;



############################################################################################################################################
select `Product Name`,region,Sum(Quantity) over(partition by region,`Product Name`) from superstore group by region order by region;

############################################################################################################################################
select `Product name`,region,Quantity
,Rank()
over(partition by region order by Quantity ASC) as SUM_Quantity
from superstore
group by region
order by Quantity ASC;
#############################################################################################################################################
select *
from (select `Product Name`,Region,`Quantity`,
Rank() Over(Partition BY Region Order By `Quantity`)AS Product_By_Category 
from(select `Product Name`,Region,SUM(`Quantity`)AS Quantity_Product_By_Category
from superstore 
group by `Product Name`,Region,`Quantity`
Order By Quantity)AS superstore1)AS superstore2
where Quantity_Product_By_Category=1;
##############################################################################################################################################
select `Product Name`,Region,Sum(Quantity),Rank() Over(Partition By Region,`Product Name`order by Sum(Quantity)) AS Window_fn  from superstore
group by `Product Name`,Region Order By Sum(Quantity) DESC,Region,`Product Name`;











































































































