<?php 
	
	//ATiM PROCURE PROCESSING BANK
	foreach($this->request->data as $tmp_procure_key_1 => $tmp_procure_new_data_set) {
		foreach($tmp_procure_new_data_set['children'] as $tmp_procure_key_2 => $tmp_procure_new_children_aliquot_record) {
			if($tmp_procure_new_children_aliquot_record['AliquotMaster']['procure_processing_bank_created_by_system'] == 'y') {
				$excluded_parent_aliquot[] = $this->request->data[$tmp_procure_key_1]['children'][$tmp_procure_key_2];
				unset($this->request->data[$tmp_procure_key_1]['children'][$tmp_procure_key_2]);
				pr($this->request->data[$tmp_procure_key_1]['children']);
			}
		}
		if(empty($this->request->data[$tmp_procure_key_1]['children'])) {
			unset($this->request->data[$tmp_procure_key_1]);
		}
	}
	if(!empty($excluded_parent_aliquot)) {
		$tmp_barcode = array();
		foreach($excluded_parent_aliquot as $new_aliquot) {
			$tmp_barcode[] = $new_aliquot['AliquotMaster']['barcode'];
		}
		$msg = __('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)').': ['.implode(",", $tmp_barcode).']';
	
		if(empty($this->request->data)) {
			$this->flash(__($msg), "javascript:history.back()", 5);
			return;
		} else {
			AppController::addWarningMsg($msg);
		}
	}
	//END ATiM PROCURE PROCESSING BANK
	