ALTER TABLE qc_tf_tx_empty DROP FOREIGN KEY `qc_tf_tx_empty_ibfk_1`
ALTER TABLE qc_tf_tx_empty CHANGE tx_master_id treatment_master_id INT NOT NULL;
ALTER TABLE qc_tf_tx_empty ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);