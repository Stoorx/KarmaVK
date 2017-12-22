USE [KarmaBotVK]
GO


DELETE FROM [dbo].[UserRestrictions]
DELETE FROM [dbo].[Senders]
DELETE FROM [dbo].[Recipients]
DELETE FROM [dbo].[Transactions]
DBCC CHECKIDENT ('Transactions', RESEED, 0)
DELETE FROM [dbo].[Admins]
DELETE FROM [dbo].[Users]
DBCC CHECKIDENT ('Users', RESEED, 0)
GO



/* Create master-user */
SET IDENTITY_INSERT [dbo].[Users] ON
INSERT INTO [dbo].[Users] (localId, chatId, vkId, points) VALUES (0, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO