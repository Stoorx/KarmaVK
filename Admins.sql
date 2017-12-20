USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Admins] (
	[localId] int NOT NULL,
	[rightId] int NOT NULL,
	[gotTimestamp] datetime NULL
) ON [PRIMARY]
GO