from api.nova_api import nova_api
from api.ceilometer_api import ceilometer_api

server_list = nova_api().get_server_list()
resource_list = ceilometer_api().get_all_resource_list()

for server in server_list:
    print(server.name)
    
for resource in resource_list:
    print(resource.name)