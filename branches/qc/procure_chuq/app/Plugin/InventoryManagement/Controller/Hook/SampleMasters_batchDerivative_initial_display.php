<?php

	if(Configure::read('procure_atim_version') != 'BANK') {
		foreach($this->request->data as $tmp_procure_new_data_set) {
			if($tmp_procure_new_data_set['parent']['ViewSample']['procure_created_by_bank'] != 'p' && !array_key_exists('ViewAliquot', $tmp_procure_new_data_set['parent'])) {
				$this->flash(__("batch init - at least one sample has been created by the system - you can only create derivatives from aliquots for samples created by the system"), $url_to_cancel, 5);
				return;
			}
		}
	}		
		
?>