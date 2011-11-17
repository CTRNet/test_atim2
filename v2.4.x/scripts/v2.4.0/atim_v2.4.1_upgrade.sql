-- Run against a 2.4.0 installation
-- Read the printed messages carefully

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number, created, created_by, modified, modified_by) VALUES
('2.4.1', NOW(), '> 3884', NOW(), 1, NOW(), 1);

REPLACE INTO i18n(id, en, fr) VALUES
('core_app_version', '2.4.1', '2.4.1');

RENAME TABLE tx_masters TO treatment_masters;
RENAME TABLE tx_masters_revs TO treatment_masters_revs;
RENAME TABLE tx_controls TO treatment_controls;
UPDATE structure_fields SET tablename='treatment_masters' WHERE tablename='tx_masters';
UPDATE datamart_structures SET control_field='treatment_control_id' WHERE control_field='tx_control_id';
ALTER TABLE treatment_masters
 DROP FOREIGN KEY FK_tx_masters_tx_controls,
 CHANGE tx_control_id treatment_control_id INT NOT NULL,
 ADD FOREIGN KEY (`treatment_control_id`) REFERENCES treatment_controls(id);
ALTER TABLE treatment_masters_revs
 CHANGE tx_control_id treatment_control_id INT NOT NULL;

ALTER TABLE txd_chemos
 DROP FOREIGN KEY FK_txd_chemos_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txd_chemos_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
ALTER TABLE txd_radiations
 DROP FOREIGN KEY FK_txd_radiations_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txd_radiations_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
ALTER TABLE txd_surgeries
 DROP FOREIGN KEY FK_txd_surgeries_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txd_surgeries_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
 
SELECT IF(MAX(id) > 4, 'You need to alter your existing treatment details table. The field "tx_master_id" should now be renamed to "treatment_master_id2.', '') FROM treatment_controls; 
