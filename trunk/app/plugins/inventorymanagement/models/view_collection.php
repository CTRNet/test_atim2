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
			
			if(!empty($collection_data['ViewCollection']['consent_master_id'])){
				$consent_model = AppModel::getInstance("Clinicalannotation", "ConsentMaster", true);
				$consent_data = $consent_model->find('first', array(
					'fields' => array('ConsentMaster.consent_status'), 
					'conditions' => array('ConsentMaster.id' => $collection_data['ViewCollection']['consent_master_id']),
					'recursive' => -1)
				);
				if($consent_data['ConsentMaster']['consent_status'] != 'obtained'){
					AppController::addWarningMsg(sprintf(__('the linked consent status is [%s]', true), __($consent_data['ConsentMaster']['consent_status'], true)));
				}
			}
		}
		
		return $return;
	}
	
}

?>
