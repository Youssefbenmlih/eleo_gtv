from flask import request, Blueprint
import pandas as pd
from flask import jsonify

from user.ac_user import *
from db_connection import con, engine

user = Blueprint('user', __name__, template_folder='templates')


@user.route('/api/users/list', methods=['GET'])
def get_users():
    req = 'SELECT * FROM dbo.users'
    return jsonify(pd.read_sql_query(req, engine).to_dict('records'))

"""
Json Content:
{
  "name": mr.name,
  "email": "user@email.com", 
  "mot_de_passe" : "mdp",
  "admin" : "n"
}
"""
@user.route('/api/users/add', methods=['POST'])
def add_user():
    request_data = request.get_json()
    query = get_insert_query(request_data)
    try:
        with con.begin():
            con.execute(query)
    except Exception as e:
        print(e)
        return "400"
    
    return "200"

"""
JSON content
{
  "email": "user@email.com", 
  "mot_de_passe" : "mdp"
}
"""
@user.route('/api/users/connect', methods=['POST'])
def connect_req():
    request_data = request.get_json()
    res = check_connection(request_data, engine)
    if (res[1]):
        return res[0], "200"
    return "403"