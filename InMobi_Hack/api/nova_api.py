from os import environ as env
from novaclient.client import Client


class nova_api():
    def __init__(self):
        self.nova_client = None
        
    def get_nova_client(self):
        if self.nova_client is None:
            self.nova_client = Client("1.1",auth_url = env['OS_AUTH_URL'],
                                username = env['OS_USERNAME'],
                                api_key = env['OS_PASSWORD'],
                                project_id = env['OS_TENANT_NAME'])
        return self.nova_client
    
    def get_server_list(self):
        nova_client = self.get_nova_client()
        return nova_client.servers.list()
    
    def create_instance(self):
        nova_client = self.get_nova_client()
        fl = nova_client.flavors.find(ram=64)
        nova_client.servers.create("new_server",flavor = fl, image = "5b6c9f20-4413-48c6-909a-5069e88bdbe0")
        
        
