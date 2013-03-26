UPDATE `versions` SET branch_build_number = '5169' WHERE version_number = '2.5.4';

update participants set participant_identifier = replace(participant_identifier, 'N/A [', '');
update participants_revs set participant_identifier = replace(participant_identifier, 'N/A [', '');
update participants set participant_identifier = replace(participant_identifier, ']', '');
update participants_revs set participant_identifier = replace(participant_identifier, ']', '');

UPDATE structure_fields SET  `type`='integer_positive' WHERE field='participant_identifier';
ALTER TABLE participants MODIFY participant_identifier int(50) DEFAULT NULL;
ALTER TABLE participants_revs MODIFY participant_identifier int(50) DEFAULT NULL;

UPDATE storage_controls SET display_x_size = 1, display_y_size = 12 WHERE storage_type = 'rack 1-12';

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_hemolysis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='qc_lady_hemoysis_color_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=10' WHERE model='AliquotDetail' AND tablename='ad_tubes' AND field='qc_lady_hemoysis_color_other' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO i18n (id, en, fr) VALUES ('P100','P100','P100'), ('CTAD','CTAD','CTAD');
