USE Onyx_Portfolio


*/
----Data Cleaning

/*
Cleaning process

anormalies detected

			clean column name
			split datetime column
			check nulls
			column by column cleaning
			check duplicates
*/
EXEC SP_RENAME 'Car_Sales.[dateCrawled]', 'Date_Listed', 'COLUMN';
EXEC SP_RENAME 'Car_sales.[name]', 'Car_name', 'COLUMN';
EXEC SP_RENAME 'Car_sales.seller', 'Seller_cat', 'COLUMN';
EXEC SP_RENAME 'Car_sales.offertype', 'Offer_type', 'COLUMN';
EXEC SP_RENAME 'Car_sales.Price', 'Price($)', 'COLUMN';
EXEC SP_RENAME 'Car_sales.vehicleType', 'Vehicle_type', 'COLUMN';
EXEC SP_RENAME 'Car_sales.yearOfRegistration', 'Reg_year', 'COLUMN';
EXEC SP_RENAME 'Car_sales.gearbox', 'Gearbox', 'COLUMN';
EXEC SP_RENAME 'Car_sales.powerPS', 'PowerPS', 'COLUMN';
EXEC SP_RENAME 'Car_sales.model', 'Model', 'COLUMN';
EXEC SP_RENAME 'Car_sales.kilometer', 'Mileage(Km)', 'COLUMN';
EXEC SP_RENAME 'Car_sales.monthOfRegistration', 'Reg_month', 'COLUMN';
EXEC SP_RENAME 'Car_sales.fuelType', 'Fuel_type', 'COLUMN';
EXEC SP_RENAME 'Car_sales.brand', 'Brand', 'COLUMN';
EXEC SP_RENAME 'Car_sales.postalCode', 'Postal_code', 'COLUMN';
EXEC SP_RENAME 'Car_sales.Lattitude', 'Latitude', 'COLUMN';
EXEC SP_RENAME 'Car_sales.lastSeen', 'Last_seen', 'COLUMN';



---- cleaning columns

SELECT * 
FROM Car_Sales
where  Car_name LIKE '%!!!%'

SELECT Car_name, REPLACE(Car_name, '!', '') AS new_car
FROM Car_Sales
where  Car_name LIKE '%!!!%'

SELECT Car_name, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Car_name, '"', ''), '#', ''), '$', ''), '%', ''), '*','') AS new_car
FROM Car_Sales
---where  Car_name LIKE '%!!!%'


UPDATE Car_Sales
SET Car_name = REPLACE(Car_name, '!', '')

UPDATE Car_Sales
SET Car_name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Car_name, '"', ''), '#', ''), '$', ''), '%', ''), '*','')

SELECT Car_name, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Car_name, '"', ''), '#', ''), '$', ''), '%', ''), '*','') AS new_car
FROM Car_Sales
WHERE Car_name IS NOT NULL
ORDER BY 1

SELECT Car_name, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Car_name, '&', ''), '.', ''), '/', ''), '?', ''), 
					'______',''), ':',''), '___>_', ''), '_', ''), '>', '') AS new_car
FROM Car_Sales
WHERE Car_name IS NOT NULL
ORDER BY 1						

UPDATE Car_sales
SET Car_name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Car_name, '&', ''), '.', ''), '/', ''), '?', ''), 
					'______',''), ':',''), '___>_', ''), '_', ''), '>', '')

SELECT car_name, TRANSLATE(car_name, '/>___>_"#$%.?:!', '')
FROM car_sales
WHERE Car_name IS NOT NULL
ORDER BY 1


SELECT Car_name, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(car_name, '[', ''), '+', ''), ']', ''), '^^', ''), '|', ''), '<', '')
						,'~','' ), '\', ''), '=', ''), '»', ''), '«', '')
FROM Car_Sales
WHERE Car_name IS NOT NULL
ORDER BY 1

UPDATE Car_sales
SET Car_name =REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(car_name, '[', ''), '+', ''), ']', ''), '^^', ''), '|', ''), '<', '')
						,'~','' ), '\', ''), '=', ''), '»', ''), '«', '')

SELECT car_name, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(car_name, '×', ''), '¥', ''), '°', ''), '•', ''), '€', '')
FROM car_sales
WHERE Car_name IS NOT NULL
ORDER BY 1

UPDATE Car_sales
SET Car_name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(car_name, '×', ''), '¥', ''), '°', ''), '•', ''), '€', '')

01788055184
		

---seller cat column
SELECT DISTINCT seller_cat, CASE WHEN Seller_cat = 'gewerblich' THEN 'Commercial'
								WHEN Seller_cat = 'privat' THEN 'Private'
								END AS seller_catt
FROM Car_Sales
order by 1

UPDATE Car_sales
SET Seller_cat = CASE WHEN Seller_cat = 'gewerblich' THEN 'Commercial'
					WHEN Seller_cat = 'privat' THEN 'Private'
					END

---Offer type
UPDATE Car_Sales
SET Offer_type = CASE WHEN Offer_type = 'Gesuch' THEN 'request'
					WHEN Offer_type = 'Angebot' THEN 'offer'
					END

--- vehicle type

UPDATE Car_Sales
SET Vehicle_type = CASE 
					WHEN Vehicle_type = 'kleinwagen' THEN 'Small_car'
					WHEN Vehicle_type = 'cabrio' THEN 'Convertible'
					WHEN Vehicle_type = 'andere' THEN 'Other'
					WHEN Vehicle_type = 'bus' THEN 'Bus'
					WHEN Vehicle_type = 'coupe' THEN 'Coupe'
					WHEN Vehicle_type = 'kombi' THEN 'Combi'
					WHEN Vehicle_type = 'limousine' THEN 'Limousine'
					WHEN Vehicle_type = 'suv' THEN 'suv'
					END
---Gearbox
UPDATE Car_Sales 
SET Gearbox =	CASE 
					WHEN Gearbox = 'automatik' THEN 'Automatic'
					WHEN Gearbox = 'manuell' THEN 'Manual'
					END

---- fuel type
UPDATE Car_Sales 
SET fuel_type = CASE 
					WHEN fuel_type = 'benzin' THEN 'Petrol'
					WHEN Fuel_type = 'hybrid' THEN 'Hybrid'
					WHEN Fuel_type = 'cng' THEN 'CNG'
					WHEN Fuel_type = 'andere' THEN 'Other'
					WHEN Fuel_type = 'diesel' THEN 'Diesel'
					WHEN Fuel_type = 'elektro' THEN 'Electric'
					WHEN Fuel_type = 'lpg' THEN 'LPG'
					END 

----Removing duplicates

		with car_dup 
		AS
			(
				SELECT *, 
				ROW_NUMBER() OVER(PARTITION BY Date_listed, Car_name, Price, gearbox, PowerPs, [Mileage(km)] ORDER BY Date_listed) AS rank_
				FROM Car_Sales
			)
				SELECT Date_listed, Car_name, Price, gearbox, PowerPs, [Mileage(Km)],  Rank_
				FROM car_dup
				WHERE rank_ >1
				ORDER BY 1, 2, 4

			DELETE 
			FROM Car_sales
			WHERE Car_name IN
					(SELECT Car_name
					FROM(
						SELECT *,
						ROW_NUMBER() OVER(PARTITION BY Date_listed, Car_name, Price, gearbox, PowerPs, [Mileage(km)] ORDER BY Date_listed) AS rank_
						FROM Car_Sales
						) d
					WHERE d.rank_ >1
				)

----droping irrelevant columns
ALTER TABLE Car_sales
DROP COLUMN  notRepairedDamage, nrOfPictures, DateCreated



/*
Going by the fact that car_names provided does not accurately describe the cars, I coined the proper correct car_names using the concat of Brand and model
*/

SELECT Car_name, Brand, Model, CONCAT(brand, '_', Model)
FROM Car_Sales
ORDER BY 1

ALTER TABLE Car_sales
ADD Car_nname VARCHAR (50)

UPDATE Car_sales
SET car_nname = CONCAT(brand, '_', Model)


SELECT DISTINCT *
FROM Car_sales

SELECT DISTINCT Brand
FROM Car_sales
ORDER BY 1


SELECT Car_name, Brand, Model, Car_nname
FROM Car_Sales
----WHERE Brand = 'Alfa_romeo' AND Car_name LIKE '%147%'
WHERE  
ORDER BY 1

SELECT Car_name, Brand, Model, Car_nname
FROM Car_Sales
WHERE Brand = 'Alfa_romeo' AND Model IS NULL --- Car_name LIKE '%147%'
ORDER BY 1

SELECT Car_name, Brand, Model, 
						Car_nname, 
							CASE 
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%147%' THEN 147
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%156%' THEN 156
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%8700%' THEN 870
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%916%' THEN 916
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%145%' THEN 145
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%146%' THEN 146
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%164%' THEN 164
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%159%' THEN 159
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%162%' THEN 162
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%164%' THEN 164
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%166%' THEN 166
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%147%' THEN 147
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%900%' THEN 900
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%155%' THEN 155
								END AS Name_01
FROM Car_Sales
WHERE Brand = 'Alfa_romeo' AND model IS NULL
ORDER BY 1

SELECT Car_name, Brand, Model, 
						Car_nname, 
UPDATE Car_Sales
SET Model =						CASE 
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%20JT%' THEN '20JT'
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%GT%' THEN 'GTV18'
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%19%' THEN '19'
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%GTV3024%' THEN 'GTV3024'
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%GTV625%' THEN 'GTV625'
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%Schoene%' THEN 'Schoene'  
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%Verkaufe%' THEN 'Verkaufe'	
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%MITO%' THEN 'MITO'
								ELSE 'Other'
								END 
WHERE Brand = 'Alfa_romeo' AND model IS NULL


UPDATE Car_Sales
SET Model =
								CASE 
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%147%' THEN 147
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%156%' THEN 156
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%8700%' THEN 870
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%916%' THEN 916
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%145%' THEN 145
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%146%' THEN 146
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%164%' THEN 164
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%159%' THEN 159
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%162%' THEN 162
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%164%' THEN 164
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%166%' THEN 166
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%147%' THEN 147
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%900%' THEN 900
								WHEN Brand = 'Alfa_romeo' AND Car_name LIKE '%155%' THEN 155
								END 
WHERE Brand = 'Alfa_romeo' AND model IS NULL
ORDER BY 1


SELECT Car_name, Brand, Model, car_nname						
FROM Car_Sales
WHERE Brand = 'audi' AND model IS NULL
ORDER BY 1

SELECT * FROM Car_Sales
WHERE Model IS NULL
ORDER BY 2


