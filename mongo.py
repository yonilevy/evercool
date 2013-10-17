import os
import pymongo

mongo = pymongo.Connection(os.getenv('MONGOHQ_URL'))['evercool']