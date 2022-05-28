from firebase_admin import auth
from flask import request

def verify_token(func):
    def wrapper(*args, **kwargs):   
        if not request.headers.get('Authorization'):
            return {"Error": "No token provided"}, 400

        token = request.headers.get('Authorization')
        try:
            user = auth.verify_id_token(token)
            request.user = user
        except:
            return {"Error": "Invalid token provided"}, 400
        return func(*args, **kwargs)
    return wrapper