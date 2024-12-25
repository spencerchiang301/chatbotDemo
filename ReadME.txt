File list:
python   				        python flask code for backend
flutter 	              flutter code for android mobile app
infra                   the infrastructure of this demo project, using two docker
                        one for backend server and other for DB to store the information
video.mp4               the mobile interface video, after you get the response from AWS server
                        you can dial a phone, navigate or make a reservation for the restaurant.
                        Access the google drive to see it.
Chatbot.jpg             Mobile interface version2. 
Login.jpg               Login interface.
MyReservation.jpg       Reservation interface.
reset password.jpg      Reset password interface.
Register a new user.jpg Create account interface.
---------------------------------------------------------------------------------
** When you use mobile app first time. Please use will.lin@gmail.com/qqq123 
   to login or register a new user and login with your user name and password.

** When we get the restaurants information, you can swip it from right to left to get 
the next restaurants. or click each button to make a reservation, dial a phone or navigate 
you to the restaurants.

** all you request to chatbot, always return steak restaurant, due to no using NLP to 
handle all requests, so now in the system promat, it is hard code. 
---------------------------------------------------------------------------------

environment:

1. A mobile phone that support Android 11.
2. The docker container
   One for mongodb and other for python backend server.

In this demo, we just create a AWS EC2 t2 small server to handle all docker container.
---------------------------------------------------------------------------------

Using mongosh to connect the mongo docker

1. After login to EC2 server, using mongosh to connect to the docker 

mongosh "mongodb://localhost:27017/choai" --apiVersion 1

2. After you connect the mongo shell, using this command to see the data 

db.question.find()

it should looks like the below 
[
  {
    _id: ObjectId('67433dfbeff7108a615b33be'),
    user: 'spencer',
    created_time: ISODate('2024-11-24T14:53:47.039Z'),
    timestamp: 1732460027.0395613,
    request: 'give me the best stack restaurant in LA?',
    answer: {
      Name: 'STK Los Angeles',
      Address: '930 Hilgard Ave, Los Angeles, CA 90024, USA',
      Telephone: '+1 310-659-3535',
      Menu: 'This high-end steakhouse offers a selection of steak cuts (from small to large), sides like truffle fries, and non-steak options like tuna tartare or free-range chicken.',
      Reason: 'Based on customer reviews and online sources, this steak restaurant has a great reputation for its quality of steak, chic'
    }
  }
]

db.users.find()

[
  {
    _id: ObjectId('67566cbd691a80dced50c326'),
    name: 'will',
    password: 'qqq123',
    email: 'will.lin@gmail.com',
    created_time: ISODate('2024-12-09T04:06:21.507Z'),
    timestamp: 1733717181.5072045
  }
]
