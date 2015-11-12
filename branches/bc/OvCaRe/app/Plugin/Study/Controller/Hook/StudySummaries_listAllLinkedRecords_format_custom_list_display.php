<?php

	if($specific_list_header == 'participants') {
		if(!isset($this->Participant)) {
			$this->Participant = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		}$participant_ids = array();
		$query = "SELECT participant_id FROM event_masters INNER JOIN ovcare_ed_study_inclusions ON id=event_master_id WHERE deleted <> 1 AND study_summary_id = $study_summary_id";
		foreach($this->Participant->tryCatchQuery($query) as $pariticpant) {
			$participant_ids[] = $pariticpant['event_masters']['participant_id'];
		}
		$this->request->data = $this->paginate($this->Participant,array('Participant.id' => $participant_ids));
		$this->Structures->set('participants');
		$this->set('details_url', '/ClinicalAnnotation/Participants/profile/%%Participant.id%%');
		$this->set('permission_link', '/ClinicalAnnotation/Participants/profile/');
	}
	
?>
