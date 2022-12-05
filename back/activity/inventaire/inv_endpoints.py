from flask import request, Blueprint
from db_connection import con, engine

inventaire = Blueprint('inventaire', __name__, template_folder='templates')

"""JSON Content for this post :
{
  "date" : "10/31/2022 10:15:00",
  "user_id" : "1",
  "nb_monte_cercle" : "12",
  "nb_demonte_cercle" : "13",
  "nb_monte_non_cercle" : "14",
  "nb_demonte_cercle" : "15"
}
"""


@inventaire.route('/api/activity/inventaire', methods=['POST'])
def inventaire_activity_store():
    request_data = request.get_json()
    user_id = request_data['user_id']
    date = request_data['date']
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
    ,[nb_demonte_non_cercle])
    VALUES
    ('{}'
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
        nb_demonte_non_cercle
    )

    try:
        with con.begin():
            con.execute(req_insert)
    except Exception as e:
        print(e)
        return "inventaire insert failed", 400

    return "200"
