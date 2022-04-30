from flask import Flask, request, redirect
from models import db
from flask_migrate import Migrate

import os
import user
import goal

app = Flask(__name__)

# configure DB
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

@app.route("/")
def login():
    # redirect to login screen
    client_id = os.environ.get('CLIENT_ID')
    response_type = os.environ.get('RESPONSE_TYPE')
    scope = os.environ.get('SCOPE')
    redirect_uri = os.environ.get('REDIRECT_URI')
    return redirect(f"https://greengoals.auth.us-east-1.amazoncognito.com/login?client_id={client_id}&response_type={response_type}&scope={scope}&redirect_uri={redirect_uri}")

@app.route('/cognito_redirect')
def cognito_redirect():
    try:
        code = request.args.get('code')
        return f"Code is :{code}"
    except:
        return "The authentication process failed, please try again."

if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=False)