<?php
class ViewCollectionCustom extends ViewCollection{
	var $useTable = 'view_collections';
	var $name = 'ViewCollection';
	
	//copied the original function but updated the title + menu
	function summary($variables=array()) {
		$return = false;
	
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
	
			$return = array(
					'menu' => array(null, $collection_data['ViewCollection']['participant_identifier']),
					'title' => array(null, __('collection', true) . ' : ' . $collection_data['ViewCollection']['participant_identifier']),
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