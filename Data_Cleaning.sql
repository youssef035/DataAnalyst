select * from housing

--standarize date format

select saledateV2, convert(date,saledate)
from housing

update housing 
set saledate=convert(date,saledate)

alter table housing 
add saledateV2 date;

update housing 
set saledateV2=convert(date,saledate)

--property address data 

select propertyaddress 
from housing 
where propertyaddress is null

select a.parcelid, a.propertyaddress, b.parcelID, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from housing A
join housing B 
on A.parcelID=B.parcelID
and A.[uniqueID] <> B.[uniqueID]
where a.propertyaddress is null

update A
set propertyaddress=isnull(a.propertyaddress, b.propertyaddress)
from housing A
join housing B 
on A.parcelID=B.parcelID
and A.[uniqueID] <> B.[uniqueID]
where a.propertyaddress is null

--breaking out adress into individual columns 'city, state, adress'

select propertyaddress from housing 
--order by parcelid

select substring(propertyaddress, 1,CHARINDEX(',', propertyaddress)-1) as adress
 ,substring(propertyaddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress)) as city
from housing


alter table housing 
add adress nvarchar(255);

update housing 
set adress=substring(propertyaddress, 1,CHARINDEX(',', propertyaddress)-1)

alter table housing 
add city nvarchar(255);

update housing 
set city=substring(propertyaddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress))

select owneraddress from housing

select 
PARSENAME(replace(owneraddress, ',', '.'), 3) as O_state
,PARSENAME(replace(owneraddress, ',', '.'), 2) as O_city
,PARSENAME(replace(owneraddress, ',', '.'), 1) as O_address
from housing

alter table housing 
add O_state nvarchar(255),
O_city nvarchar(255),
O_address nvarchar(255);


update housing
set O_state=PARSENAME(replace(owneraddress, ',', '.'), 3),
O_city=PARSENAME(replace(owneraddress, ',', '.'), 2),
O_address=PARSENAME(replace(owneraddress, ',', '.'), 1);


--change Y and N to yes and no in soldasVacant column

select distinct(soldasvacant), count(soldasvacant) as coun_t
from housing
group by SoldAsVacant
order by 2


select soldasvacant 
,CASE when soldasvacant='y' then 'YES'
when soldasvacant='n' then 'NO'
else soldasvacant
end  
from housing 

update housing 
set soldasvacant=CASE when soldasvacant='y' then 'YES'
when soldasvacant='n' then 'NO'
else soldasvacant
end  


--Remove Duplicates

 
 SELECT DISTINCT *
INTO #TempTable
FROM housing;

DELETE FROM housing;

INSERT INTO housing
SELECT *
FROM #TempTable;

DROP TABLE #TempTable;

select * from housing


--Delete unused columns
 

alter table housing
DROP column propertyaddress, owneraddress, taxdistrict;

