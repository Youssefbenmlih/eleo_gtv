#helper functions to store the logic of the demontage endpoints

def gen_transaction_request_dem(detail_list, date, user_id):
    complete_transaction_request = '''BEGIN TRANSACTION\n'''

    req_par = '''INSERT INTO [dbo].[demontage]
           ([date]
           ,[id_user])
     VALUES
           ('{}'
           ,'{}')\nDECLARE @ID_DEMONTAGE INT = ISNULL((SELECT TOP 1 id from dbo.demontage ORDER BY id DESC), 1)\n'''.format(date, user_id)

    complete_transaction_request += req_par
    
    for el in detail_list:
        req_det = '''INSERT INTO [dbo].[det_demontage]
            ([id_demontage]
            ,[touret_type]
            ,[quantite_tourets]
            ,[cercle]
            ,[ingelec])
        VALUES
            (@ID_DEMONTAGE
            ,'{}'
            ,'{}'
            ,'{}'
            ,'{}')\n'''.format(el['touret_type'], el['quantite_tourets'], el['cercle'],el['ingelec'])
        complete_transaction_request += req_det
    
    complete_transaction_request += "COMMIT"
    return complete_transaction_request