<?php

	//ATiM PROCURE PROCESSING BANK
	foreach($this->request->data as $tmp_procure_new_data_set) {
		if($tmp_procure_new_data_set['parent']['ViewSample']['procure_processing_bank_created_by_system'] == 'y' && !array_key_exists('ViewAliquot', $tmp_procure_new_data_set['parent'])) {
			$this->flash(__("batch init - at least one sample has been created by the system - you can only create derivatives from aliquots for samples created by the system"), $url_to_cancel, 5);
			return;
		}
	}
	//END ATiM PROCURE PROCESSING BANK
		
		
?>