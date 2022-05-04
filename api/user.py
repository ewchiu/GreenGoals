from flask import Blueprint, request, jsonify, make_response
from models import UsersModel
from app import db
from fb_auth import verify_token

bp = Blueprint('user', __name__, url_prefix='/users')

@bp.route('', methods=['GET', 'POST'])
def get_post_users():
    if request.method == 'GET':
        users = UsersModel.query.all()
        results = [
            {
                "user_id": user.goal_id,
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
@verify_token
def add_points(email):
    user = UsersModel.query.get_or_404(email)

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
        