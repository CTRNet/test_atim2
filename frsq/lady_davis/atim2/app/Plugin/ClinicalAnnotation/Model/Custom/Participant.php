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
}
