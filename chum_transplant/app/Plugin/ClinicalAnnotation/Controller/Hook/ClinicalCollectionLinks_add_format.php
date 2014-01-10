<?php 
	
	if(empty($this->request->data) && !empty($tx_data)) {
		$tmp_sorted_treatment_master_id = array();
		foreach($tx_data as $key_tx => $unit) $tmp_sorted_treatment_master_id[$unit['TreatmentMaster']['start_date']] = $key_tx;
		krsort($tmp_sorted_treatment_master_id);
		$key_tx = array_shift($tmp_sorted_treatment_master_id);
		$tx_data[$key_tx]['Collection']['treatment_master_id'] = $tx_data[$key_tx]['TreatmentMaster']['id'];
		$this->set('tx_data', $tx_data);
		$this->set('found_tx', true);
	}
	$this->Structures->set('treatmentmasters,chum_transplant_txd_transplants', 'atim_structure_tx');
