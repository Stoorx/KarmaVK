USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[Users] (
	[localId] int NOT NULL PRIMARY KEY IDENTITY(1, 1),
	[chatId] int NOT NULL,
	[vkId] int NOT NULL,
	[points] money NOT NULL
) ON [PRIMARY]
GO


/* Create master-user */
SET IDENTITY_INSERT [dbo].[Users] ON
INSERT INTO [dbo].[Users] (localId, chatId, vkId, points) VALUES (0, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO