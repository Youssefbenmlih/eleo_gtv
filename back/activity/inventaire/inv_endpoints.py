from flask import request, Blueprint
from db_connection import con, engine
import pandas as pd

inventaire = Blueprint('inventaire', __name__, template_folder='templates')

"""JSON Content for this post :
{
  "date" : "10/1/2022 10:15:00",
  "user_id" : "1",
  "type_touret : "G"
  "nb_monte_cercle" : "0",
  "nb_demonte_cercle" : "0",
  "nb_monte_non_cercle" : "4",
  "nb_demonte_non_cercle" : "0"
}
"""


@inventaire.route('/api/activity/inventaire', methods=['POST'])
def inventaire_activity_store():
    request_data = request.get_json()
    user_id = request_data['user_id']
    date = request_data['date']
    type = request_data['type_touret']
    stock_avant = request_data['stock_avant']
    stock_après = request_data['stock_apres']
    nb_monte_cercle = request_data['nb_monte_cercle']
    nb_demonte_cercle = request_data['nb_demonte_cercle']
    nb_monte_non_cercle = request_data['nb_monte_non_cercle']
    nb_demonte_non_cercle = request_data['nb_demonte_non_cercle']

    req_insert = """
    INSERT INTO [dbo].[inventaire]
    ([id_user]
    ,[date]
    ,[nb_monte_cercle]
    ,[nb_demonte_cercle]
    ,[nb_monte_non_cercle]
    ,[nb_demonte_non_cercle]
    ,[type_touret]
    ,[stock_avant]
    ,[stock_apres]
    )
    VALUES
    ('{}'
    ,'{}'
    ,'{}'
    ,'{}'
    ,'{}'
    ,'{}'
    ,'{}'
    ,'{}'
    ,'{}')\n
    """.format(
        user_id,
        date,
        nb_monte_cercle,
        nb_demonte_cercle,
        nb_monte_non_cercle,
        nb_demonte_non_cercle,
        type,
        stock_avant,
        stock_après,
    )

    try:
        with con.begin():
            con.execute(req_insert)
    except Exception as e:
        print(e)
        return "inventaire insert failed", 400

    get_all_stock = """
    SELECT [name]
    ,[stock_monte_cercle]
    ,[stock_demonte_cercle]
    ,[stock_monte_non_cercle]
    ,[stock_demonte_non_cercle]
    FROM [dbo].[type_touret]"""

    stock = pd.read_sql_query(get_all_stock, engine).to_dict('list')

    # REMAKE OBJECT TO BE BETTER FOR NOW LEAVE LIKE THIS
    obj = {}
    i = 0
    for _type in stock['name']:
        obj[_type] = {}
        obj[_type]["stock_monte_cercle"] = stock['stock_monte_cercle'][i]
        obj[_type]["stock_demonte_cercle"] = stock['stock_demonte_cercle'][i]
        obj[_type]["stock_monte_non_cercle"] = stock['stock_monte_non_cercle'][i]
        obj[_type]["stock_demonte_non_cercle"] = stock['stock_demonte_non_cercle'][i]
        i += 1

    req_update_mont = """UPDATE dbo.type_touret\nSET stock_monte_cercle = '{}', stock_demonte_cercle = '{}', 
    stock_monte_non_cercle = '{}', stock_demonte_non_cercle = '{}'\nWHERE name = '{}'""".format(
        obj[type]["stock_monte_cercle"] + int(nb_monte_cercle),
        obj[type]["stock_demonte_cercle"] + int(nb_demonte_cercle),
        obj[type]["stock_monte_non_cercle"] + int(nb_monte_non_cercle),
        obj[type]["stock_demonte_non_cercle"] + int(nb_demonte_non_cercle),
        type
    )

    try:
        with con.begin():
            con.execute(req_update_mont)
    except Exception as e:
        print(e)
        return "400"

    return "200"
