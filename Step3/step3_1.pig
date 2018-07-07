
d = LOAD '/project1/moviedaily.dat' USING PigStorage('\t') as (Number:int, Movie:chararray, Day_Num:int, Daily_Per_Theater:int, Date:chararray);
f = FILTER d BY (chararray)Date!='NA';
--store f into '/project1/result3';

--Average Per day collection
day_group = GROUP f by Date;
c = FOREACH day_group GENERATE group as Date, AVG(f.Daily_Per_Theater) as avg;
dump c;
--store c into '/project1/result3a';

--Movie Running for how many years
starting_date = FILTER f BY (int)Day_Num==1;
movie_group = GROUP f by Movie;
cnt = FOREACH movie_group GENERATE FLATTEN(f), MAX(f.Day_Num) as cou;
cnt1 = FILTER cnt BY f::Day_Num==cou;
ending_date = FOREACH cnt1 GENERATE $0, $1, $2, $3, $4;
joi = JOIN starting_date BY (Movie), ending_date BY(Movie);
Years_between = FOREACH joi GENERATE starting_date::Movie, DaysBetween(ToDate(ending_date::f::Date, 'MM/dd/yyyy'), ToDate(starting_date::Date, 'MM/dd/yyyy'));
dump Years_between;
--store Years_between into '/project1/result3b';

--max and min collection
gp = GROUP f by Movie;
total_collection1 = FOREACH gp GENERATE group as Movie, SUM(f.Daily_Per_Theater) as tot;
total_collection = group total_collection1 all;
max_collection = FOREACH total_collection GENERATE MAX(total_collection1.tot) as ma;
min_collection = FOREACH total_collection GENERATE MIN(total_collection1.tot) as mi;
max_movie = FILTER total_collection1 BY (float)tot == max_collection.ma;
min_movie = FILTER total_collection1 BY (float)tot == min_collection.mi;
--dump max_movie;
--dump min_movie;
store max_movie into '/project1/result3c';
store min_movie into '/project1/result3d';

--Top 10 Movies
ord = ORDER total_collection1 by tot DESC;
top_ten = limit ord 10;
dump top_ten;
store top_ten into '/project1/result3e';

--Sunday Collection task has been done using hive itself
