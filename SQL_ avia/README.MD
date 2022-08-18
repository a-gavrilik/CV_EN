# **SQL**

### Task Description:

1. Restore database from *.backup file by following link **[avia](https://drive.google.com/file/d/1U15gYuu_ZFE2sQMN32GXK3phBLcUl6OM/view)**. 
2. Then go to the **[link](https://postgrespro.com/community/demodb)** and see the description of the database.
3. Create queries to answer the following questions:

| №        | Question           | In the request must be used  |
|-------------- |-------------|-----------------------------:|
|1|Which cities have more than one airport?||
|2|At which airports are there flights performed by an aircraft with the maximum range of flight?|Subquery|
|3|Withdraw 10 flights with maximum delay time.|Operator LIMIT|
|4|Were there any reservations for which boarding passes were not received?|Correct JOIN type|
|5|Find vacant seats for each flight, their % ratio to the total number of seats on the plane. Add a column with a cumulative total - a summary cumulative accumulation of the number of departed passengers from each airport for each day. I.e. this column should reflect the cumulative amount - how many people have already left the airport on this or earlier flights per day.|Window function, Subqueries|
|6|Find the percentage of flights by types of aircraft from the total number.|Subquery, operator ROUND|
|7|Were the cities to which business class can be reached cheaper than economy class as part of the flight?|CTE|
|8|What cities don’t have direct flights between them?|The cartesian product in FROM, Created yourself VIEW, Operator EXCEPT|
|9|Calculate the distance between airports connected by direct flights, compare with the permissible maximum range of flights in aircraft serving these flights. *|Operator RADIANS or using sind/cosd|

\* In the cloud database, the coordinates are in the column airports_data.coordinates - work as with an array. In the local database, the coordinates are in the columns airports.longitude and airports.latitude.

The shortest distance between two points A and B on the Earth’s surface (when taken as a sphere) is determined by the dependency:
d = arccos {sin(latitude_a)\*sin(latitude_b) + cos(latitude_a)\*cos(latitude_b)\*cos(longitude_a - longitude_b)}, where latitude_a and latitude_b - latitudes, longitude_a and longitude_b - longituds, d - the distance between points is measured in radians of the length of the arc of a large circle of the globe.

The distance between points, measured in kilometres, is determined by the formula:
L = d*R, where R = 6,371 km is the average radius of the globe.
