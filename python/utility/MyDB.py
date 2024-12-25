from utility.MyPymongo import MyPyMongo

class MyDB:

    def __init__(self):
        self.mongo = MyPyMongo(user="XXXXXXX", password="123", host="localhost", port=27017 )
        self.mongo.conn("choai")
        self.mongo.changeCollection("question")

    def insertMongo(self, data):
        inserted_id = self.mongo.insertOne(data)
        return inserted_id

    def findAll(self):
        self.mongo.find({},{})

    def updateMongo(self, filter, data):
        self.mongo.update_one(filter=filter, update_type='set', update_dict=data)
