from flask import request, Blueprint
import pandas as pd
from flask import jsonify
from db_connection import con, engine

historique = Blueprint('historique', __name__, template_folder='templates')


@historique.route('/api/historique/list', methods=['GET'])
def get_historique():
    req_demontage = 'SELECT * FROM dbo.demontage'
    req_reception = 'SELECT * FROM dbo.reception'
    req_chargement = 'SELECT * FROM dbo.chargement'
    dem_list = pd.read_sql_query(
        req_demontage, engine).to_dict('records')
    rec_list = pd.read_sql_query(
        req_reception, engine).to_dict('records')
    cha_list = pd.read_sql_query(
        req_chargement, engine).to_dict('records')
    res = {'demontage': dem_list, 'reception': rec_list, 'chargement': cha_list}
    return jsonify(res), 200


@historique.route('/api/historique/det_dem', methods=['POST'])
def get_detail_demontage():
    request_data = request.get_json()
    req = """SELECT touret_type, quantite_tourets, cercle, ingelec
FROM [eleo_gtv].[dbo].[det_demontage] WHERE id_demontage = {};""".format(request_data['id'])
    det_list = pd.read_sql_query(req, engine).to_dict('records')
    return det_list, 200


@historique.route('/api/historique/det_rec', methods=['POST'])
def get_detail_reception():
    request_data = request.get_json()
    req = """SELECT touret_type, numero_de_lot, cercle, ingelec, quantite_tourets
FROM [eleo_gtv].[dbo].[det_reception] WHERE id_reception = {};""".format(request_data['id'])
    det_list = pd.read_sql_query(req, engine).to_dict('records')
    return det_list, 200


@historique.route('/api/historique/det_cha', methods=['POST'])
def get_detail_chargement():
    request_data = request.get_json()
    req = """SELECT touret_type, quantite_joues, cercle, ingelec
FROM [eleo_gtv].[dbo].[det_chargement] WHERE id_chargement = {};""".format(request_data['id'])
    det_list = pd.read_sql_query(req, engine).to_dict('records')
    return det_list, 200
