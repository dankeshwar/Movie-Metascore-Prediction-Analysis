title 'MOVIE METASCORE PREDICTION';

proc import datafile= 'D:\Users\hyadaval\Downloads\imdb-data\movie_data.csv'
DBMS = CSV
out = movie
replace;

proc print data = movie;
run;


data movie;
set movie;
log_rev= log(Revenue__Millions_);
run;
/**/
/*proc univariate data = movie normal plot;*/
/*var log_rev ;*/
/*run;*/

data outliers;
set movie;
if (log_rev > 0.632) then output;
run;


data outliers;
set outliers;
logvotes= log(votes);
run;

data outliers;
set outliers;
if (logvotes > 9.105) then output;
run;


data outliers;
set outliers;
if (Runtime__Minutes_ < 134.5) then output;
run;


data outliers;
set outliers;
if (rating > 4.05) then output;
run;

proc univariate data = outliers normal plot;
var logvotes log_rev Runtime__Minutes_ rating metascore ;
run;


/* DATA CLEANING COMPLETED  */





/*proc univariate data = movie normal plot;*/
/*var Runtime__Minutes_ ;*/
/*run;*/


/*data outliers;*/
/*set outliers;*/
/*if (Runtime__Minutes_ < 153) then output;*/
/*run;*/


/*data outliers;*/
/*set outliers;*/
/*logvotes= log(votes);*/
/*run;*/


/*data outliers;*/
/*set outliers;*/
/*if (logvotes > 9.105) then output;*/
/*run;*/

/*proc univariate data = outliers normal plot;*/
/*var rating Runtime__Minutes_ logvotes metascore;*/
/*run;*/



/*
data outliers;
set outliers;
if (logvotes > 9.3) then output;
run;
*/
/*
proc univariate data = outliers normal plot;
var rating Runtime__Minutes_ logvotes metascore;
run;
*/



proc print data= outliers;
run;




/*data outliers;*/
/*set outliers;*/
/*if (Revenue__Millions_ < 187.5) then output;*/
/*run;*/
/**/
/**/
/*proc univariate data=outliers normal plot;*/
/*var Revenue__Millions_;*/
/*run;*/
/**/
/**/


/*
data outliers;
set outliers;
if ( logr > 1.35) then output;
run;
*/
/*
proc univariate data = outliers normal plot;
var logr;
run;
*/
/**/
/*proc print data= outliers;*/
/*run;*/


/**/
/*data outliers;*/
/*set outliers;*/
/*if (rating > 4.05) then output;*/
/*run;*/



/*proc univariate data = outliers normal plot;*/
/*var rating; */
/*run;*/


proc surveyselect data = outliers samprate=0.8 out = sample outall method = srs;
run;

proc print data = sample;
run;

data train ;
set sample;
if (selected = 1) then output;
run;


data test ;
set sample;
if (selected = 0) then output;
run;

proc print data=train;
run;

/*proc reg data=train;*/
/*model  metascore = logvotes log_rev Runtime__Minutes_ rating / tol vif collin ; */
/*plot r.*p.;*/
/*run;*/

proc reg data=train;
model  metascore =  rating / tol vif collin ; 
plot r.*p.;
run;

data test;
set test;
y_bar = -48.46298 + (15.72861*rating);
Predicted_err = (( rating - y_bar) ** 2);
run;
/*
data test;
set test;
Revenue_Final = EXP(y_bar);
run;
*/

proc print data = test;
run;

proc means data=test;
var predicted_err;
run;
