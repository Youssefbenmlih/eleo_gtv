from flask import request, Blueprint

from activity.reception.ac_reception import gen_transaction_request_rec
from db_connection import con, engine
from stock.stock_update import update_stock

reception = Blueprint('reception', __name__, template_folder='templates')

"""JSON Content for this post :
{
  "date" : "10/31/2022 11:15:00",
  "user_id" : "1",
  "list" : [ 
    {
      "touret_type" : "G",
      "cercle" : "o",
      "ingelec": "o",
      "numero_de_lot" : "GBM0003078" 
    },
    {
      "touret_type" : "H",
      "cercle" : "o",
      "ingelec": "o",
      "numero_de_lot" : "HBM0003077"
    }
 ]
}
"""
@reception.route('/api/activity/reception', methods=['POST'])
def reception_activity_store():
    request_data = request.get_json()
    detail_list = request_data['list']
    user_id = request_data['user_id']
    date = request_data['date']

    sql_req = gen_transaction_request_rec(detail_list, date, user_id)
    
    try:
        with con.begin():
            if update_stock(detail_list, "reception") == "405":
                return "Stock update failed", 405
            con.execute(sql_req)
    except Exception as e:
        print(e)
        return "Reception insert failed", 400

    return "200"