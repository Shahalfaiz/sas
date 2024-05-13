************************************************************************
Problem 1
Using data set worldtemps, create a table with title assigned,
 the table contains 20 observations, with city names (labeled as “City”),
 and their high temperature in Celsius (labeled as “HighTempC”) with 1 decimal,
 and order the table by HighTempC from high to low.
************************************************************************;

libname Week4 '/home/u63743369/week4';
title 'World Temperatures';

proc sql outobs=20;
   create table Week4.worldtemps_table as
   select City, 
          round((AvgHigh - 32) * 5/9, 1) as HighTempC format=5.1
   from Week4.worldtemps
   order by HighTempC descending;
quit;

proc print data=Week4.worldtemps_table;
run;




************************************************************************
Problem 2
Using data set postalcodes, create a table containing states of Illinois,
 Ohio, North Carolina in this format:
************************************************************************;

libname Week4 '/home/u63743369/week4';
proc sql; 
    title 'U.S. Postal Codes'; 
    select 'In United States','postal code for','of', Name label='#', 'is', Code label='#'
    from Week4.postalcodes
    where Name in ('Ohio','Illinois', 'North Carolina','Iowa');
Quit;


************************************************************************
Problem 3
Using data set worldtemps, create a table containing City (Labeled as “City”), 
AvgHigh in Celsius (labeled as “AvgH”), AvgLow in Celsius (Labeled as “AvgL”),
Range between AvgHigh and AvgLow in Celsius (Labeled as “RangeC”), 
and only contain the cities with RangeC between 38.0 and 40.0 in Celsius, 
and order the table by RangeC from low to high.
************************************************************************;

libname Week4 '/home/u63743369/week4';
proc sql;
    create table worldtemps_filtered as
    select City,
           round((AvgHigh - 32) * 5/9, 1) as AvgH label="AvgH",
           round((AvgLow - 32) * 5/9, 1) as AvgL label="AvgL",
           round(((AvgHigh - 32) * 5/9) - ((AvgLow - 32) * 5/9), 1) as RangeC label="RangeC"
    from week4.worldtemps
    where round(((AvgHigh - 32) * 5/9) - ((AvgLow - 32) * 5/9), 1) between 38.0 and 40.0
    order by RangeC;
quit;

proc print data=worldtemps_filtered;
run;


************************************************************************
Problem 4
The following table describes the world climate zones (rounded to 
the nearest degree) that exist between Location 1 and Location 2:
Using data set worldcitycoords and World Climate Zones table ,  
develop PROC SQL code to fill up the table with ClimateZone.
************************************************************************;

libname Week4 '/home/u63743369/week4';
proc sql;
   title 'Climate Zones of World Capitals';
   select Country,
        City as Capital,
          
          case
             when Latitude >= 67 then 'North Frigid'
             when 67 > Latitude > 23 then 'North Temperate'
             when 23 > Latitude > -23 then 'Torrid'
             when -23 >= Latitude >= -67 then 'South Temperate'
             else 'South Frigid'
          end as ClimateZone
      from week4.worldcitycoords
       WHERE 
       City IN ('Santiago', 'Beijing', 'Havana', 'Oslo', 'Montevideo', 'Ottawa')
      order by Capital;
QUIT;



