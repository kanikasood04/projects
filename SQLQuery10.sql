--cleaning data in sql queries

select * from Portfolioproject.dbo.NashvilleHousing


select SaleDate 
from Portfolioproject.dbo.NashvilleHousing
----------------------------------------------------------Standarize date format-----------------------------------------------------------------------------------

--Remove time frm the date section


Update Portfolioproject.dbo.NashvilleHousing 
set SaleDate= Convert(date, SaleDate) 
--It did not work so try with other method, here we will add column in table and try to convert it 

select * from Portfolioproject..[NashvilleHousing]
Alter table Portfolioproject..[NashvilleHousing]
add Newsaledate date;

update Portfolioproject..[NashvilleHousing]
set Newsaledate = Convert(date, SaleDate) 


Select Newsaledate, Convert(date, SaleDate) 
from Portfolioproject..[NashvilleHousing]

------------------------------------------------------------------populate property address
Select propertyAddress
from Portfolioproject..[NashvilleHousing]


Select *
from Portfolioproject..[NashvilleHousing] 
where propertyAddress is null
order by ParcelID
--we have populate the address by using isnull(a.propertyAddress,b.propertyAddress)
Select a.ParcelID,a.propertyAddress,b.ParcelID , b.propertyAddress,isnull(a.propertyAddress,b.propertyAddress)
from Portfolioproject..[NashvilleHousing] a
join Portfolioproject..[NashvilleHousing] b
on a.ParcelID= b.ParcelID
and a.UniqueID <> b.UniqueID
where a.propertyAddress is null
--now new column is added in the table that is showing property address instead of null velues so we will replace the existing propertyaddres 
--that is showing null values with the new column i.e. isnull(a.propertyAddress,b.propertyAddress)

update a
set propertyAddress=isnull(a.propertyAddress,b.propertyAddress)
from Portfolioproject..[NashvilleHousing] a
join Portfolioproject..[NashvilleHousing] b
on a.ParcelID= b.ParcelID
and a.UniqueID <> b.UniqueID

        -------------------------------nbreaking out address into individs (address, city, state)

Select propertyAddress
from Portfolioproject..[NashvilleHousing] 


Select SUBSTRING(propertyAddress,1,CHARINDEX(',', propertyAddress) )as address
CHARINDEX(',', propertyAddress)
--we have used CHARINDEX(',', propertyAddress) to get the position o the comma
from Portfolioproject..[NashvilleHousing] 


Select SUBSTRING(propertyAddress,1,CHARINDEX(',', propertyAddress) -1)as address,
SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(propertyAddress)) as address

from Portfolioproject..[NashvilleHousing] 

 Alter table Portfolioproject..[NashvilleHousing]
add  propertysplitAddress  varchar(255);
update Portfolioproject..[NashvilleHousing]
set propertysplitAddress =SUBSTRING(propertyAddress,1,CHARINDEX(',', propertyAddress) -1)

 Alter table Portfolioproject..[NashvilleHousing]
add  propertysplitcity  varchar(255);
update Portfolioproject..[NashvilleHousing]
set propertysplitcity=SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(propertyAddress))


select * from Portfolioproject..[NashvilleHousing]


--splitting owner address without using substring (instead we will use  parswname)
select OwnerAddress from Portfolioproject..[NashvilleHousing]

select 
PARSENAME(replace(OwnerAddress, ',', '.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from Portfolioproject..[NashvilleHousing]

--now alter table add new columns and add above queries in OwnersplitAddress

alter table Portfolioproject..[NashvilleHousing]
add OwnersplitAddress varchar(255)
update Portfolioproject..[NashvilleHousing]
set OwnersplitAddress=PARSENAME(replace(OwnerAddress, ',', '.'),3)
--now alter table add new columns and add above queries in Ownersplitcity
alter table Portfolioproject..[NashvilleHousing]
add Ownersplitcity varchar(255)
update Portfolioproject..[NashvilleHousing]
set Ownersplitcity=PARSENAME(replace(OwnerAddress,',','.'),2)

--now alter table add new columns and add above queries in Ownersplitprovince
alter table Portfolioproject..[NashvilleHousing]
add Ownersplitprovince varchar(255)
update Portfolioproject..[NashvilleHousing]
set Ownersplitprovince=PARSENAME(replace(OwnerAddress,',','.'),1)

Select * from  Portfolioproject..[NashvilleHousing]



--CHANGE Y AND N TO YES AND NO TO THE SOLDASVACANT COLUMN-------------------------------------------------------------------------------------------------
select Distinct(SoldAsVacant),
count(SoldAsVacant) as count
from Portfolioproject..[NashvilleHousing] 
 group by SoldAsVacant
 order by count

 select SoldAsVacant
 ,
 CASE when SoldAsVacant= 'Y' then 'Yes'
 when SoldAsVacant= 'N' then 'No'
 else  SoldAsVacant
 end
  from  Portfolioproject..[NashvilleHousing]

  update Portfolioproject..[NashvilleHousing] 
  set  SoldAsVacant=CASE when SoldAsVacant= 'Y' then 'Yes'
 when SoldAsVacant= 'N' then 'No'
 else  SoldAsVacant




 --------------------------------------------------------------------REMOVE DUPLICATES----------------------------------------------------------------------
 with RowNumCTE as(
 Select *,
ROW_NUMBER() over(
PARTITION BY ParcelId,
PropertyAddress,
SalePrice,
LegalReference 
order by
UniqueID
) row_num
from  Portfolioproject..[NashvilleHousing]
--order by Parcel
)
Select * from RowNumCTE
where row_num>1 order by PropertyAddress

select * from Portfolioproject..[NashvilleHousing] 


----------------------------------------------to delete-------------------------------------------------------------------------------------------------------- 
 with RowNumCTE as(
 Select *,
ROW_NUMBER() over(
PARTITION BY ParcelId,
PropertyAddress,
SalePrice,
LegalReference 
order by
UniqueID
) row_num
from  Portfolioproject..[NashvilleHousing]
--order by Parcel
)
delete 
from RowNumCTE
where row_num>1
--order by PropertyAddress



------------------------------------------DELETE UNUSED COLUMNS----------------------------------------------------------------------------------------


select * from Portfolioproject..[NashvilleHousing] 

ALTER TABLE Portfolioproject..[NashvilleHousing] 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolioproject..[NashvilleHousing] 
DROP COLUMN SaleDate




