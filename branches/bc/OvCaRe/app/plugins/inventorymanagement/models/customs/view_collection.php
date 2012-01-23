<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $useTable = 'view_collections';	
	var $name = 'ViewCollection';	
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));

			$participant_identifier = empty($collection_data['ViewCollection']['participant_identifier'])? 'n/a' : $collection_data['ViewCollection']['participant_identifier'];
			$return = array(
				'menu' => array(null, __('participant identifier',true).' '. $participant_identifier),
				'title' => array(null, __('participant identifier', true) . '  '. $participant_identifier),
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
		}
		
		return $return;
	}
	
}

?>
