ALTER TABLE `clinical_collection_links` 
ADD INDEX(participant_id),
ADD FOREIGN KEY (participant_id) REFERENCES participants(id),
ADD UNIQUE INDEX(collection_id),
ADD FOREIGN KEY (collection_id) REFERENCES collections(id),
ADD UNIQUE INDEX(diagnosis_master_id),
ADD FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters(id),
ADD UNIQUE INDEX(consent_master_id),
ADD FOREIGN KEY (consent_master_id) REFERENCES consent_masters(id)





