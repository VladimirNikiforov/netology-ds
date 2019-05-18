# coding: utf-8

import pytest
from validations import age_is_correct


@pytest.mark.parametrize(
	'age,expected',
	[
		('15', True),
		('121', False),
		('-5', False),
		pytest.param(20, True, marks=pytest.mark.xfail(raises=TypeError)),
	])
def test_age_is_correct(age, expected):
	assert expected == age_is_correct(age)
