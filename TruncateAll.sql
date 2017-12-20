USE [KarmaBotVK]
GO

DELETE FROM [dbo].[BanList]
DELETE FROM [dbo].[Senders]
DELETE FROM [dbo].[Recipients]
DELETE FROM [dbo].[Transactions]
DELETE FROM [dbo].[Admins]
DELETE FROM [dbo].[Users]
GO

/* Create master-user */
SET IDENTITY_INSERT [dbo].[Users] ON
INSERT INTO [dbo].[Users] (localId, chatId, vkId, points) VALUES (0, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO