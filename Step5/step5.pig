d = LOAD '/project1/movietotal.dat' USING PigStorage('\t') as (Number:int, Movie:chararray, Type:chararray, Total:float);
grp = GROUP d BY Type;

--Mean Calculation
mean = foreach grp {
        sum = SUM(d.Total);
        count = COUNT(d.Movie);
        generate group, sum/count as avg, count as count;
};
dump mean;

--Standered Deviation
tmp = foreach mean {
    dif = (amnt - avg) * (amnt - avg) ;
     generate *, dif as dif;
};

grp = group tmp by Type;
standard_tmp = foreach grp generate flatten(tmp), SUM(tmp.dif) as sqr_sum;
standard = foreach standard_tmp generate *, sqr_sum / count as variance, SQRT(sqr_sum / count) as standard;
dump standard;

--Median
med = FOREACH grp GENERATE MEDIAN(d.Total);
dump med;
