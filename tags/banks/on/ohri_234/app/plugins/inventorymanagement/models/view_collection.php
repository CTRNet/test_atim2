<?php

class ViewCollection extends InventorymanagementAppModel {

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
		
			$return = array(
				'menu' => array(null, $collection_data['ViewCollection']['acquisition_label']),
				'title' => array(null, __('collection', true) . ' : ' . $collection_data['ViewCollection']['acquisition_label']),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
			
			$consent_status = $this->getUnconsentedParticipantCollections(array('data' => $collection_data));
			if(!empty($consent_status)){
				if($consent_status[$variables['Collection.id']] == null){
					AppController::addWarningMsg(__('no consent is linked to the current participant collection', true));
				}else{
					AppController::addWarningMsg(sprintf(__('the linked consent status is [%s]', true), __($consent_status[$variables['Collection.id']], true)));
				}
			}
			if(!empty($collection_data['ViewCollection']['consent_master_id'])){
				$consent_model = AppModel::getInstance("Clinicalannotation", "ConsentMaster", true);
				$consent_data = $consent_model->find('first', array(
					'fields' => array('ConsentMaster.consent_status'), 
					'conditions' => array('ConsentMaster.id' => $collection_data['ViewCollection']['consent_master_id']),
					'recursive' => -1)
				);
				if($consent_data['ConsentMaster']['consent_status'] != 'obtained'){
					
				}
			}else if($collection_data['ViewCollection']['collection_property'] == 'participant collection'){
				
			}
		}
		
		return $return;
	}
	
	/**
	 * @param array $collection with either a key 'id' referring to an array
	 * of ids, or a key 'data' referring to ViewCollections.
	 * @return array The ids of participants collections with a consent status 
	 * other than 'obtained' as key. Their value will null if there is no linked
	 * consent or the consent status otherwise. 
	 */
	function getUnconsentedParticipantCollections(array $collection){
		$data = null;
		if(array_key_exists('id', $collection)){
			$data = $this->find('all', array('conditions' => array('ViewCollection.collection_id' => $collection['id'])));
		}else{
			$data = array_key_exists('ViewCollection', $collection['data']) ? array($collection['data']) : $collection['data']; 
		}
		
		$results = array();
		$consents_to_fetch = array();
		foreach($data as $index => &$data_unit){
			if($data_unit['ViewCollection']['collection_property'] != 'participant collection'){
				//filter non participant collections
				unset($data[$index]);
			}else if(empty($data_unit['ViewCollection']['consent_master_id'])){
				//removing missing consents
				$results[$data_unit['ViewCollection']['collection_id']] = null;
				unset($data[$index]);
			}else{
				$consents_to_fetch[] = $data_unit['ViewCollection']['consent_master_id']; 
			}
		}
		
		if(!empty($consents_to_fetch)){
			//find all required consents
			$consent_model = AppModel::getInstance("Clinicalannotation", "ConsentMaster", true);
			$consent_data = $consent_model->find('all', array(
				'fields' => array('ConsentMaster.id', 'ConsentMaster.consent_status'), 
				'conditions' => array('ConsentMaster.id' => $consents_to_fetch, 'NOT' => array('ConsentMaster.consent_status' => 'obtained')),
				'recursive' => -1)
			);
			
			//put consents in array keys
			$not_obtained_consents = array();
			if(!empty($consent_data)){
				foreach($consent_data as &$consent_data_unit){
					$not_obtained_consents[$consent_data_unit['ConsentMaster']['id']] = $consent_data_unit['ConsentMaster']['consent_status'];
				}
				
				//see for each collection if the consent is found in the not obtained consent array
				foreach($data as &$data_unit){
					if(array_key_exists($data_unit['ViewCollection']['consent_master_id'], $not_obtained_consents)){
						$results[$data_unit['ViewCollection']['collection_id']] = $not_obtained_consents[$data_unit['ViewCollection']['consent_master_id']];
					}
				}
			}
		}
		
		return $results;
	}
	
}

?>
