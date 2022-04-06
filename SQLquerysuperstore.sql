--GLOBALSUPER STORE FILE
--WHAT IS DATA COUNT IN ORDERS TABLE---------------------------------------------------------------------------------------------

select * from Portfolioproject..Orders$
SELECT COUNT (*) FROM Portfolioproject..Orders$
select * from Portfolioproject..Orders$ ORDER BY 1

-- 1) WE GONNA SEE INDIVIDUAL COLUMN. FIRST WE CHECK ORDER id IS PRIMARY KEY OR NOT
SELECT [Order ID]
--, count(*)
from Portfolioproject..Orders$ 
--group by  [Order ID]
--having count(*)>1
 --by using order by we will get all data in sequence  and by count we got the count of each Id (how many times)
 --Also having count(*)>1 is used tto get data more then one

SELECT [Order ID]
, count(*)
from Portfolioproject..Orders$ 
group by  [Order ID]
having count(*)>1

--2) To get one id--------------------------------------------------------------------------

select * from Portfolioproject..Orders$ where [Order ID]= 'ES-2014-2397033'
--3)To check both RowId and Order ID are primery key------------------------------------------
SELECT [Order ID], [Row Id]
, count(*)
from Portfolioproject..Orders$ 
group by  [Order ID],[Row Id]
having count(*)>1

select * from Portfolioproject..Orders$ where  [Ship Date]< [Order Date]

----------4)how many different shipmodes are present in the table------------------------------------------
Select Distinct[Ship Mode] from Portfolioproject..Orders$ 
order by 1

--5) using DATEDIFF function to konw the number of days between the order date and ship date-----------------------
select DATEDIFF (DAY, [Order Date], [Ship Date]) as numberofdays, *
from Portfolioproject..Orders$ where  [Ship Mode]= 'Second Class'

--6)To get min and max of days--------------------------------------------------------------

select min(a.numberofdays) min, max(a.numberofdays) max from
(
select DATEDIFF (DAY, [Order Date], [Ship Date]) as numberofdays, 
* from Portfolioproject..Orders$ 
where  [Ship Mode]= 'Second Class')  a

--7) can customers order multiple orders-----------------------------------------------------------------------------------------------------------------
SELECT [Order ID], [Customer ID] 
, count(*)
from Portfolioproject..Orders$ 
group by  [Order ID],[Customer ID]
having count(*)>1

select * from Portfolioproject..Orders$
----------------------------------------------------------8) Standardize date format-----------------------------------------------------------------------------------

--Remove time frm the Order date and Ship date  section

select [Ship Date] from Portfolioproject..Orders$

Alter table Portfolioproject..Orders$
add NewShipdate date;

select* from Portfolioproject..Orders$
update Portfolioproject..Orders$
set NewShipdate = Convert(date, [SHip Date]) 

--same with the Order date
Alter table Portfolioproject..Orders$
add NewOrderdate date;

select* from Portfolioproject..Orders$
update Portfolioproject..Orders$
set NewOrderdate = Convert(date, [Order Date]) 


Select NewOrderdate, Convert(date, [Order Date]) 
from Portfolioproject..Orders$

------------------------------------------------------------------9)Breaking out 1 column into  two columns-----------------------------------------------
select* from Portfolioproject..Orders$

select [Product Name] from  Portfolioproject..Orders$

select 
PARSENAME(replace([Product Name], ',', '.'),2)ProductName,
PARSENAME(replace([Product Name],',','.'),1)ProductFeature
 from Portfolioproject..Orders$
 
 ----------------------------10)Add these two columns into the table---------------------------------------
 alter table Portfolioproject..Orders$
 add ProductName varchar(255)
 update Portfolioproject..Orders$
set ProductName=PARSENAME(replace([Product Name], ',', '.'),2)
 ------------------------------11)New column  ProductName is now created in the table----------------------------------------------- same process for second column
  alter table Portfolioproject..Orders$
 add ProductFeature varchar(255)
 update Portfolioproject..Orders$
set ProductFeature=PARSENAME(replace([Product Name],',','.'),1)

select* from Portfolioproject..Orders$



--------------------------------------------12)Use of case statement--------------------------------------------
Select [Order Priority],
Case when [Order Priority]='Medium' then 'M'
when [Order Priority]='High' then 'H'
when [Order Priority]='Low' then 'L'
else 'C'
end 
from Portfolioproject..Orders$

alter table Portfolioproject..Orders$
 add OrderPriority varchar(255)
 update Portfolioproject..Orders$
set [Order Priority]=Case when [Order Priority]='Medium' then 'M'
when [Order Priority]='High' then 'H'
when [Order Priority]='Low' then 'L'
else 'C'



end 



--------------------------------------13)To delete columns from the table-----------------------------------------------------------------------------
select * from Portfolioproject..Orders$
ALTER TABLE Portfolioproject..Orders$
DROP COLUMN [Ship Date], [Order Date], [OrderPriority]
















