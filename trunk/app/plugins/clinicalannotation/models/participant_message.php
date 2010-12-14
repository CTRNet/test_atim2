<?php

class ParticipantMessage extends ClinicalannotationAppModel {
    
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['ParticipantContact.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('ParticipantMessage.id'=>$variables['ParticipantMessage.id'])));
			
			$return = array(
				'title'			=>	array(NULL, $result['ParticipantMessage']['title']),
				'type'			=>	array(NULL, $result['ParticipantMessage']['type']),
				'data'			=> $result,
				'structure alias'=>'participantmessages'
			);
		}
		return $return;
	}
}

?>