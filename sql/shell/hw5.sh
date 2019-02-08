#!/usr/bin/env bash

# команда для загрузки файла в MONGO
/usr/bin/mongoimport --db movies --collection tags --file $NETOLOGY_DATA/raw_data/simple_tags.json

# в файле agg.js три задачи
# - подсчитайте число элементов в созданной коллекции
# - подсчитайте число фильмов с конкретным тегом - `woman`
# - используя группировку данных ($groupby) вывести top-3 самых распространённых тегов
/usr/bin/mongo movies ./agg.js