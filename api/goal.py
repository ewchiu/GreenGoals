from flask import Blueprint, request, jsonify, make_response, Response
from models import GoalsModel
from app import db

bp = Blueprint('goal', __name__, url_prefix='/goals')


@bp.route('', methods=['GET', 'POST'])
def get_post_goals():

    if request.method == 'GET':
        goals = GoalsModel.query.all()
        results = [
            {
                "goal_id": goal.goal_id,
                "description": goal.description,
                "category": goal.category,
                "points": goal.points
            }
        for goal in goals]

        return jsonify({"count": len(goals), "goals": results}), 200

    elif request.method == 'POST':
        if request.is_json:
            content = request.get_json()

            if not verify_req_body(content):
                error = {"Error": "The request object is missing at least one of the required attributes"}
                return jsonify(error), 400

            new_goal = GoalsModel(description=content["description"], category=content["category"], points=content["points"])
            db.session.add(new_goal)
            db.session.commit()
            return jsonify(new_goal), 201

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['GET', 'POST'])
        res.status_code = 405
        return res

@bp.route('/<goal_id>', methods=['GET', 'PUT', 'DELETE'])
def edit_delete_goals(goal_id):
    goal = GoalsModel.query.get_or_404(goal_id)

    if request.method == 'GET':
        response = {
            "goal_id": goal.goal_id,
            "description": goal.description,
            "category": goal.category,
            "points": goal.points
        }
        return jsonify(response), 200

    elif request.method == 'PUT':
        content = request.get_json()

        if not verify_req_body(content):
            error = {"Error": "The request object is missing at least one of the required attributes"}
            return jsonify(error), 400

        goal.description = content['description']
        goal.category = content['category']
        goal.points = content['points']
        db.session.add(goal)
        db.session.commit()

        message = {"Message": "The object was successfully updated"}
        return jsonify(message), 201

    elif request.method == 'DELETE':
        db.session.delete(goal)
        db.session.commit()
        return Response(status=204)

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['GET', 'PUT', 'DELETE'])
        res.status_code = 405
        return res

def verify_req_body(body):
    goal_attributes = ['description', 'category', 'points']
    
    for attribute in goal_attributes:
        if attribute not in body:
            return False

    return True