from itertools import product
import re
import os 
os.chdir(os.path.dirname(os.path.abspath(__file__)))
with open("input.txt",'r') as file:
    pairs_list = [line.strip().split(':') for line in file]
    pairs_list = [[item[0],item[1].split()] for  item in pairs_list]
#print(pairs_list)

def good_combos(num_list):
    result = int(num_list[0])
    numbers =  num_list[1]
    operators = ['+','*','']
    operator_combinations = product(operators, repeat=len(numbers) - 1)
    # Create expressions by placing operators between the numbers
    #expressions = []
    for op_comb in operator_combinations:
        # Combine numbers and operators into an expression
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
            if op == '':
                if op == '':
                    #expression = re.sub(r'^\((.*)\)$', r'\1', expression)
                    expression = eval(f"{expression}{numbers[i + 1]}")
            else:
                expression = eval(f"({expression}{op}{numbers[i + 1]})")
        #expression = "".join(num + op for num, op in zip(numbers, op_comb + ('',)))
        if expression == result:
            #print(expression)
            return True,result
        #expressions.append(expression)
    return False,result

result = 0
for k,num_list in enumerate(pairs_list):
    print(f"on list {k}")
    is_good,res = good_combos(num_list)
    if is_good:
        result += res 
print(result)