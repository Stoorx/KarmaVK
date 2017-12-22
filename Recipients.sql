USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Recipients] (
	[localId] int NOT NULL,
	[transactionId] int NOT NULL
	CONSTRAINT [PK_Recipients] PRIMARY KEY (
		[localId],
		[transactionId]
	)
) ON [PRIMARY]
GO