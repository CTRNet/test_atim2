<?php 

	$record_counter = 0;
	foreach($this->request->data as $procure_aliquot_data_set) {
		$record_counter++;
		$participant_identifier_and_visit = preg_match('/^(PS[1-4]P[0-9]{4}\ V[0-9]{2})/',$procure_aliquot_data_set['parent']['AliquotMaster']['barcode'],$matches)? $matches[1] : null;
		if(!$participant_identifier_and_visit) {
			$errors['barcode']['aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00'][$record_counter] = $record_counter;
		} else {
			foreach($procure_aliquot_data_set['children'] as $procure_aliquot_data) {
				if(!preg_match('/^'.$participant_identifier_and_visit.' /',$procure_aliquot_data['AliquotMaster']['barcode'])) {
					$errors['barcode']['aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00'][$record_counter] = $record_counter;
				}
			}
		}
	}

	if(empty($errors)){
		$tmp_sample_control = $this->SampleControl->getOrRedirect($child_aliquot_ctrl['AliquotControl']['sample_control_id']);
		if($tmp_sample_control['SampleControl']['sample_type'] == 'rna') {
			foreach($this->request->data as &$created_aliquots){
				foreach($created_aliquots['children'] as &$new_aliquot) {
					list($new_aliquot['AliquotDetail']['procure_total_quantity_ug'], $new_aliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($new_aliquot);
				}
			}
			$this->AliquotMaster->addWritableField(array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
		}
	}
	