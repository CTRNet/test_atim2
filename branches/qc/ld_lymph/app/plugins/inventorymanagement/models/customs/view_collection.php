<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';	
	var $useTable = 'view_collections';

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$label = (empty($collection_data['ViewCollection']['participant_identifier'])? 'n/a' : 'Part #'.($collection_data['ViewCollection']['participant_identifier'])). 
				' '.
				substr($collection_data['ViewCollection']['collection_datetime'], 0, 10);
							
			$return = array(
				'menu' => array(null,  $label),
				'title' => array(null, $label),
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
