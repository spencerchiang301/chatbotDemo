from datetime import timedelta

from flask_jwt_extended import JWTManager
from flask import Flask, request, jsonify
from flask_cors import CORS
import configparser, datetime, time

from MyChatbot import MyChatBot
from utility.MyDB import MyDB
from bson import ObjectId


config = configparser.ConfigParser()
config.read('config/config.ini')

secret = config['app']['secret']
jwtSecret = config['jwt']['secret']
openAIKey = config['ai_key']['openai']

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": ["*"]}})
app.secret_key = bytes(secret, 'UTF-8')
ACCESS_EXPIRES = timedelta(hours=1)
app.config["JWT_SECRET_KEY"] = jwtSecret
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = ACCESS_EXPIRES
app.config["JWT_REFRESH_TOKEN_EXPIRES"] = timedelta(days=30)
jwt = JWTManager()
jwt.init_app(app)

__mychatbot = MyChatBot()
__myMongo = MyDB()
@app.route("/", methods=['GET','POST'])
def root():
    return "<p>Hello, World!</p>"


@app.route('/registerUser', methods=['POST'])
def registerUser():
    try:
        now = datetime.datetime.now()
        timestamp = time.time()
        name = request.get_json().get("name")
        password = request.get_json().get("password")
        email = request.get_json().get("email")
        __myMongo.changeCollection("users")
        counter =__myMongo.count({"name":name,"email":email})
        if counter == 1:
            return jsonify({"responseResult": "The user name exists, please use another one", "responseStatus": "Exists"}), 200
        else:
            inserted_id =__myMongo.insertMongo({"name":name,
                                                "password":password,
                                                "email":email,
                                                "created_time":now,
                                                "timestamp":timestamp,
                                                })
            print("id: {}".format(inserted_id))
            return jsonify({"responseResult":"Create a new user successfully", "responseStatus":"Ok"}), 200
    except Exception as e:
        return jsonify({"responseResult": "Can't create a new User", "responseStatus": "Failed"}), 500


@app.route('/authenticateUser', methods=['POST'])
def authenticateUser():
    try:
        password = request.get_json().get("password").strip()
        email = request.get_json().get("email").strip()
        print(password)
        print(email)
        __myMongo.changeCollection("users")
        counter =__myMongo.count({"password":password,"email":email})
        print("count: {}".format(counter))
        if counter == 1:
            return jsonify({"responseResult":"login successfully", "responseStatus":"Ok"}), 200
    except Exception as e:
        return jsonify({"responseResult": "Can't authenticate for your account", "responseStatus": "Failed"}), 500


@app.route('/chatbot', methods=['GET', 'POST'])
def chatBot():
    inserted_id = None
    try:
        if request.method == "POST":
            now = datetime.datetime.now()
            timestamp = time.time()
            queryString = request.get_json().get("queryString")
            inserted_id =__myMongo.insertMongo({"user":"spencer","created_time":now, "timestamp":timestamp,
                                                "request":queryString})
            print("queryString:{}, id: {}".format(queryString, inserted_id))
        else:
            queryString = request.args.get('queryString')
            # print(queryString)

        if not queryString :
            return jsonify({"error": "Missing queryString"}), 400

        finalResult = __mychatbot.change_message(queryString)
        print(finalResult)
        __mongo = __myMongo.updateMongo(filter={"_id":ObjectId(inserted_id)}, data={"answer":finalResult})
        return finalResult, 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000)