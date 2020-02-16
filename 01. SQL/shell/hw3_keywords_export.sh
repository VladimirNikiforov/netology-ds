#!/usr/bin/env bash
#Filename: hw3_keywords_export.sh

echo "Выгружаем таблицу в текстовый файл с разделителями - табуляцией..."
psql -U postgres -c "\copy (select * from top_rated_tags) to '/usr/local/share/netology/raw_data/top_rated_tags.tsv' with delimiter as E'\t'"