import requests
import unittest
from activity_tests import TestActivityApi

"""
Here will be unit tests

first test all activties with normal request, bad request

then test stock ep, user endpoints with normal request, bad request

"""

class TestEleoGTV_Api_User_and_Stock(unittest.TestCase):

    def test_get_stock(self):
        res = requests.get("http://127.0.0.1:5000/api/stock/get")
        self.assertEqual(res.status_code, 200)

    def test_get_users(self):
        res = requests.get("http://127.0.0.1:5000/api/users/list")
        self.assertEqual(res.status_code, 200)

    def test_connect_user_valid(self):
        obj = {
            "email": "youssefbenmlih@gmail.com", 
            "mot_de_passe" : "mdp"
        }
        res = requests.post("http://127.0.0.1:5000/api/users/connect", json = obj)
        self.assertEqual(res.status_code, 200)
    
    def test_connect_user_invalid(self):
        fake_user = {
            "email": "fake@email.com", 
            "mot_de_passe" : "123mdp"
        }
        res = requests.post("http://127.0.0.1:5000/api/users/connect", json = fake_user)
        self.assertEqual(res.status_code, 403)
    
    def test_add_user(self):
        user = {
            "name": "test",
            "email": "user@email.com", 
            "mot_de_passe" : "mdp",
            "admin" : "n"
        }
        res = requests.post("http://127.0.0.1:5000/api/users/add", json = user)
        self.assertEqual(res.status_code, 200)

def suite():
    suite = unittest.TestSuite()
    suite.addTests(TestEleoGTV_Api_User_and_Stock)
    suite.addTests(TestActivityApi)
    return suite

if __name__ == '__main__':
    runner = unittest.TextTestRunner()
    runner.run(suite())

#LAUNCH WITH: python -m unittest -v -f .\test_main.py