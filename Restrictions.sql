USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Restrictions] (
	[restrictionId] int NOT NULL PRIMARY KEY,
	[restrictionName] nchar(48) NOT NULL
) ON [PRIMARY]
GO