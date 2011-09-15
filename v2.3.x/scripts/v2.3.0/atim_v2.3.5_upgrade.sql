-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.5', NOW(), '3451');

ALTER TABLE groups
 ADD deleted BOOLEAN NOT NULL DEFAULT 0;

SELECT '****************' as msg
UNION
SELECT IF((SELECT COUNT(*) FROM users WHERE group_id NOT IN(SELECT id FROM groups)) > 0, 'You have users referencing non existing groups. You need to fix them before running the next query.', 'You db is ok. You can run the next query.') AS msg
UNION 
ALTER TABLE users 
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);" AS msg
UNION ALL
SELECT '****************' as msg;