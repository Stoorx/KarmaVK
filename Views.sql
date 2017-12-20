USE [KarmaBotVK]
GO

/* Registered conferences view */
CREATE VIEW [dbo].[RegisteredConferences]
AS SELECT DISTINCT 
		[chatId] 
	FROM [dbo].[Users]
	WHERE (chatId <> 0)
GO

/* All banned users */
CREATE VIEW [dbo].[BannedUsers]
AS SELECT 
		[chatId], 
		[vkId], 
		[banUntil] 
	FROM [dbo].[Users] 
	INNER JOIN [dbo].[BanList] ON [Users].[localId] = [BanList].[localId]
GO

/* Transaction journal access */
CREATE VIEW [dbo].[ClearTransactions]
AS SELECT TOP (1000)
			[Transactions].[transactionId], 
			[Senders].[localId] AS [sender], 
			[Recipients].[localId] AS [recipient], 
			[transactionAmount], 
			[transactionTimestamp]
	FROM [dbo].[Transactions]
	INNER JOIN [dbo].[Recipients] ON [Recipients].[transactionId] = [Transactions].[transactionId]
	INNER JOIN [dbo].[Senders] ON [Senders].[transactionId] = [Transactions].[transactionId]
GO