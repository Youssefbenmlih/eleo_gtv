import requests
import unittest

"""
Here will be unit tests

first test all activties with normal request, bad request

then test user endpoints with normal request, bad request

and finallt stock
"""

class TestEleoGTV_Api(unittest.TestCase):

    def test_get_stock(self):
        res = requests.get("http://127.0.0.1:5000/api/stock/get")
        self.assertEqual(res.status_code, 200)

    def test_get_users(self):
        res = requests.get("http://127.0.0.1:5000/api/users/list")
        self.assertEqual(res.status_code, 200)

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
        h_avant = stock_before['G']['stock_monte_cercle']

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
        h_après = stock_before['G']['stock_monte_cercle']

        self.assertEqual((g_avant + 1, h_avant + 1), (g_après, h_après))

if __name__ == '__main__':
    unittest.main()

#LAUNCH WITH: python -m unittest -v .\tests.py