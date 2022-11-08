CREATE TABLE [users] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255),
  [email] nvarchar(255),
  [mot_de_passe] nvarchar(255),
  [admin] boolean,
  PRIMARY KEY ([id])
)
GO

CREATE TABLE [inventaire] (
  [id_user] int,
  [date] timestamp,
  [nb_monte_cercle] int,
  [nb_demonte_cercle] int,
  [nb_monte_non_cercle] int,
  [nb_demonte_non_cercle] int
)
GO

CREATE TABLE [chargement] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [date] timestamp,
  [id_user] int
)
GO

CREATE TABLE [demontage] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [date] timestamp,
  [id_user] int
)
GO

CREATE TABLE [reception] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [date] timestamp,
  [id_user] int
)
GO

CREATE TABLE [det_chargement] (
  [id] int IDENTITY(1, 1),
  [id_chargement] int,
  [id_touret_type] int,
  [quantite_joues] int,
  [cercle] boolean,
  [ingelec] boolean,
  [Tare] int,
  PRIMARY KEY ([id], [id_chargement])
)
GO

CREATE TABLE [det_demontage] (
  [id] int IDENTITY(1, 1),
  [id_demontage] int,
  [id_touret_type] int,
  [quantite_tourets] int,
  [cercle] boolean,
  [ingelec] boolean,
  PRIMARY KEY ([id], [id_demontage])
)
GO

CREATE TABLE [det_reception] (
  [id] int IDENTITY(1, 1),
  [id_reception] int,
  [id_touret_type] int,
  [quantite_tourets] int,
  [cercle] boolean,
  [ingelec] boolean,
  [numero_de_lot] nvarchar(255),
  PRIMARY KEY ([id], [id_reception])
)
GO

CREATE TABLE [type_touret] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255) NOT NULL CHECK ([name] IN ('i', 'g', 'h')),
  [stock_monte_cercle] int,
  [stock_demonte_cercle] int,
  [stock_monte_non_cercle] int,
  [stock_demonte_non_cercle] int
)
GO

ALTER TABLE [chargement] ADD FOREIGN KEY ([id_user]) REFERENCES [users] ([id])
GO

ALTER TABLE [demontage] ADD FOREIGN KEY ([id_user]) REFERENCES [users] ([id])
GO

ALTER TABLE [reception] ADD FOREIGN KEY ([id_user]) REFERENCES [users] ([id])
GO

ALTER TABLE [det_chargement] ADD FOREIGN KEY ([id_chargement]) REFERENCES [chargement] ([id])
GO

ALTER TABLE [det_demontage] ADD FOREIGN KEY ([id_demontage]) REFERENCES [demontage] ([id])
GO

ALTER TABLE [det_reception] ADD FOREIGN KEY ([id_reception]) REFERENCES [reception] ([id])
GO

ALTER TABLE [det_demontage] ADD FOREIGN KEY ([id_touret_type]) REFERENCES [type_touret] ([id])
GO

ALTER TABLE [det_chargement] ADD FOREIGN KEY ([id_touret_type]) REFERENCES [type_touret] ([id])
GO

ALTER TABLE [det_reception] ADD FOREIGN KEY ([id_touret_type]) REFERENCES [type_touret] ([id])
GO

ALTER TABLE [inventaire] ADD FOREIGN KEY ([nb_monte_cercle]) REFERENCES [type_touret] ([stock_monte_cercle])
GO

ALTER TABLE [inventaire] ADD FOREIGN KEY ([nb_demonte_cercle]) REFERENCES [type_touret] ([stock_demonte_cercle])
GO

ALTER TABLE [inventaire] ADD FOREIGN KEY ([nb_monte_non_cercle]) REFERENCES [type_touret] ([stock_monte_non_cercle])
GO

ALTER TABLE [inventaire] ADD FOREIGN KEY ([nb_demonte_non_cercle]) REFERENCES [type_touret] ([stock_demonte_non_cercle])
GO

ALTER TABLE [inventaire] ADD FOREIGN KEY ([id_user]) REFERENCES [users] ([id])
GO
