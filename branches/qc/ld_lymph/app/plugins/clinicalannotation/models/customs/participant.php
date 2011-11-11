<?php

class ParticipantCustom extends Participant {
	
	var $useTable = 'participants';	
	var $name = 'Participant';	
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
					'menu'				=>	array( NULL, __('participant',true).' #'.($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ' #'.($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
}

?>