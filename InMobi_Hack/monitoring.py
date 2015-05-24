from api.ceilometer_api import ceilometer_api as Ceilometer
from api.nova_api import nova_api as Nova
from data_structure.event import Event
import time

nova = Nova()
ceilometer = Ceilometer()


def get_monitoring_data(ultron):
    server_list = nova.get_server_list()
    for server in server_list:
        sample = ceilometer.get_cpu_util_sample(server.id)[0]
        event = Event(meter_type="cpu_util",resource_type="OS::Nova::Server",
                      resource_id=sample.resource_id,value=sample.counter_volume,
                      timestamp=sample.timestamp)
        ultron.set_event(event)
            
            
def monitor_instances(ultron):
    while True:
        get_monitoring_data(ultron)
        print("\n\n Polling so....waiting for 12 sec \n\n")
        time.sleep(12)
        
    