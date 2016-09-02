<?php 

if(empty($this->request->data)) {
	$this->StudySummary = AppModel::getInstance('Study', 'StudySummary', true);
	$collection_data['FunctionManagement']['chus_autocomplete_collections_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array('StudySummary' => array('id' => $collection_data['Collection']['chus_default_collection_study_summary_id'])));
}
	
	