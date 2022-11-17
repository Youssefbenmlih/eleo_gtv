import requests
import unittest

"""
activities unit tests.
"""

class TestActivityApi(unittest.TestCase):

    def test_reception_bad_json(self):
        obj = {
            "date": "10/31/2022 11:15:00",
            "user_id": "1",
            "list": [
            {
                "touret_type": "M",
                "cercle": "o",
                "ingelec": "n",
                "numero_de_lot": "GBM0003078"
            },
                {
                "touret_type": "H",
                "cercle": "o",
                "ingelec": "o",
                "numero_de_lot": "HBM0003077"
            }
            ]
        }
        res = requests.post("http://127.0.0.1:5000/api/activity/reception", json = obj)
        self.assertEqual(res.status_code, 400)
    
    def test_reception_good_json(self):
        stock_before = requests.get("http://127.0.0.1:5000/api/stock/get").json()
        
        g_avant = stock_before['G']['stock_monte_cercle']
        h_avant = stock_before['H']['stock_monte_cercle']

        obj = {
            "date": "10/31/2022 11:15:00",
            "user_id": "1",
            "list": [
            {
                "touret_type": "G",
                "cercle": "o",
                "ingelec": "o",
                "numero_de_lot": "GBM0003078"
            },
                {
                "touret_type": "H",
                "cercle": "o",
                "ingelec": "o",
                "numero_de_lot": "HBM0003077"
            }
            ]
        }
        res = requests.post("http://127.0.0.1:5000/api/activity/reception", json = obj)
        self.assertEqual(res.status_code, 200)

        stock_before = requests.get("http://127.0.0.1:5000/api/stock/get").json()
        
        g_après = stock_before['G']['stock_monte_cercle']
        h_après = stock_before['H']['stock_monte_cercle']

        self.assertEqual((g_avant + 1, h_avant + 1), (g_après, h_après))

    def test_chargement_bad_json(self):
        obj = {
            "date" : "10/31/2022 14:15:00",
            "user_id" : "1",
            "list" : [ 
            {
                "touret_type" : "G",
                "quantite_joues" : "2",
                "cercle" : "o",
                "ingelec": "o",
                "Tare" : "26000" 
            },
            {
                "touret_type" : "M",
                "quantite_joues" : "2",
                "cercle" : "o",
                "ingelec": "o",
                "Tare" : "22500"
            }
            ]
        }
        res = requests.post("http://127.0.0.1:5000/api/activity/chargement", json = obj)
        self.assertEqual(res.status_code, 400)
    
    def test_chargement_good_json(self):
        stock_before = requests.get("http://127.0.0.1:5000/api/stock/get").json()
        
        g_avant = stock_before['G']['stock_demonte_cercle']
        h_avant = stock_before['H']['stock_demonte_cercle']

        obj = {
            "date" : "10/31/2022 14:15:00",
            "user_id" : "1",
            "list" : [ 
            {
                "touret_type" : "G",
                "quantite_joues" : "2",
                "cercle" : "o",
                "ingelec": "o",
                "Tare" : "26000" 
            },
            {
                "touret_type" : "H",
                "quantite_joues" : "2",
                "cercle" : "o",
                "ingelec": "o",
                "Tare" : "22500"
            }
            ]
        }

        res = requests.post("http://127.0.0.1:5000/api/activity/chargement", json = obj)
        self.assertEqual(res.status_code, 200)

        stock_before = requests.get("http://127.0.0.1:5000/api/stock/get").json()
        
        g_après = stock_before['G']['stock_demonte_cercle']
        h_après = stock_before['H']['stock_demonte_cercle']

        self.assertEqual((g_avant - 1, h_avant - 1), (g_après, h_après))

    def test_demontage_bad_json(self):
        obj = {
            "date" : "10/31/2022 14:15:00",
            "user_id" : "1",
            "list" : [ 
            {
                "touret_type" : "G",
                "quantite_tourets" : "2",
                "cercle" : "o",
                "ingelec": "o"
            },
            {
                "touret_type" : "M",
                "quantite_tourets" : "2",
                "cercle" : "o",
                "ingelec": "o"
            }
            ]
        }
        res = requests.post("http://127.0.0.1:5000/api/activity/demontage", json = obj)
        self.assertEqual(res.status_code, 400)
    
    def test_demontage_good_json(self):
        stock_before = requests.get("http://127.0.0.1:5000/api/stock/get").json()
        
        g_avant_d = stock_before['G']['stock_demonte_cercle']
        h_avant_d = stock_before['H']['stock_demonte_cercle']
        g_avant_m = stock_before['G']['stock_monte_cercle']
        h_avant_m = stock_before['H']['stock_monte_cercle']

        obj = {
            "date" : "10/31/2022 14:15:00",
            "user_id" : "1",
            "list" : [ 
            {
                "touret_type" : "G",
                "quantite_tourets" : "1",
                "cercle" : "o",
                "ingelec": "o",
            },
            {
                "touret_type" : "H",
                "quantite_tourets" : "1",
                "cercle" : "o",
                "ingelec": "o",
            }
            ]
        }

        res = requests.post("http://127.0.0.1:5000/api/activity/demontage", json = obj)
        self.assertEqual(res.status_code, 200)

        stock_before = requests.get("http://127.0.0.1:5000/api/stock/get").json()
        
        g_apres_d = stock_before['G']['stock_demonte_cercle']
        h_apres_d = stock_before['H']['stock_demonte_cercle']
        g_apres_m = stock_before['G']['stock_monte_cercle']
        h_apres_m = stock_before['H']['stock_monte_cercle']

        self.assertEqual((g_avant_m - 1, h_avant_m - 1), (g_apres_m, h_apres_m))
        self.assertEqual((g_avant_d + 1, h_avant_d + 1), (g_apres_d, h_apres_d))
