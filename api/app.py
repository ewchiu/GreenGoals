from flask import Flask, Blueprint
from flask_sqlalchemy import SQLAlchemy

import os
import user
import goal

app = Flask(__name__)
app.register_blueprint(user.bp)
app.register_blueprint(goal.bp)

# PostgreSQL initialization
pg_user = os.environ.get('PG_USERNAME')
pg_password = os.environ.get('PG_PASSWORD')
pg_host = os.environ.get('PG_HOST')
pg_port = os.environ.get('PG_PORT')
pg_database = os.environ.get('PG_DATABASE')

CONF = f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_database}"
app.config['SQLALCHEMY_DATABASE_URI'] = CONF

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = 'secret'
db = SQLAlchemy(app)

@app.route("/")
def hello_world():
    return "<h1>Please navigate GreenGoals using the mobile app.</h1>"

if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=False)