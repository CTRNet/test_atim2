-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.2.1 alpha', NOW(), '> 2838');

ALTER TABLE users 
 DROP COLUMN last_visit;
 
UPDATE structure_formats SET `language_heading`='diagnosis' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
