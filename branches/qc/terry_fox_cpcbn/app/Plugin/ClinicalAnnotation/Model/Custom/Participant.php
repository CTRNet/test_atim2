<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));	
			$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
			$bank = $bank_model->find('first', array('conditions' => array('Bank.id' => $result['Participant']['qc_tf_bank_id'])));
			
			$label = $result['Participant']['participant_identifier'] . ' [' . $bank['Bank']['name'].']';
			$return = array(
					'menu'				=>	array( NULL, $label ),
					'title'				=>	array( NULL, $label),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);	
		}
		
		return $return;
	}
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		if(array_key_exists('qc_tf_bank_id', $this->data['Participant'])) {
			$conditions = array(
				'Participant.qc_tf_bank_id'=> $this->data['Participant']['qc_tf_bank_id'], 
				'Participant.qc_tf_bank_participant_identifier'=> $this->data['Participant']['qc_tf_bank_participant_identifier']);
			if($this->id) $conditions[] = 'Participant.id != '.$this->id;
			
			$count = $this->find('count', array('conditions'=> $conditions));
			if($count) {
				$this->validationErrors['qc_tf_bank_participant_identifier'][] = 'this bank participant identifier has already been assigned to a patient of this bank';
				$result = false;
			}
		}
		
		return $result;
	}

}

?>