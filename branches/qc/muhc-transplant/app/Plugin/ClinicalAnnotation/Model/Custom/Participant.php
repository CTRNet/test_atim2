<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = "Participant";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$joins = array(
				array(
					'table'	=> 'banks',
					'alias'	=> 'Bank',
					'type'	=> 'INNER',
					'conditions' => 'Bank.id = Participant.muhc_participant_bank_id'));
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id']), 'joins' => $joins, 'fields' => array('Bank.*, Participant.*'),));	
			$title = $result['Bank']['muhc_irb_nbr']. ' ('.$result['Participant']['participant_identifier'].')';
			$return = array(
					'menu'				=>	array( NULL, $title),
					'title'				=>	array( NULL, $title),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
}

?>