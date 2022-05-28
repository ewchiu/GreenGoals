from flask import Flask, request, redirect, render_template
from firebase_admin import credentials
from flask_migrate import Migrate
from models import db

import firebase_admin
import os
import user
import goal

app = Flask(__name__)

# connect to DB
pg_user = os.environ.get('PG_USERNAME')
pg_password = os.environ.get('PG_PASSWORD')
pg_host = os.environ.get('PG_HOST')
pg_port = os.environ.get('PG_PORT')
pg_database = os.environ.get('PG_DATABASE')

app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_database}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)
migrate = Migrate(app, db)

app.register_blueprint(goal.bp)
app.register_blueprint(user.bp)

# connect to firebase
cred = credentials.Certificate('fbAdminConfig.json')
firebase = firebase_admin.initialize_app(cred)

@app.route("/")
def login():
    return "<p>Please login through the GreenGoals mobile app.</p>"

@app.route("/api")
def api_spec():
    return render_template('GreenGoalsAPI.html')
    

if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=False)
