# coding: utf-8

# Изменения поля Возраст в словаре студентов вида:
# {No: [ФИО, Возраст, Группа], No:[....], No: [....]}

import sys
import json

# Needs two parameters
assert(sys.argv[0] == 2)

fio = sys.argv[1]
new_age = sys.argv[2]

def age_is_correct(age, lower_age = 1, upper_age = 120):
    """
    Проверка корректности возраста age по следующим правилам:
    1. Целое число
    2. В адекватных пределах
    
    Возвращает True или False. Пример
    age_is_correct(15)
    True
    
    age_is_correct(121)
    False
    
    age_is_correct(-5)
    False
    """
    
    # if str.isnumeric(age):
    if lower_age <= int(age) <= upper_age:
        return True
    
    return False

assert(len(fio) > 0)
assert(age_is_correct(new_age))

l_students_dict = json.load( open( "../data/l_students_dict.json" ) )

for k, v in l_students_dict.items():
    if v[0] == fio:
        l_students_dict[k][1] = int(new_age)
        
print(l_students_dict)