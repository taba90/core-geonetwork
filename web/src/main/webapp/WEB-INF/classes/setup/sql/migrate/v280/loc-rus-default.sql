-- ISO 3 letter code migration
INSERT INTO Languages VALUES ('rus','русский язык', 'n', 'n');

UPDATE CategoriesDes             SET langid='rus' WHERE langid='ru';
UPDATE IsoLanguagesDes           SET langid='rus' WHERE langid='ru';
UPDATE RegionsDes                SET langid='rus' WHERE langid='ru';
UPDATE GroupsDes                 SET langid='rus' WHERE langid='ru';
UPDATE OperationsDes             SET langid='rus' WHERE langid='ru';
UPDATE StatusValuesDes           SET langid='rus' WHERE langid='ru';
UPDATE CswServerCapabilitiesInfo SET langid='rus' WHERE langid='ru';
DELETE FROM Languages WHERE id='ru';

-- Take care to table ID (related to other loc files)
DELETE FROM CategoriesDes WHERE langid='rus' AND iddes IN (11, 12, 13);
INSERT INTO CategoriesDes VALUES (11,'rus','Z3950 Servers');
INSERT INTO CategoriesDes VALUES (12,'rus','Registers');
INSERT INTO CategoriesDes VALUES (13,'rus','Физические образцы');

DELETE FROM StatusValuesDes WHERE langid='rus' AND iddes IN (0, 1, 2, 3, 4, 5);
INSERT INTO StatusValuesDes VALUES (0,'rus','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'rus','Draft');
INSERT INTO StatusValuesDes VALUES (2,'rus','Approved');
INSERT INTO StatusValuesDes VALUES (3,'rus','Retired');
INSERT INTO StatusValuesDes VALUES (4,'rus','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'rus','Rejected');
