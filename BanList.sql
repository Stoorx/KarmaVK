USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[BanList] (
	[localId] int NOT NULL PRIMARY KEY,
	[banUntil] datetime NOT NULL
) ON [PRIMARY]
GO