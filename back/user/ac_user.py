import pandas as pd


def check_connection(data, engine):
    req = 'SELECT id, name, email, mot_de_passe FROM dbo.users WHERE email = \'{}\''.format(
        data['email'])
    users = pd.read_sql_query(req, engine).to_dict('records')
    if len(users) == 1 and users[0]['mot_de_passe'] == data['mot_de_passe']:
        return users[0], True
    return "error", False


def get_insert_query(request_data):
    req = '''INSERT INTO [dbo].[users]
           ([name]
           ,[email]
           ,[mot_de_passe]
           ,[admin])
     VALUES
           ('{0}', '{1}', '{2}', '{3}')'''.format(request_data['name'], request_data['email'],
                                                  request_data['mot_de_passe'], request_data['admin'])
    return req
