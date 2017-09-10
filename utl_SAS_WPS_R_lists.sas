R lists are a nice addition to SAS processing ( IML/R or WPS/Proc/R)

In simulation studies you might want to generate hundreds of
matricies for further analysis.

This is a simple dumb example use an R list structure.

   WORKING CODE
     SAS/IML/R WPS/PROC R

        samples <- lapply(1:4, (function(x) { x*have} ) );
        averages <- as.data.frame(sapply(samples, mean));


HAVE

SD1.HAVE total obs=3

 Obs    V1    V2    V3

  1      4     1     1
  2      1     4     1
  3      1     1     4

WANT  (4 matrices and their means - change '1:4' to '1:100' and get 100 matrices )
====

  Create a 'list' of matrices using arbitrary functions
  operating on all elements of the original 'have' matrix.


[[1]]
     V1 V2 V3   * element mutiplication by 1 (could be a more complex operation)
[1,]  4  1  1
[2,]  1  4  1
[3,]  1  1  4   mean = (3*4 + 6)/9 = 18/2 = 2

[[2]]
     V1 V2 V3   * element mutiplication by 2
[1,]  8  2  2
[2,]  2  8  2
[3,]  2  2  8   mean 4

[[3]]
     V1 V2 V3
[1,] 12  3  3   * element mutiplication by 3
[2,]  3 12  3
[3,]  3  3 12   mean 6

[[4]]
     V1 V2 V3
[1,] 16  4  4
[2,]  4 16  4
[3,]  4  4 16  mean 8

SAS datset WORK.AVERAGES total obs=4

obs    MEANS

1       2
2       4
3       6
4       8

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|
;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input V1 V2 V3;
cards2;
4 1 1
1 4 1
1 1 4
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|
*____
|  _ \
| |_) |
|  _ <
|_| \_\

;

%utl_submit_r64('
source("c:/Program Files/R/R-3.3.2/etc/Rprofile.site",echo=T);
library(haven);
have<-as.matrix(read_sas("d:/sd1/have.sas7bdat"));
samples <- lapply(1:4, (function(x){
  x*have
}));
samples;
averages <- as.data.frame(sapply(samples, mean));
colnames(averages)=c("means");
str(averages);
averages;
');

*                                              ______
__      ___ __  ___    _ __  _ __ ___   ___   / /  _ \
\ \ /\ / / '_ \/ __|  | '_ \| '__/ _ \ / __| / /| |_) |
 \ V  V /| |_) \__ \  | |_) | | | (_) | (__ / / |  _ <
  \_/\_/ | .__/|___/  | .__/|_|  \___/ \___/_/  |_| \_\
         |_|          |_|
;

%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have<-as.matrix(read_sas("d:/sd1/have.sas7bdat"));
samples <- lapply(1:4, (function(x){
  x*have
}));
samples;
averages <- as.data.frame(sapply(samples, mean));
colnames(averages)=c("means");
str(averages);
averages;
endsubmit;
import r=averages  data=wrk.averages;
run;quit;
');


 > source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
> .libPaths(c(.libPaths(), "d:/3.3.2", "d:/3.3.2_usr"))
> options(help_type = "html")
> library(haven);
> have<-as.matrix(read_sas("d:/sd1/have.sas7bdat"));
> samples <- lapply(1:4, (function(x){  x*have}));
> samples;
> averages <- as.data.frame(sapply(samples, mean));
> colnames(averages)=c("means");
> str(averages);
> averages;

NOTE: Processing of R statements complete

15        import r=averages  data=wrk.averages;
NOTE: Creating data set 'WRK.averages' from R data frame 'averages'
NOTE: Column names modified during import of 'averages'


The WPS System

[[1]]
     V1 V2 V3
[1,]  4  1  1
[2,]  1  4  1
[3,]  1  1  4
[[2]]
     V1 V2 V3
[1,]  8  2  2
[2,]  2  8  2
[3,]  2  2  8
[[3]]
     V1 V2 V3
[1,] 12  3  3
[2,]  3 12  3
[3,]  3  3 12
[[4]]
     V1 V2 V3
[1,] 16  4  4
[2,]  4 16  4
[3,]  4  4 16
'data.frame':	4 obs. of  1 variable:
 $ means: num  2 4 6 8
  means
1     2
2     4
3     6
4     8





