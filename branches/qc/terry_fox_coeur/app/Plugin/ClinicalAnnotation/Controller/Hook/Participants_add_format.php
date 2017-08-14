<?php 
	
	// Set default values
	
    $control_participant_identifiers = $this->Participant->find('list', array(
        'fields' => array(
            "Participant.participant_identifier"            
        ), 
	    'conditions' => array(
	        'Participant.qc_tf_is_control' => 'y'
	    ), 
	    'recursive'=>'-1')
    );
    $last_id = $this->Participant->find('first', array(
	    'fields' => array(" MAX(participant_identifier) AS max_val"), 
	    'conditions' => array('Participant.qc_tf_is_control' => 'n'), 
	    'recursive'=>'-1'));
	$next_participant_identifier = empty($last_id[0]['max_val'])? '1': $last_id[0]['max_val']+1;
	while(in_array($next_participant_identifier, $control_participant_identifiers)) {
	    $next_participant_identifier++;
	}
	$this->set('default_participant_identifier', $next_participant_identifier);