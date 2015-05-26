<?php 
	
if($is_specimen && $sample_control_data['SampleControl']['sample_type'] != $this->Collection->getCollectionSampleTypeBasedOnCollectionType($collection_data['Collection']['qcroc_collection_type'])) {	
	AppController::addWarningMsg(__('this sample type can not be created for this collection type'));
	if(!isset(AppController::getInstance()->passedArgs['templateInitId']))	$this->redirect('/InventoryManagement/Collections/detail/' . $collection_id);
}

