

class Event(object):
    def __init__(self, meter_type, resource_type, resource_id, value, timestamp = None):
        self.meter_type = meter_type
        self.resource_type = resource_type
        self.resource_id = resource_id
        self.value = value
        self.timestamp = timestamp
