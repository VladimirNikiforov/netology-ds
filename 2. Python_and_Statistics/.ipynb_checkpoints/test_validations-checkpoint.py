# coding: utf-8

from validations import number_of_columns
from validations import age_is_correct
from validations import line_is_correct
from validations import age_classification

import pytest


def test_number_of_columns():
	assert number_of_columns('25,Private,226802,11th,7,Never-married,Machine-op-inspct,Own-child,Black,Male,0,0,40,United-States,<=50K') == 15
	assert number_of_columns('25;Private;226802', separator=';') == 3

	# внезапно
	assert number_of_columns('') == 1


def test_age_is_correct():
	assert age_is_correct('15') == True
	assert age_is_correct('121') == False
	assert age_is_correct('-5') == False


def test_line_is_correct():
	assert line_is_correct('25,Private,226802,11th,7,Never-married,Machine-op-inspct,Own-child,Black,Male,0,0,40,United-States,<=50K') == True

	# столбцов меньше, чем надо
	assert line_is_correct('25,Private,226802,11th,7,Never-married,Machine-op-inspct,Own-child,Black,Male,0,0,40,United-States') == False

	# возраст меньше нижней границы
	assert line_is_correct('-2,Private,226802,11th,7,Never-married,Machine-op-inspct,Own-child,Black,Male,0,0,40,United-States') == False

	# возраст выше верхней границы
	assert line_is_correct('121,Private,226802,11th,7,Never-married,Machine-op-inspct,Own-child,Black,Male,0,0,40,United-States') == False


def test_age_classification():
	assert age_classification('18') == 'children'
	assert age_classification(2) == 'children'

	assert age_classification(35) == 'young'
	assert age_classification(75) == 'retiree'
