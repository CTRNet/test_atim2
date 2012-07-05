<?php

class ViewCollectionCustom extends ViewCollection {
	
	//var $useTable = 'diagnosis_masters';
	var $name = 'ViewCollection';
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
			$title = __('independant collection') . ' ['.$collection_data['ViewCollection']['participant_identifier'].']';
			if(!empty($collection_data['ViewCollection']['qc_tf_bank_participant_identifier'])) {
				$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
				$bank = $bank_model->find('first', array('conditions' => array('id' => $collection_data['ViewCollection']['bank_id'])));
				$bank_name = $bank['Bank']['name'];
				
				$title = $bank_name.': '.$collection_data['ViewCollection']['qc_tf_bank_participant_identifier'] . ' ['.$collection_data['ViewCollection']['participant_identifier'].']';
			}
			$return = array(
				'menu' => array(null, $title),
				'title' => array(null, __('collection') . ' : ' . $title),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}
	
}

