from importlib import import_module

from pymongo import MongoClient
from bson import ObjectId
import datetime


class MyPyMongo:

    def __init__(self, user, password, host, port):
        self._user = user
        self._password = password
        self._host = host
        self._port = port
        self._db = None
        self._collection = None
        self._conn = None

    def conn(self, database):
        self._conn = MongoClient(host=self._host, port=self._port)
        self._db = self._conn[database]

    def changeCollection(self, collection):
        self._collection = self._db[collection]

    def findOne(self, filter, projection):
        if projection == {}:
            result = self._collection.find_one(filter=filter)
        else:
            result = self._collection.find_one(filter=filter, projection=projection)

        return result

    def find(self, filter, projection):
        if projection == {}:
            results = self._collection.find(filter=filter)
        else:
            results = self._collection.find(filter=filter, projection=projection)

        return results

    def insertOne(self, data):
        result = self._collection.insert_one(data)
        return result.inserted_id

    def count(self, filter=None):
        if filter is not None:
            result = self._collection.find(filter=filter).count()
        else:
            result = self._collection.find({}).count()

        return result

    def distinct(self, field, filter=None):
        if filter is not None:
            return self._collection.distinct(field, filter=filter)
        else:
            return self._collection.distinct(field)

    def update_one(self, filter, update_type, update_dict):
        if update_type == "set":
            set_dict = {}
            set_dict["$set"] = update_dict
            results = self._collection.update_one(filter=filter, update=set_dict)
        elif update_type == "inc":
            inc_dict = {}
            inc_dict["$inc"] = update_dict
            results = self._collection.update_one(filter=filter, update=inc_dict)

        return results

    def update_many(self, filter, update_type, update_dict):
        if update_type == "set":
            set_dict = {}
            set_dict["$set"] = update_dict
            results = self._collection.update_one(filter=filter, update=set_dict)
        elif update_type == "inc":
            inc_dict = {}
            inc_dict["$inc"] = update_dict
            results = self._collection.update_one(filter=filter, update=inc_dict)

        return results

    def aggregate(self, pipeline):
        results = self._collection.aggregate(pipeline=pipeline)

        return results

# a = MyPyMongo(user='', password='', host='localhost', port=27017)
# a.conn(database='choai')
# a.changeCollection("question")
# now = datetime.datetime.now()
# result = a.insertOne({"current_time":now})
