<?php 
	
	if($this->request->data['Collection']['procure_visit'] != $collection_data['Collection']['procure_visit']) {
		$collection_aliquot_count = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($collection_aliquot_count) {
			$submitted_data_validates = false;
			$this->Collection->validationErrors['procure_visit'][] = __('visit of the collection cannot be changed - aliquot exists');
		}
	}
	