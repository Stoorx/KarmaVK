CREATE VIEW badUsers
AS SELECT id FROM dbo.KarmaJournal WHERE points < 0;