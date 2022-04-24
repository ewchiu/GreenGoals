from flask import Blueprint, request, jsonify
from rds_db import get_db_conn, execute_query

bp = Blueprint('goal', __name__, url_prefix='/goals')

@bp.route('', methods=['GET', 'POST'])
def get_post_goals():
    if request.method == 'GET':
        conn = get_db_conn()
        query = 'SELECT * FROM goals'
        goals = execute_query(conn, query).fetchall()

        return jsonify(goals), 200

    elif request.method == 'POST':
        content = request.get_json()

        conn = get_db_conn()
        query = 'INSERT INTO GOALS (description, points) VALUES(%s, %s)'
        data = (content['desc'], content['points'])
        goal = execute_query(conn, query, data)

        return 200