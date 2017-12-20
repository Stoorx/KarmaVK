USE [KarmaBotVK]
GO

/* This trigger unban unbannable admin automatically */
CREATE TRIGGER [dbo].[autoUnbannable]
	ON [dbo].[BanList]
	AFTER INSERT
AS
BEGIN
	DECLARE @currentId int = 0
	DECLARE unbanCursor CURSOR
	FAST_FORWARD
	FOR SELECT [localId] FROM inserted

	OPEN unbanCursor
	FETCH NEXT FROM unbanCursor INTO @currentId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (SELECT [rightName] FROM [dbo].[Admins] 
			INNER JOIN [dbo].[AdminRights] ON [Admins].[rightId] = [AdminRights].[rightId]
			WHERE [localId] = @currentId AND [rightName] = N'Unbannable')
		BEGIN
			DELETE FROM [dbo].[BanList] WHERE [localId] = @currentId
		END
		FETCH NEXT FROM unbanCursor INTO @currentId
	END
	CLOSE unbanCursor
	DEALLOCATE unbanCursor
END
GO


/* Makes a timestamp on admin's rights */
CREATE TRIGGER [dbo].[gotRightsTS]
	ON [dbo].[Admins]
	AFTER INSERT
AS
BEGIN
	UPDATE [dbo].[Admins] 
		SET [gotTimestamp] = CURRENT_TIMESTAMP 
		WHERE [localId] = (SELECT localId  FROM inserted) 
			AND [rightId] = (SELECT rightId FROM inserted)
END
GO

/* Makes a timestamp on admin's rights */
CREATE TRIGGER [dbo].[userClearDelete]
	ON [dbo].[Users]
	AFTER DELETE
AS
BEGIN
	DELETE FROM [dbo].[Transactions] 
		WHERE [transactionId] =	
			(SELECT [transactionId] FROM [dbo].[Senders] WHERE [localId] = (SELECT [localId] FROM deleted))
	DELETE FROM [dbo].[Transactions] 
		WHERE [transactionId] =	
			(SELECT [transactionId] FROM [dbo].[Recipients] WHERE [localId] = (SELECT [localId] FROM deleted))
END
GO