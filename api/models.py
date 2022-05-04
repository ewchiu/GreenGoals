from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class GoalsModel(db.Model):
    __tablename__ = 'goals'

    goal_id = db.Column(db.Integer, primary_key = True)
    description = db.Column(db.String())
    category = db.Column(db.String())
    points = db.Column(db.Integer())

    def __init__(self, description, category, points):
        self.description = description
        self.category = category
        self.points = points

    def __repr__(self):
        return f"{self.goal_id}:{self.description}:{self.category}:{self.points}"

class UsersModel(db.Model):
    __tablename__ = 'users'

    user_id = db.Column(db.Integer, primary_key = True)
    email = db.Column(db.String(), unique = True)
    points = db.Column(db.Integer())

    def __init__(self, email, points):
        self.email = email
        self.points = points

    def __repr__(self):
        return f"{self.user_id}:{self.email}:{self.points}"        