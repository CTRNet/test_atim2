
ALTER TABLE sample_controls
  ADD COLUMN qc_nd_sample_type_code VARCHAR(50) NOT NULL DEFAULT '' AFTER 	sample_category;

UPDATE sample_controls SET qc_nd_sample_type_code = 'A' WHERE sample_type = 'ascite';
UPDATE sample_controls SET qc_nd_sample_type_code = 'B' WHERE sample_type = 'blood';
UPDATE sample_controls SET qc_nd_sample_type_code = 'T' WHERE sample_type = 'tissue';
UPDATE sample_controls SET qc_nd_sample_type_code = 'U' WHERE sample_type = 'urine';
UPDATE sample_controls SET qc_nd_sample_type_code = 'ASC-C' WHERE sample_type = 'ascite cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'ASC-S' WHERE sample_type = 'ascite supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'BLD-C' WHERE sample_type = 'blood cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PBMC' WHERE sample_type = 'pbmc';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PLS' WHERE sample_type = 'plasma';
UPDATE sample_controls SET qc_nd_sample_type_code = 'SER' WHERE sample_type = 'serum';
UPDATE sample_controls SET qc_nd_sample_type_code = 'C-CULT' WHERE sample_type = 'cell culture';
UPDATE sample_controls SET qc_nd_sample_type_code = 'DNA' WHERE sample_type = 'dna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'RNA' WHERE sample_type = 'rna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CONC-U' WHERE sample_type = 'concentrated urine';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CENT-U' WHERE sample_type = 'centrifuged urine';
UPDATE sample_controls SET qc_nd_sample_type_code = 'AMP-RNA' WHERE sample_type = 'amplified rna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'LB' WHERE sample_type = 'b cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'cDNA' WHERE sample_type = 'cdna';
UPDATE sample_controls SET qc_nd_sample_type_code = 'T-LYS' WHERE sample_type = 'tissue lysate';
UPDATE sample_controls SET qc_nd_sample_type_code = 'T-SUSP' WHERE sample_type = 'tissue suspension';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PW' WHERE sample_type = 'peritoneal wash';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CF' WHERE sample_type = 'cystic fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'OF' WHERE sample_type = 'other fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PW-C' WHERE sample_type = 'peritoneal wash cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PW-S' WHERE sample_type = 'peritoneal wash supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CF-C' WHERE sample_type = 'cystic fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'CF-S' WHERE sample_type = 'cystic fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'OF-C' WHERE sample_type = 'other fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'OF-S' WHERE sample_type = 'other fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PC-F' WHERE sample_type = 'pericardial fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PL-F' WHERE sample_type = 'pleural fluid';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PC-C' WHERE sample_type = 'pericardial fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PC-S' WHERE sample_type = 'pericardial fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PL-C' WHERE sample_type = 'pleural fluid cell';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PL-S' WHERE sample_type = 'pleural fluid supernatant';
UPDATE sample_controls SET qc_nd_sample_type_code = 'C-LYSATE' WHERE sample_type = 'cell lysate';
UPDATE sample_controls SET qc_nd_sample_type_code = 'PROT' WHERE sample_type = 'protein';
UPDATE sample_controls SET qc_nd_sample_type_code = 'BM' WHERE sample_type = 'bone marrow';
UPDATE sample_controls SET qc_nd_sample_type_code = 'BM-SUSP' WHERE sample_type = 'bone marrow suspension';
UPDATE sample_controls SET qc_nd_sample_type_code = 'No-BC' WHERE sample_type = 'no-b cell';

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

UPDATE participants SET participant_identifier = id;
UPDATE participants_revs SET participant_identifier = id;

UPDATE structure_formats SET `display_order`='16', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

DELETE FROM structure_formats
WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'sd_%')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sample_code' AND model = 'SampleMaster');

UPDATE aliquot_masters SET barcode = id;
UPDATE aliquot_masters_revs SET barcode = id;

REPLACE INTO i18n (id,en,fr) VALUES ('aliquot barcode', 'Aliquot System Code', 'Aliquot - Code système');
