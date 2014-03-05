<?php
class ParticipantCustom extends Participant{
	var $name 		= "Participant";
	var $tableName	= "participants";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			$return = array(
					'menu'				=>	array( NULL, 'Col# '.$result['Participant']['participant_identifier']),
					'title'				=>	array( NULL, 'Collection# : '.$result['Participant']['participant_identifier']),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function validates($options = array()){
		$errors = parent::validates($options);
		if(array_key_exists('date_of_death', $this->data['Participant']) && ($this->data['Participant']['date_of_death'])) {
			if($this->data['Participant']['vital_status'] != 'deceased') {
				$this->validationErrors['vital_status'][] = __('vital status mismatch');
				return false;
			}
		}
		return $errors;
	}
}
