from flask import Blueprint, request

bp = Blueprint('user', __name__, url_prefix='/user')

@bp.route('', methods=['GET'])
def get_users():
    if request.method == 'GET':
        pass