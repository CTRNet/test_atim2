<?php

class SardoMigrationsController extends AdministrateAppController {
	var $uses = array('Administrate.SardoImportSummary');
	
	function listAll(){	
		$condtions = array();
		$this->Structures->set('qc_nd_sardo_migrations');
		$this->request->data = $this->paginate($this->SardoImportSummary, $condtions);
		if(!$this->Session->read('flag_show_confidential')){
			foreach($this->request->data as &$new_data){
				if($new_data['SardoImportSummary']['message'] =='Creation/Update summary') $new_data['SardoImportSummary']['details']= CONFIDENTIAL_MARKER;
			}
		}		
	}
}
