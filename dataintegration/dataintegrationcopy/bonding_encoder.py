from json import JSONEncoder
import numpy


class BondingEncoder(JSONEncoder):
        def default(self, o):
            if isinstance(o, numpy.generic):
                return numpy.asscalar(o)
            return o.__dict__
