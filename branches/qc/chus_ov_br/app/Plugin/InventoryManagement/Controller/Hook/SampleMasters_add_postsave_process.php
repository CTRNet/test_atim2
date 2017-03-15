<?php

if($is_specimen){
	if(!isset($collection_data) || empty($collection_data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	if(!$this->SampleMaster->validateChusCollectionDates($collection_data, $this->request->data)) AppController::addWarningMsg(__('at least one specimen will have a collection date different than the new date of the collection'));
}
