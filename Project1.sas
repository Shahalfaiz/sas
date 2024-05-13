*---------------------------------------------------------------------------*
Week 1 | Project 1
Problem 1. Read in Data from DATALINES
1.Use list input with spaces delimiter to read in the data. Print the data
*---------------------------------------------------------------------------*;
DATA score;
    INFILE DATALINES;
      INPUT Course_name $ Course_number  Days $ Credits;
    DATALINES;
DSCI 200 .  3
DSCI 307 TT 3
MATH 371 MW .
MATH 372 MW 3
;
RUN;

PROC PRINT DATA=score;
    TITLE 'input with spaces delimiter to read in the data';
RUN;

*---------------------------------------------------------------------------*
2.Use column input to read in the data. Print the data.
*---------------------------------------------------------------------------*;
DATA score;
   INFILE DATALINES ;
   input Course_name $ 1-4
         Course_number 6-8
         Days $ 10-11
         Credits 13-14;
   datalines;
DSCI 200 .  3
DSCI 307 TT 3
MATH 371 MW .
MATH 372 MW 3
;
run;

PROC PRINT DATA=score;
    TITLE 'column input to read in the data';
RUN;

*---------------------------------------------------------------------------*
Problem 2. Read in Data from DATALINES 
1.Use formatted column input with pointers and informats to read in the data. Print the data.
*---------------------------------------------------------------------------*;
DATA score;
   INFILE DATALINES ;
   input Course $char7.+1 Days $char2.+1 BeginDate mmddyy10. EndDate mmddyy10.  Credits 2. Tuition dollar8.;
   format BeginDate EndDate mmddyy10. Tuition dollar8.;
   datalines;
DSCI200  . 8/26/2019 10/29/2019 3 $3000
DSCI307 TT 8/26/2019 12/12/2019 3 $3000
MATH371 MW 8/26/2019 12/11/2019 . $3000
MATH372 MW 8/26/2019      .     3 $3000
;
run;

PROC PRINT DATA=score;
    TITLE ' formatted column input with pointers and informats to read in the data';
RUN;
*---------------------------------------------------------------------------*
Problem 2. Read in Data from DATALINES 
2.Use modified list input with ampersand(&) and colon(:) modifiers to read in the data. Print the data
*---------------------------------------------------------------------------*;

DATA score;
   INFILE DATALINES ;
   INPUT course :  $7.
         days :  $2.
         BeginDate : mmddyy10.
         EndDate : mmddyy10.
         Credits : 2.
         Tuition : dollar8.;     
   DATALINES;
DSCI200  . 8/26/2019 10/29/2019 3 $3000
DSCI307 TT 8/26/2019 12/12/2019 3 $3000
MATH371 MW 8/26/2019 12/11/2019 . $3000
MATH372 MW 8/26/2019      .     3 $3000
;
RUN;


PROC PRINT DATA=score;
    TITLE 'Reading in Data using Modifers';
    format BeginDate EndDate mmddyy10. Tuition dollar8.;  
RUN;
*---------------------------------------------------------------------------*
3.Use list input with the informat statement to read in the data
*---------------------------------------------------------------------------*;

DATA score;
   INFILE DATALINES ;
   INFORMAT course $7. days $2. BeginDate mmddyy10. EndDate mmddyy10. Credits 2. Tuition dollar8.;
   INPUT course  $ days BeginDate EndDate Credits Tuition;     
   DATALINES;
DSCI200  . 8/26/2019 10/29/2019 3 $3000
DSCI307 TT 8/26/2019 12/12/2019 3 $3000
MATH371 MW 8/26/2019 12/11/2019 . $3000
MATH372 MW 8/26/2019      .     3 $3000
;
RUN;


PROC PRINT DATA=score;
    TITLE 'Reading in Data using List Input and Informat';
    format BeginDate EndDate mmddyy10. Tuition dollar8.;  
RUN;
*---------------------------------------------------------------------------*
Problem 3. Read in Data from External Files
1.Use DATA step with INFILE and INPUT to read in data from an external file
*---------------------------------------------------------------------------*;
DATA score;
   INFILE '/home/u63743369/week1/class_schedule.csv' DSD FIRSTOBS=2 ;
   input CourseName $ CourseNumber $ Days $ BeginDate :mmddyy10. EndDate :mmddyy10. Credits Tuition : dollar8.;
   FORMAT BeginDate EndDate mmddyy10. Tuition dollar8.;
RUN;

PROC PRINT DATA=score;
   TITLE 'Reading in Data from a CSV File';
RUN;

*---------------------------------------------------------------------------*
2.Use PROC IMPORT to read in data from an external file
*---------------------------------------------------------------------------*;
PROC IMPORT  
DATAFILE='/home/u63743369/week1/class_schedule.xlsx' 
    OUT = score  DBMS = xlsx
    REPLACE ;
    GETNAMES = yes;
RUN;

PROC PRINT DATA=score;
    TITLE 'Reading in Data from excel';
RUN;


















