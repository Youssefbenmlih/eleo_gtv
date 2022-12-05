# helper functions to store the logic of the reception endpoints

def gen_transaction_request_rec(detail_list, date, user_id):
    complete_transaction_request = '''BEGIN TRANSACTION\n'''

    req_par = '''INSERT INTO [dbo].[reception]
           ([date]
           ,[id_user])
     VALUES
           ('{}'
           ,'{}')\n
           IF @@ERROR <> 0 BEGIN RAISERROR('Insert into reception failed', 16, -1) ROLLBACK TRANSACTION RETURN END
           DECLARE @ID_RECEPTION INT = ISNULL((SELECT TOP 1 id from dbo.reception ORDER BY id DESC), 1)\n'''.format(date, user_id)

    complete_transaction_request += req_par

    for el in detail_list:
        req_det = '''INSERT INTO [dbo].[det_reception]
            ([id_reception]
            ,[touret_type]
            ,[cercle]
            ,[ingelec]
            ,[numero_de_lot]
            ,[quantite_tourets])
        VALUES
            (@ID_RECEPTION
            ,'{}'
            ,'{}'
            ,'{}'
            ,'{}'
            ,'{}')\n
            IF @@ERROR <> 0 BEGIN 
            RAISERROR('Insert into det_reception table failed', 16, -1) ROLLBACK TRANSACTION RETURN 
            END\n'''.format(el['touret_type'], el['cercle'], el['ingelec'], el['numero_de_lot'], el['quantite_tourets'])
        complete_transaction_request += req_det

    complete_transaction_request += "COMMIT TRANSACTION"
    return complete_transaction_request
