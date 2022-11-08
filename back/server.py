import pandas as pd
import keyring
keyring.set_password('db', 'admindb', 'Imacab@2022')
import sqlalchemy as sa
import urllib
from sqlalchemy import create_engine, event
from sqlalchemy.engine.url import URL

from flask import Flask, request, json
from flask import jsonify
app = Flask(__name__)
    
# params = urllib.parse.quote_plus("DRIVER={SQL Server};"
#                                  "SERVER=imacabsrv.database.windows.net;"
#                                  "DATABASE=TEST;"
#                                  "UID=admindb;"
#                                  "PWD=" + keyring.get_password("db", "admindb") + ";")
    
# engine = sa.create_engine("mssql+pyodbc:///?odbc_connect={}".format(params))
# req = 'SELECT * FROM dbo.TEST'
# df = pd.read_sql_query(req, engine)
# df.head()

app.config["DEBUG"] = True

@app.route('/', methods=['GET'])
def home():
    return "Future app!"

def check_connection(data):
    return True

@app.route('/connect/user', methods=['POST'])
def connect_req():
    content = request.json
    data = json.loads(request.data)
    if (check_connection(data)):
        return 200
    return 403
    

app.run()

