ALTER TABLE qc_tf_txd_hormonotherapies
 DROP FOREIGN KEY qc_tf_txd_hormonotherapies_ibfk_1,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE qc_tf_txd_hormonotherapies_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
 
 