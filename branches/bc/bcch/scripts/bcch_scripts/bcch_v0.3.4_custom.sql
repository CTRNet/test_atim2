-- BCCH Customization Script
-- Version 0.3.4
-- ATiM Version: 2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.3.4", '');
	
--  =========================================================================
--	Eventum ID: #XXXX 
--  BB-91
--	=========================================================================

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`)
VALUES  
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_tissues' AND `databrowser_label`='tissue'), 
 (SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr mononuclear cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_mononuclear_cells'), 1, NULL);
	

	