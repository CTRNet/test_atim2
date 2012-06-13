<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $useTable = 'view_collections';	
	var $name = 'ViewCollection';	
	
	function summary($variables=array()) {
		$return = false;
	
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$label = $collection_data['ViewCollection']['frsq_number']. ' [' . substr($collection_data['ViewCollection']['collection_datetime'].']', 0, 7);
			$return = array(
					'menu' => array( NULL, ($label) ),
					'title' => array( NULL, ($label) ),
					'structure alias' 	=> 'view_collection',
					'data'				=> $collection_data
			);
				
			$consent_status = $this->getUnconsentedParticipantCollections(array('data' => $collection_data));
			if(!empty($consent_status)){
				if(!$collection_data['ViewCollection']['participant_id']){
					AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
				}else if($consent_status[$variables['Collection.id']] == null){
					$link = '';
					if(AppController::checkLinkPermission('/ClinicalAnnotation/ClinicalCollectionLinks/detail/')){
						$link = sprintf(' <a href="%sClinicalAnnotation/ClinicalCollectionLinks/detail/%d/%d">%s</a>', AppController::getInstance()->request->webroot, $collection_data['ViewCollection']['participant_id'], $collection_data['ViewCollection']['collection_id'], __('click here to access it'));
					}
					AppController::addWarningMsg(__('no consent is linked to the current participant collection').'.'.$link);
				}else{
					AppController::addWarningMsg(__('the linked consent status is [%s]', __($consent_status[$variables['Collection.id']])));
				}
			}
		}
	
		return $return;
	}
	
}

?>
