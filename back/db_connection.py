import keyring
keyring.set_password('db', 'admindb', 'Imacab@2022')
import sqlalchemy as sa
import urllib


def connect_to_db():
    params = urllib.parse.quote_plus("DRIVER={SQL Server};"
                                    "SERVER=imacabsrv.database.windows.net;"
                                    "DATABASE=eleo_gtv;"
                                    "UID=admindb;"
                                    "PWD=" + keyring.get_password("db", "admindb") + ";")

    engine = sa.create_engine("mssql+pyodbc:///?odbc_connect={}".format(params))
    con = engine.connect()
    return con, engine

con, engine = connect_to_db()