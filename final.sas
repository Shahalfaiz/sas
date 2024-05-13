***************************************************************
*1.Import the Bay Area House Price data set from the file Bay Area House Price.csv’.
 Name the data set as house_price.
**************************************************************;

proc import datafile='/home/u63743369/week8/Bay Area House Price.csv'
    out=work.house_price
    dbms=csv
    replace;
    getnames=yes;
run;

***************************************************************
*2.Drop the variables: address, info, z_address, neighborhood,
 latitude, longitude, and zpid both using Data Statement and PROC SQL.
 Name the new data set as house_price.
**************************************************************;

data house_price(drop=address info z_address neighborhood latitude longitude zpid);
    set house_price; 
run;


proc import datafile='/home/u63743369/week8/Bay Area House Price.csv'
    out=work.house_price
    dbms=csv
    replace;
    getnames=yes;
run;

proc sql;
    create table house_price as
    select *
    from house_price
    (drop=address info z_address neighborhood latitude longitude zpid);
quit;

***************************************************************
*3.Add a new variable price_per_square_foot defined by 
lastsoldprice/finishedsqft both using Data Statement and PROC SQL.
**************************************************************;

data house_price;
    set house_price;
    price_per_square_foot = lastsoldprice / finishedsqft;
run;


proc sql;
    create table house_price as
    select *,
           lastsoldprice / finishedsqft as price_per_square_foot
    from house_price;
quit;


***************************************************************
*4.Find the average of lastsoldprice by zipcode both using Data
 Statement and PROC SQL.
**************************************************************;

proc sort data=house_price;
    by zipcode;
run;

proc means data=house_price noprint;
    by zipcode;
    output out=avg_lastsoldprice(drop=_type_ _freq_) mean=average_lastsoldprice;
run;


proc sql;
    create table avg_lastsoldprice_zipcode as
    select zipcode,
           mean(lastsoldprice) as average_lastsoldprice
    from house_price
    group by zipcode;
quit;


***************************************************************
*5.Find the average of lastsoldprice by usecode, totalrooms,
 and bedrooms both using Data Statement and PROC SQL.
**************************************************************;

proc sort data=house_price;
    by usecode totalrooms bedrooms;
run;

proc means data=house_price noprint;
    by usecode totalrooms bedrooms;
    output out=avg_lastsoldprice(drop=_type_ _freq_) mean=average_lastsoldprice;
run;



proc sql;
    create table avg_lastsoldprice as
    select usecode, totalrooms, bedrooms,
           mean(lastsoldprice) as average_lastsoldprice
    from house_price
    group by usecode, totalrooms, bedrooms;
quit;


***************************************************************
*6.Plot the bar charts for bathrooms, bedrooms, usecode, totalrooms 
respectively, and save the bar chart of bedrooms as bedrooms.png.
**************************************************************;

proc sgplot data=house_price;
    title 'Bar Chart for Bathrooms';
    vbar bathrooms;
run;

proc sgplot data=house_price;
    title 'Bar Chart for Bedrooms';
    vbar bedrooms;
run;

proc sgplot data=house_price;
    title 'Bar Chart for Use Code';
    vbar usecode;
run;

proc sgplot data=house_price;
    title 'Bar Chart for Total Rooms';
    vbar totalrooms;
run;



***************************************************************
*7.Plot the Histogram, boxplot for lastsoldprice, zestimate respectively.
 Are they normal or skewed? What’s the median of the lastsoldprice?
 What’s the median of the zestimate?
**************************************************************;

proc univariate data=house_price noprint;
    var lastsoldprice;
    histogram lastsoldprice / normal;
    inset median / position=ne;
run;



proc sgplot data=house_price;
    vbox lastsoldprice;
    title 'Box Plot of Last Sold Price';
run;


proc sgplot data=house_price;
    histogram zestimate;
    density zestimate / type=kernel;
run;

proc sgplot data=house_price;
    vbox zestimate;
    title 'Box Plot of Zestimate';
run;

**************************
Are they normal or skewed/ it is not normal and it is skewed
What’s the median of the lastsoldprice?990,000
 What’s the median of the zestimate?1,230,758;
***************************************************************;

*************************************************************
*8.Compare the average of zestimate for any two different zipcodes
 (You choose two different zipcodes). 
 Do you agree that there is no difference between the average zestimate 
 in the two zipcodes statistically? Why?
**************************************************************;


proc means data=house_price(where=(zipcode=94107)) mean noprint;
    var zestimate;
    output out=avg_zestimate_94110 mean=average_zestimate_94110;
run;


proc means data=house_price(where=(zipcode=94112)) mean noprint;
    var zestimate;
    output out=avg_zestimate_94117 mean=average_zestimate_94117;
run;


proc ttest data=house_price;
    class zipcode;
    var zestimate;
    where zipcode in (94107, 94112);
run;

**********************************************************
The p-values from both methods are small, less than 0.0001.
 This means there's a big difference in the average zestimate 
 between the two zip codes. Also, the t-values are about 19.54, 
 which shows a big difference in means. So, based on this data, 
 we can say that there's a big difference in the average zestimate
 between zip codes 94107 and 94112.;
*************************************************************;




*************************************************************
*9.Do you agree that there is no difference between the average
 zestimate and the average of lastsoldprice statistically? Why?
**************************************************************;


proc ttest data=house_price;
    var zestimate;
    var lastsoldprice;
run;

*******************************************************************
I would disagree that there is no difference between the 
average zestimate and the average lastsoldprice.;
********************************************************************;


*************************************************************
*10.Do you agree that the number of bedrooms is associated with the usecode? Why?
**************************************************************;


proc freq data=house_price;
  tables bedrooms*usecode / chisq;
run;

***********************************************************************
Yes, I agree. The analysis we did showed that there's a strong connection 
between the number of bedrooms and the usecode.
**************************************************************************

*************************************************************
*11.Do you agree that the number of bedrooms is associated with 
the number of bathrooms? Why?
**************************************************************;

proc reg data=house_price;
    model bathrooms = bedrooms;
run;

***************************************************************
Yes, I agree that the number of bedrooms is linked to the number of bathrooms.
***************************************************************;


*************************************************************
*12.Calculate the correlation coefficients of all numerical
 variables with the variable zesitmate, and plot the scatter
 plot and matrix.  (Hint: Use PLOTS(MAXPOINTS=none)=scatter 
 in PROC CORR  so that the scatter graph is shown. Otherwise 
 you may not see the graph because the data is very large.);
**************************************************************;

proc corr data=house_price plots(maxpoints=none)=scatter;
    var zestimate bathrooms bedrooms finishedsqft lastsoldprice totalrooms yearbuilt;
run;


*************************************************************
*13.Find a regression model for zestimate with the first
 three most correlated variables.
**************************************************************;

proc reg data=house_price;
    model zestimate = bathrooms bedrooms finishedsqft;
run;

*************************************************************
*14.Find a regression model for zestimate with the first five most correlated variables
**************************************************************;

proc reg data=house_price;
    model zestimate = bathrooms lastsoldprice finishedsqft bedrooms totalrooms;
run;

*************************************************************
*15.Compare the adjusted R^2 in the two models 
from question 13) and 14). The model that has a bigger adjusted R^2 is better.
**************************************************************;
**************************************************************
in question 13 has an adjusted R^2 of 0.5961.
in question 14 has an adjusted R^2 of 0.8328.
I see thatquestion 14 has a significantly higher 
***************************************************************;

*************************************************************
*16.Use the better model from question 15) to predict the house 
prices given the values of independent variables.
 (You name the values of independent variables for  4 houses);
**************************************************************;
data new_houses;
    input bathrooms lastsoldprice finishedsqft bedrooms totalrooms;
    datalines;
2 1500000 1800 3 7
1 800000 1000 2 5
3 2200000 2200 4 8
2.5 1750000 2000 3 6
;
run;

proc reg data=new_houses outest=estimates;
    model lastsoldprice = bathrooms  finishedsqft bedrooms totalrooms;
run;
proc print data=estimates;
run;

*************************************************************
*17.Export the predictive values from question 16) as an excel 
file named ‘prediction.xlsx’
**************************************************************;

proc export data=estimates
    outfile='/home/u63743369/week8/prediction.xlsx'
    dbms=xlsx
    replace;
run;

*************************************************************
*18.Create a macro named average with two parameters category 
and price. In the macro, firstly use PROC MEANS for the data set
 house_price to calculate the mean of &price by &category. 
 In the PROC MEANS, use option NOPRINT, and let OUT=averageprice.
 Then use PROC PRINT to print the data averageprice using the macro variables in the TITLE.
**************************************************************;

%macro average(category, price);
    /* Use PROC MEANS to calculate the mean of &price by &category */
    proc means data=house_price noprint mean;
        var &price;
        by &category;
        output out=averageprice mean=&price;
    run;

    /* Use PROC PRINT to print the data averageprice with macro variables in the title */
    title "Average &price by &category";
    proc print data=averageprice;
    run;
%mend;

*************************************************************
*19.Call the macro %average(category=zipcode, price=price_per_square_foot).
**************************************************************;

proc sort data=house_price;
    by zipcode;
run;

%average(category=zipcode, price=price_per_square_foot);

*************************************************************
*20.Call the macro %average(category=totalrooms, price=zestimate).
**************************************************************;

proc sort data=house_price;
    by totalrooms;
run;

%average(category=totalrooms, price=zestimate);

























































