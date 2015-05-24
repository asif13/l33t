from rule_parser import get_rule
from monitoring import monitor_instances
from api.nova_api import nova_api as Nova
import time



class Ultron(object):
    def __init__(self, rule_list = []):
        self.rule_list = rule_list
        self.event = None
        self.previous_time_stamp = None
        
    def set_rule_list(self, rule_list):
        self.rule_list = rule_list
    
    def set_event(self, event):
        self.event = event
        print("Got an event ---> I am on a roll")
        self.compare_event()
        
    
    def compare_event(self): 
        for rule in self.rule_list:
            for if_con in rule.if_list:
                if self.compare_condition(condition = if_con) == True:
                    self.create_result(rule = rule)
                    print("\n\n I think i found something...\n\n")
                    return True
                else:
                    print("\n Nothing so far \n")
                    continue
                    
        return False
                
                
                
    
    def compare_condition(self,condition):
        if condition.resource_id != self.event.resource_id:
            return False
        else:
            return self.check_save_me(condition.save_me)
        
    def check_save_me(self,save_me):
        if save_me.operator == 'ge':
            print(save_me.threshold)
            print(self.event.value)
            if str(save_me.meter_type) == str(self.event.meter_type) and int(save_me.threshold) < int(self.event.value):
                return True
            else:
                return False
        elif save_me.operator == 'le':
            if str(save_me.meter_type) == str(self.event.meter_type) and int(save_me.threshold) > int(self.event.value):
                return True
            else:
                return False
        
        
        
        
    def create_result(self,rule):
        print("create result time")
        Nova().create_instance()
        print("\n\n NEW Instance Created ... Give me 5 min\n\n to get the monitoring data\n\n")
        time.sleep(300)
        pass
    


ultron = Ultron()
rule_list = get_rule()
ultron.set_rule_list(rule_list)
monitor_instances(ultron)

