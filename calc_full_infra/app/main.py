from flask import Flask, make_response, render_template, request
import jwt

from random import randrange
import datetime

import operations


import sqlite3
from contextlib import closing


SECRET_KEY = "53EB4E333DF73D56824F796D6EEBD"

flask_app = Flask(__name__)

def create_token(username, password):
    validity = datetime.datetime.utcnow() + datetime.timedelta(days=15)

    token = jwt.encode({'user_id': 86545, 'username': username, 'exp': validity}, SECRET_KEY, "HS256")

    return token

def verify_token(token):
    if token:
        decoded_token = jwt.decode(token, SECRET_KEY, "HS256")
        print(decoded_token)
        return True
    else:
        return False


@flask_app.route('/')
def index():
    print(request.cookies)
    isUserLoggedIn = False

    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])

    if isUserLoggedIn:
        print("Welcome back!")
        return render_template('calculator.html')
    else:
        user_id = randrange(1,10)
        print(f"The user ID is: {user_id}")
        response = make_response("This is the index page of a Secure REST API calculator application!")
        response.set_cookie('user_id', str(user_id))
        return response

@flask_app.route('/login')
def login():
    return render_template('login.html')

@flask_app.route('/calculator', methods = ['POST'])
def authentication():
     user_data = request.form
     username = user_data['username']
     password = user_data['password']

     user_token = create_token(username, password)

     response = make_response(render_template('calculator.html'))

     response.set_cookie('token', user_token)


     with closing(sqlite3.connect("calculator.db")) as connection:
         with closing(connection.cursor()) as cursor:

             cursor.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password TEXT);")

             try:
                 cursor.execute(f"INSERT INTO users (username, password) VALUES ('{username}', '{password}'); ")
                 connection.commit()
             except Exception as e:
                 print(e)


     return response

@flask_app.route('/results', methods = ['POST'])
def calculator():
    number_data = request.form

    first_number = int(number_data['first_number'])
    second_number = int(number_data['second_number'])

    addition = f"{first_number} + {second_number} = {operations.addition(first_number, second_number)}"
    subtraction = f"{first_number} - {second_number} = {operations.subtraction(first_number, second_number)}"
    multiplication = f"{first_number} * {second_number} = {operations.multiplication(first_number, second_number)}"
    division = f"{first_number} / {second_number} = {operations.division(first_number, second_number)}"

    return render_template('results.html', add = addition, sub = subtraction, multi = multiplication, div = division)



if __name__ == '__main__':
    print("This is a Secure REST API Server running a calculator app: ")
    flask_app.run(host = "0.0.0.0", debug = True, ssl_context = ('certs/cert.pem', 'certs/key.pem'))
