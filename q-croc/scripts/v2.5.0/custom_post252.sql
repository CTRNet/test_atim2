
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopControl' AND `tablename`='sop_controls' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sop_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sopmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `tablename`='sop_masters' AND `field`='activated_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='lesion size (cm)' WHERE model='TreatmentDetail' AND tablename='qcroc_txd_liver_biopsies' AND field='lesion_size' AND `type`='float_positive' AND structure_value_domain  IS NULL ;

REPLACE INTO i18n (id,en) VALUES 
('sop_code','SOP#'),('sop_version','Version#'),
('lesion size (cm)','Lesion size (cm)');












