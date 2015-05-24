from ceilometerclient import client
from os import environ as env


class ceilometer_api():
    def __init__(self):
        self.keystone = {}
        self.keystone['os_username'] = env['OS_USERNAME']
        self.keystone['os_password'] = env['OS_PASSWORD']
        self.keystone['os_auth_url'] = env['OS_AUTH_URL']
        self.keystone['os_tenant_name'] = env['OS_TENANT_NAME']
        self.ceilometer_client = None

    def get_ceilometer_client(self):
        if self.ceilometer_client is None:
            self.ceilometer_client = client.get_client(2,**self.keystone)
        return self.ceilometer_client
    
    def get_all_resource_list(self):
        ceilometer_client = self.get_ceilometer_client()
        return ceilometer_client.resources.list()
    
    def get_resource_details(self,resource_id):
        ceilometer_client = self.get_ceilometer_client()
        return ceilometer_client.resources.get(resource_id)
    
    def get_statistics(self, meter_name, resource_id = None):
        ceilometer_client = self.get_ceilometer_client()
        if resource_id is None:
            return ceilometer_client.statistics.list(meter_name)
        elif resource_id is not None:
            query = self.make_query(resource_id = resource_id)
            return ceilometer_client.statistics.list(meter_name,q=query)
    

    def get_sample_list(self,meter_name, resource_id = None):
        ceilometer_client = self.get_ceilometer_client()
        if resource_id is None:
            return ceilometer_client.samples.list(meter_name)
        elif resource_id is not None:
            query = self.make_query(resource_id = resource_id)
            return ceilometer_client.samples.list(meter_name,q = query)


    def get_alarm_list(self):
        ceilometer_client = self.get_ceilometer_client()
        return ceilometer_client.alarms.list()
    
    def alarm_create(self,name,description,alarm_action,ok_action,insufficient_data_actions,resource_id ,meter_name = "cpu_util",period = 300,statistic = "avg",
                     comparison_operator = "ge",threshold = 2.0,repeat_actions = True):
        ceilometer_client = self.get_ceilometer_client()
        query = self.make_query(resource_id = resource_id)
        return ceilometer_client.alarms.create(name = name, description = description, alarm_action = alarm_action, ok_action = ok_action,
                                        insufficient_data_action = insufficient_data_actions,query = query, meter_name = meter_name,
                                        period = period,statistic = statistic, comparison_operator = comparison_operator, threshold = threshold,
                                         repeat_actions = repeat_actions)
        
    
    def get_cpu_util_stats(self,resource_id = None):
        return self.get_statistics("cpu_util", resource_id)
    
    def get_cpu_util_sample(self, resource_id = None):
        return self.get_sample_list("cpu_util", resource_id)

    def get_disk_read_bytes_stats(self,resource_id = None):
        return self.get_statistics("disk.read.bytes", resource_id)
    
    def get_disk_read_request_rate_stats(self,resource_id = None):
        return self.get_statistics("disk.read.requests.rate", resource_id)
    
    def get_disk_write_request_rate_stats(self,resource_id = None):
        return self.get_statistics("disk.write.requests.rate", resource_id)
    '''
    def get_memory_usage_stats(self,resource_id = None):
        return 
    '''
    
    def get_disk_write_bytes_stats(self, resource_id = None):
        return self.get_statistics("disk.write.bytes", resource_id)
    
    def get_network_incoming_bytes_stats(self, resource_id = None):
        return self.get_statistics("network.incoming.bytes.rate", resource_id)
    
    def get_network_outgoing_bytes_stats(self, resource_id = None):
        return self.get_statistics("network.outgoing.bytes.rate", resource_id)
    
    '''
 the method make_query has been copied from horizon_ceilometer_api.py
 this method is used to create a query type data structure as explained in the docs
 this query can be passed as a parameter in the api request
    '''
    
    def make_query(self,user_id=None, tenant_id=None, resource_id=None,
        user_ids=None, tenant_ids=None, resource_ids=None):
        """Returns query built form given parameters.

        This query can be then used for querying resources, meters and
        statistics.

        :Parameters:
          - `user_id`: user_id, has a priority over list of ids
          - `tenant_id`: tenant_id, has a priority over list of ids
          - `resource_id`: resource_id, has a priority over list of ids
          - `user_ids`: list of user_ids
          - `tenant_ids`: list of tenant_ids
          - `resource_ids`: list of resource_ids
        """
        user_ids = user_ids or []
        tenant_ids = tenant_ids or []
        resource_ids = resource_ids or []

        query = []
        if user_id:
            user_ids = [user_id]
            for u_id in user_ids:
                query.append({"field": "user_id", "op": "eq", "value": u_id})

        if tenant_id:
            tenant_ids = [tenant_id]
            for t_id in tenant_ids:
                query.append({"field": "project_id", "op": "eq", "value": t_id})

        if resource_id:
            resource_ids = [resource_id]
            for r_id in resource_ids:
                query.append({"field": "resource_id", "op": "eq", "value": r_id})

                return query
            
        
        

