DELETE FROM Settings WHERE id=23 AND parentid=20;
INSERT INTO Settings VALUES (23,20,'protocol','http');

DELETE FROM Settings WHERE id=88 AND parentid=80;
INSERT INTO Settings VALUES (88,80,'defaultGroup', NULL);

DELETE FROM Settings WHERE id=113 AND parentid=87;
INSERT INTO Settings VALUES (113,87,'group',NULL);

DELETE FROM Settings WHERE id=178 AND parentid=173;
INSERT INTO Settings VALUES (178,173,'group',NULL);

DELETE FROM Settings WHERE id=179 AND parentid=170;
INSERT INTO Settings VALUES (179,170,'defaultGroup', NULL);

UPDATE Settings SET value='2.6.5' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';