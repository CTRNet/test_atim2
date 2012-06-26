DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-83' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `language_label`='dx_date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_dx date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-83' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `language_label`='dx_date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_dx date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-83' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `language_label`='dx_date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_dx date' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='locked' AND `flag_confidential`='0');

UPDATE diagnosis_controls SET form_alias=CONCAT('diagnosismasters,',form_alias) WHERE id IN(14,15,16); 

-- 2012-06-14
UPDATE qc_tf_dxd_eocs SET presence_of_precursor_of_benign_lesions="benign or borderline tumours" WHERE presence_of_precursor_of_benign_lesions="benign  or borderline tumours";
UPDATE structure_permissible_values SET value="benign or borderline tumours" WHERE value="benign  or borderline tumours";
ALTER TABLE qc_tf_tx_empty_revs
 CHANGE COLUMN tx_master_id treatment_master_id INT NOT NULL;
UPDATE structure_permissible_values SET value="Ascites" WHERE value="ascite";

-- 2012-06-26
UPDATE banks SET misc_identifier_control_id=9 WHERE id=9;
UPDATE banks SET misc_identifier_control_id=10 WHERE id=10;

