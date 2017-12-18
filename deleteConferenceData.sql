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
CREATE PROCEDURE deleteConferenceData 
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
