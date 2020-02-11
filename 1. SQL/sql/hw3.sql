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

-- Предварительно удаляем таблицу keywords при ее наличии...
DROP TABLE IF EXISTS keywords;
-- 1. Создаем таблицу keywords
CREATE TABLE keywords ( id bigint, tags varchar(32000) );

-- Копирование данных из файла в созданную таблицу
\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER


-- transform by CTE
WITH top_rated as (SELECT movieId, AVG(rating) avg_rating
                     FROM ratings
                    GROUP BY movieId
                   HAVING COUNT(distinct userid) > 50
                    ORDER BY avg_rating DESC, movieId ASC
                    LIMIT 150
                  )
SELECT t.movieId, t.avg_rating, k.tags
  FROM top_rated t
  JOIN keywords k on t.movieId = k.id
 ORDER BY avg_rating DESC, movieId ASC;


-- ЗАПРОС3. Load into table TOP_RATED_TAGS
WITH top_rated as (SELECT movieId, AVG(rating) avg_rating
                     FROM ratings
                    GROUP BY movieId
                   HAVING COUNT(distinct userid) > 50
                    ORDER BY avg_rating DESC, movieId ASC
                    LIMIT 150
                  )
SELECT t.movieId, k.tags top_rated_tags
  INTO top_rated_tags
  FROM top_rated t
  JOIN keywords k on t.movieId = k.id
 ORDER BY avg_rating DESC, movieId ASC;

-- Выгружаем таблицу в текстовый файл с разделителями - табуляцией
\copy (select * from top_rated_tags) to '/usr/local/share/netology/raw_data/top_rated_tags.tsv' with delimiter as E'\t'