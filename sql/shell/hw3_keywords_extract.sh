#!/usr/bin/env bash
#Filename: hw3_keywords_extract.sh

echo "Предварительно удаляем таблицу keywords при ее наличии..."
psql -U postgres -c "DROP TABLE IF EXISTS keywords"

echo "1. Создаем таблицу keywords..."
psql -U postgres -c "CREATE TABLE keywords ( id bigint, tags varchar(32000) );"

echo "2. Копирование данных из файла в созданную таблицу"
psql -U postgres -c "\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER"

echo "3. Проверяем, что в таблице есть записи"
psql -U postgres -c "SELECT COUNT(*) FROM keywords;"