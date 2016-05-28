
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';
UPDATE datamart_structure_functions SET flag_active = 1 WHERE label = 'participant identifiers report';
UPDATE datamart_reports SET flag_active = 1 WHERE name = 'participant identifiers';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'RAMQ', 'input',  NULL , '1', 'size=20', '', '', 'RAMQ', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='RAMQ' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='RAMQ' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='BR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='PR_Nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE versions SET branch_build_number = '5741' WHERE version_number = '2.6.2';

-- ---------------------------------------------------------------------------------------------------------
-- SQL statements executed on 20140516 to fix little issues
-- ----------------------------------------------------------------------------------------------------------

INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell pellets'), 'tube', '', 'ld_lymph_cell_pellets_tubes', 'ad_tubes', '', 1, '', 0, 'cell pellets|tube');
SET @last_aliquot_control_id = LAST_INSERT_ID();
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
(NULL, @last_aliquot_control_id, @last_aliquot_control_id, 1, NULL);
INSERT INTO structures(`alias`) VALUES ('ld_lymph_cell_pellets_tubes');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_cell_pellets_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_cell_pellets_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cell count' AND `language_tag`=''), '1', '75', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_cell_pellets_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '76', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_cell_pellets_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_cell_pellets_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_cell_pellets_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE aliquot_controls SET databrowser_label = 'other fluid pellet|tube' WHERE databrowser_label = 'other fluid pellet |tube';

INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active, lab_book_control_id) VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'cell pellets'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'cell pellets'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 1, NULL);

DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id from structure_fields WHERE field = 'ld_lymph_specimen_number')
AND rule LIKE 'custom,%' AND language_message = 'value is required';

-- ---------------------------------------------------------------------------------------------------------
-- 20160527
-- ----------------------------------------------------------------------------------------------------------

-- Create buffy coat then move -BC blood tube to derivative
-- ----------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(4);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(37);
REPLACE INTO i18n (id,en,fr) VALUES ('pbmc','BuffyCoat','BuffyCoat');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(165, 17, 166, 18);

UPDATE structure_fields SET  `tablename`='',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='cell_concentration_unit')  WHERE model='AliquotDetail' AND tablename='ad_cell_tubes' AND field='concentration_unit' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='cell_concentration_unit');

-- Test and warning

SET @blood_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood');
SET @blood_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @blood_sample_control_id AND aliquot_type = 'tube'); 
SET @pbmc_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
SET @pbmc_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @pbmc_sample_control_id AND aliquot_type = 'tube'); 
SET @plasma_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'plasma');
SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

SELECT AliquotMaster.barcode AS 'Aliquot that wont be changed to BFC. Please validate.', SampleControl.sample_type
FROM sample_controls SampleControl
INNER JOIN aliquot_controls AliquotControl ON SampleControl.id = AliquotControl.sample_control_id
INNER JOIN aliquot_masters AliquotMaster ON AliquotControl.id = AliquotMaster.aliquot_control_id
WHERE AliquotMaster.deleted <> 1
AND AliquotMaster.barcode LIKE '%-BC%'
AND SampleControl.sample_type != 'blood';

SELECT AliquotMaster.id AS 'Check BFC aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'AliquotInternalUse' AS 'Type of record'
FROM aliquot_internal_uses AS AliquotInternalUse
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE AliquotInternalUse.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%')

UNION ALL

SELECT AliquotMaster.id AS 'Check BFC aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
CONCAT('Source aliquot of ', SampleControl.sample_type) AS 'Type of record'
FROM source_aliquots AS SourceAliquot
JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
JOIN sample_controls AS SampleControl ON SampleControl.id = SampleMaster.sample_control_id
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
WHERE SourceAliquot.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%')

UNION ALL

SELECT CONCAT('Parent: ',AliquotMaster.id, ' & Child : ', AliquotMasterChild.id) AS aliquot_master_id,
CONCAT('Parent: ',AliquotMaster.barcode, ' & Child : ', AliquotMasterChild.barcode) AS barcode,
'Realiquoting' AS 'Type of record'
FROM realiquotings AS Realiquoting
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE Realiquoting.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%')

UNION ALL

SELECT AliquotMaster.id AS 'Check BFC aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'QualityCtrl' AS 'Type of record'
FROM quality_ctrls AS QualityCtrl
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE QualityCtrl.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%')

UNION ALL

SELECT AliquotMaster.id AS 'Check BFC aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'OrderItem' AS 'Type of record'
FROM order_items OrderItem
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
JOIN `orders` AS `Order` ON  Order.id = OrderLine.order_id			
WHERE OrderItem.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%')

UNION ALL

SELECT AliquotMaster.id AS 'Check BFC aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'AliquotReviewMaster' AS 'Type of record'
FROM aliquot_review_masters AS AliquotReviewMaster
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE AliquotReviewMaster.deleted 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%');

SELECT SampleMaster.sample_code AS 'Code of derivative created from %-BC% blood tubes (source aliquot). To check after migration.', CONCAT(SampleControl.sample_type, ' / collection_id = ', SampleMaster.collection_id) AS information
FROM sample_masters SampleMaster
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
WHERE SampleMaster.parent_id IN (
	SELECT DISTINCT AliquotMaster.sample_master_id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%'
)
AND SampleControl.sample_type NOT IN ('plasma')
AND SampleMaster.deleted <> 1;

-- Create PBMC

SET @blood_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood');
SET @blood_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @blood_sample_control_id AND aliquot_type = 'tube'); 
SET @pbmc_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'pbmc');
SET @pbmc_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @pbmc_sample_control_id AND aliquot_type = 'tube'); 
SET @plasma_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'plasma');
SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

INSERT INTO sample_masters (sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, created, created_by, modified, modified_by)
(SELECT DISTINCT CONCAT('BFC',SampleMaster.sample_code), SampleMaster.ld_lymph_specimen_number, @pbmc_sample_control_id, SampleMaster.id, 'blood', SampleMaster.collection_id, SampleMaster.id, 'blood', @modified, @modified_by, @modified, @modified_by 
FROM aliquot_masters AliquotMaster INNER JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BC%');

UPDATE sample_masters SET sample_code = id WHERE sample_code like 'BFC%' AND modified_by = @modified_by AND modified = @modified;

INSERT INTO derivative_details (sample_master_id) (SELECT id FROM sample_masters WHERE sample_control_id = @pbmc_sample_control_id AND modified_by = @modified_by AND modified = @modified);

INSERT INTO sd_der_pbmcs (sample_master_id) (SELECT id FROM sample_masters WHERE sample_control_id = @pbmc_sample_control_id AND modified_by = @modified_by AND modified = @modified);

UPDATE sample_masters PbmcSampleMaster, derivative_details PbmcDerivativeDetail, sample_masters PlasmaSampleMaster, derivative_details PlasmaDerivativeDetail 
SET PbmcDerivativeDetail.creation_site = PlasmaDerivativeDetail.creation_site, 
PbmcDerivativeDetail.creation_by = PlasmaDerivativeDetail.creation_by, 
PbmcDerivativeDetail.creation_datetime = PlasmaDerivativeDetail.creation_datetime, 
PbmcDerivativeDetail.creation_datetime_accuracy = PlasmaDerivativeDetail.creation_datetime_accuracy
WHERE PbmcSampleMaster.modified_by = @modified_by 
AND PbmcSampleMaster.modified = @modified
AND PbmcSampleMaster.sample_control_id = @pbmc_sample_control_id
AND PbmcSampleMaster.id = PbmcDerivativeDetail.sample_master_id 
AND PbmcSampleMaster.parent_id = PlasmaSampleMaster.parent_id
AND PlasmaSampleMaster.id = PlasmaDerivativeDetail.sample_master_id
AND PlasmaSampleMaster.sample_control_id = @plasma_sample_control_id
AND PlasmaSampleMaster.deleted <> 1;

INSERT INTO sample_masters_revs (id, sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, version_created, modified_by)
(SELECT id, sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, modified, modified_by
FROM sample_masters WHERE sample_control_id = @pbmc_sample_control_id AND modified_by = @modified_by AND modified = @modified);

INSERT INTO derivative_details_revs (sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,version_created)
(SELECT sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,modified
FROM sample_masters INNER JOIN derivative_details ON id = sample_master_id WHERE sample_control_id = @pbmc_sample_control_id AND modified_by = @modified_by AND modified = @modified);

INSERT INTO sd_der_pbmcs_revs (sample_master_id,version_created)
(SELECT sample_master_id,modified
FROM sample_masters INNER JOIN derivative_details ON id = sample_master_id WHERE sample_control_id = @pbmc_sample_control_id AND modified_by = @modified_by AND modified = @modified);

-- Link DNA/RNA to pbmc if BFC aliquot is a source aliquot for the DNA or RNA

SELECT DISTINCT 'ERR8489494' AS 'Migration failed'
FROM source_aliquots AS SourceAliquot,
aliquot_masters AS AliquotMaster, 
sample_masters AS DerivativeSampleMaster,
sample_controls AS DerivativeSampleControl
WHERE DerivativeSampleMaster.id = SourceAliquot.sample_master_id
AND AliquotMaster.id = SourceAliquot.aliquot_master_id
AND SourceAliquot.deleted <> 1 
AND AliquotMaster.deleted <> 1 
AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id 
AND AliquotMaster.barcode LIKE '%-BC%'
AND DerivativeSampleControl.id = DerivativeSampleMaster.sample_control_id
AND DerivativeSampleControl.sample_type NOT IN ('dna','rna');

UPDATE source_aliquots AS SourceAliquot,
aliquot_masters AS AliquotMaster, 
sample_masters AS DerivativeSampleMaster,
sample_masters AS PbmcSampleMaster
SET DerivativeSampleMaster.parent_id = PbmcSampleMaster.id,
DerivativeSampleMaster.parent_sample_type = 'pbmc',
DerivativeSampleMaster.modified = @modified,
DerivativeSampleMaster.modified_by = @modified_by
WHERE DerivativeSampleMaster.id = SourceAliquot.sample_master_id
AND AliquotMaster.id = SourceAliquot.aliquot_master_id
AND SourceAliquot.deleted <> 1 
AND AliquotMaster.deleted <> 1 
AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id 
AND AliquotMaster.barcode LIKE '%-BC%'
AND PbmcSampleMaster.sample_control_id = @pbmc_sample_control_id
AND PbmcSampleMaster.parent_id = AliquotMaster.sample_master_id;

INSERT INTO sample_masters_revs (id, sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, version_created, modified_by)
(SELECT id, sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, modified, modified_by
FROM sample_masters WHERE parent_sample_type = 'pbmc' AND modified_by = @modified_by AND modified = @modified);

INSERT INTO derivative_details_revs (sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,version_created)
(SELECT sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,modified
FROM sample_masters INNER JOIN derivative_details ON id = sample_master_id WHERE parent_sample_type = 'pbmc' AND modified_by = @modified_by AND modified = @modified);

INSERT INTO sd_der_dnas_revs (sample_master_id,version_created)
(SELECT sample_master_id,modified
FROM sample_masters INNER JOIN sd_der_dnas ON id = sample_master_id WHERE parent_sample_type = 'pbmc' AND modified_by = @modified_by AND modified = @modified);

INSERT INTO sd_der_rnas_revs (sample_master_id,version_created)
(SELECT sample_master_id,modified
FROM sample_masters INNER JOIN sd_der_rnas ON id = sample_master_id WHERE parent_sample_type = 'pbmc' AND modified_by = @modified_by AND modified = @modified);

-- Link aliquot to pbmc

UPDATE aliquot_masters AliquotMaster, sample_masters PbmcSampleMaster
SET AliquotMaster.sample_master_id = PbmcSampleMaster.id,
AliquotMaster.aliquot_control_id = @pbmc_tube_aliquot_control_id,
AliquotMaster.modified = @modified,
AliquotMaster.modified_by = @modified_by
WHERE AliquotMaster.deleted <> 1
AND AliquotMaster.barcode LIKE '%-BC%'
AND AliquotMaster.aliquot_control_id = @blood_tube_aliquot_control_id 
AND PbmcSampleMaster.parent_id = AliquotMaster.sample_master_id
AND PbmcSampleMaster.sample_control_id = @pbmc_sample_control_id;

INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail,
use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, notes,
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail,
use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, notes,
modified_by, modified FROM aliquot_masters WHERE aliquot_control_id = @pbmc_tube_aliquot_control_id AND modified = @modified AND modified_by = @modified_by);

INSERT INTO ad_tubes_revs (aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,modified
FROM ad_tubes INNER JOIN aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = @pbmc_tube_aliquot_control_id AND modified = @modified AND modified_by = @modified_by);

-- Cytokine
-- ----------------------------------------------------------------------------------------------------------

ALTER TABLE sd_der_proteins
  ADD COLUMN ld_lymph_type VARCHAR(100) DEFAULT NULL;
ALTER TABLE sd_der_proteins_revs
  ADD COLUMN ld_lymph_type VARCHAR(100) DEFAULT NULL;
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',ld_lymph_proteins') WHERE sample_type = 'protein';

INSERT INTO structures(`alias`) VALUES ('ld_lymph_proteins');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('ld_lymph_protein_types', "StructurePermissibleValuesCustom::getCustomDropdown(\'Protein Types\')" );
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Protein Types', 1, 100, 'inventory');
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
('cytokine', 'Cytokine', 'Cytokine', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_proteins', 'ld_lymph_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_protein_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_proteins'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_proteins' AND `field`='ld_lymph_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_protein_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '410', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- Plasma to DNA, RNA, Protein links
-- ----------------------------------------------------------------------------------------------------------

INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'plasma'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), '1'),
((SELECT id FROM sample_controls WHERE sample_type = 'plasma'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), '1'),
((SELECT id FROM sample_controls WHERE sample_type = 'plasma'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), '1');

-- Create Bone Marrow Fraction
-- ----------------------------------------------------------------------------------------------------------

INSERT INTO sample_controls (sample_type, sample_category, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('bone marrow fraction', 'derivative', 'sd_undetailed_derivatives,derivatives', 'ld_lymph_sd_der_bone_marrow_fractions', 'bone marrow fraction');
INSERT INTO i18n (id,en,fr)
VALUES 
('bone marrow fraction', 'Bone Marrow Fraction', 'Fraction de moelle osseuse');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'bone marrow'), (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction'), '1'),
((SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), '1'),
((SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), '1'),
((SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction'), (SELECT id FROM sample_controls WHERE sample_type = 'protein'), '1');
CREATE TABLE `ld_lymph_sd_der_bone_marrow_fractions` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_ld_lymph_sd_der_bone_marrow_fractions_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_ld_lymph_sd_der_bone_marrow_fractions_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `ld_lymph_sd_der_bone_marrow_fractions_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, aliquot_type_precision, detail_form_alias, detail_tablename, volume_unit, flag_active, databrowser_label)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction'), 'tube', '(ml)', ' ad_der_tubes_incl_ml_vol', 'ad_tubes', 'ml', '1', 'bone marrow fraction|tube');

-- Test and warning

SET @bone_marrow_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow');
SET @bone_marrow_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @bone_marrow_sample_control_id AND aliquot_type = 'tube'); 
SET @bone_marrow_fraction_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction');
SET @bone_marrow_fraction_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND aliquot_type = 'tube'); 
SET @bone_marrow_suspension_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow suspension');
SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

SELECT AliquotMaster.barcode AS 'Aliquot that wont be changed to BMF. Please validate.', SampleControl.sample_type
FROM sample_controls SampleControl
INNER JOIN aliquot_controls AliquotControl ON SampleControl.id = AliquotControl.sample_control_id
INNER JOIN aliquot_masters AliquotMaster ON AliquotControl.id = AliquotMaster.aliquot_control_id
WHERE AliquotMaster.deleted <> 1
AND AliquotMaster.barcode LIKE '%-BF%'
AND SampleControl.sample_type != 'bone marrow';

SELECT AliquotMaster.id AS 'Check Bone Marrow aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'AliquotInternalUse' AS 'Type of record'
FROM aliquot_internal_uses AS AliquotInternalUse
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE AliquotInternalUse.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%')

UNION ALL

SELECT AliquotMaster.id AS 'Check Bone Marrow aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
CONCAT('Source aliquot of ', SampleControl.sample_type) AS 'Type of record'
FROM source_aliquots AS SourceAliquot
JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
JOIN sample_controls AS SampleControl ON SampleControl.id = SampleMaster.sample_control_id
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
WHERE SourceAliquot.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%')

UNION ALL

SELECT CONCAT('Parent: ',AliquotMaster.id, ' & Child : ', AliquotMasterChild.id) AS aliquot_master_id,
CONCAT('Parent: ',AliquotMaster.barcode, ' & Child : ', AliquotMasterChild.barcode) AS barcode,
'Realiquoting' AS 'Type of record'
FROM realiquotings AS Realiquoting
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE Realiquoting.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%')

UNION ALL

SELECT AliquotMaster.id AS 'Check Bone Marrow aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'QualityCtrl' AS 'Type of record'
FROM quality_ctrls AS QualityCtrl
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE QualityCtrl.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%')

UNION ALL

SELECT AliquotMaster.id AS 'Check Bone Marrow aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'OrderItem' AS 'Type of record'
FROM order_items OrderItem
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
JOIN `orders` AS `Order` ON  Order.id = OrderLine.order_id			
WHERE OrderItem.deleted <> 1 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%')

UNION ALL

SELECT AliquotMaster.id AS 'Check Bone Marrow aliquot use&event have been migrated (aliquot_master_id)',
AliquotMaster.barcode,
'AliquotReviewMaster' AS 'Type of record'
FROM aliquot_review_masters AS AliquotReviewMaster
JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE AliquotReviewMaster.deleted 
AND AliquotMaster.id IN (SELECT AliquotMaster.id
	FROM aliquot_masters AliquotMaster
	WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%');

-- Create Bone Marrow Fraction

SET @bone_marrow_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow');
SET @bone_marrow_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @bone_marrow_sample_control_id AND aliquot_type = 'tube'); 
SET @bone_marrow_fraction_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow fraction');
SET @bone_marrow_fraction_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND aliquot_type = 'tube'); 
SET @bone_marrow_suspension_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'bone marrow suspension');
SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

INSERT INTO sample_masters (sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, created, created_by, modified, modified_by)
(SELECT DISTINCT CONCAT('BMF',SampleMaster.sample_code), SampleMaster.ld_lymph_specimen_number, @bone_marrow_fraction_sample_control_id, SampleMaster.id, 'bone marrow', SampleMaster.collection_id, SampleMaster.id, 'bone marrow', @modified, @modified_by, @modified, @modified_by 
FROM aliquot_masters AliquotMaster INNER JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id AND AliquotMaster.barcode LIKE '%-BF%');

UPDATE sample_masters SET sample_code = id WHERE sample_code like 'BMF%' AND modified_by = @modified_by AND modified = @modified;

INSERT INTO derivative_details (sample_master_id) (SELECT id FROM sample_masters WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND modified_by = @modified_by AND modified = @modified);

INSERT INTO ld_lymph_sd_der_bone_marrow_fractions (sample_master_id) (SELECT id FROM sample_masters WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND modified_by = @modified_by AND modified = @modified);

UPDATE sample_masters BoneMarrowFractionSampleMaster, derivative_details BoneMarrowFractionDerivativeDetail, sample_masters BoneMarrowSuspension, derivative_details BoneMarrowSuspensionDerivativeDetail 
SET BoneMarrowFractionDerivativeDetail.creation_site = BoneMarrowSuspensionDerivativeDetail.creation_site, 
BoneMarrowFractionDerivativeDetail.creation_by = BoneMarrowSuspensionDerivativeDetail.creation_by, 
BoneMarrowFractionDerivativeDetail.creation_datetime = BoneMarrowSuspensionDerivativeDetail.creation_datetime, 
BoneMarrowFractionDerivativeDetail.creation_datetime_accuracy = BoneMarrowSuspensionDerivativeDetail.creation_datetime_accuracy
WHERE BoneMarrowFractionSampleMaster.modified_by = @modified_by 
AND BoneMarrowFractionSampleMaster.modified = @modified
AND BoneMarrowFractionSampleMaster.sample_control_id = @bone_marrow_fraction_sample_control_id
AND BoneMarrowFractionSampleMaster.id = BoneMarrowFractionDerivativeDetail.sample_master_id 
AND BoneMarrowFractionSampleMaster.parent_id = BoneMarrowSuspension.parent_id
AND BoneMarrowSuspension.id = BoneMarrowSuspensionDerivativeDetail.sample_master_id
AND BoneMarrowSuspension.sample_control_id = @bone_marrow_suspension_sample_control_id
AND BoneMarrowSuspension.deleted <> 1;

INSERT INTO sample_masters_revs (id, sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, version_created, modified_by)
(SELECT id, sample_code, ld_lymph_specimen_number, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, modified, modified_by
FROM sample_masters WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND modified_by = @modified_by AND modified = @modified);

INSERT INTO derivative_details_revs (sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,version_created)
(SELECT sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,modified
FROM sample_masters INNER JOIN derivative_details ON id = sample_master_id WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND modified_by = @modified_by AND modified = @modified);

INSERT INTO ld_lymph_sd_der_bone_marrow_fractions_revs (sample_master_id,version_created)
(SELECT sample_master_id,modified
FROM sample_masters INNER JOIN derivative_details ON id = sample_master_id WHERE sample_control_id = @bone_marrow_fraction_sample_control_id AND modified_by = @modified_by AND modified = @modified);

-- Check no tube of bone warrow was used as source aliquot

SELECT DISTINCT 'ERR848943' AS 'Migration failed'
FROM source_aliquots AS SourceAliquot,
aliquot_masters AS AliquotMaster
WHERE AliquotMaster.id = SourceAliquot.aliquot_master_id
AND SourceAliquot.deleted <> 1 
AND AliquotMaster.deleted <> 1 
AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id 
AND AliquotMaster.barcode LIKE '%-BF%';

-- Link aliquots to Bone Marrow Fraction

UPDATE aliquot_masters AliquotMaster, sample_masters BoneMarrowFractionSampleMaster
SET AliquotMaster.sample_master_id = BoneMarrowFractionSampleMaster.id,
AliquotMaster.aliquot_control_id = @bone_marrow_fraction_tube_aliquot_control_id,
AliquotMaster.modified = @modified,
AliquotMaster.modified_by = @modified_by
WHERE AliquotMaster.deleted <> 1
AND AliquotMaster.barcode LIKE '%-BF%'
AND AliquotMaster.aliquot_control_id = @bone_marrow_tube_aliquot_control_id 
AND BoneMarrowFractionSampleMaster.parent_id = AliquotMaster.sample_master_id
AND BoneMarrowFractionSampleMaster.sample_control_id = @bone_marrow_fraction_sample_control_id;

INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail,
use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, notes,
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail,
use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, notes,
modified_by, modified FROM aliquot_masters WHERE aliquot_control_id = @bone_marrow_fraction_tube_aliquot_control_id AND modified = @modified AND modified_by = @modified_by);

INSERT INTO ad_tubes_revs (aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,modified
FROM ad_tubes INNER JOIN aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = @bone_marrow_fraction_tube_aliquot_control_id AND modified = @modified AND modified_by = @modified_by);

-- Versions
-- ----------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6490' WHERE version_number = '2.6.2';
UPDATE versions SET permissions_regenerated = 0;
