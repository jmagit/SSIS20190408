SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Cursos].[Horarios]') AND type in (N'U'))
BEGIN
CREATE TABLE [Cursos].[Horarios](
	[IdHorario] [tinyint] IDENTITY(1,1) NOT NULL,
	[Dias] [varchar](20) NOT NULL,
	[Horas] [varchar](30) NOT NULL,
	[Descripcion]  AS ((([Dias]+' (')+[Horas])+')'),
 CONSTRAINT [PK_Horarios] PRIMARY KEY NONCLUSTERED 
(
	[IdHorario] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Horarios] UNIQUE NONCLUSTERED 
(
	[Dias] ASC,
	[Horas] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Cursos].[CatalogoAcciones]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [Cursos].[CatalogoAcciones]
AS
SELECT     Cursos.AreasConocimiento.Area, Cursos.AccionesFormativas.CodAccion, Cursos.AccionesFormativas.NombreAccion, Cursos.AccionesFormativas.NumHoras, 
                      Cursos.Modalidades.Modalidad
FROM         Cursos.AreasConocimiento INNER JOIN
                      Cursos.AccionesFormativas ON Cursos.AreasConocimiento.IdArea = Cursos.AccionesFormativas.IdArea INNER JOIN
                      Cursos.Modalidades ON Cursos.AccionesFormativas.IdModalidad = Cursos.Modalidades.IdModalidad



' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Cursos].[Modalidades]') AND type in (N'U'))
BEGIN
CREATE TABLE [Cursos].[Modalidades](
	[IdModalidad] [char](1) NOT NULL,
	[Modalidad] [varchar](20) NOT NULL,
	[Metodologia] [varchar](max) NULL,
 CONSTRAINT [PK_Modalidades] PRIMARY KEY CLUSTERED 
(
	[IdModalidad] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Modalidad] UNIQUE NONCLUSTERED 
(
	[Modalidad] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Cursos].[AreasConocimiento]') AND type in (N'U'))
BEGIN
CREATE TABLE [Cursos].[AreasConocimiento](
	[IdArea] [smallint] IDENTITY(1,1) NOT NULL,
	[Area] [varchar](100) NOT NULL,
 CONSTRAINT [PK_AreasConocimiento] PRIMARY KEY CLUSTERED 
(
	[IdArea] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Area] UNIQUE NONCLUSTERED 
(
	[Area] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Cursos].[Grupos]') AND type in (N'U'))
BEGIN
CREATE TABLE [Cursos].[Grupos](
	[CodAccion] [smallint] NOT NULL,
	[NumGrupo] [tinyint] NOT NULL,
	[FechaInicio] [smalldatetime] NULL,
	[FechaFin] [smalldatetime] NULL,
	[IdHorario] [tinyint] NULL,
 CONSTRAINT [PK_Grupos] PRIMARY KEY CLUSTERED 
(
	[CodAccion] ASC,
	[NumGrupo] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Cursos].[Grupos]') AND name = N'IX_Fechas')
CREATE NONCLUSTERED INDEX [IX_Fechas] ON [Cursos].[Grupos] 
(
	[FechaInicio] ASC,
	[FechaFin] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Cursos].[Grupos]') AND name = N'IX_FechasFin')
CREATE NONCLUSTERED INDEX [IX_FechasFin] ON [Cursos].[Grupos] 
(
	[FechaFin] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]') AND type in (N'U'))
BEGIN
CREATE TABLE [Cursos].[AccionesFormativas](
	[CodAccion] [smallint] NOT NULL,
	[NombreAccion] [varchar](250) NOT NULL,
	[NumHoras] [smallint] NOT NULL,
	[IdModalidad] [char](1) NOT NULL,
	[IdArea] [smallint] NULL,
	[Resumen]  AS ((((([NombreAccion]+' [')+[IdModalidad])+', ')+CONVERT([varchar],[NumHoras],0))+'h]'),
 CONSTRAINT [PK_AccionesFormativas] PRIMARY KEY NONCLUSTERED 
(
	[CodAccion] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]') AND name = N'IX_AccionesFormativasNombre')
CREATE CLUSTERED INDEX [IX_AccionesFormativasNombre] ON [Cursos].[AccionesFormativas] 
(
	[NombreAccion] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]') AND name = N'IX_AccionesFormativas')
CREATE NONCLUSTERED INDEX [IX_AccionesFormativas] ON [Cursos].[AccionesFormativas] 
(
	[IdArea] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Cursos].[Calendario]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [Cursos].[Calendario]
AS
SELECT     Cursos.AreasConocimiento.Area, Cursos.AccionesFormativas.CodAccion, Cursos.AccionesFormativas.NombreAccion, 
                      Cursos.AccionesFormativas.NumHoras, Cursos.Modalidades.Modalidad, Cursos.Grupos.NumGrupo, Cursos.Grupos.FechaInicio, 
                      Cursos.Grupos.FechaFin, Cursos.Horarios.Descripcion
FROM         Cursos.AreasConocimiento INNER JOIN
                      Cursos.AccionesFormativas ON Cursos.AreasConocimiento.IdArea = Cursos.AccionesFormativas.IdArea INNER JOIN
                      Cursos.Modalidades ON Cursos.AccionesFormativas.IdModalidad = Cursos.Modalidades.IdModalidad INNER JOIN
                      Cursos.Grupos ON Cursos.AccionesFormativas.CodAccion = Cursos.Grupos.CodAccion INNER JOIN
                      Cursos.Horarios ON Cursos.Grupos.IdHorario = Cursos.Horarios.IdHorario
' 
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Cursos].[CK_Modalidades_Clv]') AND parent_object_id = OBJECT_ID(N'[Cursos].[Modalidades]'))
ALTER TABLE [Cursos].[Modalidades]  WITH CHECK ADD  CONSTRAINT [CK_Modalidades_Clv] CHECK  (([IdModalidad]=substring([IdModalidad],(1),(1))))
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Cursos].[FK_Grupos_AccionesFormativas]') AND parent_object_id = OBJECT_ID(N'[Cursos].[Grupos]'))
ALTER TABLE [Cursos].[Grupos]  WITH NOCHECK ADD  CONSTRAINT [FK_Grupos_AccionesFormativas] FOREIGN KEY([CodAccion])
REFERENCES [Cursos].[AccionesFormativas] ([CodAccion])
ON DELETE CASCADE
GO
ALTER TABLE [Cursos].[Grupos] CHECK CONSTRAINT [FK_Grupos_AccionesFormativas]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Cursos].[FK_Grupos_Horarios]') AND parent_object_id = OBJECT_ID(N'[Cursos].[Grupos]'))
ALTER TABLE [Cursos].[Grupos]  WITH NOCHECK ADD  CONSTRAINT [FK_Grupos_Horarios] FOREIGN KEY([IdHorario])
REFERENCES [Cursos].[Horarios] ([IdHorario])
GO
ALTER TABLE [Cursos].[Grupos] CHECK CONSTRAINT [FK_Grupos_Horarios]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Cursos].[CK_Fechas]') AND parent_object_id = OBJECT_ID(N'[Cursos].[Grupos]'))
ALTER TABLE [Cursos].[Grupos]  WITH NOCHECK ADD  CONSTRAINT [CK_Fechas] CHECK  (([FechaInicio]<=[FechaFin]))
GO
ALTER TABLE [Cursos].[Grupos] CHECK CONSTRAINT [CK_Fechas]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Cursos].[CK_NumeroGrupo]') AND parent_object_id = OBJECT_ID(N'[Cursos].[Grupos]'))
ALTER TABLE [Cursos].[Grupos]  WITH NOCHECK ADD  CONSTRAINT [CK_NumeroGrupo] CHECK  (([NumGrupo]>(0)))
GO
ALTER TABLE [Cursos].[Grupos] CHECK CONSTRAINT [CK_NumeroGrupo]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Cursos].[FK_AccionesFormativas_AreasConocimiento]') AND parent_object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]'))
ALTER TABLE [Cursos].[AccionesFormativas]  WITH NOCHECK ADD  CONSTRAINT [FK_AccionesFormativas_AreasConocimiento] FOREIGN KEY([IdArea])
REFERENCES [Cursos].[AreasConocimiento] ([IdArea])
ON DELETE CASCADE
GO
ALTER TABLE [Cursos].[AccionesFormativas] CHECK CONSTRAINT [FK_AccionesFormativas_AreasConocimiento]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Cursos].[FK_AccionesFormativas_Modalidades]') AND parent_object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]'))
ALTER TABLE [Cursos].[AccionesFormativas]  WITH NOCHECK ADD  CONSTRAINT [FK_AccionesFormativas_Modalidades] FOREIGN KEY([IdModalidad])
REFERENCES [Cursos].[Modalidades] ([IdModalidad])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Cursos].[AccionesFormativas] CHECK CONSTRAINT [FK_AccionesFormativas_Modalidades]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Cursos].[CK_CodAccion]') AND parent_object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]'))
ALTER TABLE [Cursos].[AccionesFormativas]  WITH NOCHECK ADD  CONSTRAINT [CK_CodAccion] CHECK  (([CodAccion]>(0)))
GO
ALTER TABLE [Cursos].[AccionesFormativas] CHECK CONSTRAINT [CK_CodAccion]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Cursos].[CK_NumeroHoras]') AND parent_object_id = OBJECT_ID(N'[Cursos].[AccionesFormativas]'))
ALTER TABLE [Cursos].[AccionesFormativas]  WITH NOCHECK ADD  CONSTRAINT [CK_NumeroHoras] CHECK  (([NumHoras]>(0)))
GO
ALTER TABLE [Cursos].[AccionesFormativas] CHECK CONSTRAINT [CK_NumeroHoras]
