import urllib
import sqlalchemy as sa
import keyring


def connect_to_db():
    params = urllib.parse.quote_plus("DRIVER={SQL Server};"
                                     "SERVER=prod2srv;"
                                     "DATABASE=eleo_gtv;"
                                     "UID=yassines;"
                                     "PWD=" + keyring.get_password("db", "yassines") + ";")

    engine = sa.create_engine(
        "mssql+pyodbc:///?odbc_connect={}".format(params))
    con = engine.connect()
    return con, engine


con, engine = connect_to_db()
