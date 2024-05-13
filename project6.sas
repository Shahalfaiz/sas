************************************************************************
Problem 1: Macros
Use %LET to create a macro variable named ClassAge, assigning to it a value of Pre-K 4.
************************************************************************;
%let ClassAge = Pre-K 4;

************************************************************************
2.Read the data set School 1 final.csv and name it final.
Then use IF to subset with the macro variable &ClassAge. 
Name the subset as ClassAge_final. Print it using the macro variable in TITLE. 
************************************************************************;

data final;
  infile '/home/u63743369/week6/school 1 final.csv' delimiter=',' firstobs=2;
  input ClassID ChildID Gender $ ClassAge $ Language $ f1 f2 f3 f4;
run;

data ClassAge_final;
  set final;
  if ClassAge = "&ClassAge";
run;

title "Subset of Final Dataset for &ClassAge";
proc print data=ClassAge_final;
run;

************************************************************************
3.Create a macro named average with two parameters category and question.
In the macro, firstly apply PROC MEANS for the data set final to calculate 
the mean of &question by &category. In the PROC MEANS, use option NOPRINT, 
and let OUT=averagescore. Then apply PROC PRINT to print the data averagescore 
using the macro variables in the TITLE. 
************************************************************************;

%macro average(category, question);
  
  proc means data=final mean noprint;
    var &question;
    class &category;
    output out=averagescore mean=;
  run;

  title "Mean of &question by &category";
  proc print data=averagescore;
    title2 "Category: &category, Question: &question";
  run;

%mend;

************************************************************************
4.Invoke the macro %average(category=Gender, question=f1). 
************************************************************************;

%average(category=Gender, question=f1);

************************************************************************
5.Invoke the macro %average(category= ClassAge, question=f3).
************************************************************************;

%average(category=ClassAge, question=f3);

************************************************************************
6.Create a macro named class with one parameter category. In the macro,
 use %IF &category =Gender %THEN %DO PROC MEANS for the data final 
 to calculate the mean of the variable f1 by &category.  %ELSE %IF &category =ClassAge
 %THEN %DO PROC MEANS for the data final to calculate the mean of the variable f2 by &category.
************************************************************************;
%MACRO class(category);
    %IF &category = Gender %THEN %DO;
        PROC MEANS DATA=final MEAN NOPRINT;
            VAR f1;
            CLASS &category;
            OUTPUT OUT=mean_f1 MEAN=mean_f1;
        RUN;
        PROC PRINT DATA=mean_f1;
            TITLE "Mean of f1 by &category";
        RUN;
    %END;
    %ELSE %IF &category = ClassAge %THEN %DO;
        PROC MEANS DATA=final MEAN NOPRINT;
            VAR f2;
            CLASS &category;
            OUTPUT OUT=mean_f2 MEAN=mean_f2;
        RUN;
        PROC PRINT DATA=mean_f2;
            TITLE "Mean of f2 by &category";
        RUN;
    %END;

%MEND;

************************************************************************
7.Call the macro %class(category=Gender)
************************************************************************;

%class(category=Gender);



************************************************************************
8.Call the macro %class(category=ClassAge)
************************************************************************;

%class(category=ClassAge);


************************************************************************
Problem 2: Visualization
1.Read the data 2010-2015-Age65above
Final Death Count.csv' with INPUT year month  gender $ age  ICD10 $ death
Name the data as death_count.
************************************************************************;

DATA death_count;
    INFILE '/home/u63743369/week6/2010-2015-Age65above Final Death Count (2).csv' DLM=',' FIRSTOBS=2;
    INPUT year month gender $ age ICD10 $ death;
RUN;


************************************************************************
2.Use PROC MEANS to get the total death of each year. Create a horizontal Bar Chart for the total death of each year.
************************************************************************;

PROC MEANS DATA=death_count SUM;
    CLASS year;
    VAR death;
    OUTPUT OUT=yearly_death_count SUM=total_death;
RUN;

PROC SGPLOT DATA=yearly_death_count;
    HBAR year / RESPONSE=total_death
                 DATALABEL;
    TITLE 'Total Death Count by Year';
RUN;

************************************************************************
3.Use PROC MEANS to get total death by ICD10. Create a scatter plot
for the total death by ICD 10. Label the x-axis as ‘Death Code’,
y-axis as ‘Total Death’, and save the graph as ‘Scatter plot total death by Death Code.png’
************************************************************************;

PROC MEANS DATA=death_count SUM;
    CLASS ICD10;
    VAR death;
    OUTPUT OUT=icd10_death_count SUM=total_death;
RUN;

PROC SGPLOT DATA=icd10_death_count;
    SCATTER x=ICD10 y=total_death / DATALABEL;
    XAXIS LABEL='Death Code';
    YAXIS LABEL='Total Death';
    TITLE 'Total Death by ICD10';
RUN;

************************************************************************
4.Create a histogram for the death where the ICD=52.
************************************************************************;

data death_icd52;
  set death_count;
  where ICD10 = '52';
run;

proc univariate data=death_icd52;
  histogram death / binwidth=1000;
  title 'Histogram of Death with ICD10 Code 52';
run;

************************************************************************
5.Create a vertical box plot for the death with category =gender.
************************************************************************;

proc sgplot data=death_count;
  vbox death / category=gender;
  xaxis label='Gender';
  yaxis label='Death Count';
  title 'Vertical Box Plot of Death by Gender';
run;

************************************************************************
6.Create a horizontal box plot for the death with category =month. 
Save the graph as ‘Boxplot death by month.png’.
************************************************************************;

proc sgplot data=death_count;
  hbox death / category=month;
  xaxis label='Death Count';
  yaxis label='Month';
  title 'Horizontal Box Plot of Death by Month';
run;
























