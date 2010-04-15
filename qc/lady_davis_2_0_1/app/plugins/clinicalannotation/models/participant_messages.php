<?php

class ParticipantMessage extends ClinicalAnnotationAppModel {
    
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['ParticipantContact.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('ParticipantMessage.id'=>$variables['ParticipantMessage.id'])));
			
			$return = array(
				'Summary' => array(
					'title'			=>	array(NULL, $result['ParticipantMessage']['title']),
					'type'			=>	array(NULL, $result['ParticipantMessage']['type']),
					'participant_id' => array(NULL, $result['ParticipantMessage']['participant_id']),
					'description'	=>	array(
						'date_requested'	=>	$result['ParticipantMessage']['date_requested'],
						'author'			=>	$result['ParticipantMessage']['author'],
						'desc'				=>	$result['ParticipantMessage']['description'],
						'due_date'			=>	$result['ParticipantMessage']['due_date']
					)
				)
			);
		}
		return $return;
	}
}

?>