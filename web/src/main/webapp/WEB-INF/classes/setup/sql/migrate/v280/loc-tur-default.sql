-- ISO 3 letter code migration
INSERT INTO Languages VALUES ('tur','Turkish', 'n', 'n');

UPDATE CategoriesDes             SET langid='tur' WHERE langid='tr';
UPDATE IsoLanguagesDes           SET langid='tur' WHERE langid='tr';
UPDATE RegionsDes                SET langid='tur' WHERE langid='tr';
UPDATE GroupsDes                 SET langid='tur' WHERE langid='tr';
UPDATE OperationsDes             SET langid='tur' WHERE langid='tr';
UPDATE StatusValuesDes           SET langid='tur' WHERE langid='tr';
UPDATE CswServerCapabilitiesInfo SET langid='tur' WHERE langid='tr';
DELETE FROM Languages WHERE id='tr';

-- Take care to table ID (related to other loc files)
DELETE FROM CswServerCapabilitiesInfo WHERE langid='tur' AND idfield IN (57,58,59,60);
INSERT INTO CswServerCapabilitiesInfo VALUES (57, 'tur', 'title', '');
INSERT INTO CswServerCapabilitiesInfo VALUES (58, 'tur', 'abstract', '');
INSERT INTO CswServerCapabilitiesInfo VALUES (59, 'tur', 'fees', '');
INSERT INTO CswServerCapabilitiesInfo VALUES (60, 'tur', 'accessConstraints', '');

DELETE FROM CategoriesDes WHERE langid='tur' AND iddes IN (11, 12, 13);
INSERT INTO CategoriesDes VALUES (11,'tur','Z3950 Sunucular');
INSERT INTO CategoriesDes VALUES (12,'tur','Kayıtlar');
INSERT INTO CategoriesDes VALUES (13,'tur','Fiziksel Örnekleri');

DELETE FROM OperationsDes WHERE langid='tur' AND iddes IN (0, 1, 2, 3, 5, 6);
INSERT INTO OperationsDes VALUES (0,'tur','Publish');
INSERT INTO OperationsDes VALUES (1,'tur','Download');
INSERT INTO OperationsDes VALUES (2,'tur','Editing');
INSERT INTO OperationsDes VALUES (3,'tur','Notify');
INSERT INTO OperationsDes VALUES (5,'tur','Interactive Map');
INSERT INTO OperationsDes VALUES (6,'tur','Featured');

DELETE FROM StatusValuesDes WHERE langid='tur' AND iddes IN (0, 1, 2, 3, 4, 5);
INSERT INTO StatusValuesDes VALUES (0,'tur','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'tur','Draft');
INSERT INTO StatusValuesDes VALUES (2,'tur','Approved');
INSERT INTO StatusValuesDes VALUES (3,'tur','Retired');
INSERT INTO StatusValuesDes VALUES (4,'tur','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'tur','Rejected');
