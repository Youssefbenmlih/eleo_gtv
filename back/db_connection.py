import urllib
import sqlalchemy as sa
import keyring
keyring.set_password('db', 'sa', 'Dragon2001..')


def connect_to_db():
    params = urllib.parse.quote_plus("DRIVER={SQL Server};"
                                     "SERVER=localhost\SQLEXPRESS;"
                                     "DATABASE=eleo_gtv;"
                                     "UID=sa;"
                                     "PWD=" + keyring.get_password("db", "sa") + ";")

    engine = sa.create_engine(
        "mssql+pyodbc:///?odbc_connect={}".format(params))
    con = engine.connect()
    return con, engine


con, engine = connect_to_db()
