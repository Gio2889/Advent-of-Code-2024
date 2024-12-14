# from itertools import product
# import re
# with open("test_input.txt",'r') as file:
#     pairs_list = [line.strip().split(':') for line in file]
#     pairs_list = [[item[0],item[1].split()] for  item in pairs_list]
# #print(pairs_list)

# def good_combos(num_list):
#     result = int(num_list[0])
#     numbers =  num_list[1]
#     print(num_list)
#     operators = ['+','*','']
#     operator_combinations = product(operators, repeat=len(numbers) - 1)
#     # Create expressions by placing operators between the numbers
#     #expressions = []
#     for op_comb in operator_combinations:
#         expression = numbers[0]
#         for i, op in enumerate(op_comb):
#             if op == '':
#                 expression = re.sub(r'^\((.*)\)$', r'\1', expression)
#                 expression = f"{expression}{numbers[i + 1]}"
#             else:
#                 expression = f"({expression}{op}{numbers[i + 1]})"
#         #print(expression)
#         #expression = "".join(num + op for num, op in zip(numbers, op_comb + ('',)))
#         #print(expression)
#         if eval(expression) == result:
#             print(expression)
#             return True,result
#         #expressions.append(expression)
    
#     return False,result

# result = 0
# for num_list in pairs_list:
#     is_good,res = good_combos(num_list)
#     if is_good:
#         result += res 
# print(result)

import re
from itertools import product, combinations

# Read input
with open("test_input.txt", 'r') as file:
    pairs_list = [line.strip().split(':') for line in file]
    pairs_list = [[item[0], item[1].split()] for item in pairs_list]

def group_combinations(numbers):
    """Generate all possible groupings of adjacent numbers."""
    if len(numbers) == 1:
        return [numbers]
    
    results = []
    for i in range(1, len(numbers) + 1):
        # Group the first `i` numbers
        left = numbers[:i]
        # Recurse for the remaining numbers
        for rest in group_combinations(numbers[i:]):
            results.append([left] + rest)
    return results

def flatten_group(group):
    """Flatten a nested group into a single string."""
    return ['*'.join(g) if isinstance(g, list) else g for g in group]

def good_combos(num_list):
    result = int(num_list[0])
    numbers = num_list[1]
    print(f"Checking: {num_list}")
    
    operators = ['+', '*', '']  # Include join operator
    groupings = group_combinations(numbers)
    print(groupings)
    
    for grouping in groupings:
        print(grouping)
        # Flatten grouped numbers
        # flattened = flatten_group(grouping)
        # print(flattened)
        operator_combinations = product(operators, repeat=len(grouping) - 1)
        
        for op_comb in operator_combinations:
            expression = grouping[0]
            for i, op in enumerate(op_comb):
                if op == '':
                    expression = re.sub(r'^\((.*)\)$', r'\1', expression)
                    expression = f"{expression}{grouping[i + 1]}"
                else:
                    expression = f"({expression}{op}{grouping[i + 1]})"
            
            # Evaluate the expression
            try:
                if eval(expression) == result:
                    print(f"Valid expression: {expression}")
                    return True, result
            except Exception as e:
                print(f"Skipping invalid expression: {expression} ({e})")
    
    return False, result

result = 0
for num_list in pairs_list:
    is_good, res = good_combos(num_list)
    if is_good:
        result += res
print(f"Total Result: {result}")
