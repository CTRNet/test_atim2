<?php
	
	/* 
	@author Stephen Fung
	@since 2015-04-23
	Add participant identifier to the consent forms model
	Eventum ID: 3216
	*/

	$participant_of_consent = $this->Participant->find('first', array(
			'conditions' => array('Participant.id' => $participant_id)));


	$participant_identifier_of_consent = $participant_of_consent['Participant']['participant_identifier'];


	$query_to_update = "UPDATE consent_masters SET consent_masters.participant_identifier = "."'".$participant_identifier_of_consent."'"." WHERE consent_masters.participant_id = ".$this->Participant->id.";";

	$this->ConsentMaster->tryCatchQuery($query_to_update);

	$this->ConsentMaster->tryCatchQuery(str_replace("consent_masters", "consent_masters_revs", $query_to_update));
