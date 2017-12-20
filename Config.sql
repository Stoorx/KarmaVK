USE [KarmaBotVK]
GO

/* Config table */
CREATE TABLE [dbo].[Config] (
	[parameter] nchar(24) NOT NULL PRIMARY KEY,
	[value] nchar(48)
) ON [PRIMARY]
GO