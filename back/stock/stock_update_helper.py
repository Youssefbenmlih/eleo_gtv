import sys
import pandas as pd
sys.path.append('../')
from db_connection import con, engine

#Helper functions to recover stock amounts from JSON request raw data

def parse_request_list_dem_rec(request_list):
    tab = { 'G' : [0, 0], 'H' : [0, 0], 'I' : [0,0]}
    for el in request_list:
        if el['cercle'] == "o":
            tab[el['touret_type']][0] += int(el['quantite_tourets'])
        else:
            tab[el['touret_type']][1] += int(el['quantite_tourets'])
    return tab

def parse_request_list_chargement(request_list):
    tab = { 'G' : [0, 0], 'H' : [0, 0], 'I' : [0,0]}
    for el in request_list:
        if el['cercle'] == "o":
            tab[el['touret_type']][0] += int(int(el['quantite_joues']) / 2)
        else:
            tab[el['touret_type']][1] += int(int(el['quantite_joues']) / 2)
    return tab


"""--------------INSERT UPDATED VALUES FOR STOCK---------------"""



def update_stock_demontage(request_list):
    tab = parse_request_list_dem_rec(request_list)

    for type_t in tab:
        nb_tour_dem_cercle, nb_tour_dem_n_cercle = tab[type_t][0], tab[type_t][1]
        if nb_tour_dem_cercle == 0 and nb_tour_dem_n_cercle == 0:
            continue

        req_select = """SELECT stock_demonte_cercle, stock_demonte_non_cercle\nFROM dbo.type_touret
        WHERE name = '{}'""".format(type_t)

        curr_numbers = pd.read_sql_query(req_select, engine).to_dict('records')[0]

        #START OF ERROR HANDLING
        req_select_monte = """SELECT stock_monte_cercle, stock_monte_non_cercle\nFROM dbo.type_touret
        WHERE name = '{}'""".format(type_t)
        tour_mont =  pd.read_sql_query(req_select_monte, engine).to_dict('records')[0]
        newd, newdn = tour_mont['stock_monte_cercle'] - nb_tour_dem_cercle, tour_mont['stock_monte_non_cercle'] - nb_tour_dem_n_cercle
        if newd < 0 or newdn < 0:
            return "405", "Pas assez de tourets sont en stock pour que ce soit possible"
        
        req_update_mont = """UPDATE dbo.type_touret\nSET stock_monte_cercle = '{}',
        stock_monte_non_cercle = '{}'\nWHERE name = '{}'""".format(newd, newdn, type_t)

        try:
            with con.begin():
                con.execute(req_update_mont)
        except Exception as e:
            print(e)
            return "400"
        #END

        ndc, ndnc = curr_numbers['stock_demonte_cercle'] + nb_tour_dem_cercle, curr_numbers['stock_demonte_non_cercle'] + nb_tour_dem_n_cercle

        req_update = """UPDATE dbo.type_touret\nSET stock_demonte_cercle = '{}',
        stock_demonte_non_cercle = '{}'\nWHERE name = '{}'""".format(ndc, ndnc, type_t)

        try:
            with con.begin():
                con.execute(req_update)
        except Exception as e:
            print(e)
            return "400"
    return "200"


def update_stock_reception(request_list):
    
    tab = parse_request_list_dem_rec(request_list)

    for type_t in tab:
        nb_tour_cercle, nb_tour_n_cercle = tab[type_t][0], tab[type_t][1]
        if nb_tour_cercle == 0 and nb_tour_n_cercle == 0:
            continue

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
    return "200"


def update_stock_chargement(request_list):
    tab = parse_request_list_chargement(request_list)

    for type_t in tab:
        nb_tour_dem_cercle, nb_tour_dem_n_cercle = tab[type_t][0], tab[type_t][1]
        if nb_tour_dem_cercle == 0 and nb_tour_dem_n_cercle == 0:
            continue

        req_select = """SELECT stock_demonte_cercle, stock_demonte_non_cercle\nFROM dbo.type_touret
        WHERE name = '{}'""".format(type_t)

        curr_numbers = pd.read_sql_query(req_select, engine).to_dict('records')[0]
        print("---")
        print(nb_tour_dem_cercle)
        print(nb_tour_dem_n_cercle)
        print(curr_numbers['stock_demonte_cercle'] - nb_tour_dem_cercle)
        print(curr_numbers['stock_demonte_non_cercle'] - nb_tour_dem_n_cercle)
        print("---")
        ndc, ndnc = curr_numbers['stock_demonte_cercle'] - nb_tour_dem_cercle, curr_numbers['stock_demonte_non_cercle'] - nb_tour_dem_n_cercle

        #ERROR HANDLING
        if  ndc < 0 or ndnc < 0:
            return "405", "ERROR: Vous essayez de charger plus que le stock de tourets démontés"
        #END OF ERROR HANDLING
        
        req_update = """UPDATE dbo.type_touret\nSET stock_demonte_cercle = '{}',
        stock_demonte_non_cercle = '{}'\nWHERE name = '{}'""".format(ndc, ndnc, type_t)

        try:
            with con.begin():
                con.execute(req_update)
        except Exception as e:
            print(e)
            return "400"
    return "200"