#  OLA Data Analyst Project
 CREATE DATABASE Ride_Bookings;
 
 USE Ride_Bookings;


-- SQL Questions:
-- 1. Fetch all successfully completed bookings.
SELECT * FROM ride_bookings
WHERE booking_status = "Success";

-- Save the query or result in View:
Create View Successful_Bookings AS
SELECT * FROM ride_bookings
WHERE booking_status = "Success";

SELECT * FROM Successful_Bookings;

--  2. Determine the average ride distance for each vehicle type.
Create View Avg_Ride_Distance_for_each_vehicle AS
SELECT vehicle_type, avg(ride_distance) as avg_distance FROM ride_bookings
GROUP BY vehicle_type;

SELECT * FROM Avg_Ride_Distance_for_each_vehicle;

--  3. Get the total number of cancelled rides by customers.
Create View Canceled_Rides_by_Customers AS
SELECT COUNT(*) AS Canceled_by_Customer FROM ride_bookings
WHERE Booking_Status = "Canceled by Customer";
SELECT * FROM Canceled_Rides_by_Customers;


--  4. Find and list the top 5 customers who booked the highest number of rides.
Create View Top_5_Customer_by_Highest_Rides AS
SELECT Customer_ID, COUNT(Booking_ID) AS no_of_rides
FROM ride_bookings
GROUP BY Customer_ID
ORDER BY no_of_rides DESC Limit 5;

SELECT * FROM Top_5_Customer_by_Highest_Rides;

--  5. Determine the number of rides cancelled by drivers due to personal or vehicle issues.
CREATE VIEW Driver_Canceled_Rides_Personal_Vehicle_Issue AS
SELECT COUNT(*) FROM ride_bookings
WHERE Canceled_Rides_By_Driver = "Personal & Car related issue";

SELECT * FROM Driver_Canceled_Rides_Personal_Vehicle_Issue;

--  6. Find the maximum and minimum driver ratings for Prime Sedan bookings.
CREATE VIEW MAX_MIN_Prime_Sedan_Driver_Rating AS
SELECT MAX(Driver_Ratings), Min(Driver_Ratings) FROM ride_bookings
WHERE Vehicle_Type = "Prime Sedan";

SELECT * FROM MAX_MIN_Prime_Sedan_Driver_Rating;

--  7. Retrieve all rides where payment was made using UPI:
CREATE VIEW UPI_Rides AS
SELECT * FROM ride_bookings
WHERE Payment_Method = "UPI";

SELECT * FROM UPI_Rides;

--  8. Find the average customer rating per vehicle type:
CREATE VIEW Avg_Rating_Per_Vehicle AS
SELECT Vehicle_Type, AVG(Customer_Rating) AS AVG_Rating FROM ride_bookings
GROUP BY Vehicle_Type;

SELECT * FROM Avg_Rating_Per_Vehicle;

--  9. Calculate the total booking value of rides completed successfully:
CREATE VIEW Total_Successful_Booking_Value AS
SELECT SUM(Booking_Value) AS Total_Successful_Booking_Value FROM ride_bookings
WHERE Booking_Status = "Success";

SELECT * FROM Total_Successful_Booking_Value;


--  10. List all incomplete rides along with the reason:
CREATE VIEW Incomplete_Rides_Reason AS
SELECT Booking_ID, Incomplete_Rides_Reason FROM ride_bookings
WHERE Incomplete_Rides = "Yes";

SELECT * FROM Incomplete_Rides_Reason;

# 11. Determine the top 3 vehicle type with te highest average booking value:
CREATE VIEW Top3_Vehicle_by_Avg_Booking_Value AS
SELECT Vehicle_Type, AVG(Booking_Value) AS Avg_Booking_Value
FROM ride_bookings
GROUP BY Vehicle_Type
Order By Avg_Booking_Value DESC
LIMIT 3;

SELECT * FROM Top3_Vehicle_by_Avg_Booking_Value;

-- 12. Calculate the percentage of rides that were canceled by customers or drivers.
CREATE VIEW Cancel_Percentage AS
SELECT
	(SUM(CASE WHEN Booking_Status = "Canceled by Customer" THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Canceled_by_Customer_Percentage,
	(SUM(CASE WHEN Booking_Status = "Canceled by Driver" THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Canceled_by_Driver_Percentage
FROM ride_bookings;

SELECT * FROM Cancel_Percentage;

-- 12. Find the top 5 areas with the highest ride demand.
CREATE VIEW Top5_High_Ride_Demand_Area AS
SELECT Pickup_Location, COUNT(*) AS Ride_Count
FROM ride_bookings
GROUP BY Pickup_Location
ORDER BY Ride_Count DESC
LIMIT 5;

SELECT * FROM Top5_High_Ride_Demand_Area;

-- 13. Identify peak hours for bookings.
CREATE VIEW Peak_Hours AS
SELECT HOUR(Time) As Booking_Hour, COUNT(*) AS Total_Bookings
FROM ride_bookings
GROUP BY Booking_Hour
ORDER BY Booking_Hour DESC;

SELECT * FROM Peak_Hours;

-- 14. Find the correlation between booking value and ride distance.
CREATE VIEW Correlation_Booking_Value_Distance AS
SELECT 
    (SUM((Booking_Value - (SELECT AVG(Booking_Value) FROM ride_bookings)) *
         (Ride_Distance - (SELECT AVG(Ride_Distance) FROM ride_bookings))) /
     ((SELECT COUNT(*) FROM ride_bookings) - 1)) AS Covariance,
    (SELECT STD(Booking_Value) FROM ride_bookings) * 
    (SELECT STD(Ride_Distance) FROM ride_bookings) AS Std_Dev_Product,
    (SUM((Booking_Value - (SELECT AVG(Booking_Value) FROM ride_bookings)) *
         (Ride_Distance - (SELECT AVG(Ride_Distance) FROM ride_bookings))) /
     (((SELECT COUNT(*) FROM ride_bookings) - 1) *
      (SELECT STD(Booking_Value) FROM ride_bookings) *
      (SELECT STD(Ride_Distance) FROM ride_bookings))) AS Correlation
FROM ride_bookings;
SELECT * FROM Correlation_Booking_Value_Distance;
#Calculates covariance and standard deviations to compute Pearson correlation between Booking_Value and Ride_Distance

-- 15. Determine the top 5 most profitable pickup locations.
CREATE VIEW Top_Profitable_Pickup_Locations AS
SELECT Pickup_Location, SUM(Booking_Value) AS Total_Revenue
FROM ride_bookings
GROUP BY Pickup_Location
ORDER BY Pickup_Location DESC
LIMIT 5;
SELECT * FROM Top_Profitable_Pickup_Locations;

-- 16. Find the busiest vehicle type on weekends.
CREATE VIEW Weekend_Busy_Vehicle AS
SELECT Vehicle_Type, COUNT(*) AS Weekend_Rides
FROM ride_bookings
WHERE DAYOFWEEK(Date) IN (1, 7) -- 1: Sunday, 7: Saturday
GROUP BY Vehicle_Type
ORDER BY Weekend_Rides DESC
LIMIT 1;
SELECT * FROM Weekend_Busy_Vehicle;

-- 17. Calculate the percentage of successful rides for each vehicle type.
CREATE VIEW Success_Percentage_Per_Vehicle AS
SELECT 
    Vehicle_Type,
    (SUM(CASE WHEN Booking_Status = "Success" THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Success_Percentage
FROM ride_bookings
GROUP BY Vehicle_Type;
SELECT * FROM Success_Percentage_Per_Vehicle;

-- 18.  Find the day of the week with the highest ride cancellations.
CREATE VIEW Cancelations_By_Day AS
SELECT 
    DAYNAME(Date) AS Day_Of_Week,
    COUNT(*) AS Total_Cancellations
FROM ride_bookings
WHERE Booking_Status LIKE "Canceled%"
GROUP BY DAYNAME(Date)
ORDER BY Total_Cancellations DESC;

SELECT * FROM Cancelations_By_Day;

# __________________________________________________

# Direct Access the results / answers with "View":

-- 1. Fetch all successfully completed bookings.
SELECT * FROM Successful_Bookings;

--  2. Determine the average ride distance for each vehicle type.
SELECT * FROM Avg_Ride_Distance_for_each_vehicle;

--  3. Get the total number of cancelled rides by customers.
SELECT * FROM Canceled_Rides_by_Customers;

--  4. Find and list the top 5 customers who booked the highest number of rides.
SELECT * FROM Top_5_Customer_by_Highest_Rides;

--  5. Determine the number of rides cancelled by drivers due to personal or vehicle issues.
SELECT * FROM Driver_Canceled_Rides_Personal_Vehicle_Issue;

--  6. Find the maximum and minimum driver ratings for Prime Sedan bookings.
SELECT * FROM MAX_MIN_Prime_Sedan_Driver_Rating;

--  7. Retrieve all rides where payment was made using UPI:
SELECT * FROM UPI_Rides;

--  8. Find the average customer rating per vehicle type:
SELECT * FROM Avg_Rating_Per_Vehicle;

--  9. Calculate the total booking value of rides completed successfully:
SELECT * FROM Total_Successful_Booking_Value;

--  10. List all incomplete rides along with the reason:
SELECT * FROM Incomplete_Rides_Reason;

# 11. Determine the top 3 vehicle type with te highest average booking value:
SELECT * FROM Top3_Vehicle_by_Avg_Booking_Value;

-- 12. Find the top 5 areas with the highest ride demand.
SELECT * FROM Top5_High_Ride_Demand_Area;

-- 13. Identify peak hours for bookings.
SELECT * FROM Peak_Hours;

-- 14. Find the correlation between booking value and ride distance.
SELECT * FROM Correlation_Booking_Value_Distance;

#Calculates covariance and standard deviations to compute Pearson correlation between Booking_Value and Ride_Distance

-- 15. Determine the top 5 most profitable pickup locations.
SELECT * FROM Top_Profitable_Pickup_Locations;

-- 16. Find the busiest vehicle type on weekends.
SELECT * FROM Weekend_Busy_Vehicle;

-- 17. Calculate the percentage of successful rides for each vehicle type.
SELECT * FROM Success_Percentage_Per_Vehicle;

-- 18.  Find the day of the week with the highest ride cancellations.
SELECT * FROM Cancelations_By_Day;