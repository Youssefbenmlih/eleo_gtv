CREATE TABLE [users] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] nvarchar(255),
  [email] nvarchar(255),
  [mot_de_passe] nvarchar(255),
  [admin] varchar(1)
)
GO
/****** Object:  Table [dbo].[type_touret]    Script Date: 25/11/2022 12:24:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[type_touret](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[stock_monte_cercle] [int] NULL,
	[stock_demonte_cercle] [int] NULL,
	[stock_monte_non_cercle] [int] NULL,
	[stock_demonte_non_cercle] [int] NULL,
 CONSTRAINT [PK__type_tou__3213E83F0854789B] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_type_touret] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[type_touret]  WITH CHECK ADD CHECK  (([name]='h' OR [name]='g' OR [name]='i'))
GO



/****** Object:  Table [dbo].[chargement]    Script Date: 25/11/2022 12:22:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[chargement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[id_user] [int] NULL,
 CONSTRAINT [PK__chargeme__3213E83F77EEC253] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[chargement]  WITH CHECK ADD  CONSTRAINT [FK__chargemen__id_us__6C190EBB] FOREIGN KEY([id_user])
REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[chargement] CHECK CONSTRAINT [FK__chargemen__id_us__6C190EBB]
GO


/****** Object:  Table [dbo].[demontage]    Script Date: 25/11/2022 12:23:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[demontage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[id_user] [int] NULL,
 CONSTRAINT [PK__demontag__3213E83FCAAFF0D7] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[demontage]  WITH CHECK ADD  CONSTRAINT [FK__demontage__id_us__02FC7413] FOREIGN KEY([id_user])
REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[demontage] CHECK CONSTRAINT [FK__demontage__id_us__02FC7413]
GO

/****** Object:  Table [dbo].[det_reception]    Script Date: 25/11/2022 12:23:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[reception]    Script Date: 25/11/2022 12:24:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[reception](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[id_user] [int] NULL,
 CONSTRAINT [PK__receptio__3213E83FD4EA68FB] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[reception]  WITH CHECK ADD  CONSTRAINT [FK__reception__id_us__03F0984C] FOREIGN KEY([id_user])
REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[reception] CHECK CONSTRAINT [FK__reception__id_us__03F0984C]
GO


/****** Object:  Table [dbo].[det_chargement]    Script Date: 25/11/2022 12:25:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[det_chargement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_chargement] [int] NOT NULL,
	[touret_type] [nvarchar](255) NULL,
	[quantite_joues] [int] NULL,
	[cercle] [varchar](1) NULL,
	[ingelec] [varchar](1) NULL,
	[Tare] [int] NULL,
 CONSTRAINT [PK__det_char__012A2208F0CF250A] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[id_chargement] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[det_chargement]  WITH CHECK ADD  CONSTRAINT [FK_det_chargement_type_touret] FOREIGN KEY([touret_type])
REFERENCES [dbo].[type_touret] ([name])
GO

ALTER TABLE [dbo].[det_chargement] CHECK CONSTRAINT [FK_det_chargement_type_touret]
GO

ALTER TABLE [dbo].[det_chargement]  WITH CHECK ADD  CONSTRAINT [FK_id_det_charg_to_id_ch__6EF57B66] FOREIGN KEY([id_chargement])
REFERENCES [dbo].[chargement] ([id])
GO

ALTER TABLE [dbo].[det_chargement] CHECK CONSTRAINT [FK_id_det_charg_to_id_ch__6EF57B66]
GO

/****** Object:  Table [dbo].[det_demontage]    Script Date: 25/11/2022 12:25:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[det_demontage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_demontage] [int] NOT NULL,
	[touret_type] [nvarchar](255) NULL,
	[quantite_tourets] [int] NULL,
	[cercle] [varchar](1) NULL,
	[ingelec] [varchar](1) NULL,
 CONSTRAINT [PK__det_demo__FFF458C30D994DCA] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[id_demontage] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[det_demontage]  WITH CHECK ADD  CONSTRAINT [FK__detail_demontage_to_demontage] FOREIGN KEY([id_demontage])
REFERENCES [dbo].[demontage] ([id])
GO

ALTER TABLE [dbo].[det_demontage] CHECK CONSTRAINT [FK__detail_demontage_to_demontage]
GO

ALTER TABLE [dbo].[det_demontage]  WITH CHECK ADD  CONSTRAINT [FK_det_demontage_type_touret] FOREIGN KEY([touret_type])
REFERENCES [dbo].[type_touret] ([name])
GO

ALTER TABLE [dbo].[det_demontage] CHECK CONSTRAINT [FK_det_demontage_type_touret]
GO


/****** Object:  Table [dbo].[det_reception]    Script Date: 25/11/2022 12:25:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[det_reception](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_reception] [int] NOT NULL,
	[touret_type] [nvarchar](255) NULL,
	[cercle] [varchar](1) NULL,
	[ingelec] [varchar](1) NULL,
	[numero_de_lot] [nvarchar](255) NULL,
 CONSTRAINT [PK__det_rece__586F69E210DA4221] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[id_reception] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[det_reception]  WITH CHECK ADD  CONSTRAINT [FK_det_reception_type_touret] FOREIGN KEY([touret_type])
REFERENCES [dbo].[type_touret] ([name])
GO

ALTER TABLE [dbo].[det_reception] CHECK CONSTRAINT [FK_det_reception_type_touret]
GO

ALTER TABLE [dbo].[det_reception]  WITH CHECK ADD  CONSTRAINT [FK_id_det_recep_to_id_rec__06CD04F7] FOREIGN KEY([id_reception])
REFERENCES [dbo].[reception] ([id])
GO

ALTER TABLE [dbo].[det_reception] CHECK CONSTRAINT [FK_id_det_recep_to_id_rec__06CD04F7]
GO

/****** Object:  Table [dbo].[inventaire]    Script Date: 25/11/2022 12:26:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[inventaire](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_user] [int] NULL,
	[date] [datetime] NOT NULL,
	[nb_monte_cercle] [int] NULL,
	[nb_demonte_cercle] [int] NULL,
	[nb_monte_non_cercle] [int] NULL,
	[nb_demonte_non_cercle] [int] NULL,
 CONSTRAINT [PK_inventaire_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[inventaire]  WITH CHECK ADD  CONSTRAINT [FK__inventair__id_us__0A9D95DB] FOREIGN KEY([id_user])
REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[inventaire] CHECK CONSTRAINT [FK__inventair__id_us__0A9D95DB]
GO


