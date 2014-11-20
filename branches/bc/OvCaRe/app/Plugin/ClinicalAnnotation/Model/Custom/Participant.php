<?php

class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	var $hasMany = array(
		'DiagnosisMaster' => array(
			'className'   => 'ClinicalAnnotation.DiagnosisMaster',
			 'foreignKey'  => 'participant_id')
	); 	

	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			$title = __('participant identifier').': '.$result['Participant']['participant_identifier'];
			$return = array(
					'menu'				=>	array( NULL, ($title) ),
					'title'				=>	array( NULL, ($title) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
			//Add voas nbr
			$collection_model = AppModel::getInstance("InventoryManagement", "Collection", true);
			$participant_collection = $collection_model->find('all', array('conditions' => array('Collection.participant_id' => $variables['Participant.id']), 'order' => array('Collection.collection_voa_nbr ASC'), 'recursive' => '-1'));
			$voas = array();
			foreach($participant_collection as $new_collections) {
				$voas[] = $new_collections['Collection']['collection_voa_nbr'];
				
			}
			$voas = implode(', ',$voas);
			$return['data']['Generated']['ovcare_participant_voas'] = $voas;
		}
		
		return $return;
	}

}
?>