USE [KarmaBotVK]
GO

CREATE TABLE [dbo].[UserRestrictions] (
	[localId] int NOT NULL,
	[restrictionId] int NOT NULL,
	[restrictedUntil] datetime NOT NULL
	CONSTRAINT [PK_UserRestrictions] PRIMARY KEY (
		[localId],
		[restrictionId]
	)
) ON [PRIMARY]
GO 