USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[AdminRights] (
	[rightId] int NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[rightName] nchar(48) NOT NULL
) ON [PRIMARY]