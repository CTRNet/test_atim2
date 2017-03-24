<?php 
	
	//$aliquot_control
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'whatman paper') {
		$errors['aliquot_type']['whatman paper can not be created anymore'][] = '';
	}

	//Validate match between barcode, participant_identifier and visit
	$record_counter = 0;
	foreach($this->request->data as &$procure_new_sample_aliquots_set) {
		$record_counter++;
		$procure_participant_identifier = $procure_new_sample_aliquots_set['parent']['ViewSample']['participant_identifier'];
		$procure_visit = $procure_new_sample_aliquots_set['parent']['ViewSample']['procure_visit'];
		$line_counter = 0;
		foreach($procure_new_sample_aliquots_set['children'] as &$procure_new_aliquot){
			$line_counter++;
			$barcode_error = $this->AliquotMaster->validateBarcode($procure_new_aliquot['AliquotMaster']['barcode'], Configure::read('procure_bank_id'), $procure_participant_identifier, $procure_visit);
			if($barcode_error) $errors['barcode'][$barcode_error][] = ($is_batch_process? $record_counter : $line_counter);
			$procure_new_aliquot['AliquotMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
		}
	}
	$this->AliquotMaster->addWritableField(array('procure_created_by_bank'));

	if(empty($errors)){
		$quantity_calculated = false;
		foreach($this->request->data as &$tmp_created_aliquots){
			if($tmp_created_aliquots['parent']['ViewSample']['sample_type'] == 'rna') {
				$quantity_calculated = true;
				foreach($tmp_created_aliquots['children'] as &$tmp_new_aliquot) {
					list($tmp_new_aliquot['AliquotDetail']['procure_total_quantity_ug'], $tmp_new_aliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($tmp_new_aliquot);
				}
			}
		}
		if($quantity_calculated) $this->AliquotMaster->addWritableField(array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
	}
	