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

/* UserRestrictions constraints */
ALTER TABLE [dbo].[UserRestrictions]
ADD CONSTRAINT FK_UserRestrictions_UsersLocalId FOREIGN KEY (localId)
	REFERENCES [dbo].[Users] (localId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
;
GO

ALTER TABLE [dbo].[UserRestrictions]
ADD CONSTRAINT FK_UserRestrictions_RestrictionsRestrictionId FOREIGN KEY (restrictionId)
	REFERENCES [dbo].[Restrictions] (restrictionId)
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

