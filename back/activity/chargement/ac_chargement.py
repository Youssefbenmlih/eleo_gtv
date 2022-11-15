#helper functions to store the logic of the chargement endpoints

def gen_transaction_request_cha(detail_list, date, user_id):
    complete_transaction_request = '''BEGIN TRANSACTION\n'''

    req_par = '''INSERT INTO [dbo].[chargement]
           ([date]
           ,[id_user])
     VALUES
           ('{}'
           ,'{}')\nDECLARE @ID_CHARGEMENT INT = ISNULL((SELECT TOP 1 id from dbo.chargement ORDER BY id DESC), 1)\n'''.format(date, user_id)

    complete_transaction_request += req_par
    
    for el in detail_list:
        req_det = '''INSERT INTO [dbo].[det_chargement]
            ([id_chargement]
            ,[touret_type]
            ,[quantite_joues]
            ,[cercle]
            ,[ingelec]
            ,[Tare])
        VALUES
            (@ID_CHARGEMENT
            ,'{}'
            ,'{}'
            ,'{}'
            ,'{}'
            ,'{}')\n'''.format(el['touret_type'], el['quantite_joues'], el['cercle'],el['ingelec'],el['Tare'])
        complete_transaction_request += req_det

    complete_transaction_request += "COMMIT"
    return complete_transaction_request