-- First explore every thing
SELECT TOP 10 *
FROM NashvileHousing

-- Looking at SaleDate column
SELECT SaleDate
FROM NashvileHousing

-- Get rid of the time at end of the date

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvileHousing

-- Now it is nonly Date

UPDATE NashvileHousing
SET SaleDate = CONVERT(Date, SaleDate)

SELECT SaleDate
FROM NashvileHousing

-- It wasn't converted, So I'll use ALTER

ALTER TABLE NashvileHousing
ADD SaleDateNew Date;

UPDATE NashvileHousing
SET SaleDateNew = CONVERT(Date, SaleDate)

SELECT SaleDateNew
FROM NashvileHousing
--It worked as required
--Now exploring PropertyAddress column
SELECT PropertyAddress
FROM NashvileHousing

SELECT *
FROM NashvileHousing
WHERE PropertyAddress IS NULL

SELECT PropertyAddress, ParcelID
FROM NashvileHousing
-- notice that when ever property address is repeated, parcel id is repeated as well
-- so, the two columns are related
SELECT *
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
 
SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE b.PropertyAddress IS NULL

-- OK, this can be very useful if I populated the property address ids that 
-- are missing from this Joint

SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress, b.PropertyAddress) AS new_address
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Lets fill the missing values 
UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Check if it was done correctly
SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- No NULL values are present
SELECT a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID
FROM NashvileHousing a JOIN NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
-- The updating process was done correctly

-- Discovering Address Column after filling missing values

SELECT PropertyAddress
FROM NashvileHousing
-- It is divided into Adress, city, state

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address
FROM NashvileHousing

SELECT
	PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address2
FROM NashvileHousing

ALTER TABLE NashvileHousing
ADD PropertyAdressSplit Nvarchar(255)

UPDATE NashvileHousing
SET PropertyAdressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvileHousing
ADD PropertyCity Nvarchar(255)

UPDATE NashvileHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM NashvileHousing

-- Splitting owner address
SELECT OwnerAddress
FROM NashvileHousing

SELECT 
	OwnerAddress,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address
FROM NashvileHousing

ALTER TABLE NashvileHousing
ADD OwnerSplitAdress Nvarchar(255)

UPDATE NashvileHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvileHousing
ADD OwnerCity Nvarchar(255)

UPDATE NashvileHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvileHousing
ADD OwnerState Nvarchar(255)

UPDATE NashvileHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Ensuring all previous done properly

SELECT 
	PropertyAddress,
	PropertyAdressSplit,
	PropertyCity,
	OwnerAddress,
	OwnerSplitAdress,
	OwnerCity,
	OwnerState
FROM NashvileHousing

-- The splitting was done in correct and clean manner
