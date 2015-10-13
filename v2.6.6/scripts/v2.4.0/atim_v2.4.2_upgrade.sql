-- Run against a 2.4.1 installation
-- Read the printed messages carefully

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES
('2.4.2', NOW(), '3972');

ALTER TABLE txe_chemos
 DROP FOREIGN KEY FK_txe_chemos_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txe_chemos_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
 
ALTER TABLE txe_surgeries
 DROP FOREIGN KEY FK_txe_surgeries_tx_masters,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE txe_surgeries_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;

SELECT IF((SELECT COUNT(*) FROM treatment_controls WHERE extend_tablename NOT IN('txe_chemos', 'txe_surgeries')) > 0, 'You should review your treatment extend tables to change tx_master_id to treatment_master_id.', '') AS msg;