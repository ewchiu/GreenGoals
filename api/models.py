from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class GoalModel(db.Model):
    __tablename__ = 'goals'

    goal_id = db.Column(db.Integer, primary_key = True)
    description = db.Column(db.String())
    points = db.Column(db.Integer())

    def __init__(self, description, points):
        self.description = description
        self.points = points

    def __repr__(self):
        return f"{self.goal_id}:{self.description}:{self.points}"
        