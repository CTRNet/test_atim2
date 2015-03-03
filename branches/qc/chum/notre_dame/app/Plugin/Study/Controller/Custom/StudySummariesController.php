<?php
class StudySummariesControllerCustom extends StudySummariesController{
	
	function listAllLinkedParticipants( $study_summary_id ) {
		if(!$this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
		$this->EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$event_master_ids = array();
		$query = "SELECT event_master_id FROM qc_nd_ed_studies AS EventDetail WHERE study_summary_id = $study_summary_id";
		foreach($this->EventMaster->tryCatchQuery($query) as $event_detail) $event_master_ids[] = $event_detail['EventDetail']['event_master_id'];
		$this->EventMaster->bindModel(
			array('belongsTo' => array(
				'Participant' => array(
					'className'    => 'ClinicalAnnotation.Participant',
					'foreignKey'    => 'participant_id'))));
		$this->request->data = $this->paginate($this->EventMaster, array('EventMaster.id' => $event_master_ids));
		$this->Structures->set('qc_nd_study_participants');
	}
	
}