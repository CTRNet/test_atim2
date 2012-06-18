<?php

class CollectionCustom extends Collection{

	var $name = "Collection";
	var $useTable = "collections";
	
	function updateCollectionSampleLabels($collection_id, $bank_participant_identifier = null) {
		if(!isset($this->SampleMaster)) {
			$this->SampleMaster = AppModel::getInstance('Inventorymanagement', 'SampleMaster', true);
		}
		
		if(!isset($this->ViewCollection)) {
			$this->ViewCollection = AppModel::getInstance('Inventorymanagement', 'ViewCollection', true);
		}
		
		// Get bank_participant_identifier
		if(is_null($bank_participant_identifier)){
			$collection_view_data = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
			if(empty($collection_view_data)){ 
				AppController::getInstance()->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			$bank_participant_identifier = empty($collection_view_data['ViewCollection']['identifier_value'])? '' : $collection_view_data['ViewCollection']['identifier_value'];			
		}
		
		// Get collection samples list
		$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
		$collection_samples_list = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'order' => 'SampleMaster.initial_specimen_sample_id ASC, SampleControl.sample_category ASC'));
		
		// Update collection samples label
		$specimens_sample_labels_from_id = array();
		foreach($collection_samples_list as $new_collection_sample) {	
			$new_sample_label = null;	
			if($new_collection_sample['SampleControl']['sample_category'] == 'specimen') {
				$new_sample_label = $this->SampleMaster->createSampleLabel($collection_id, $new_collection_sample, $bank_participant_identifier);
				$specimens_sample_labels_from_id[$new_collection_sample['SampleMaster']['id']] = $new_sample_label;
			} else {
				if(!isset($specimens_sample_labels_from_id[$new_collection_sample['SampleMaster']['initial_specimen_sample_id']])) { pr($new_collection_sample);pr($specimens_sample_labels_from_id);exit;AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				$new_sample_label = $this->SampleMaster->createSampleLabel($collection_id, $new_collection_sample, $bank_participant_identifier, $specimens_sample_labels_from_id[$new_collection_sample['SampleMaster']['initial_specimen_sample_id']]);
			}
						
			// Save new label
			$this->SampleMaster->id = $new_collection_sample['SampleMaster']['id'];
			if(!$this->SampleMaster->save(array('SampleMaster' => array('sample_label' => $new_sample_label)), false)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
	}
	
}

?>
