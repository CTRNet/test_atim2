<?php 
	
if(!$need_to_save){
	//Set default bank
	if(!isset($this->request->data['Collection']['bank_id'])) 
		$this->request->data['Collection']['bank_id'] = 1;
	//Copy study in duplicate collection process
	if(isset($this->request->data['Collection']['chus_default_collection_study_summary_id'])) {
		$this->StudySummary = AppModel::getInstance('Study', 'StudySummary', true);
		$this->request->data['FunctionManagement']['chus_autocomplete_collections_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array('StudySummary' => array('id' => $this->request->data['Collection']['chus_default_collection_study_summary_id'])));
	}
	//Set collection date based one surgery/biopsy date
	if(isset($collection_data) && isset($collection_data['TreatmentMaster'])) {
		$this->request->data['Collection']['collection_datetime'] = $collection_data['TreatmentMaster']['start_date'];
		$this->request->data['Collection']['collection_datetime_accuracy'] = $collection_data['TreatmentMaster']['start_date_accuracy'];
	}
}