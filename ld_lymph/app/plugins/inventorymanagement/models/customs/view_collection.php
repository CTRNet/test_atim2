<?php

class ViewCollectionCustom extends ViewCollection {

	var $name = "ViewCollection";
	var $useTable = "view_collections";

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			preg_match('/^([0-9]{4})-([0-9]{2})-([0-9]{2})/', $collection_data['ViewCollection']['collection_datetime'], $matches);
			$title = '-';
			if(isset($matches[1]) && isset($matches[2]) && isset($matches[3])) {
				$title = AppController::getFormatedDateString($matches[1],$matches[2],$matches[3]);
			}
			$title .= ' '.(empty($collection_data['ViewCollection']['participant_identifier'])?'n/a':$collection_data['ViewCollection']['participant_identifier']);

			$return = array(
				'menu' => array(null, $title),
				'title' => array(null, __('collection', true) . ' : ' . $title),
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
