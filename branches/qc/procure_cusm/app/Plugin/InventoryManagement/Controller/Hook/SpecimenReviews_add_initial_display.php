<?php 
	
	if(Configure::read('procure_atim_version') != 'BANK') {
		$filtered_array = array_filter($this->viewVars['aliquot_list']);
		if(empty($filtered_array)) {
			$this->flash(__("no aliquot to test exists"), "/InventoryManagement/SpecimenReviews/listAll/$collection_id/$sample_master_id/", 5);
			return;
		}
	}
	