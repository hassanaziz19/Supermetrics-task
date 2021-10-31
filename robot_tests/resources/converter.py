"""
Function takes string as an input then converts it to ASCII numbers and returns the sum of numbers.
"""

def return_sum_of_ascii(cat_name):
    lst = [ord(i) for i in str(cat_name)]
    return sum(lst)