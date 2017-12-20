USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Transactions] (
	[transactionId] int NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[transactionAmount] money NOT NULL,
	[transactionTimestamp] datetime NOT NULL
) ON [PRIMARY]
GO