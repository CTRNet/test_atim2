<?php

class ParticipantCustom extends Participant {
	
	var $useTable = 'participants';
	var $name = 'Participant';
	
	var $registered_view = array(
		'InventoryManagement.ViewCollection' => array('Participant.id'),
		'InventoryManagement.ViewSample' => array('Participant.id'),
		'InventoryManagement.ViewAliquot' => array('Participant.id')
	);
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$joins = array(array(
				'table' => 'banks',
				'alias'	=> 'Bank',
				'type'	=> 'LEFT',
				'conditions' => array('Bank.id = Participant.qc_tf_bank_id', 'Bank.deleted <> 1')
			));
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id']), 'joins' => $joins, 'fields' => 'Participant.*, Bank.*'));
			
			
			$title = $result['Participant']['participant_identifier'];
			if(AppController::getInstance()->Session->read('flag_show_confidential')) {
				$title =  $result['Bank']['name'].' #'.$result['Participant']['qc_tf_bank_identifier'].' ['. $result['Participant']['participant_identifier'].']';
			}
			
			$return = array(
					'menu'				=>	array( NULL, ($title) ),
					'title'				=>	array( NULL, ($title) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
}
