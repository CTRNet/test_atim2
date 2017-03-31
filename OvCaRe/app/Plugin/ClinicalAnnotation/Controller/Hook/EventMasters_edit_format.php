<?php
//***********************************************************************************************************************
//TODO Ying Request To Validate
//***********************************************************************************************************************
// We tried to link either collections or aliquots or aliquot uses to a study instead to use the Event Study reocrds.
// This Event Study Record was created to track study to participant link created from file maker pro.
//***********************************************************************************************************************
// 	if($event_master_data['EventControl']['event_type'] == 'study inclusion based on filemaker')
// 		$this->flash(__('no new data supposed to be created'), 'javascript:history.back()');
//***********************************************************************************************************************
//TODO END Ying Request To Validate
//***********************************************************************************************************************	

	if(empty($this->request->data) && isset($event_master_data['EventMaster']['ovcare_study_summary_id'])) {
		$this->StudySummary = AppModel::getInstance("Study", "StudySummary", true);
		$event_master_data['FunctionManagement']['ovcare_autocomplete_event_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array('StudySummary' => array('id' => $event_master_data['EventMaster']['ovcare_study_summary_id'])));
	}

?>