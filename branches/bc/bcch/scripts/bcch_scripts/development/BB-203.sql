-- BCCH Customization Script

-- ATiM Version: 2.6.7
-- BB-203


use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BB-203", '');


ALTER TABLE shipments
    ADD COLUMN `principal_investigator_approval_status` VARCHAR(20) AFTER `shipped_by`,
    ADD COLUMN `biobank_manager_approval_status` VARCHAR(20) AFTER `principal_investigator_approval_status`,
    ADD COLUMN `lab_staff_receival_status` VARCHAR(20) AFTER `biobank_manager_approval_status`,
    ADD COLUMN `biobank_staff_retrieval_status` VARCHAR(20) AFTER `lab_staff_receival_status`,
    ADD COLUMN `principal_investigator_name` VARCHAR(255) AFTER `biobank_staff_retrieval_status`,
    ADD COLUMN `biobank_manager_name` VARCHAR(255) AFTER `principal_investigator_name`,
    ADD COLUMN `lab_staff_receival_name` VARCHAR(20) AFTER `biobank_manager_name`,
    ADD COLUMN `biobank_staff_retrieval_name` VARCHAR(100) AFTER `lab_staff_receival_name`,
    ADD COLUMN `notes` TEXT AFTER `biobank_staff_retrieval_name`;

ALTER TABLE shipments_revs
    ADD COLUMN `principal_investigator_approval_status` VARCHAR(20) AFTER `shipped_by`,
    ADD COLUMN `biobank_manager_approval_status` VARCHAR(20) AFTER `principal_investigator_approval_status`,
    ADD COLUMN `lab_staff_receival_status` VARCHAR(20) AFTER `biobank_manager_approval_status`,
    ADD COLUMN `biobank_staff_retrieval_status` VARCHAR(20) AFTER `lab_staff_receival_status`,
    ADD COLUMN `principal_investigator_name` VARCHAR(255) AFTER `biobank_staff_retrieval_status`,
    ADD COLUMN `biobank_manager_name` VARCHAR(255) AFTER `principal_investigator_name`,
    ADD COLUMN `lab_staff_receival_name` VARCHAR(20) AFTER `biobank_manager_name`,
    ADD COLUMN `biobank_staff_retrieval_name` VARCHAR(100) AFTER `lab_staff_receival_name`,
    ADD COLUMN `notes` TEXT AFTER `biobank_staff_retrieval_name`;

INSERT INTO structure_value_domains (`domain_name`, `override`, `source`) VALUES
('shipment_approval_status', 'open', NULL),
('shipment_receiving_status', 'open', NULL),
('shipment_retrieval_status', 'open', NULL);

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('confirmed', 'confirmed');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_approval_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'obtained'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_approval_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'pending'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_approval_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'denied'), 3, 1, 1);

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_receiving_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'confirmed'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_receiving_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'pending'), 2, 1, 1);

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_retrieval_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'confirmed'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_retrieval_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'pending'), 2, 1, 1);


INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Order', 'Shipment', 'shipments', 'principal_investigator_approval_status', 'Approval from Principal Investigator', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_approval_status'), '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'biobank_manager_approval_status', 'Approval from Biobank Manager', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_approval_status'), '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'lab_staff_receival_status', 'Lab Staff Receival Confirmation', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_receiving_status'), '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'biobank_staff_retrieval_status', 'Biobank Staff Retreival Confirmation', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'shipment_retrieval_status'), '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'principal_investigator_name', 'Name of Principal Investigator', '', 'input', '', '', NULL, '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'biobank_manager_name', 'Name of BioBank Manager', '', 'input', '', 'Tamsin Tarling', NULL, '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'lab_staff_receival_name', 'Name of Lab Staff Receiving the Specimens', '', 'input', '', '', NULL, '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'biobank_staff_retrieval_name', 'Name of Biobank Staff Retreiving the Specimens', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'custom_laboratory_staff'), '', 'open', 'open', 'open', 0),
('Order', 'Shipment', 'shipments', 'notes', 'notes', '', 'textarea', '', '', NULL, '', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'principal_investigator_approval_status' AND `type`='select'),
0, 20, 'PI/Lab Sign Off', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'principal_investigator_name' AND `type`='input'),
0, 21, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'lab_staff_receival_status' AND `type`='select'),
0, 23, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'lab_staff_receival_name' AND `type`='input'),
0, 24, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'biobank_manager_approval_status' AND `type`='select'),
0, 26, 'Biobank Staff Sign Off', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'biobank_manager_name' AND `type`='input'),
0, 27, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'biobank_staff_retrieval_status' AND `type`='select'),
0, 29, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'biobank_staff_retrieval_name' AND `type`='select'),
0, 30, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias` = 'shipments'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Order' AND `model`='Shipment' AND `tablename`='shipments' AND `field` = 'notes' AND `type`='textarea'),
0, 35, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
0, 0, 0, 0, 1, 0, 0);


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('confirmed', 'Confirmed', ''),
('PI/Lab Sign Off', 'PI/Lab Sign Off', ''),
('Biobank Staff Sign Off', 'Biobank Staff Sign Off', ''),
('Approval from Principal Investigator', 'Approval from Principal Investigator', ''),
('Name of Principal Investigator', 'Name of Principal Investigator', ''),
('Approval from Biobank Manager', 'Approval from Biobank Manager', ''),
('Name of BioBank Manager', 'Name of BioBank Manager', ''),
('Lab Staff Receival Confirmation', 'Lab Staff Receival Confirmation', ''),
('Name of Lab Staff Receiving the Specimens', 'Name of Lab Staff Receiving the Specimens', ''),
('Biobank Staff Retreival Confirmation', 'Biobank Staff Retreival Confirmation', ''),
('Name of Biobank Staff Retreiving the Specimens', 'Name of Biobank Staff Retreiving the Specimens', '');
