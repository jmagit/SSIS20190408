USE [CursoSSIS]
GO

/****** Object:  Table [Pelis].[Clientes]    Script Date: 08/04/2019 18:20:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Pelis].[Clientes](
	[idCliente] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[idCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [Pelis].[Alquileres]    Script Date: 09/04/2019 9:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Pelis].[Alquileres](
	[IdAlquiler] [int] IDENTITY(1,1) NOT NULL,
	[IdPelicula] [int] NOT NULL,
	[IdCliente] [int] NOT NULL,
	[FAlquiler] [datetime] NOT NULL,
	[FDevolucion] [datetime] NULL,
 CONSTRAINT [PK_Alquileres] PRIMARY KEY CLUSTERED 
(
	[IdAlquiler] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Pelis].[Alquileres]  WITH CHECK ADD  CONSTRAINT [FK_Alquileres_Clientes] FOREIGN KEY([IdCliente])
REFERENCES [Pelis].[Clientes] ([idCliente])
GO

ALTER TABLE [Pelis].[Alquileres] CHECK CONSTRAINT [FK_Alquileres_Clientes]
GO

ALTER TABLE [Pelis].[Alquileres]  WITH CHECK ADD  CONSTRAINT [FK_Alquileres_Peliculas] FOREIGN KEY([IdPelicula])
REFERENCES [Pelis].[Peliculas] ([idPelicula])
GO

ALTER TABLE [Pelis].[Alquileres] CHECK CONSTRAINT [FK_Alquileres_Peliculas]
GO

