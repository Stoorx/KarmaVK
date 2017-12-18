USE [master]
GO
/****** Object:  Database [KarmaVKdb]    Script Date: 18.12.2017 21:10:19 ******/
CREATE DATABASE [KarmaVKdb]
 ON  PRIMARY 
( NAME = N'KarmaVKdb', FILENAME = N'd:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\KarmaVKdb.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'KarmaVKdb_log', FILENAME = N'd:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\KarmaVKdb_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

USE [KarmaVKdb]
GO
/****** Object:  Table [dbo].[Admins]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admins](
	[id] [int] NOT NULL,
	[canChangeRights] [bit] NULL,
	[canChangePoints] [bit] NULL,
	[canBanUsers] [bit] NULL,
	[canBeBanned] [bit] NULL,
	[canEmmitKarma] [bit] NULL,
 CONSTRAINT [PK_Admins] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BanList]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BanList](
	[id] [int] NOT NULL,
	[banUntil] [datetime] NOT NULL,
 CONSTRAINT [PK_BanList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[History]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[History](
	[transactionId] [int] IDENTITY(1,1) NOT NULL,
	[transmitterId] [int] NOT NULL,
	[recieverId] [int] NOT NULL,
	[quantity] [money] NOT NULL,
	[transactionTime] [datetime] NOT NULL,
 CONSTRAINT [PK_History] PRIMARY KEY CLUSTERED 
(
	[transactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KarmaJournal]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KarmaJournal](
	[id] [int] NOT NULL,
	[points] [money] NOT NULL,
 CONSTRAINT [PK_KarmaJournal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[chatId] [int] NOT NULL,
	[vkId] [int] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[adminsOperations]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[adminsOperations]
AS SELECT * FROM dbo.History WHERE transmitterId = (SELECT id FROM dbo.Admins);
GO
/****** Object:  View [dbo].[badUsers]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[badUsers]
AS SELECT id FROM dbo.KarmaJournal WHERE points < 0;
GO
/****** Object:  View [dbo].[tomorowUnbanned]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tomorowUnbanned]
AS SELECT id FROM dbo.BanList WHERE banUntil - CURRENT_TIMESTAMP < 0;
GO
ALTER TABLE [dbo].[Admins]  WITH CHECK ADD  CONSTRAINT [Connection_Foreign_Key_Users_Admins] FOREIGN KEY([id])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[Admins] CHECK CONSTRAINT [Connection_Foreign_Key_Users_Admins]
GO
ALTER TABLE [dbo].[BanList]  WITH CHECK ADD  CONSTRAINT [Connection_Foreign_Key_BanList_Users] FOREIGN KEY([id])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[BanList] CHECK CONSTRAINT [Connection_Foreign_Key_BanList_Users]
GO
ALTER TABLE [dbo].[History]  WITH CHECK ADD  CONSTRAINT [FK_History_Users_Reciever] FOREIGN KEY([recieverId])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[History] CHECK CONSTRAINT [FK_History_Users_Reciever]
GO
ALTER TABLE [dbo].[History]  WITH CHECK ADD  CONSTRAINT [FK_History_Users_Transmitter] FOREIGN KEY([transmitterId])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[History] CHECK CONSTRAINT [FK_History_Users_Transmitter]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [Foreign_Key_Connection_Users_KarmaJournal] FOREIGN KEY([id])
REFERENCES [dbo].[KarmaJournal] ([id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [Foreign_Key_Connection_Users_KarmaJournal]
GO
/****** Object:  StoredProcedure [dbo].[changeKarma]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[changeKarma] 
	-- Parameters
	@conferenceID int = 0, 
	@transmitterVKID int = 0,
	@recieverVKID int = 0,
	@transferAmount money = 0
AS
BEGIN
	SET NOCOUNT ON;

    -- Declare local variables
	DECLARE @transmiterLocalID int;
	DECLARE @recieverLocalID int;
	DECLARE @currentTransieverPoints money;
	
	-- Getting local IDs of users
	SET @transmiterLocalID = (SELECT id FROM dbo.Users WHERE chatId = @conferenceID AND vkId = @transmitterVKID);
	SET @recieverLocalID = (SELECT id FROM dbo.Users WHERE chatId = @conferenceID AND vkId = @recieverVKID);

	IF NOT EXISTS (SELECT id FROM dbo.BanList WHERE id = @transmiterLocalID) 
	BEGIN
		-- Check is enough transmitter's Karma
		SET @currentTransieverPoints = (SELECT points FROM dbo.KarmaJournal WHERE id = @transmiterLocalID);
		IF @currentTransieverPoints - @transferAmount > 0
		BEGIN
			-- Change scores
			UPDATE dbo.KarmaJournal SET points = (SELECT points FROM dbo.KarmaJournal WHERE id = @transmiterLocalID) - @transferAmount WHERE id = @transmiterLocalID;
			UPDATE dbo.KarmaJournal SET points = (SELECT points FROM dbo.KarmaJournal WHERE id = @recieverLocalID) + @transferAmount WHERE id = @recieverLocalID;
			-- Write history
			INSERT INTO dbo.History (transmitterId, recieverId, quantity, transactionTime) VALUES (@transmiterLocalID, @recieverLocalID, @transferAmount, CURRENT_TIMESTAMP);

		END
	
			-- TODO: Make error not enough money;
	END
		-- TODO: Make error user un BL;
END
GO
/****** Object:  StoredProcedure [dbo].[deleteConferenceData]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[deleteConferenceData] 
	-- Add the parameters for the stored procedure here
	@conferenceId int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	DELETE FROM dbo.History WHERE transmitterId = (SELECT id FROM dbo.Users WHERE chatId = @conferenceId);
	DELETE FROM dbo.History WHERE recieverId = (SELECT id FROM dbo.Users WHERE chatId = @conferenceId);
	DELETE FROM dbo.KarmaJournal WHERE id = (SELECT id FROM dbo.Users WHERE chatId = @conferenceId);
	DELETE FROM dbo.BanList WHERE id = (SELECT id FROM dbo.Users WHERE chatId = @conferenceId);
	DELETE FROM dbo.Admins WHERE id = (SELECT id FROM dbo.Users WHERE chatId = @conferenceId);
	DELETE FROM dbo.Users WHERE chatId = @conferenceId;

END
GO
/****** Object:  StoredProcedure [dbo].[emmitKarma]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[emmitKarma] 
	@conferenceId int = 0,
	@emmitAmount money = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @currentEmmitId int;
    
	DECLARE emmiterCursor CURSOR
	FORWARD_ONLY
	FAST_FORWARD
	READ_ONLY
	FOR SELECT id FROM dbo.Users WHERE chatId = @conferenceId;

	OPEN emmiterCursor;

	FETCH NEXT FROM emmiterCursor INTO @currentEmmitId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE dbo.KarmaJournal SET points = (SELECT points FROM dbo.KarmaJournal WHERE id = @currentEmmitId) + @emmitAmount WHERE id = @currentEmmitId;
		INSERT INTO dbo.History (transmitterId, recieverId, quantity, transactionTime) VALUES (0, @currentEmmitId, @emmitAmount, CURRENT_TIMESTAMP);
	END

	CLOSE emmiterCursor;
	DEALLOCATE emmiterCursor;

END
GO
/****** Object:  StoredProcedure [dbo].[unbanUsersAtTime]    Script Date: 18.12.2017 21:10:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[unbanUsersAtTime] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	DELETE FROM dbo.BanList WHERE banUntil < CURRENT_TIMESTAMP;
END
GO
USE [master]
GO
ALTER DATABASE [KarmaVKdb] SET  READ_WRITE 
GO
