-- ISO 3 letter code migration
INSERT INTO Languages VALUES ('cat','Català', 'n', 'n');

UPDATE CategoriesDes             SET langid='cat' WHERE langid='ca';
UPDATE IsoLanguagesDes           SET langid='cat' WHERE langid='ca';
UPDATE RegionsDes                SET langid='cat' WHERE langid='ca';
UPDATE GroupsDes                 SET langid='cat' WHERE langid='ca';
UPDATE OperationsDes             SET langid='cat' WHERE langid='ca';
UPDATE StatusValuesDes           SET langid='cat' WHERE langid='ca';
UPDATE CswServerCapabilitiesInfo SET langid='cat' WHERE langid='ca';
DELETE FROM Languages WHERE id='ca';

-- Take care to table ID (related to other loc files)
DELETE FROM CswServerCapabilitiesInfo WHERE langid='cat' AND idfield IN (53, 54, 55, 56);
INSERT INTO CswServerCapabilitiesInfo VALUES (53, 'cat', 'title', '');
INSERT INTO CswServerCapabilitiesInfo VALUES (54, 'cat', 'abstract', '');
INSERT INTO CswServerCapabilitiesInfo VALUES (55, 'cat', 'fees', '');
INSERT INTO CswServerCapabilitiesInfo VALUES (56, 'cat', 'accessConstraints', '');

DELETE FROM CategoriesDes WHERE langid='cat' AND iddes IN (11, 12, 13);
INSERT INTO CategoriesDes VALUES (11,'cat','Z3950 Servers');
INSERT INTO CategoriesDes VALUES (12,'cat','Registers');
INSERT INTO CategoriesDes VALUES (13,'cat','Physical Samples');

DELETE FROM StatusValuesDes WHERE langid='cat' AND iddes IN (0, 1, 2, 3, 4, 5);
INSERT INTO StatusValuesDes VALUES (0,'cat','Unknown');
INSERT INTO StatusValuesDes VALUES (1,'cat','Draft');
INSERT INTO StatusValuesDes VALUES (2,'cat','Approved');
INSERT INTO StatusValuesDes VALUES (3,'cat','Retired');
INSERT INTO StatusValuesDes VALUES (4,'cat','Submitted');
INSERT INTO StatusValuesDes VALUES (5,'cat','Rejected');

