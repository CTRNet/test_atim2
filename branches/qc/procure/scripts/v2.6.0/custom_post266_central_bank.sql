UPDATE users SET flag_active = 0, password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979';
UPDATE users SET username = 'NicoEn', first_name = 'N. Luc & Migration', last_name = 'N. Luc & Migration', flag_active = 1 WHERE id = 1;

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_participant_attribution_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='procure_created_by_bank');



Bien positioner les procure_created_by_bank






UPDATE versions SET site_branch_build_number = '6370' WHERE version_number = '2.6.6';
UPDATE versions SET permissions_regenerated = 0;
