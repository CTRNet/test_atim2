<?php 
	
	if($collection_data['Collection']['procure_visit'] == 'Controls') {
	    AppController::addWarningMsg(__('control collection - no data can be updated'));
	}
