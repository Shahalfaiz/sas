************************************************************************
Problem 1
Using data set countries,
1. Create a table with Continent, sum of Population, and number of the Countries
************************************************************************;
libname week5 '/home/u63743369/week5';
proc sql;
    create table ContinentSummary as
    select Continent,
           sum(Population) as TotalPopulation,
           count(distinct Name) as NumberOfCountries
    from week5.countries
    group by Continent;
quit;




************************************************************************
2. Sub-set a data set from Continent that only includes the Continents with
 more than 40 countries, then, create a table with Continent, sum of Population,
 and number of the Countries;
************************************************************************;
libname week5 '/home/u63743369/week5';
proc sql;
    create table ContinentSubset as
    select Continent,
           sum(Population) as TotalPopulation,
           count(distinct Name) as NumberOfCountries
    from week5.countries
    group by Continent
    having NumberOfCountries > 40;
quit;


************************************************************************
Problem 2
Using data sets unitedstates, postalcodes, uscitycoords, create a table containing 
all States in US with columns of State, State_code, Capital, Latitude, and Longitude.
************************************************************************;

libname week5 '/home/u63743369/week5';
proc sql;
    select us.Capital format=$15., us.Name as State  format=$15., pc.Code, c.Latitude, c.Longitude 
    from Week5.unitedstates as us
    inner join Week5.postalcodes as pc on us.Name = pc.Name
    inner join Week5.uscitycoords as c on us.Capital = c.City and pc.Code = c.State;
    title 'Coordinates of State Capitals';
Quit;

************************************************************************
Problem 3
Using data sets unitedstates and countries and a subquery in its WHERE clause
 to select US states that have a population greater than Greece.
************************************************************************;

libname week5 '/home/u63743369/week5';
PROC SQL;
    SELECT Name, Population
    FROM week5.unitedstates
    WHERE Population > (SELECT Population FROM week5.countries WHERE Name = 'Greece');
QUIT;

************************************************************************
Problem 4
Using table Countries, create a table of two columns: Continent and TotalArea,
please make sure to exclude the countries that have missing values of Continent.
************************************************************************;

libname week5 '/home/u63743369/week5';
PROC SQL;
    CREATE TABLE Continent_TotalArea AS
    SELECT Continent, SUM(Area) AS TotalArea
    FROM week5.countries
    WHERE Continent IS NOT NULL
    GROUP BY Continent;
QUIT;


************************************************************************
Problem 5
Compare DATA step match-merges with PROC SQL joins, and see how they work similarly
 and differently. Create a table with columns of FLD_ID, Farmer,
 and Crop by joining below two tables together using data step and PROC SQL joins.
************************************************************************;

data FLDFarmers;
    input Field_id Farmer $20.;
    datalines;
12678 Farmer_A
12678 Farmer_A
11857 Farmer_B
11857 Farmer_B
10446 Farmer_A
10446 Farmer_C
14789 Farmer_G
;
run;

data FLDCrops;
    input Field_id Crop $20.;
    datalines;
12678 Corn
12678 Soybeans
11857 Wheat
11857 Corn
13229 Soybeans
13229 Wheat
10889 Corn
10446 Soybeans
15668 Wheat
;
run;


PROC SORT DATA=FLDCrops;
  BY Field_id;
RUN;

PROC SORT DATA=FLDFarmers;
  BY Field_id;
RUN;

DATA combined_datastep;
  MERGE FLDCrops FLDFarmers;
  BY Field_id;

PROC PRINT DATA=combined_datastep;
TITLE 'Merge the data sets ';
RUN;





PROC SQL;
    CREATE TABLE combined_sql AS
    SELECT F.Field_id, F.Farmer, C.Crop
    FROM FLDFarmers AS F
    FULL JOIN FLDCrops AS C
    ON F.Field_id = C.Field_id;
QUIT;




************************************************************************
Compare DATA step match-merges with PROC SQL joins

1.PROC SQL It's faster and shorter, especially for simple tasks
2.we ask SAS to join the lists based on shared categories, like FLDCrops
 
3.DATA Step It takes more steps and might be a bit long
4. DATA Step might not be as efficient for large datasets
************************************************************************;












