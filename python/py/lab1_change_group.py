# coding: utf-8

# Изменения поля Группа в словаре студентов вида:
# {No: [ФИО, Возраст, Группа], No:[....], No: [....]}

import sys
import json

# Needs two parameters
assert(sys.argv[0] == 2)

fio = sys.argv[1]
new_group = sys.argv[2]

assert(len(fio) > 0)
assert(len(new_group) > 0)

l_students_dict = json.load( open( "../data/l_students_dict.json" ) )

for k, v in l_students_dict.items():
    if v[0] == fio:
        l_students_dict[k][2] = new_group
        
print(l_students_dict)