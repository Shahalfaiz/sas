************************************************************************
*Problem 1: PROC UNIVARIATE
Read the Data set school 2 final.csv'.Name it as  s2f.  Then do the following analysis:
Use PROC UNIVARIATE to analyze the variables f1, f2, f3, f4. Which variable is normal?
Which variable is right-skewed? Which variable is left-skewed?;
************************************************************************;
proc import datafile='/home/u63743369/week7/school 2 final.csv'  out=s2f replace;
run;

proc univariate data=s2f;
   var f1 f2 f3 f4;
   histogram / normal;
run;

************************************************************************
Variable f1 appears to follow a normal distribution.
Variable f2 is left-skewed.
Variables f3 and f4 do not appear to follow a normal distribution;
************************************************************************;



************************************************************************
2.Use PROC UNIVARIATE with option plot to graph the histogram, box-plot, 
and Normal Probability Plot for the variable f3. And only print the graphs.;
************************************************************************;

ODS SELECT Histogram BoxPlot QQPlot PLOTS;
proc univariate data=s2f PLOT;
    var f3;
run;


************************************************************************
3.Add a new variable difference defined as difference=f4-f2. Analyze 
the variable difference and graph its histogram, Boxplot, qqplot.
 Print only the TestsNormality and TestsForLocation. Does the mean of 
 the variable difference equal to 0 statistically?;
************************************************************************;

data s2f;
    set s2f;
    difference = f4 - f2;
run;
ODS SELECT PLOTS;

proc univariate data=s2f plot;
    var difference; 
    ODS SELECT TestsNormality TestsForLocation;
run;

****************************************************************
*the mean of the variable "difference" is not equal to 0.;
***************************************************************** 

************************************************************************
4.Use PROC UNIVARIATE to analyze the variable difference by Gender.
************************************************************************;

ods select BasicMeasures;
proc univariate data=s2f;
    class Gender;
run;

************************************************************************
5.For the variable difference, calculate custom percentiles from 5 to
 100 by 5 and export these percentiles to an xlsx file named percentiles.xlsx.
************************************************************************;

proc univariate data=s2f noprint;
    var difference;
    output out=percentiles pctlpre=P_ pctlpts=5 to 100 by 5;
run;
proc print data=percentiles;
run;
/* Export percentiles to an xlsx file */
proc export data=percentiles
    dbms=xlsx
    outfile='/home/u63743369/week7/percentiles.xlsx'
    replace;
run;

************************************************************************
*Problem 2: PROC TTEST
1.Two sections of a statistics course took a standardized final. 
Random samples were drawn from each section as follows:
               Section A: 65, 68, 75, 78, 70
               Section B: 50, 59, 71, 80, 65.;
************************************************************************;

data scores;
    input section $ score;
    datalines;
    A 65
    A 68
    A 75
    A 78
    A 70
    B 50
    B 59
    B 71
    B 80
    B 65
    ;
run;

proc ttest;
   class section;
   var score;
run;

*************************************************
Based on the test I did, I didn't find enough proof 
to say Section A is better than Section B. So, I can't agree with what the professor said.
***************************************************;



************************************************************************
3.An experiment is conducted to show that blood pressure levels can be 
consciously reduced in people trained in this program. The blood pressure 
measurements (in millimeters of mercury) listed in the table below represent 
readings before and after biofeedback training of six subjects."               
Do the data provide enough evidence to indicate that the mean blood 
pressure level decreases after training? Use α = 0.05.
************************************************************************;

data blood_pressure;
    input Before After;
    datalines;
136.9 130.2
201.4 180.7
166.8 149.6
150.0 153.2
173.2 162.6
169.3 160.1
;
run;

proc ttest;
    paired Before*After;
run;


************************************************************************
Problem 3: RPOC FREQ
In a study of the television viewing habits of children, a developmental 
psychologist selects a random sample of 300 first graders - 100 boys 
and 200 girls. Each child is asked which of the following TV programs they 
like best: The Lone Ranger, Sesame Street, or The Simpsons. The results are
 shown in the contingency table below.
************************************************************************;

data tv_viewing;
   input gender $ program $ count @@;
   datalines;
Boys Lone_Ranger 50  Boys Sesame_Street 30  Boys The_Simpsons 20
Girls Lone_Ranger 50 Girls Sesame_Street 80 Girls The_Simpsons 70
;
run;

proc print data=tv_viewing;
   title 'TV Viewing Habits of Children';
run;

proc freq data=tv_viewing;
   tables gender * program / chisq;
   title 'Chi-Square Test for Independence';
run;

*******************************************************************************************************
it appears that there are no significant differences in TV program preferences between boys and girls;
******************************************************************************************************;


















