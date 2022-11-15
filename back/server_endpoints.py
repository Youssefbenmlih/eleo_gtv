from flask import Flask

app = Flask(__name__)

from activity.demontage.dem_endpoints import demontage
from activity.reception.rec_endpoints import reception
from activity.chargement.cha_endpoints import chargement
from user.user_endpoints import user
app.register_blueprint(user)
app.register_blueprint(demontage)
app.register_blueprint(reception)
app.register_blueprint(chargement)

@app.route('/', methods=['GET'])
def home():
    return "welcome to the eleo_gtv api"

app.run()