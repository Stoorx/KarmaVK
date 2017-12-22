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
CREATE VIEW [dbo].[RestrictedUsers]
AS SELECT 
		[chatId], 
		[vkId],
		[restrictionName],
		[restrictedUntil] 
	FROM [dbo].[UserRestrictions] 
	INNER JOIN [dbo].[Users] ON [Users].[localId] = [UserRestrictions].[localId]
	INNER JOIN [dbo].[Restrictions] ON [Restrictions].[restrictionId] = [UserRestrictions].[restrictionId]
GO

/* Transaction journal access */
CREATE VIEW [dbo].[ClearTransactions]
AS SELECT
		[Transactions].[transactionId], 
		[Senders].[localId] AS [sender], 
		[Recipients].[localId] AS [recipient], 
		[transactionAmount], 
		[transactionTimestamp]
	FROM [dbo].[Transactions]
	INNER JOIN [dbo].[Recipients] ON [Recipients].[transactionId] = [Transactions].[transactionId]
	INNER JOIN [dbo].[Senders] ON [Senders].[transactionId] = [Transactions].[transactionId]
GO