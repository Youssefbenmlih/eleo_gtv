import pandas as pd
from flask import Flask, request
from flask import jsonify

from db_connection import con, engine

app = Flask(__name__)

from activity.demontage.dem_endpoints import demontage
from activity.reception.rec_endpoints import reception
from activity.chargement.cha_endpoints import chargement
app.register_blueprint(demontage)
app.register_blueprint(reception)
app.register_blueprint(chargement)

@app.route('/', methods=['GET'])
def ls():
    return "welcome to the eleo_gtv api"


@app.route('/api/users/list', methods=['GET'])
def get_users():
    req = 'SELECT * FROM dbo.users'
    return jsonify(pd.read_sql_query(req, engine).to_dict('records'))

@app.route('/api/users/add', methods=['POST'])
def add_user():
    request_data = request.get_json()
    req = '''INSERT INTO [dbo].[users]
           ([name]
           ,[email]
           ,[mot_de_passe]
           ,[admin])
     VALUES
           ('{0}', '{1}', '{2}', '{3}')'''.format(request_data['name'], request_data['email'], 
                                                 request_data['mot_de_passe'], request_data['admin'])
    con.execute(req)
    return "200"
    

def check_connection(data):
    req = 'SELECT name, email, mot_de_passe FROM dbo.users WHERE email = \'{}\''.format(data['email'])
    users = pd.read_sql_query(req, engine).to_dict('records')
    if len(users) == 1 and users[0]['mot_de_passe'] == data['mot_de_passe']:
        return users[0]['name'], True
    return "error", False

@app.route('/api/users/connect', methods=['POST'])
def connect_req():
    request_data = request.get_json()
    res = check_connection(request_data)
    if (res[1]):
        return res[0], "200"
    return "403"

app.run()