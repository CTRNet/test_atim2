<?php 
	

	if(($treatment_master_data['TreatmentDetail']['donor_status'] != $this->request->data['TreatmentDetail']['donor_status']) || ($treatment_master_data['TreatmentDetail']['previous_transplant'] != $this->request->data['TreatmentDetail']['previous_transplant'])) {
		$collection_model = AppModel::getInstance('InventoryManagement', 'Collection');
		$collections_to_update = $collection_model->find('all', array('conditions'=>array('Collection.treatment_master_id' => $tx_master_id), 'recursive' => '-1'));
		$collection_model->addWritableField(array('acquisition_label','treatment_master_id'));
		foreach($collections_to_update as $tmp_collection) {
			$collection_model->data = array();
			$collection_model->id = $tmp_collection['Collection']['id'];
			$collection_model->save(array('Collection' => array('treatment_master_id' => $tmp_collection['Collection']['treatment_master_id'])), false);
		}
	}

	
