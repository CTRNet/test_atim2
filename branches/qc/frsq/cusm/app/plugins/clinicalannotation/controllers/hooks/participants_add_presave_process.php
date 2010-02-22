<?php
 	
 	// --------------------------------------------------------------------------------
	// Generate Participant.participant_identifier
	// -------------------------------------------------------------------------------- 	
 	$last_participant_created = $this->Participant->find('first',array('order'=>array('Participant.id DESC'), 'limit' => 1, 'recursive' => '-1'));
 	$next_participant_id = $last_participant_created['Participant']['id'] + 1;
 	
 	$supposed_participant_identifier = 'Ap-' . $next_participant_id;
 	
 	$next_participant_identifier = $supposed_participant_identifier;
 	$sub_identifier = 1;
 	$new_identifier_found = false;
 	while(!$new_identifier_found) {
 		$part_counter = $this->Participant->find('count',array('conditions'=>array('Participant.participant_identifier' => $next_participant_identifier), 'recursive' => '-1'));
 		if($part_counter == 0) {
 			$new_identifier_found = true;
 		} else {
 			$next_participant_identifier = $supposed_participant_identifier . '.' . $sub_identifier;
 			$sub_identifier++;
 		}
 	}
 	
 	$this->data['Participant']['participant_identifier'] = $next_participant_identifier;
	
?>
