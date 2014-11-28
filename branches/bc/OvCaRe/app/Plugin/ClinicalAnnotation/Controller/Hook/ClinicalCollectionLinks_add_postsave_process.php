<?php
	if(!isset($this->request->data['Collection']['deleted'])) {
		$this->Participant->updateParticipantVOANumbers($participant_id);
	}
	
?>