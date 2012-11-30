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
	
	function validates($options = array()){
		$result = parent::validates($options);	
		if(isset($this->data['Participant']['qc_tf_bank_id']) && isset($this->data['Participant']['qc_tf_bank_identifier'])) {		
			$conditions = array(
				'Participant.qc_tf_bank_id'=>$this->data['Participant']['qc_tf_bank_id'],
				'Participant.qc_tf_bank_identifier'=>$this->data['Participant']['qc_tf_bank_identifier']);
			if($this->id) $conditions[] = 'Participant.id <> '.$this->id;
			if($this->find('count', array('conditions'=>$conditions, 'recursive' => -1))) {
				$this->validationErrors['qc_tf_bank_identifier'] = 'this bank identifier has already been recorded for this bank';
				$result = false;
			}
		}	
		return $result;
	}
	
}
