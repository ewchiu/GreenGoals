from flask import Blueprint, request, jsonify, make_response
from rds_db import get_db_conn, execute_query
from models import db

bp = Blueprint('goal', __name__, url_prefix='/goals')


@bp.route('', methods=['GET', 'POST'])
def get_post_goals():
    conn = get_db_conn()

    if request.method == 'GET':
        
        query = 'SELECT * FROM goals'
        goals = execute_query(conn, query).fetchall()
        output = {"goals": goals}

        conn.close()
        return jsonify(output), 200

    elif request.method == 'POST':
        content = request.get_json()
        if 'description' not in content or 'points' not in content:
            error = {"Error": "The request object is missing at least one of the required attributes"}
            return jsonify(error), 400

        goal = {
            'description': content['description'],
            'points': content['points']
            }

        query = 'INSERT INTO GOALS (description, points) VALUES(%s, %s)'
        data = (goal['description'], goal['points'])
        execute_query(conn, query, data)

        conn.close()
        return jsonify(goal), 200

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['GET', 'POST'])
        res.status_code = 405
        return 

@bp.route('/<goal_id>', methods=['GET', 'PUT', 'DELETE'])
def edit_delete_goals(goal_id):
    conn = get_db_conn()

    if request.method == 'GET':
        
        query = 'SELECT * FROM goals WHERE goal_id=%s'
        data = (goal_id,)
        goal = execute_query(conn, query, data).fetchall()
        print("getting goal")
        print(goal)

        conn.close()
        return jsonify(goal), 200

    content = request.get_json()
    if not verify_req_body(content):
            error = {"Error": "The request object is missing at least one of the required attributes"}
            return jsonify(error), 400

    else:
        res = make_response({"Error": "Method not recognized"})
        res.headers.set('Allow', ['PUT', 'DELETE'])
        res.status_code = 405
        return 

def verify_req_body(body):
    goal_attributes = ['goal_id', 'description', 'points']
    
    for attribute in goal_attributes:
        if attribute not in body:
            return False

    return True