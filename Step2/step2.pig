d = LOAD '/project1/movietotal.dat' USING PigStorage('\t') as (Number:int, Movie:chararray, type:chararray, Total:float);

f = FILTER d BY (float)Total<100;
dump f;
store f into '/project1/result1';
