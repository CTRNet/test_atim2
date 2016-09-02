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
}
	
	
	