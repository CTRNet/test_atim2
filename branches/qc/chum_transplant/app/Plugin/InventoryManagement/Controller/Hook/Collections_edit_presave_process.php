<?php

if($collection_data['Collection']['chum_transplant_type'] == 'donor time 0' && $collection_data['Collection']['chum_transplant_type'] != $this->request->data['Collection']['chum_transplant_type']) {
	$ChumTransplantDonorCollectionsList = AppModel::getInstance('InventoryManagement', 'ChumTransplantDonorCollectionsList', true);
	$is_collection_into_donor_collections_list = $ChumTransplantDonorCollectionsList->find('count', array('conditions' => array('ChumTransplantDonorCollectionsList.collection_id' => $collection_id)));
	if($is_collection_into_donor_collections_list > 0) {
		$this->Collection->validationErrors['chum_transplant_type'][] = __('your collection is included into a donor collections list - status can not be changed');
		$submitted_data_validates = false;
	}
}




