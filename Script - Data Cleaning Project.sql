
-- Cleaning Data in SQL

SELECT *
FROM PortfolioProject..NashvilleHousingData


-- Standardise Date Format

ALTER TABLE NashvilleHousingData
ADD SaleDateConverted Date

UPDATE NashvilleHousingData
SET SaleDateConverted = CONVERT(date, SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousingData


-- Populate Property Address Data

SELECT *
FROM PortfolioProject..NashvilleHousingData
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..NashvilleHousingData A
JOIN PortfolioProject..NashvilleHousingData B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..NashvilleHousingData A
JOIN PortfolioProject..NashvilleHousingData B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress IS NULL


-- Breaking Address Into Columns (Address, City, State)

-- For Property Address
SELECT *
FROM PortfolioProject..NashvilleHousingData
-- WHERE PropertyAddress IS NULL
-- ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX('"', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX('"', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM PortfolioProject..NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD PropertySplitAddress NVARCHAR(255);

ALTER TABLE NashvilleHousingData
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX('"', PropertyAddress)-1)

UPDATE NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX('"', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousingData


-- For Owner Address

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, '"', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, '"', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, '"', '.'), 1)
FROM PortfolioProject..NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD OwnerSplitAddress NVARCHAR(255);

ALTER TABLE NashvilleHousingData
ADD OwnerSplitCity NVARCHAR(255);

ALTER TABLE NashvilleHousingData
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, '"', '.'), 3)

UPDATE NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, '"', '.'), 2)

UPDATE NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, '"', '.'), 1)

SELECT *
FROM PortfolioProject..NashvilleHousingData


-- Change 1 and 0 to Yes and No in Sold as Vacant 

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 1 THEN 'Yes'
	WHEN SoldAsVacant = 0 THEN 'No'
END AS SoldAsVacantText
FROM PortfolioProject..NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD SoldAsVacantText NVARCHAR(255);

UPDATE NashvilleHousingData
SET SoldAsVacantText = CASE 
	WHEN SoldAsVacant = 1 THEN 'Yes'
	WHEN SoldAsVacant = 0 THEN 'No'
END


-- Remove Duplicates

WITH ROWNUMCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
				) AS RowNum
FROM PortfolioProject..NashvilleHousingData
)

-- SELECT *
-- FROM ROWNUMCTE
-- WHERE RowNum > 1
-- ORDER BY PropertyAddress

DELETE
FROM ROWNUMCTE
WHERE RowNum > 1
-- ORDER BY PropertyAddress


--- Remove Unused Columns

SELECT *
FROM PortfolioProject..NashvilleHousingData

ALTER TABLE NashvilleHousingData
DROP COLUMN PropertyAddress, SoldAsVacant, OwnerAddress, TaxDistrict, SaleDate