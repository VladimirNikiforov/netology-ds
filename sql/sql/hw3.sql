SELECT 'ФИО: Никифоров Владимир' as FIO;

-- оконные функции
SELECT userId, movieId,
       case when MAX(rating) OVER (PARTITION BY userId) = MIN(rating) OVER (PARTITION BY userId) then 0
         else (rating - MIN(rating) OVER (PARTITION BY userId))/(MAX(rating) OVER (PARTITION BY userId) - MIN(rating) OVER (PARTITION BY userId))
       end normed_rating,
       AVG(rating) OVER (PARTITION BY userId) avg_rating
  FROM ratings
 ORDER BY userId, movieId
 LIMIT 30;

