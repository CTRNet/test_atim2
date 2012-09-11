<?php

if($is_specimen){
	if(!$this->SampleMaster->validateChusCollectionDates($sample_data, $this->request->data)) AppController::addWarningMsg(__('at least one specimen will have a collection date different than the new date of the collection'));
}
