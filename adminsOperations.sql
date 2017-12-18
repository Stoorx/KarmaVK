CREATE VIEW adminsOperations
AS SELECT * FROM dbo.History WHERE transmitterId = (SELECT id FROM dbo.Admins);
GO