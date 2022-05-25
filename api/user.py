from flask import Blueprint, request, jsonify, make_response
from models import UsersModel, UsersGoalsModel
from app import db
from fb_auth import verify_token
from datetime import date

bp = Blueprint('user', __name__, url_prefix='/users')

@bp.route('', methods=['GET', 'POST'])
def get_post_users():
    if request.method == 'GET':
        users = UsersModel.query.all()
        results = [
            {
                "user_id": user.user_id,
                "email": user.email,
                "points": user.points
            }
        for user in users]

        return jsonify({"count": len(users), "users": results}), 200

    # create new user
    elif request.method == 'POST':
        if request.is_json:
            content = request.get_json()

            if 'email' not in content:
                error = {"Error": "The request object is missing at least one of the required attributes"}
                return jsonify(error), 400

            new_user = UsersModel(email=content["email"], points=0)
            db.session.add(new_user)
            db.session.commit()

            user = {
                "user_id": new_user.user_id,
                "email": new_user.email,
                "points": new_user.points
            }
            return jsonify(user), 201

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['GET', 'POST'])
        res.status_code = 405
        return res

@bp.route('/<email>', methods=['GET', 'POST'])
# @verify_token
def add_points(email):
    user = UsersModel.query.filter(UsersModel.email.contains(email)).first()

    if request.method == 'POST':
        if request.is_json:
            content = request.get_json()

            if 'points' not in content:
                error = {"Error": "The request object is missing at least one of the required attributes"}
                return jsonify(error), 400

            user.points += content['points']
            db.session.add(user)
            db.session.commit()

            message = {"Message": "The user's point total was successfully updated"}
            return jsonify(message), 201

    elif request.method == 'GET':
        response = {
            "user_id": user.user_id,
            "email": user.email,
            "points": user.points
        }
        return jsonify(response), 200

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['POST'])
        res.status_code = 405
        return res

@bp.route('/<uid>/goals', methods=['GET', 'POST'])
# @verify_token
def goals_for_user(uid):
    user = UsersModel.query.get_or_404(uid)

    if request.method == 'POST':
        if request.is_json:
            content = request.get_json()

            if 'goal_id' not in content:
                error = {"Error": "The request object is missing at least one of the required attributes"}
                return jsonify(error), 400

            new_usergoal = UsersGoalsModel(user_id=uid, goal_id=content['goal_id'], date_assigned=date.today())
            db.session.add(new_usergoal)
            db.session.commit()

            usergoal = {
                "id": new_usergoal.id,
                "user_id": new_usergoal.user_id,
                "goal_id": new_usergoal.goal_id,
                "date_assigned": new_usergoal.date_assigned,
                "complete": new_usergoal.complete
            }
            return jsonify(usergoal), 201

    elif request.method == 'GET':
        if request.is_json:
            content = request.get_json()

            usersgoals = UsersGoalsModel.query.filter_by(user_id=user.user_id).all()
            results = [
                {
                    "id": goal.id,
                    "user_id": goal.user_id,
                    "goal_id": goal.goal_id,
                    "date_assigned": goal.date_assigned,
                    "complete": goal.complete
                } 
            for goal in usersgoals]
            return jsonify({"count": len(usersgoals), "goals": results}), 200 

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['GET', 'POST'])
        res.status_code = 405
        return res

@bp.route('/<user_id>/goals/<id>', methods=['PATCH'])
# @verify_token
def update_goal_for_user(user_id, id):
    user = UsersModel.query.get_or_404(user_id)
    usersgoal = UsersGoalsModel.query.get_or_404(id)

    if request.method == 'PATCH':
        usersgoal.complete = True
        db.session.add(usersgoal)
        db.session.commit()

        message = {"Message": "The goal was marked as completed for the user"}
        return jsonify(message), 201
    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['PATCH'])
        res.status_code = 405
        return res