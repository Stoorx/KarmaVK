USE [KarmaBotVK]
GO

/* Write transaction to journal and make connections*/
CREATE PROCEDURE [dbo].[WriteTransaction]
	@senderId int = 0,
	@recipientId int = 0,
	@transactionAmount money = 0
AS
BEGIN
	IF @senderId IS NULL OR @recipientId IS NULL
		RAISERROR (N'Sender or Recipient is NULL', 11, 1)
	/* If sender and recipient in one chat */
	IF (SELECT [chatId] FROM [dbo].[Users] WHERE [localId] = @senderId) = (SELECT [chatId] FROM [dbo].[Users] WHERE [localId] = @recipientId) OR @senderId = 0 OR @recipientId = 0
	BEGIN
		DECLARE @currentTime datetime = CURRENT_TIMESTAMP
		DECLARE @currentTransaction int = 0;
		
		/* Write to journal */
		INSERT INTO [dbo].[Transactions] (transactionAmount, transactionTimestamp) VALUES (@transactionAmount, @currentTime);
		SET @currentTransaction = (SELECT TOP(1) [transactionId] FROM [dbo].[Transactions] ORDER BY [transactionId] DESC)
		
		/* Make connections */
		INSERT INTO [dbo].[Senders] (localId, transactionId) VALUES (@senderId, @currentTransaction)
		INSERT INTO [dbo].[Recipients] (localId, transactionId) VALUES (@recipientId, @currentTransaction)
	END
	ELSE
	BEGIN
		RAISERROR (N'Sender and Recipient are not in the same chat', 11, 1)
	END
	
END
GO

CREATE PROCEDURE [dbo].[RegisterUser]
	@chatId int = 0,
	@userVkId int = 0
AS
BEGIN
	IF NOT EXISTS (SELECT [localId] FROM [dbo].[Users] WHERE [chatId] = @chatId AND [vkId] = @userVkId)
	BEGIN
		/* Register new user */
		INSERT INTO [dbo].[Users] (chatId, vkId, points) VALUES (@chatId, @userVkId, 0)
		DECLARE @userLocalId int = 0;
		SET @userLocalId = (SELECT [localId] FROM [dbo].[Users] WHERE chatId = @chatId AND vkId = @userVkId)
		EXEC [dbo].[WriteTransaction] @senderId = 0, @recipientId = @userLocalId, @transactionAmount = 0
		
		/* Emmit start Karma */
		DECLARE @emmitAmount money = 0
		SET @emmitAmount = (SELECT [value] FROM [dbo].[Config] WHERE [parameter] = N'StartKarma')
		IF @emmitAmount IS NULL
			SET @emmitAmount = 0
		UPDATE [dbo].[Users] SET [points] = [points] + @emmitAmount WHERE [localId] = @userLocalId;
		EXEC [dbo].[WriteTransaction] @senderId = 0, @recipientId = @userLocalId, @transactionAmount = @emmitAmount
	END
END
GO

/* Transfer points from sender to recipient */
CREATE PROCEDURE [dbo].[ChangeKarma]
	@chatId int = 0,
	@senderVkId int = 0,
	@recipientVkId int = 0,
	@transactionAmount money = 0
AS
BEGIN
	DECLARE @senderLocalId int = 0
	DECLARE @recipientLocalId int = 0
	SET @senderLocalId = (SELECT [localId] FROM [dbo].[Users] WHERE [chatId] = @chatId AND [vkId] = @senderVkId)
	SET @RecipientLocalId = (SELECT [localId] FROM [dbo].[Users] WHERE [chatId] = @chatId AND [vkId] = @recipientVkId)
	
	/* If users have not registered yet*/
	IF @senderLocalId IS NULL
	BEGIN
		EXEC [dbo].[RegisterUser] @chatId, @senderVkId
		SET @senderLocalId = (SELECT [localId] FROM [dbo].[Users] WHERE [chatId] = @chatId AND [vkId] = @senderVkId)
	END
	IF @RecipientLocalId IS NULL
	BEGIN
		EXEC [dbo].[RegisterUser] @chatId, @recipientVkId
		SET @RecipientLocalId = (SELECT [localId] FROM [dbo].[Users] WHERE [chatId] = @chatId AND [vkId] = @recipientLocalId)
	END

	/* Transfer karma */
	UPDATE [dbo].[Users] SET [points] = [points] + @transactionAmount WHERE [localId] = @recipientLocalId
	UPDATE [dbo].[Users] SET [points] = [points] - @transactionAmount WHERE [localId] = @senderLocalId
	EXEC [dbo].[WriteTransaction] @senderLocalId, @recipientLocalId, @transactionAmount
END
GO

