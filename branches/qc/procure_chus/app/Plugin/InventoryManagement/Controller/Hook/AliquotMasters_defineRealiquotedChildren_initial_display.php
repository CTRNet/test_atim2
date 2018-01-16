<?php 

    // ATiM Processing Site Data Check
    //===================================================
    // An aliquot of a sample created by system to migrate aliquot from ATiM-Processing site and defined as created by another bank than the bank 
    // of the ATiM used (aliquot previously
    // transferred from bank different than PS3 to 'Processing Site' and now merged into the ATiM of PS3) can not be defined as the children of an aliquot (realiquoting definition).
	
    $new_excluded_aliquot = false;
	foreach($this->request->data as $tmp_procure_key_1 => $tmp_procure_new_data_set) {
		foreach($tmp_procure_new_data_set['children'] as $tmp_procure_key_2 => $tmp_procure_new_children_aliquot_record) {
			if($tmp_procure_new_children_aliquot_record['SampleMaster']['procure_created_by_bank'] == 's' 
            && $tmp_procure_new_children_aliquot_record['AliquotMaster']['procure_created_by_bank'] != Configure::read('procure_bank_id')) {
				unset($this->request->data[$tmp_procure_key_1]['children'][$tmp_procure_key_2]);
			}
		}
		if(empty($this->request->data[$tmp_procure_key_1]['children'])) {
		    $excluded_parent_aliquot[] = $this->request->data[$tmp_procure_key_1]['parent'];
		    unset($this->request->data[$tmp_procure_key_1]);
		    $new_excluded_aliquot = true;
		}
	}	
	if($new_excluded_aliquot) {
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
	