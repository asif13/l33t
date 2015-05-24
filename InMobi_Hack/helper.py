from api.nova_api import nova_api as Nova
import json
from data_structure.server import Server
from api.ceilometer_api import ceilometer_api as Ceilometer
from data_structure.statistics import Statistics
from data_structure.sample import Sample

nova = Nova()
ceilometer = Ceilometer()


def get_server_list():
    server_list = nova.get_server_list()
    new_server_list = []
    for server in server_list:
        new_server = Server(name=server.name, resource_id=server.id)
        new_server_list.append(new_server.__dict__)
    return json.dumps(new_server_list)

def get_statistics(resource_id, meter):
    stat_list = []
    for stat in ceilometer.get_statistics(meter, resource_id):
        print(stat)
        new_stat = Statistics(count= stat.count, duration_start=stat.duration_start,
                              duration_end=stat.duration_end,mi=stat.min,ma=stat.max,
                              avg=stat.avg,sum = stat.sum)
        stat_list.append(new_stat.__dict__)
    
    return json.dumps(stat_list)

def get_sample_for_util(resource_id):
    samp_list = []
    for sample in ceilometer.get_cpu_util_sample(resource_id):
        print(sample)
        new_sample = Sample(counter_name=sample.counter_name,resource_id=sample.resource_id,
                            timestamp=sample.timestamp,counter_volume=sample.counter_volume)
        samp_list.append(new_sample.__dict__)
        #samp_list.append(new_stat.__dict__)
    return json.dumps(samp_list)
    
    
        