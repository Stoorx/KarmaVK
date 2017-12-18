CREATE VIEW tomorowUnbanned
AS SELECT id FROM dbo.BanList WHERE banUntil - CURRENT_TIMESTAMP < 0;
GO