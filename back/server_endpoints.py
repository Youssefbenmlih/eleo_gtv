from stock.stock_endpoints import stock
from user.user_endpoints import user
from activity.historique import historique
from activity.inventaire.inv_endpoints import inventaire
from activity.chargement.cha_endpoints import chargement
from activity.reception.rec_endpoints import reception
from activity.demontage.dem_endpoints import demontage
from flask import Flask

app = Flask(__name__)

app.register_blueprint(user)
app.register_blueprint(demontage)
app.register_blueprint(reception)
app.register_blueprint(chargement)
app.register_blueprint(inventaire)
app.register_blueprint(historique)
app.register_blueprint(stock)


@app.route('/', methods=['GET'])
def home():
    return "welcome to the eleo_gtv api"


app.run()
