from flask import request, Blueprint
import pandas as pd
from flask import jsonify

from db_connection import con, engine

stock = Blueprint('stock', __name__, template_folder='templates')

@stock.route('/api/stock/get', methods=['GET'])
def get_stock():

    get_all_stock = """
    SELECT [name]
    ,[stock_monte_cercle]
    ,[stock_demonte_cercle]
    ,[stock_monte_non_cercle]
    ,[stock_demonte_non_cercle]
    FROM [dbo].[type_touret]"""

    stock = pd.read_sql_query(get_all_stock, engine).to_dict('list')

    #REMAKE OBJECT TO BE BETTER FOR NOW LEAVE LIKE THIS
    obj = {}
    i = 0
    for type in stock['name']:
        obj[type] = {}
        obj[type]["stock_monte_cercle"]  = stock['stock_monte_cercle'][i]
        obj[type]["stock_demonte_cercle"]  = stock['stock_demonte_cercle'][i]
        obj[type]["stock_monte_non_cercle"]  = stock['stock_monte_non_cercle'][i]
        obj[type]["stock_demonte_non_cercle"]  = stock['stock_demonte_non_cercle'][i]
        i += 1

    return obj

