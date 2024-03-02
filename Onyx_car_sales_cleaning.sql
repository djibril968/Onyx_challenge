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



SELECT *
FROM Car_Sales

SELECT DISTINCT [name]
FROM Car_Sales
where  [name] LIKE '%!!!%'