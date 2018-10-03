<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $useTable = 'view_collections';	
	var $name = 'ViewCollection';	
		
	function summary($variables=array()) {
		$return = false;

		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));

			$collection_title = __('participant identifier').': '.(empty($collection_data['ViewCollection']['participant_identifier'])? __('unlinked') : $collection_data['ViewCollection']['participant_identifier']);
			if(!empty($collection_data['ViewCollection']['collection_datetime'])) {
				$formatted_collection_date = substr($collection_data['ViewCollection']['collection_datetime'], 0, strpos($collection_data['ViewCollection']['collection_datetime'], ' '));
				switch($collection_data['ViewCollection']['collection_datetime_accuracy']) {
					case 'y':
						$formatted_collection_date = '+/-'.substr($formatted_collection_date, 0, strpos($formatted_collection_date, '-'));
						break;
					case 'm':
						$formatted_collection_date = substr($formatted_collection_date, 0, strpos($formatted_collection_date, '-'));
						break;
					case 'd':
						$formatted_collection_date = substr($formatted_collection_date, 0, strrpos($formatted_collection_date, '-'));
						break;
					default:
				}
				$collection_title .= ' [' . $formatted_collection_date .']';
			}
			
			$return = array(
				'menu' => array(null, $collection_title),
				'title' => array(null, __('collection') . ' : ' . $collection_title),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
			
			$consent_status = $this->getUnconsentedParticipantCollections(array('data' => $collection_data));
			if(!empty($consent_status)){
				if($consent_status[$variables['Collection.id']] == null){
					AppController::addWarningMsg(__('no consent is linked to the current participant collection'));
				}else{
					AppController::addWarningMsg(__('the linked consent status is [%s]', $consent_status[$variables['Collection.id']], true));
				}
			}
		}
		
		return $return;
	}
	
}

?>
