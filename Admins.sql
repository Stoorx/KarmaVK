USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Admins] (
	[localId] int NOT NULL,
	[rightId] int NOT NULL,
	[gotTimestamp] datetime NULL
	CONSTRAINT [PK_Admins] PRIMARY KEY (
		[localId],
		[rightId]
	)
) ON [PRIMARY]
GO