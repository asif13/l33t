from data_structure.if_condition import if_condition
from data_structure.rule import rule as Rule
from data_structure.save_me import save_me
import glob
import os
import json

def get_rule(path = "/home/ubuntu/rules/"):
    rule_list = []
    for filename in glob.glob(os.path.join(path,'*.json')):
        rule = create_rule(file_name = filename)
        rule_list.append(rule)
    return rule_list

def create_rule(file_name):
    print(file_name)
    try:
        with open(file_name,"r") as json_data:
            data = json.load(json_data)
            print(data)
            return create_obj(data)
    except IOError as err:
        print("File error cannot read file" + str(err))

            
def create_obj(data):
    if_condition_list = []
    for if_cond in data['if']:
        save = save_me(threshold=if_cond['save_me']['threshold'],operator=if_cond['save_me']['operator'],
                       meter_type=if_cond['save_me']['meter_type'])
        if_con = if_condition(save_me=save,resource_type=if_cond['resource_type'],
                              resource_id=if_cond['resource_id'])
        if_condition_list.append(if_con)
    
    then = data['then']
    rule = Rule(if_list = if_condition_list, then = then)
    return rule
        
    
        
    
print(get_rule())