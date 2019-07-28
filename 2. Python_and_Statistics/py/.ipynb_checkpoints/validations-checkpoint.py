# coding: utf-8

def line_is_correct(line):
    """
    Проверка строки на корректность. Проверяются условия:
    1. В строке 15 столбцов (пригодится с упражнения)
    2. Столбец с возрастом первый по счету
    3. Возраст должен быть целым числом в адекватных пределах
    """
    age = line.strip().split(',')[0]
    
    if number_of_columns(line) == 15:
        if age_is_correct(age):
            return True
    
    return False


def number_of_columns(line, separator=','):
    """Возвращает количество столбцов в строке line с разделителем separator"""
    
    return len(line.split(separator))


def age_is_correct(age, lower_age = 0, upper_age = 120):
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


def age_classification(age):
    """
    Возвращает возрастную категорию для возраста age (можно передать как строку).
    Классификация категорий:
        - до 18 лет - children 
        - 19-60 - young
        - старше 65 - retiree
    
    Пример
    age_classification('18')
    'children'
    
    age_classification(65)
    'retiree'
    """
    
    if int(age) <= 18:
        return 'children'

    if int(age) <= 65:
        return 'young'

    if int(age) > 65:
        return 'retiree'

    return 'boom'

