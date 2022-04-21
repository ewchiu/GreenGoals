from flask import Blueprint, request

bp = Blueprint('goal', __name__, url_prefix='/goal')

@bp.route('', methods=['GET'])
def get_goals():
    if request.method == 'GET':
        pass