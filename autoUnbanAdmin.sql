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
CREATE TRIGGER autoUnbanAdmin
   ON  dbo.BanList 
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	
	DECLARE unbanCursor CURSOR
	FORWARD_ONLY
	FAST_FORWARD
	READ_ONLY
	FOR SELECT id from inserted;

	DECLARE @isUnbannable bit;
	DECLARE @currentId int;

	SET @isUnbannable = 0;

	FETCH NEXT FROM unbanCursor INTO @currentId;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @isUnbannable = (SELECT canBeBanned FROM dbo.Admins WHERE id = @currentId);
		IF @isUnbannable = 1
		BEGIN
			DELETE FROM dbo.BanList WHERE id = @currentId;
		END
		FETCH NEXT FROM unbanCursor INTO @currentId;
	END

END
GO
