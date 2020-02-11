SELECT 'ФИО: Никифоров Владимир' as FIO;

-- запрос 1.1
SELECT * FROM ratings LIMIT 10;

-- запрос 1.2
SELECT * FROM links where movieid between 100 and 1000 and imdbid like '%42' LIMIT 10;

-- запрос 2.1
SELECT l.imdbid
  FROM public.links as l
  JOIN public.ratings as r
    ON l.movieid = r.movieid and r.rating = 5
LIMIT 10;

-- запрос 3.1
SELECT count(l.movieid) as cnt
  FROM public.links l
  LEFT JOIN public.ratings r
    ON l.movieid = r.movieid
 WHERE r.movieid IS NULL;

-- запрос 3.2
SELECT userId,
       AVG(rating) as avg_rating
  FROM public.ratings
 GROUP BY userId
HAVING AVG(rating) > 3.5
ORDER BY avg_rating DESC
 LIMIT 10;

-- запрос 4.1
SELECT l.imdbid
  FROM public.links l
 WHERE l.movieid in (SELECT r.movieid
                       FROM public.ratings r
                      GROUP BY r.movieid
                     HAVING AVG(r.rating) > 3.5)
 LIMIT 10;

-- запрос 4.2
WITH tmp_table as (SELECT r.userid
                     FROM public.ratings r
                    GROUP BY r.userid
                   HAVING count(r.rating) > 10
                  )
SELECT AVG(r.rating) as avg_rating
  FROM tmp_table t
  JOIN public.ratings r on t.userid = r.userid;