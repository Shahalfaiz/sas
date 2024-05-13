************************************************************************
Problem 1.
Read the four data sets from the files:
************************************************************************;

DATA s1f;
  INFILE '/home/u63743369/week3/school 1 final.csv' DSD firstobs=2;
  INPUT ClassID ChildID Gender $ Class_Age $ Language $ f1 f2 f3 f4;
RUN;

DATA s1m;
  INFILE '/home/u63743369/week3/school 1 midterm.csv' DSD firstobs=2;
  INPUT ClassID ChildID Gender $ ClassAge $ Language $ m1 m2 m3 m4;
RUN;

DATA s2f;
  INFILE '/home/u63743369/week3/school 2 final.csv' DSD firstobs=2;
  INPUT ClassID ChildID Gender $ ClassAge $ f1 f2 f3 f4;
RUN;

DATA s2m;
  INFILE '/home/u63743369/week3/school 2 midterm.csv' DSD firstobs=2;
  INPUT ClassID ChildID Gender $ ClassAge $ m1 m2 m3 m4;
RUN;


************************************************************************
2.Interleave s1m and s2m by ChildID. Name the new data set as midterm and print it.
************************************************************************;

PROC SORT DATA=s1m;
  BY ChildID;
RUN;

PROC SORT DATA=s2m;
  BY ChildID;
RUN;

DATA midterm;
 SET s1m s2m;
 BY ChildID;
RUN;

PROC PRINT DATA = midterm;
    TITLE 'Interleaving Data Sets Using the SET Statements';
RUN;

************************************************************************
3.Interleave s1fand s2f by ChildID. Name the new data set as final and print it.
************************************************************************;

PROC SORT DATA=s1f;
  BY ChildID;
RUN;

PROC SORT DATA=s2f;
  BY ChildID;
RUN;

DATA final;
 SET s1f s2f;
 BY ChildID;
RUN;

PROC PRINT DATA = final;
    TITLE 'Interleaving Data Sets Using the SET Statements';
RUN;

************************************************************************
4.Merge the data sets midterm and final by ChildID. Name the new data set as assess and print it.
************************************************************************;

PROC SORT DATA=midterm;
  BY ChildID;
RUN;

PROC SORT DATA=final;
  BY ChildID;
RUN;

DATA assess;
  MERGE midterm final;
  BY ChildID;

PROC PRINT DATA=assess;
TITLE 'Merge the data sets midterm and final';
RUN;


************************************************************************
5.Find the mean of each numerical variables in the data set assess
************************************************************************;

PROC MEANS DATA=assess N MEAN;
RUN;


************************************************************************
6.Update the data sets midterm with the data set final by ChildID. Print the updated data set.
************************************************************************;
DATA midtermfinal;
    UPDATE midterm final;
     BY ChildID;
RUN;
PROC PRINT DATA = midtermfinal;
    TITLE 'Update the data sets midterm with the data set final';
RUN;

************************************************************************
7.Use OUTPUT statement and IF statement to regroup the data set assess
 into 4 data sets PREK4, PREK3, Female, and Male. Print the 4 data sets.
************************************************************************;

DATA PREK4 PREK3 Female Male;
  SET assess;

  IF ClassAge = 'Pre-K 4' THEN OUTPUT PREK4;
  ELSE IF ClassAge = 'Pre-K 3' THEN OUTPUT PREK3;
  ELSE IF Gender = 'Female' THEN OUTPUT Female;
  ELSE IF Gender = 'Male' THEN OUTPUT Male;
RUN;

PROC PRINT DATA=PREK4;
  TITLE 'PREK4 Dataset';
RUN;

PROC PRINT DATA=PREK3;
  TITLE 'PREK3 Dataset';
RUN;

PROC PRINT DATA=Female;
  TITLE 'Female Dataset';
RUN;

PROC PRINT DATA=Male;
  TITLE 'Male Dataset';
RUN;


************************************************************************
8.Use KEEP or DROP data step statements to select the two variables m2 and 
f2 from the data set assess. Name the selected data set as select_m2_f2.
 Print the first five observations..
************************************************************************;

DATA select_m2_f2;
  SET assess;
  KEEP m2 f2;
RUN;

PROC PRINT DATA=select_m2_f2 (obs=5);
  TITLE 'select the two variables';
RUN;



************************************************************************
9.Use KEEP or DROP data set options to select the two variables m3 and f3 
from the data set assess. Name the selected data set as select_m3_f3. Print
 the observations from the 50th row to the 100th row
************************************************************************;

DATA select_m3_f3;
  SET assess;
  KEEP m3 f3;
RUN;

PROC PRINT DATA=select_m3_f3 (OBS=100 FIRSTOBS=50);
  TITLE 'Selected Data Set (m3 and f3)';
RUN;


************************************************************************
10.Add two new variables (columns) d1 and d2 in the data set assess, 
where d1=f1-m1, d2=f2-m2. Use Where data statement or data set option to select 
the observations with d1 >0 and d2>0. Name the selected data set as improvement and print it
************************************************************************;

DATA assess;
  SET assess;
  d1 = f1 - m1;
  d2 = f2 - m2;
RUN;

DATA improvement;
  SET assess;
  WHERE d1 > 0 AND d2 > 0;
RUN;

PROC PRINT DATA=improvement;
  TITLE 'two new variables';
RUN;


************************************************************************
11.Merge midterm and final by ChildID with IN options to get the common part. 
Name the merged data set as both and Print it.
************************************************************************;

PROC SORT DATA=midterm;
  BY ChildID;
RUN;

PROC SORT DATA=final;
  BY ChildID;
RUN;

DATA both;
  MERGE midterm(IN=a) final(IN=b);
  BY ChildID;
  IF a AND b THEN OUTPUT;
RUN;

PROC PRINT DATA=both;
  TITLE 'Merge midterm and final';
RUN;

************************************************************************
12.Merge midterm and final by ChildID with IN options to get the data that are 
in midterm but not in final. Name the merged data set as right_merge and print it.
************************************************************************;

PROC SORT DATA=midterm;
  BY ChildID;
RUN;

PROC SORT DATA=final;
  BY ChildID;
RUN;

data right_merge;
  merge midterm(in=a) final(in=b);
  by ChildID;
  IF a  THEN OUTPUT;
  
RUN;

PROC PRINT DATA=right_merge;
  TITLE 'Right Merge';
RUN;


************************************************************************
13.Merge midterm and final by ChildID with IN options to get the data 
that are in final but not in midterm. Name the merged data set as left_merge and print it
************************************************************************;

PROC SORT DATA=midterm;
  BY ChildID;
RUN;

PROC SORT DATA=final;
  BY ChildID;
RUN;

data left_merge;
  merge midterm(in=a) final(in=b);
  by ChildID;
  IF b   THEN OUTPUT;
  
RUN;

PROC PRINT DATA=left_merge;
   TITLE 'Left Merge';
RUN;
































































