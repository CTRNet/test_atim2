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
		}
		
		return $return;
	}

}
?>