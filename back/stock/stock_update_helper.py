import sys
import pandas as pd
sys.path.append('../')
from db_connection import con, engine

#Helper functions to recover stock amounts from JSON request raw data

def parse_request_list_demontage(request_list):
    nb_tourets_demonte_cercle = 0
    nb_tourets_demonte_non_cercle = 0
    for el in request_list:
        if el['cercle'] == "o":
            nb_tourets_demonte_cercle += int(el['quantite_tourets'])
        else:
            nb_tourets_demonte_non_cercle += int(el['quantite_tourets'])
    return nb_tourets_demonte_cercle, nb_tourets_demonte_non_cercle, el['touret_type']

def parse_request_list_chargement(request_list):
    nb_tourets_demonte_cercle = 0
    nb_tourets_demonte_non_cercle = 0
    for el in request_list:
        if el['cercle'] == "o":
            nb_tourets_demonte_cercle += int(int(el['quantite_joues']) / 2)
        else:
            nb_tourets_demonte_non_cercle += int(int(el['quantite_joues']) / 2)
    return nb_tourets_demonte_cercle, nb_tourets_demonte_non_cercle, el['touret_type']

def parse_request_list_reception(request_list):
    nb_tourets_monte_cercle = 0
    nb_tourets_monte_non_cercle = 0
    for el in request_list:
        if el['cercle'] == "o":
            nb_tourets_monte_cercle += int(el['quantite_tourets'])
        else:
            nb_tourets_monte_non_cercle += int(el['quantite_tourets'])
    return nb_tourets_monte_cercle, nb_tourets_monte_non_cercle, el['touret_type']



"""--------------INSERT UPDATED VALUES FOR STOCK---------------"""



def update_stock_demontage(request_list):
    nb_tour_dem_cercle, nb_tour_dem_n_cercle, type_t = parse_request_list_demontage(request_list)

    req_select = """SELECT stock_demonte_cercle, stock_demonte_non_cercle\nFROM dbo.type_touret
    WHERE name = '{}'""".format(type_t)

    curr_numbers = pd.read_sql_query(req_select, engine).to_dict('records')[0]

    ndc, ndnc = curr_numbers['stock_demonte_cercle'] + nb_tour_dem_cercle, curr_numbers['stock_demonte_non_cercle'] + nb_tour_dem_n_cercle

    req_update = """UPDATE dbo.type_touret\nSET stock_demonte_cercle = '{}',
    stock_demonte_non_cercle = '{}'\nWHERE name = '{}'""".format(ndc, ndnc, type_t)

    try:
        with con.begin():
            con.execute(req_update)
    except Exception as e:
        print(e)
        return "400"


def update_stock_reception(request_list):
    nb_tour_cercle, nb_tour_n_cercle, type_t = parse_request_list_reception(request_list)

    req_select = """SELECT stock_monte_cercle, stock_monte_non_cercle\nFROM dbo.type_touret
    WHERE name = '{}'""".format(type_t)

    curr_numbers = pd.read_sql_query(req_select, engine).to_dict('records')[0]

    nc, nnc = curr_numbers['stock_monte_cercle'] + nb_tour_cercle, curr_numbers['stock_monte_non_cercle'] + nb_tour_n_cercle

    req_update = """UPDATE dbo.type_touret\nSET stock_monte_cercle = '{}',
    stock_monte_non_cercle = '{}'\nWHERE name = '{}'""".format(nc, nnc, type_t)

    try:
        with con.begin():
            con.execute(req_update)
    except Exception as e:
        print(e)
        return "400"


def update_stock_chargement(request_list):
     nb_tour_dem_cercle, nb_tour_dem_n_cercle, type_t = parse_request_list_chargement(request_list)

    # req_select = """SELECT stock_demonte_cercle, stock_demonte_non_cercle\nFROM dbo.type_touret
    # WHERE name = '{}'""".format(type_t)

    # curr_numbers = pd.read_sql_query(req_select, engine).to_dict('records')[0]

    # ndc, ndnc = curr_numbers['stock_demonte_cercle'] + nb_tour_dem_cercle, curr_numbers['stock_demonte_non_cercle'] + nb_tour_dem_n_cercle

    # req_update = """UPDATE dbo.type_touret\nSET stock_demonte_cercle = '{}',
    # stock_demonte_non_cercle = '{}'\nWHERE name = '{}'""".format(ndc, ndnc, type_t)

    # try:
    #     with con.begin():
    #         con.execute(req_update)
    # except Exception as e:
    #     print(e)
    #     return "400"