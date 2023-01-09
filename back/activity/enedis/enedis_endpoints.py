from flask import request, Blueprint
import pandas as pd
from flask import jsonify
from db_connection import con, engine

enedis = Blueprint('enedis', __name__, template_folder='templates')


@enedis.route('/api/enedis/list', methods=['GET'])
def get_lots():
    get_all_stock = """
    SELECT [lot]
    ,[place]
    ,[numero]
    FROM [dbo].[enedis]"""

    stock = pd.read_sql_query(get_all_stock, engine).to_dict('list')

    # REMAKE OBJECT TO BE BETTER FOR NOW LEAVE LIKE THIS
    obj = {}
    i = 0
    for type in stock['lot']:
        obj[type] = {}
        obj[type]["place"] = stock['place'][i]
        obj[type]["numero"] = stock['numero'][i]
        i += 1

    return obj


@enedis.route('/api/enedis/edit/<lot>/<numero>/<place>', methods=['POST'])
def edit_placement(lot, place, numero):

    get_lot = """
    SELECT [lot]
    ,[place]
    ,[numero]
    FROM [dbo].[enedis] where lot = '{}'""".format(lot)

    element = pd.read_sql_query(get_lot, engine).to_dict('list')
    print(element)

    if (len(element['lot']) != 0):
        req_update = """UPDATE dbo.enedis\nSET place = '{}',
        numero = '{}'\nWHERE lot = '{}'""".format(place, numero, lot)

        try:
            with con.begin():
                con.execute(req_update)
        except Exception as e:
            print(e)
            return "400"
    else:
        req_update = """INSERT INTO [dbo].[enedis]
    ([lot]
    ,[place]
    ,[numero]
    )
    VALUES
    ('{}'
    ,'{}'
    ,'{}')\n""".format(lot, place, numero)

        try:
            with con.begin():
                con.execute(req_update)
        except Exception as e:
            print(e)
            return "400"
    return "200"
