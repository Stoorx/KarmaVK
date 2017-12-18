-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE emmitKarma 
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
	END

	CLOSE emmiterCursor;
	DEALLOCATE emmiterCursor;

END
GO
