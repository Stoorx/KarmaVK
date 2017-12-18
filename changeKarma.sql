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
CREATE PROCEDURE changeKarma 
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
