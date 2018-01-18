<?php 

	$record_counter = 0;
	foreach($this->request->data as $procure_aliquot_data_set) {
		$record_counter++;
		$procure_participant_identifier = $procure_visit = null;
		if(preg_match('/^(PS[1-4]P[0-9]{4})\ ([Vv]((0[1-9])|([1-9][0-9]))([\.,]([1-9])){0,1})/',$procure_aliquot_data_set['parent']['AliquotMaster']['barcode'], $matches)) {
			$procure_participant_identifier = $matches[1];
			$procure_visit = $matches[2];
		}
		foreach($procure_aliquot_data_set['children'] as $procure_aliquot_data) {
			$barcode_error = $this->AliquotMaster->validateBarcode($procure_aliquot_data['AliquotMaster']['barcode'], Configure::read('procure_bank_id'), $procure_participant_identifier, $procure_visit);
			if($barcode_error) $errors['barcode'][$barcode_error][$record_counter] = $record_counter;
		}
	}
	
	if(empty($errors)){
		$tmp_sample_control = $this->SampleControl->getOrRedirect($child_aliquot_ctrl['AliquotControl']['sample_control_id']);
		foreach($this->request->data as &$created_aliquots){
			foreach($created_aliquots['children'] as &$new_aliquot) {
				if($tmp_sample_control['SampleControl']['sample_type'] == 'rna') list($new_aliquot['AliquotDetail']['procure_total_quantity_ug'], $new_aliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($new_aliquot);
				$new_aliquot['AliquotMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
			}
		}
		$child_writable_fields['aliquot_masters']['addgrid'] = array_merge($child_writable_fields['aliquot_masters']['addgrid'], array('procure_created_by_bank'));
		if(!isset($child_writable_fields[$child_aliquot_ctrl['AliquotControl']['detail_tablename']]['addgrid'])) $child_writable_fields[$child_aliquot_ctrl['AliquotControl']['detail_tablename']]['addgrid'] = array();
		$child_writable_fields[$child_aliquot_ctrl['AliquotControl']['detail_tablename']]['addgrid'] = array_merge($child_writable_fields[$child_aliquot_ctrl['AliquotControl']['detail_tablename']]['addgrid'], array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
	}
	