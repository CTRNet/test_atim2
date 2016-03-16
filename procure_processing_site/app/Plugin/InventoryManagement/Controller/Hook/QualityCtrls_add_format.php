<?php 
	
	if(Configure::read('procure_atim_version') != 'BANK') {
		foreach($this->request->data as $tmp_procure_data_set) {
			if($tmp_procure_data_set['parent']['ViewSample']['procure_created_by_bank'] != 'p' && !isset($tmp_procure_data_set['parent']['AliquotMaster'])) {
				$this->flash(__("at least one sample has been created by the system - you have to select first an tested aliquot if this one exists"), $cancel_button, 5);
				return;
			}
		}
	}
