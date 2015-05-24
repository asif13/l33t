from flask import Flask
from flask import request
from helper import get_server_list
from helper import get_statistics
from helper import get_sample_for_util

class Orchestrator(object):
    def __init__(self):
        pass
    
    def server_list(self):
        return get_server_list()
    
    def get_stats(self,resource_id, meter):
        return get_statistics(resource_id, meter)
    
    def get_sample_list(self, resource_id):
        return get_sample_for_util(resource_id)        


orchestra = Orchestrator()
app = Flask(__name__)


@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response

@app.route("/server", methods = ['GET'])
def server_list():
    if request.method == 'GET':
        server_list = orchestra.server_list()
        return server_list

@app.route("/stats", methods = ['GET'])
def get_stats():
    if request.method == 'GET':
        stats = orchestra.get_stats(request.args['id'],request.args['meter'])
        return stats
    
@app.route("/sample", methods = ['GET'])
def get_sample():
    if request.method == 'GET':
        sample = orchestra.get_sample_list(request.args['id'])
        return sample
    
app.debug = True
app.run(host = "0.0.0.0", port = 8123)