*******************************************************************
*Problem 1.Export Dataset 
*1.Create a libname using the command: LIBNAME *****
*******************************************************************;
LIBNAME  Week2 '/home/u63743369/week2';
*******************************************************************
*2.Read data from the file and Save the data as a permanent SAS dataset named death_count in the library Week2 *****
*******************************************************************;
DATA Week2.death_count; 
   INFILE '//home/u63743369/week2/2010-2015-Age65above Final Death Count.csv' DSD FIRSTOBS = 2;
   INPUT year month	gender $ age  ICD10 $ death;
RUN;

PROC PRINT DATA = Week2.death_count;
TITLE 'Save Permanent DataSet';
RUN;

*******************************************************************
*3.Use SET to read data from the permanent dataset *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
DATA Week2.death_2015;
   SET Week2.death_count;
   WHERE year = 2015;
RUN;
PROC PRINT DATA = Week2.death_2015;
TITLE 'Read Permanent Dataset';
RUN;

*******************************************************************
*4.Use PROC EXPORT to save the data *****
*******************************************************************;
PROC EXPORT DATA=Week2.death_2015
            OUTFILE='//home/u63743369/week2/death_2015.csv'
            DBMS=CSV REPLACE;
RUN;





*******************************************************************
*Problem 2. PROC MEANS
*1.Create a libname using the command: LIBNAME *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
DATA Week2.death_count;
   INFILE '//home/u63743369/week2/2010-2015-Age65above Final Death Count.csv' DSD FIRSTOBS = 2;
   INPUT year month gender $ age ICD10 $ death;
RUN;
PROC PRINT data=Week2.death_count (obs=3);
    TITLE '';
RUN;
*******************************************************************
*2.Use Class statement to calculate the sum of the variable death by year. *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC MEANS DATA=Week2.death_count;
   CLASS year;
   VAR death;
   OUTPUT OUT=Week2.sum_death_by_year SUM=;
   TITLE 'Proc Means';
RUN;
*******************************************************************
*3.Use Class statement to calculate the mean and std of the variable death by month *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC MEANS DATA=Week2.death_count;
   CLASS month;
   VAR death;
   OUTPUT OUT=Week2.death_by_month MEAN= STD= /AUTONAME;
   TITLE 'Proc Means';
RUN;
*******************************************************************
*Use OUTPUT statement to save the mean and std into a data set named death_by_month. *****
*******************************************************************;
proc means data=week2.death_count NOPRINT;
     CLASS month;
     VAR death;
     output out=week2.death_by_month mean= std= /autoname;
run;

*******************************************************************
*4.Use By under PROC MEANS to calculate the sum of the variable death by gender. *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC SORT DATA=Week2.death_count;
   BY gender;
RUN;

PROC MEANS DATA=Week2.death_count  N MEAN STD MAXDEC=2 ;
   VAR death;
   BY gender;
   OUTPUT OUT=Week2.sum_death_by_gender SUM=;
    TITLE 'Proc Means (using BY statement)';
RUN;   
   
   
   
*******************************************************************
*Problem 3. PROC FREQ
*1.Use PROC FREQ to find the frequency distributions for the variables year and gender respectively in the dataset death_count. *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC FREQ DATA=Week2.death_count;
   TABLES year gender;
   TITLE 'One-way Frequency Table';
RUN;
*******************************************************************
*2. Use PROC FREQ to find the 2-way frequency distributions for the variables gender*month in the dataset death_count.
 *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC FREQ DATA=Week2.death_count;
   TABLES gender * month;
   TITLE 'Two-way Frequency Table';
RUN;




*******************************************************************
*Problem 4. PROC TABULATE
*1.Use PROC TABULATE to create a report about the sum and mean of death with Table year, gender ALL, (month ALL)*death*(mean sum). *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC TABULATE DATA=Week2.death_count;
   CLASS year gender month;
   VAR death;
   TABLE year, gender ALL, (month ALL)*death*(mean sum);
   TITLE 'PROC TABULATE';
RUN;
*******************************************************************
*2.Use PROC TABULATE to create a report about the sum and mean of death with Table year, gender, (month)*death*(mean sum). *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC TABULATE DATA=Week2.death_count;
   CLASS year gender month;
   VAR death;
   TABLE year, gender, (month)*death*(mean sum);
   TITLE 'PROC TABULATE';
RUN;



*******************************************************************
*Problem 5. PROC REPORT 
*1. Use PROC REPORT to create a report about the sum and mean of death by gender and month.  *****
*******************************************************************;
LIBNAME Week2 '/home/u63743369/week2';
PROC REPORT DATA=Week2.death_count;
   COLUMN gender month, death;
   DEFINE gender / GROUP;
   DEFINE month / ACROSS;
   DEFINE death / SUM 'Sum of Death';
   DEFINE death / MEAN 'Mean of Death';
   TITLE 'PROC REPORT';
RUN;

