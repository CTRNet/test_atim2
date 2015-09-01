<?php 

	//Validate match between barcode, participant_identifier and visit
	$record_counter = 0;
	foreach($this->request->data as &$procure_new_sample_aliquots_set) {
		$record_counter++;
		$procure_participant_identifier = $procure_new_sample_aliquots_set['parent']['ViewSample']['participant_identifier'];
		$procure_visit = $procure_new_sample_aliquots_set['parent']['ViewSample']['procure_visit'];
		$line_counter = 0;
		foreach($procure_new_sample_aliquots_set['children'] as &$procure_new_aliquot){
			$line_counter++;
			if(!preg_match('/^'.$procure_participant_identifier.' '.$procure_visit.' /', $procure_new_aliquot['AliquotMaster']['barcode'])) {
				$errors['barcode']['aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00'][] = ($is_batch_process? $record_counter : $line_counter);
			}
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
	