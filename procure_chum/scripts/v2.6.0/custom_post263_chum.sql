
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

