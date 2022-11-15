from stock_update_helper import *

def update_stock(request_list, activity):
    if activity == "demontage":
        update_stock_demontage(request_list)
    if activity == "reception":
        update_stock_reception(request_list)
    update_stock_chargement(request_list)

#TEST
l = [ 
    {
      "touret_type" : "G",
      "quantite_tourets" : "22",
      "cercle" : "o",
      "ingelec": "o"
    },
    {
      "touret_type" : "H",
      "quantite_tourets" : "12",
      "cercle" : "n",
      "ingelec": "o"
    }
 ]

update_stock(l, "reception")
