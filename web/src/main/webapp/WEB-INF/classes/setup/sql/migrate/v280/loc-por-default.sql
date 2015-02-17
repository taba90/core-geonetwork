-- ISO 3 letter code migration
INSERT INTO Languages VALUES ('por','Português', 'y', 'n');

UPDATE CategoriesDes             SET langid='por' WHERE langid='pt';
UPDATE IsoLanguagesDes           SET langid='por' WHERE langid='pt';
UPDATE RegionsDes                SET langid='por' WHERE langid='pt';
UPDATE GroupsDes                 SET langid='por' WHERE langid='pt';
UPDATE OperationsDes             SET langid='por' WHERE langid='pt';
UPDATE StatusValuesDes           SET langid='por' WHERE langid='pt';
UPDATE CswServerCapabilitiesInfo SET langid='por' WHERE langid='pt';
DELETE FROM Languages WHERE id='pt';

-- Take care to table ID (related to other loc files)
DELETE FROM CategoriesDes WHERE langid='por' AND iddes IN (11, 12, 13);
INSERT INTO CategoriesDes VALUES (11,'por','Z3950 Servers');
INSERT INTO CategoriesDes VALUES (12,'por','Registers');
INSERT INTO CategoriesDes VALUES (13,'por','Amostras físicas');

DELETE FROM StatusValuesDes WHERE langid='por' AND iddes IN (0, 1, 2, 3, 4, 5);
INSERT INTO StatusValuesDes VALUES (0,'por','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'por','Draft');
INSERT INTO StatusValuesDes VALUES (2,'por','Approved');
INSERT INTO StatusValuesDes VALUES (3,'por','Retired');
INSERT INTO StatusValuesDes VALUES (4,'por','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'por','Rejected');

