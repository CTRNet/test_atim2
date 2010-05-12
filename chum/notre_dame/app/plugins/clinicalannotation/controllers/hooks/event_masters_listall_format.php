<?php

	// --------------------------------------------------------------------------------
	// Override structure
	// -------------------------------------------------------------------------------- 
	if($event_group == 'lifestyle') {
		$this->Structures->set('ed_all_procure_lifestyle');
	} else {
		$this->redirect( '/pages/err_clin_system_error', null, true ); 
	}
	
	
?>