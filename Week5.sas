************************************************************************
*Example- Summarizing Data with a WHERE Clause;
************************************************************************;
libname sql '/folders/myfolders/Week5';
proc sql outobs=12; 
    title 'Mean Temperatures for World Cities'; 
    select City, Country, mean(AvgHigh, AvgLow) as MeanTemp 
    from sql.worldtemps 
    where calculated MeanTemp gt 75 
    order by MeanTemp desc;
Quit;

************************************************************************
* Example-Displaying Sums;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'World Oil Reserves'; 
    select sum(Barrels) format=comma18. as TotalBarrels 
    from Week5.oilrsrvs;
Quit;
************************************************************************
* Example-Remerging Summary Statistics;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';

proc sql outobs=12; 
    title 'Largest Country Populations'; 
    select Name, Population format=comma20., 
    max(Population) as MaxPopulation format=comma20. 
    from Week5.countries 
 	order by Population desc;
Quit;
************************************************************************
*Example-Counting Unique Values;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql;
    title 'Number of Continents in the Countries Table'; 
        select count(distinct Continent) as Count 
from Week5.countries;
Quit;
************************************************************************
*Example-Counting Nonmissin Values;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql;
    title 'Countries for Which a Continent is Listed'; 
    select count(Continent) as Count 
    from Week5.countries;
Quit;
************************************************************************
*Example-Counting All Rows;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Number of Countries in the Week5.Countries Table'; 
    select count(*) as Number 
    from Week5.countries;
Quit;
************************************************************************
*Example- Summarizing Data with Missing Values;
************************************************************************;
*Part I  unexpected output; 
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Average Length of Angel Falls, Amazon and Nile Rivers-Wrong'; 
    select Name, Length, avg(Length) as AvgLength 
    from Week5.features 
    where Name in ('Angel Falls', 'Amazon', 'Nile');
Quit;

*Part II modified output; 
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Average Length of Angel Falls, Amazon and Nile Rivers-Correct'; 
    select Name, Length, coalesce(Length, 0) as NewLength, 
    avg(calculated NewLength) as AvgLength 
    from Week5.features 
    where Name in ('Angel Falls', 'Amazon', 'Nile');
Quit;
************************************************************************
*Example- Grouping by One Column;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Total Populations of World Continents'; 
    select Continent, sum(Population) format=comma14. as TotalPopulation 
    from Week5.countries 
    where Continent is not missing 
    group by Continent;
Quit;
************************************************************************
*Example- Grouping without Summarizing;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=12; 
    title 'High and Low Temperatures'; 
    select City, Country, AvgHigh, AvgLow 
    from Week5.worldtemps 
    group by Country;
Quit;
************************************************************************
*Example- Grouping by Multiple Columns;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Total Square Miles of Deserts and Lakes'; 
    select Location, Type, sum(Area) as TotalArea format=comma16. 
    from Week5.features 
    where type in ('Desert', 'Lake') 
    group by Location, Type;
Quit;
************************************************************************
*Example- Grouping and Sorting Data;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Total Square Miles of Deserts and Lakes'; 
    select Location, Type, sum(Area) as TotalArea format=comma16. 
    from Week5.features 
    where type in ('Desert', 'Lake') 
    group by Location, Type 
    order by Location desc;
Quit;
************************************************************************
*Example- Grouping with Missing Values;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
/* unexpected output */
proc sql outobs=12; 
	title 'Areas of World Continents'; 
	select Name format=$25., Continent, 
			sum(Area) format=comma12. as TotalArea 
	from Week5.countries 
	group by Continent 
	order by Continent, Name;
Quit;

/* modified output */
proc sql outobs=12; 
    title 'Areas of World Continents'; 
    select Name format=$25., Continent, 
        sum(Area) format=comma12. as TotalArea 
    from Week5.countries 
    where Continent is not missing 
    group by Continent 
    order by Continent, Name; 
Quit;
************************************************************************
*Example- Using a Simple HAVING Clause;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'Numbers of Islands, Oceans, and Seas'; 
    select Type, count(*) as Number 
    from Week5.features 
    group by Type 
    having Type in ('Island', 'Ocean', 'Sea') 
    order by Type;
Quit;
************************************************************************
*Example- Using HAVING with Aggregate Functions;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql; 
   title 'Total Populations of Continents with More than 15 Countries'; 
    select Continent, sum(Population) as TotalPopulation format=comma16., count(*) as Count 
    from Week5.countries 
    group by Continent 
    having count(*) gt 15 
    order by Continent;
Quit;
************************************************************************
*Example- Inner Joins by Using Table Aliases;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=6; 
    title 'Oil Production/Reserves of Countries'; 
    select * 
    from Week5.oilprod as p, Week5.oilrsrvs as r 
    where p.country = r.country;
Quit;
************************************************************************
*Example- Inner Joins by Specifying the Order of Join Output;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=6; 
    title 'Oil Production/Reserves of Countries'; 
    select p.country, barrelsperday 'Production', barrels 'Reserves' 
    from Week5.oilprod p, Week5.oilrsrvs r 
    where p.country = r.country 
    order by barrelsperday desc;
Quit;
************************************************************************
*Example- Inner Joins by Creating Inner Joins Using INNER JOIN Keywords;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=6; 
    select p.country, barrelsperday 'Production', barrels 'Reserves' 
    from Week5.oilprod p inner join Week5.oilrsrvs r 
    on p.country = r.country 
    order by barrelsperday desc;
Quit;
************************************************************************
*Example-Left Outer Join;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=10; 
    title 'Coordinates of Capital Cities'; 
    select Capital format=$20., Name 'Country' format=$20., Latitude, Longitude 
    from Week5.countries a left join Week5.worldcitycoords b 
    on a.Capital = b.City and a.Name = b.Country 
    order by Capital;
Quit;
************************************************************************
*Example-Right Outer Join;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=10; 
    title 'Populations of Capitals Only'; 
    select City format=$20., Country 'Country' format=$20., Population 
    from Week5.countries right join Week5.worldcitycoords 
    on Capital = City and Name = Country 
    order by City;
Quit;
************************************************************************
*Example-Full Outer Join;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=10; 
    title 'Populations and/or Coordinates of World Cities'; 
    select City '#City#(WorldCityCoords)' format=$20., 
    Capital '#Capital#(Countries)' format=$20., Population, Latitude, Longitude 
    from Week5.countries full join Week5.worldcitycoords 
    on Capital = City and Name = Country;
Quit;
************************************************************************
*Example-Selecting Data from More Than Two Tables;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=10;
    select us.Capital format=$15., us.Name 'State' format=$15.,  pc.Code, c.Latitude, c.Longitude 
    from Week5.unitedstates us, Week5.postalcodes pc, Week5.uscitycoords c 
    where us.Capital = c.City and us.Name = pc.Name and pc.Code = c.State;
    title 'Coordinates of State Capitals';
Quit; 
************************************************************************
*Example-Merge Tables When All of the Values Match;
************************************************************************;
*Read in data;
data fltsuper;
input Flight Supervisor $;
datalines;
145 Kang 
150 Miller 
155 Evanko 
;
data fltdest;
input Flight Destination $;
datalines;
145 Brussels
150 Paris
155 Honolulu
;
run;

*part I use DATA step match-merge;
data merged; 
    merge fltsuper fltdest; 
    by Flight;
run;

proc print data=merged noobs; 
    title 'Table Merged by Data Step';
run; 

*part II use PROC SQL join ;
proc sql; 
    title 'Table Merged by PROC SQL'; 
    select s.flight, Supervisor, Destination 
    from fltsuper s, fltdest d 
    where s.Flight=d.Flight;
Quit;
************************************************************************
*Example-Merge Tables When Only Some of the Values Match;
************************************************************************;
*Read in data;

data fltsuper;
input Flight Supervisor $;
datalines;
145 Kang 
150 Miller 
155 Evanko
157 Lei 
;

data fltdest;
input Flight Destination $;
datalines;
145 Brussels
150 Paris
165 Seattle
;
run;

*part I use DATA step match-merge;
data merged; 
    merge fltsuper fltdest; 
    by Flight;
run;

proc print data=merged noobs; 
    title 'Table Merged by Data Step';
run; 

*part II use PROC SQL full join ;
proc sql; 
    title 'Table Merged by PROC SQL'; 
    select coalesce(s.Flight,d.Flight) as Flight, Supervisor, Destination 
    from fltsuper s full join fltdest d 
    on s.Flight=d.Flight;
Quit;
************************************************************************
*Example-Merge or Jion Tables  When the Position of the Values Is Important;
************************************************************************;
*Read in data;

data fltsuper;
input Flight Supervisor $;
datalines;
145 Kang
145 Ramirez  
150 Miller
150 Picard  
155 Evanko
157 Lei 
;

data fltdest;
input Flight Destination $;
datalines;
145 Brussels
150 Paris
165 Seattle
;
run;

*part I use DATA step match-merge;
data merged; 
    merge fltsuper fltdest; 
    by Flight;
run;

proc print data=merged noobs; 
    title 'Table Merged by Data Step';
run; 

*part II use PROC SQL full join ;
proc sql; 
    title 'Table Merged by PROC SQL'; 
    select * 
    from fltsuper s, fltdest d 
    where s.Flight=d.Flight;
Quit;

************************************************************************
*Example-Single-Value Subqueries;
************************************************************************;

libname Week5 '/folders/myfolders/Week5';
proc sql; 
    title 'U.S. States with Population Greater than Belgium'; 
    select Name 'State' , population format=comma10. 
    from Week5.unitedstates 
    where population gt 
        (select population from Week5.countries 
                where name = "Belgium");
quit;


proc sql; 
    title 'U.S. States with Population Greater than Belgium'; 
    select Name 'State', population format=comma10. 
    from Week5.unitedstates 
    where population gt 10162614;
quit;

************************************************************************
*Example-Multiple-Value Subqueries;
************************************************************************;
libname Week5 '/folders/myfolders/Week5';
proc sql outobs=5; 
    title 'Populations of Major Oil Producing Countries'; 
    select name 'Country', Population format=comma15. 
    from Week5.countries 
    where Name in 
            (select Country from Week5.oilprod);
Quit;
