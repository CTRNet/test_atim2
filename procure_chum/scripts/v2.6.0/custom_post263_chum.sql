
UPDATE versions SET site_branch_build_number = '5803' WHERE version_number = '2.6.3';

-- 20140703 ------------------------------------------------------------------------------------------------------

SET @date_modif = (SELECT NOW() FROM collections LIMIT 0,1);

ALTER TABLE sd_der_urine_cents ADD COLUMN qc_nd_pellet_absence char(1) DEFAULT '';
ALTER TABLE sd_der_urine_cents_revs ADD COLUMN qc_nd_pellet_absence char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_urine_cents', 'qc_nd_pellet_absence', 'yes_no',  NULL , '0', '', '', '', 'pellet absence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_sd_urine_cents'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_pellet_absence' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pellet absence' AND `language_tag`=''), '2', '457', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('pellet absence', 'Pellet Absence', 'Absence culot');

UPDATE  sample_masters uc, sd_der_urine_cents uc_d
SET procure_approximatif_pellet_volume_ml = null, procure_other_pellet_aspect_after_centrifugation = '', qc_nd_pellet_absence = 'y', uc.modified = @date_modif, uc.modified_by = '9'
WHERE uc_d.sample_master_id = uc.id AND procure_approximatif_pellet_volume_ml = '0' AND procure_other_pellet_aspect_after_centrifugation = 'Absent';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_urines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='pellet_signs' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_urines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='pellet_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_urines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='pellet_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') AND `flag_confidential`='0');

select distinct procure_approximatif_pellet_volume_ml, procure_pellet_volume_ml from sd_der_urine_cents;

UPDATE sample_masters u, sd_spe_urines u_d, sample_masters uc, sd_der_urine_cents uc_d
SET uc_d.qc_nd_pellet_absence = 'n', uc.modified = @date_modif, uc.modified_by = '9'
WHERE u_d.sample_master_id = u.id AND uc.parent_id = u.id AND uc_d.sample_master_id = uc.id
AND u_d.pellet_signs = 'yes';
UPDATE sample_masters u, sd_spe_urines u_d, sample_masters uc, sd_der_urine_cents uc_d
SET uc_d.qc_nd_pellet_absence = 'y', uc.modified = @date_modif, uc.modified_by = '9'
WHERE u_d.sample_master_id = u.id AND uc.parent_id = u.id AND uc_d.sample_master_id = uc.id
AND u_d.pellet_signs = 'no';
UPDATE sample_masters u, sd_spe_urines u_d, sample_masters uc, sd_der_urine_cents uc_d
SET uc_d.procure_pellet_volume_ml = u_d.pellet_volume, uc.modified = @date_modif, uc.modified_by = '9'
WHERE u_d.sample_master_id = u.id AND uc.parent_id = u.id AND uc_d.sample_master_id = uc.id
AND u_d.pellet_volume IS NOT NULL AND u_d.pellet_volume_unit = 'ml';
UPDATE sample_masters u, sd_spe_urines u_d, sample_masters uc, sd_der_urine_cents uc_d
SET uc_d.procure_pellet_volume_ml = (u_d.pellet_volume/1000), uc.modified = @date_modif, uc.modified_by = '9'
WHERE u_d.sample_master_id = u.id AND uc.parent_id = u.id AND uc_d.sample_master_id = uc.id
AND u_d.pellet_volume IS NOT NULL AND u_d.pellet_volume_unit = 'ul';
UPDATE sample_masters u, sd_spe_urines u_d, sample_masters uc, sd_der_urine_cents uc_d
SET uc_d.procure_pellet_volume_ml = u_d.pellet_volume, uc.modified = @date_modif, uc.modified_by = '9'
WHERE u_d.sample_master_id = u.id AND uc.parent_id = u.id AND uc_d.sample_master_id = uc.id
AND u_d.pellet_volume IS NOT NULL AND (u_d.pellet_volume_unit IS NULL OR u_d.pellet_volume_unit LIKE '');

SELECT u.id AS ur_id, uc.id AS urc_id, 
u_d.pellet_signs as ur_pellet_signs, uc_d.qc_nd_pellet_absence as urc_pellet_absence, 
u_d.pellet_volume as ur_pellet_vol, u_d.pellet_volume_unit as ur_pellet_vol_unit, 
uc_d.procure_pellet_volume_ml as urc_pellet_vol, uc_d.procure_approximatif_pellet_volume_ml as urc_approx_pellet_vol
FROM sample_masters u
INNER JOIN sd_spe_urines u_d ON u_d.sample_master_id = u.id
INNER JOIN sample_masters uc ON uc.parent_id = u.id
INNER JOIN sd_der_urine_cents uc_d ON uc_d.sample_master_id = uc.id
WHERE u_d.pellet_volume IS NOt NULL AND (u_d.pellet_volume_unit IS NULL OR u_d.pellet_volume_unit LIKE '')
LIMIT 0,100;

-- ------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_tube_weight') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_tube_weight_gr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------

UPDATE collections col, sample_masters sm, sample_controls sc, specimen_details sp, aliquot_masters am, aliquot_controls ac 
SET time_at_room_temp_mn = TIMESTAMPDIFF(MINUTE, collection_datetime, am.storage_datetime), sm.modified = @date_modif, sm.modified_by = '9'
WHERE sm.collection_id = col.id
AND sc.id = sm.sample_control_id
AND sp.sample_master_id = sm.id
AND am.sample_master_id = sm.id
AND ac.id = am.aliquot_control_id
AND am.deleted <> 1 AND sc.sample_type = 'blood' AND ac.aliquot_type = 'tube'
AND collection_datetime_accuracy = 'c' AND storage_datetime_accuracy = 'c' 
AND collection_datetime IS NOT NULL AND collection_datetime NOT LIKE '%00:00:00' AND storage_datetime IS NOT NULL AND storage_datetime NOT LIKE '%00:00:00'
AND (time_at_room_temp_mn IS NULL OR time_at_room_temp_mn LIKE '');

-- ------------------------------------------------------------------------------------------------------

INSERT INTO sample_masters_revs 
(id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes, modified_by, version_created)
(SELECT id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes, modified_by, modified FROM sample_masters WHERE modified_by = 9 AND modified = @date_modif);

INSERT INTO specimen_details_revs (sample_master_id,supplier_dept,time_at_room_temp_mn,reception_by,reception_datetime,reception_datetime_accuracy,version_created)
(SELECT sample_master_id,supplier_dept,time_at_room_temp_mn,reception_by,reception_datetime,reception_datetime_accuracy,modified FROM specimen_details INNER JOIN sample_masters ON id = sample_master_id WHERE modified_by = 9 AND modified = @date_modif);

INSERT INTO derivative_details_revs (sample_master_id,creation_site,creation_by,creation_datetime,lab_book_master_id,sync_with_lab_book,creation_datetime_accuracy,version_created)
(SELECT sample_master_id,creation_site,creation_by,creation_datetime,lab_book_master_id,sync_with_lab_book,creation_datetime_accuracy,modified FROM derivative_details INNER JOIN sample_masters ON id = sample_master_id WHERE modified_by = 9 AND modified = @date_modif);

INSERT INTO sd_der_urine_cents_revs (sample_master_id,procure_processed_at_reception,procure_conserved_at_4,procure_time_at_4,procure_aspect_after_refrigeration,procure_other_aspect_after_refrigeration,procure_aspect_after_centrifugation,procure_other_aspect_after_centrifugation,procure_pellet_aspect_after_centrifugation,procure_other_pellet_aspect_after_centrifugation,procure_approximatif_pellet_volume_ml,procure_pellet_volume_ml,qc_nd_concentrated,qc_nd_pellet_absence,version_created)
(SELECT sample_master_id,procure_processed_at_reception,procure_conserved_at_4,procure_time_at_4,procure_aspect_after_refrigeration,procure_other_aspect_after_refrigeration,procure_aspect_after_centrifugation,procure_other_aspect_after_centrifugation,procure_pellet_aspect_after_centrifugation,procure_other_pellet_aspect_after_centrifugation,procure_approximatif_pellet_volume_ml,procure_pellet_volume_ml,qc_nd_concentrated,qc_nd_pellet_absence,modified FROM sd_der_urine_cents INNER JOIN sample_masters ON id = sample_master_id WHERE modified_by = 9 AND modified = @date_modif);

INSERT INTO sd_spe_bloods_revs (sample_master_id,blood_type,collected_tube_nbr,collected_volume,collected_volume_unit,procure_collection_site,procure_collection_without_incident,procure_tubes_inverted_8_10_times,procure_tubes_correclty_stored,version_created)
(SELECT sample_master_id,blood_type,collected_tube_nbr,collected_volume,collected_volume_unit,procure_collection_site,procure_collection_without_incident,procure_tubes_inverted_8_10_times,procure_tubes_correclty_stored,modified FROM sd_spe_bloods INNER JOIN sample_masters ON id = sample_master_id WHERE modified_by = 9 AND modified = @date_modif);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Version', 'versions', 'site_branch_build_number', 'input-readonly',  NULL , '0', 'size=25', '', '', 'site build number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='versions'), (SELECT id FROM structure_fields WHERE `model`='Version' AND `tablename`='versions' AND `field`='site_branch_build_number' AND `type`='input-readonly' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='site build number' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('site build number','Site Version/Build','Site Version/Numéro Version');

UPDATE versions SET site_branch_build_number = '5806' WHERE version_number = '2.6.3';

-- 2014-08-05 ------------------------------------------------------------------------------------------------------

ALTER TABLE sd_der_urine_cents ADD COLUMN qc_nd_pellet_presence char(1) DEFAULT '';
ALTER TABLE sd_der_urine_cents_revs ADD COLUMN qc_nd_pellet_presence char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_urine_cents', 'qc_nd_pellet_presence', 'yes_no',  NULL , '0', '', '', '', 'pellet presence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_sd_urine_cents'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_pellet_presence' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pellet presence' AND `language_tag`=''), '2', '457', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('pellet presence', 'Pellet Presence', 'Présence culot');

UPDATE sd_der_urine_cents SET qc_nd_pellet_presence = 'y' WHERE qc_nd_pellet_absence = 'n';
UPDATE sd_der_urine_cents_revs SET qc_nd_pellet_presence = 'y' WHERE qc_nd_pellet_absence = 'n';
UPDATE sd_der_urine_cents SET qc_nd_pellet_presence = 'n' WHERE qc_nd_pellet_absence = 'y';
UPDATE sd_der_urine_cents_revs SET qc_nd_pellet_presence = 'n' WHERE qc_nd_pellet_absence = 'y';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_sd_urine_cents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_pellet_absence' AND `language_label`='pellet absence' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_pellet_absence' AND `language_label`='pellet absence' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_urine_cents' AND `field`='qc_nd_pellet_absence' AND `language_label`='pellet absence' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE sd_der_urine_cents DROP COLUMN qc_nd_pellet_absence;
ALTER TABLE sd_der_urine_cents_revs DROP COLUMN qc_nd_pellet_absence;

REPLACE INTO i18n (id,en,fr) 
VALUES
('approximatif pellet volume ml','Approximate volume (ml) of pellet (for 50 mL volume)','Volume (ml) approximatif du culot (pour volume de 50 mL)');

UPDATE versions SET site_branch_build_number = '5843' WHERE version_number = '2.6.3';

-- 2014-08-19 ------------------------------------------------------------------------------------------------------

ALTER TABLE procure_ed_lab_pathologies ADD COLUMN qc_nd_surgeon varchar(100) default null;
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN qc_nd_surgeon varchar(100) default null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'procure_ed_lab_pathologies', 'qc_nd_surgeon', 'input',  NULL , '0', 'size=30', '', '', 'surgeon', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_pathologies' AND `field`='qc_nd_surgeon' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='surgeon' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE procure_ed_lab_pathologies ADD COLUMN qc_nd_margins_extensive_apex tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN qc_nd_margins_extensive_apex tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'procure_ed_lab_pathologies', 'qc_nd_margins_extensive_apex', 'checkbox',  NULL , '0', '', '', '', 'apex', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='procure_ed_lab_pathologies' AND `field`='qc_nd_margins_extensive_apex' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='apex' AND `language_tag`=''), '3', '85', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_fields SET  `model`='EventDetail' WHERE model='EventMaster' AND tablename='procure_ed_lab_pathologies' AND field='qc_nd_surgeon' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `model`='EventDetail' WHERE model='EventMaster' AND tablename='procure_ed_lab_pathologies' AND field='qc_nd_margins_extensive_apex';

ALTER TABLE procure_txe_medications MODIFY duration VARCHAR(250) DEFAULT NULL;
ALTER TABLE procure_txe_medications_revs MODIFY duration VARCHAR(250) DEFAULT NULL;

-- 2014-08-20 --------------------------------------------------------------------------------------------------------

DELETE FROM i18n WHERE id IN ('participant does not allow followup', 'participant stopped the followup','no consent is linked to the current participant');
INSERT INTO i18n (id,en,fr) 
VALUES
('participant does not allow followup', 'Participant does not allow follow-up', 'Le participant ne permet pas un suivi'),
('participant stopped the followup', 'Participant stopped the followup', 'Le participant a arrêté le suivi'),
('no consent is linked to the current participant','No consent is linked to the current participant', 'Aucun consentement n''est lié au participant');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '1', 'prostate bank no lab', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '29', 'prostatectomy in atim', '0', '1', 'date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=20,class=range file' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_aborted_prostatectomy', 'yes_no',  NULL , '0', '', '', '', 'aborted prostatectomy', ''), 
('Datamart', '0', '', 'procure_curietherapy', 'yes_no',  NULL , '0', '', '', '', 'curietherapy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_aborted_prostatectomy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aborted prostatectomy' AND `language_tag`=''), '0', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_report_criteria_and_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_curietherapy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='curietherapy' AND `language_tag`=''), '0', '50', 'other treatments', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='28' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='29' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_aborted_prostatectomy' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('prostatectomy in atim','Prostatectomy (in ATiM)','Prostatectomie (dans ATiM)'),
('aborted prostatectomy','Aborted Prostatectomy','Prostatectomie abandonnée '),
('curietherapy','Curietherapy','Curiethérapie '),
('other treatments','Other Treatments','Autres traitements');

UPDATE versions SET site_branch_build_number = '5870' WHERE version_number = '2.6.3';

-- 2014-11-19 --------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET field = 'qc_nd_aborted_prostatectomy' WHERE  field = 'procure_aborted_prostatectomy';
UPDATE structure_fields SET field = 'qc_nd_curietherapy' WHERE  field = 'procure_curietherapy';
UPDATE versions SET site_branch_build_number = '5945' WHERE version_number = '2.6.3';
UPDATE versions SET permissions_regenerated = 0;

-- 2014-11-26 --------------------------------------------------------------------------------------------------------

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_followups_report_result'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '1', 'prostate bank no lab', '0', '', '0', '', '0', '', '1', 'size=20,class=range file', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_aliquots_report_result'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '1', 'prostate bank no lab', '0', '', '0', '', '0', '', '1', 'size=20,class=range file', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE event_masters SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -PST', ' V01 -PST') WHERE procure_form_identification LIKE '% V0 -PST%';
UPDATE event_masters_revs SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -PST', ' V01 -PST') WHERE procure_form_identification LIKE '% V0 -PST%';
UPDATE event_masters SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -FBP', ' V01 -FBP') WHERE procure_form_identification LIKE '% V0 -FBP%';
UPDATE event_masters_revs SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -FBP', ' V01 -FBP') WHERE procure_form_identification LIKE '% V0 -FBP%';
UPDATE event_masters SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -QUE', ' V01 -QUE') WHERE procure_form_identification LIKE '% V0 -QUE%';
UPDATE event_masters_revs SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -QUE', ' V01 -QUE') WHERE procure_form_identification LIKE '% V0 -QUE%';
UPDATE event_masters EventMaster, event_controls EventControl, participants Participant
SET EventMaster.procure_form_identification = CONCAT(participant_identifier, ' Vx -FSPx')
WHERE EventMaster.event_control_id = EventControl.id 
AND EventMaster.participant_id = Participant.id
AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');
UPDATE event_masters_revs EventMaster, event_controls EventControl, participants Participant
SET EventMaster.procure_form_identification = CONCAT(participant_identifier, ' Vx -FSPx')
WHERE EventMaster.event_control_id = EventControl.id 
AND EventMaster.participant_id = Participant.id
AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');
SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM event_masters EventMaster
INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -PST[0-9]+$' 
AND deleted <> 1 AND EventControl.event_type = 'procure pathology report'
UNION ALL
SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM event_masters EventMaster
INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -FBP[0-9]+$' 
AND deleted <> 1 AND EventControl.event_type = 'procure diagnostic information worksheet'
UNION ALL
SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM event_masters EventMaster
INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -QUE[0-9]+$' 
AND deleted <> 1 AND EventControl.event_type = 'procure questionnaire administration worksheet'
UNION ALL
SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM event_masters EventMaster
INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -FSP[0-9]+$' 
AND deleted <> 1 AND EventControl.event_type = 'procure follow-up worksheet'
UNION ALL
SELECT EventMaster.participant_id, EventControl.event_type, EventMaster.id AS event_master_id, EventMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM event_masters EventMaster
INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ Vx -FSPx$' 
AND deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');

UPDATE consent_masters SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -CSF', ' V01 -CSF') WHERE procure_form_identification LIKE '% V0 -CSF%';
UPDATE consent_masters_revs SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -CSF', ' V01 -CSF') WHERE procure_form_identification LIKE '% V0 -CSF%';
SELECT participant_id, id AS consent_master_id, procure_form_identification as 'Wrong procure_form_identification' 
FROM consent_masters 
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -CSF[0-9x]+$' AND deleted <> 1;

UPDATE treatment_masters SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -MED', ' V01 -MED') WHERE procure_form_identification LIKE '% V0 -MED%';
UPDATE treatment_masters_revs SET procure_form_identification = REPLACE(procure_form_identification, ' V0 -MED', ' V01 -MED') WHERE procure_form_identification LIKE '% V0 -MED%';
UPDATE treatment_masters TreatmentMaster, treatment_controls TreatmentControl, participants Participant
SET TreatmentMaster.procure_form_identification = CONCAT(participant_identifier, ' Vx -FSPx')
WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
AND TreatmentMaster.participant_id = Participant.id
AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment';
UPDATE treatment_masters_revs TreatmentMaster, treatment_controls TreatmentControl, participants Participant
SET TreatmentMaster.procure_form_identification = CONCAT(participant_identifier, ' Vx -FSPx')
WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
AND TreatmentMaster.participant_id = Participant.id
AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment';
UPDATE treatment_masters TreatmentMaster, treatment_controls TreatmentControl, participants Participant
SET TreatmentMaster.procure_form_identification = CONCAT(participant_identifier, ' Vx -MEDx')
WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
AND TreatmentMaster.participant_id = Participant.id
AND TreatmentControl.tx_method = 'procure medication worksheet - drug';
UPDATE treatment_masters_revs TreatmentMaster, treatment_controls TreatmentControl, participants Participant
SET TreatmentMaster.procure_form_identification = CONCAT(participant_identifier, ' Vx -MEDx')
WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
AND TreatmentMaster.participant_id = Participant.id
AND TreatmentControl.tx_method = 'procure medication worksheet - drug';
SELECT TreatmentMaster.participant_id, TreatmentMaster.id AS treatment_master_id, TreatmentControl.tx_method, TreatmentMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM treatment_masters TreatmentMaster
INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -MED[0-9]+$' AND deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet'
UNION ALL 
SELECT TreatmentMaster.participant_id, TreatmentMaster.id AS treatment_master_id, TreatmentControl.tx_method, TreatmentMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM treatment_masters TreatmentMaster
INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ Vx -FSPx$' AND deleted <> 1 AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment'
UNION ALL 
SELECT TreatmentMaster.participant_id, TreatmentMaster.id AS treatment_master_id, TreatmentControl.tx_method, TreatmentMaster.procure_form_identification as 'Wrong procure_form_identification' 
FROM treatment_masters TreatmentMaster
INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
WHERE procure_form_identification NOT REGEXP '^PS[0-9]P0[0-9]+ Vx -MEDx$' AND deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet - drug';

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET site_branch_build_number = '5951' WHERE version_number = '2.6.3';

-- 2014-11-27 --------------------------------------------------------------------------------------------------------
-- Clean Up in stock field

SET @modified_by = '9';
SET @modified = (SELECT NOW() FROM users LIMIt 0,1);

-- EDTA/SERUM blood tube

UPDATE aliquot_masters am, aliquot_controls ac, sample_masters sm, sample_controls sc, sd_spe_bloods sd
SET am.in_stock = 'no', am.storage_master_id = null, am.storage_coord_x = '', am.storage_coord_y = '', am.modified = @modified, am.modified_by = @modified_by
WHERE ac.id = am.aliquot_control_id AND am.sample_master_id = sm.id AND sc.id = sm.sample_control_id AND sd.sample_master_id = sm.id
AND am.deleted <> 1
AND (am.in_stock = 'yes - not available' OR (am.in_stock = 'yes - available' AND in_stock_detail = 'used'))
AND sc.sample_type = 'blood' AND sd.blood_type IN ('serum','k2-EDTA') AND ac.aliquot_type = 'tube';

-- URINE

UPDATE aliquot_masters am, aliquot_controls ac, sample_masters sm, sample_controls sc
SET am.in_stock = 'no', am.storage_master_id = null, am.storage_coord_x = '', am.storage_coord_y = '', am.modified = @modified, am.modified_by = @modified_by
WHERE ac.id = am.aliquot_control_id AND am.sample_master_id = sm.id AND sc.id = sm.sample_control_id
AND am.deleted <> 1
AND (am.in_stock = 'yes - not available' OR (am.in_stock = 'yes - available' AND in_stock_detail = 'used'))
AND sc.sample_type = 'urine';

-- Paxgene use for RNA

UPDATE aliquot_masters am, aliquot_controls ac, sample_masters sm, sample_controls sc, sd_spe_bloods sd, sample_masters rna_sm, sample_controls rna_sc
SET am.in_stock = 'no', am.storage_master_id = null, am.storage_coord_x = '', am.storage_coord_y = '', am.modified = @modified, am.modified_by = @modified_by
WHERE ac.id = am.aliquot_control_id AND am.sample_master_id = sm.id AND sc.id = sm.sample_control_id AND sd.sample_master_id = sm.id
AND am.deleted <> 1
AND (am.in_stock = 'yes - not available' OR (am.in_stock = 'yes - available' AND in_stock_detail = 'used'))
AND sc.sample_type = 'blood' AND sd.blood_type IN ('paxgene') AND ac.aliquot_type = 'tube'
AND rna_sm.parent_id = sm.id
AND rna_sc.id = rna_sm.sample_control_id
AND rna_sc.sample_type = 'rna';

INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,qc_nd_stored_by,
modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,qc_nd_stored_by,
modified_by,modified FROM aliquot_masters WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tubes_revs(aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,
procure_expiration_date,procure_tube_weight_gr,procure_total_quantity_ug,qc_nd_storage_solution,qc_nd_purification_method,
version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,
procure_expiration_date,procure_tube_weight_gr,procure_total_quantity_ug,qc_nd_storage_solution,qc_nd_purification_method,
modified FROM ad_tubes INNER JOIN aliquot_masters ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);
