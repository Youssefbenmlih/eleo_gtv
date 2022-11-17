import requests
import unittest

"""
Here will be unit tests

first test all activties with normal request, bad request

then test user endpoints with normal request, bad request

and finallt stock
"""

class TestApiFT(unittest.TestCase):

    def test_get_stock(self):
        res = requests.get("http://127.0.0.1:5000/api/stock/get")
        self.assertEqual(res.status_code, 200)
    
    def test_reception_good_json(self):
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

if __name__ == '__main__':
    unittest.main()

#LAUNCH WITH: python -m unittest -v .\tests.py