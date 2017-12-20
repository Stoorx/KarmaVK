USE [KarmaBotVK]
GO

/* Recipients constraints */
ALTER TABLE [dbo].[Recipients]
ADD CONSTRAINT FK_Recipients_TransactionsTransactionId FOREIGN KEY (transactionId)
	REFERENCES [dbo].[Transactions] (transactionId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

ALTER TABLE [dbo].[Recipients]
ADD CONSTRAINT FK_Recipients_UsersLocalId FOREIGN KEY (localId)
	REFERENCES [dbo].[Users] (localId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO


/* Senders constraints */
ALTER TABLE [dbo].[Senders]
ADD CONSTRAINT FK_Senders_TransactionsTransactionId FOREIGN KEY (transactionId)
	REFERENCES [dbo].[Transactions] (transactionId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

ALTER TABLE [dbo].[Senders]
ADD CONSTRAINT FK_Senders_UsersLocalId FOREIGN KEY (localId)
	REFERENCES [dbo].[Users] (localId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

/* BanList constraints */
ALTER TABLE [dbo].[BanList]
ADD CONSTRAINT FK_BanList_UsersLoaclId FOREIGN KEY (localId)
	REFERENCES [dbo].[Users] (localId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

/* Admins constraints */
ALTER TABLE [dbo].[Admins]
ADD CONSTRAINT FK_Admins_UsersLocalId FOREIGN KEY (localId)
	REFERENCES [dbo].[Users] (localId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

ALTER TABLE [dbo].[Admins]
ADD CONSTRAINT FK_Admins_AdminRights FOREIGN KEY (rightId)
	REFERENCES [dbo].[AdminRights] (rightId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

