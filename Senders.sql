USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Senders] (
	[localId] int NOT NULL,
	[transactionId] int NOT NULL
	CONSTRAINT [PK_Senders] PRIMARY KEY (
		[localId],
		[transactionId]
	)
) ON [PRIMARY]
GO