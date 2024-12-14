#import pandas as pd 
from itertools import product 
with open("input.txt",'r') as file:
    pairs_list = [line.strip().split(':') for line in file]
    pairs_list = [[item[0],item[1].split()] for  item in pairs_list]
#print(pairs_list)

def good_combos(num_list):
    result = int(num_list[0])
    numbers =  num_list[1]
    operators = ['+','*']
    operator_combinations = product(operators, repeat=len(numbers) - 1)
    # Create expressions by placing operators between the numbers
    #expressions = []
    for op_comb in operator_combinations:
        # Combine numbers and operators into an expression
        # print(op_comb)
        # ('+', '+', '+')
        # ('+', '+', '*')
        # ('+', '*', '+')
        # ('+', '*', '*')
        # ('*', '+', '+')
        # ('*', '+', '*')
        # ('*', '*', '+')
        # ('*', '*', '*')
        expression = numbers[0]
        for i, op in enumerate(op_comb):
            expression = f"({expression}{op}{numbers[i + 1]})"
        #expression = "".join(num + op for num, op in zip(numbers, op_comb + ('',)))
        #print(expression)
        if eval(expression) == result:
            #print(expression)
            return True,result
        #expressions.append(expression)
    return False,result

result = 0
for num_list in pairs_list:
    is_good,res = good_combos(num_list)
    if is_good:
        result += res 
print(result)
#303876485655
print(303876485655-303876515419)
#29764


#303876515419