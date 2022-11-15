from flask import request, Blueprint

from activity.chargement.ac_chargement import gen_transaction_request_cha
from db_connection import con, engine

chargement = Blueprint('chargement', __name__, template_folder='templates')

"""JSON Content for this post :
{
  "date" : "10/31/2022 14:15:00",
  "user_id" : "1",
  "list" : [ 
    {
      "touret_type" : "G",
      "quantite_joues" : "28",
      "cercle" : "o",
      "ingelec": "o",
      "Tare" : "26000" 
    },
    {
      "touret_type" : "H",
      "quantite_joues" : "18",
      "cercle" : "o",
      "ingelec": "o",
      "Tare" : "22500"
    }
 ]
}
"""
@chargement.route('/api/activity/chargement', methods=['POST'])
def chargement_activity_store():
    request_data = request.get_json()
    detail_list = request_data['list']
    user_id = request_data['user_id']
    date = request_data['date']

    sql_req = gen_transaction_request_cha(detail_list, date, user_id)

    try:
        with con.begin():
            con.execute(sql_req)
    except Exception as e:
        print(e)
        return "400"

    return "200"