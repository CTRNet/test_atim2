ALTER TABLE  ohri_txd_surgeries DROP FOREIGN KEY `FK_ohri_txd_surgeries_tx_masters`;
ALTER TABLE  ohri_txd_surgeries CHANGE tx_master_id treatment_master_id int(11) DEFAULT NULL;
ALTER TABLE  ohri_txd_surgeries ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
