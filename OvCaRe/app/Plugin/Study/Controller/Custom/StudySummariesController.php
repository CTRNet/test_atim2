<?php
class StudySummariesControllerCustom extends StudySummariesController{
	
	function listAllLinkedParticipants( $study_summary_id ) {
		if(!$this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
		$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$participant_ids = array();
		$query = "SELECT participant_id FROM event_masters INNER JOIN ovcare_ed_study_inclusions ON id=event_master_id WHERE deleted <> 1 AND study_summary_id = $study_summary_id";
		foreach($this->Participant->tryCatchQuery($query) as $pariticpant) {
			$participant_ids[] = $pariticpant['event_masters']['participant_id'];
		}	
		$this->request->data = $this->paginate($this->Participant, array('Participant.id' => $participant_ids));
		$this->Structures->set('ovcare_study_participants');
	}
	
}