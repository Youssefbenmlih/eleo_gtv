import sys
sys.path.append('../')
from stock.stock_update_helper import *

def update_stock(request_list, activity):
    if activity == "demontage":
        return update_stock_demontage(request_list)
    if activity == "reception":
        return update_stock_reception(request_list)
    return update_stock_chargement(request_list)

