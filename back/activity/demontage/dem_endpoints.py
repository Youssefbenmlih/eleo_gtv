from flask import request, Blueprint

from activity.demontage.ac_demontage import gen_transaction_request_dem
from db_connection import con, engine

demontage = Blueprint('demontage', __name__, template_folder='templates')

"""JSON Content for this post :
{
  "date" : "10/31/2022 10:15:00",
  "user_id" : "1",
  "list" : 
  [ 
    {
      "touret_type" : "G",
      "quantite_tourets" : "22",
      "cercle" : "o",
      "ingelec": "o"
    },
    {
      "touret_type" : "H",
      "quantite_tourets" : "12",
      "cercle" : "o",
      "ingelec": "o"
    }
  ]
}
"""
@demontage.route('/api/activity/demontage', methods=['POST'])
def demontage_activity_store():
    request_data = request.get_json()
    detail_list = request_data['list']
    user_id = request_data['user_id']
    date = request_data['date']
    
    sql_req = gen_transaction_request_dem(detail_list, date, user_id)
    
    try:
        with con.begin():
            con.execute(sql_req)
    except Exception as e:
        print(e)
        return "400"

    return "200"