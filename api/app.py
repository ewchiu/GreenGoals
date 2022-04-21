from flask import Flask, Blueprint

import user
import goal

app = Flask(__name__)
app.register_blueprint(user.bp)
app.register_blueprint(goal.bp)

@app.route("/")
def hello_world():
    return "<h1>Please navigate GreenGoals using the mobile app.</h1>"

if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=True)