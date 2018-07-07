d = LOAD '/project1/movieweekend.dat' USING PigStorage('\t') as (Number:int, Movies:chararray, Week_Num:int, Weekend_Per_Theater:int, Weekend_Date:chararray);


movie = GROUP d BY Movies;

num_weeks = FOREACH movie GENERATE group, COUNT(d.Movies);
--dump num_weeks;
store num_weeks into '/project1/result4a';

tot_col = FOREACH movie GENERATE group, SUM(d.Weekend_Per_Theater);
--dump tot_col;
store tot_col into '/project1/result4b';
