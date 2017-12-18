-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
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
CREATE TRIGGER registerNewUser 
   ON  dbo.Users
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @idForRegister int

	DECLARE registeringCursor CURSOR
	FORWARD_ONLY
	FAST_FORWARD
	READ_ONLY
	FOR SELECT id FROM inserted;

	OPEN registerCursor

	FETCH NEXT FROM registeringCursor INTO @idForRegister;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO dbo.KarmaJournal (id, points) VALUES (@idForRegister, 0);
		INSERT INTO dbo.History (transmitterId, recieverId, quantity, transactionTime) VALUES (0, @idForRegister, 0, CURRENT_TIMESTAMP);
		FETCH NEXT FROM registeringCursor INTO @idForRegister;
	END

	CLOSE registerCursor
	DEALLOCATE registerCursor

END
GO
