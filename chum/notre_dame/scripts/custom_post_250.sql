UPDATE misc_identifier_controls SET reg_exp_validation='^H[\\d]+$', user_readable_format='H#', misc_identifier_format='H' WHERE id=8;
UPDATE misc_identifier_controls SET reg_exp_validation='^N[\\d]+$', user_readable_format='N#', misc_identifier_format='N' WHERE id=9;
UPDATE misc_identifier_controls SET reg_exp_validation='^S[\\d]+$', user_readable_format='S#', misc_identifier_format='S' WHERE id=10;

UPDATE datamart_browsing_controls SET flag_active_1_to_2=1, flag_active_2_to_1=1 WHERE id1=11;

UPDATE structure_fields SET tablename='specimen_details' WHERE model='SpecimenDetail' AND field='sequence_number';
UPDATE structure_fields SET tablename='specimen_details' WHERE model='SpecimenDetail' AND field='type_code';

UPDATE structure_formats SET `display_order`='29' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='28' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='has_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

