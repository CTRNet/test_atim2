<?php

	//Set default consent
	if($consent_data) {
		$all_obtained_consents = array();
		foreach($consent_data as $tmp_new_consent) {
			if($tmp_new_consent['ConsentMaster']['consent_status'] == 'obtained') {
				$all_obtained_consents[$tmp_new_consent['ConsentMaster']['consent_signed_date']][$tmp_new_consent['ConsentMaster']['id']] = $tmp_new_consent['ConsentMaster']['id'];
			}
		}
		krsort($all_obtained_consents);
		$selected_consents = array_shift($all_obtained_consents);
		krsort($selected_consents);
		$this->request->data['Collection']['consent_master_id'] = array_shift($selected_consents);
		$consent_found = $this->setForRadiolist($consent_data, 'ConsentMaster', 'id', $this->request->data, 'Collection', 'consent_master_id');
		$this->set('consent_data', $consent_data);
		$this->set('consent_found', $consent_found);
	}
	
	//Set default diagnosis 
	if($diagnosis_data) {
		$all_primary_ovary_endometrium_tumors = array();
		$all_other_dxs = array();
		foreach($diagnosis_data as $tmp_new_dx) {
			if($tmp_new_dx['DiagnosisControl']['category'] == 'primary' && $tmp_new_dx['DiagnosisControl']['controls_type'] == 'ovary or endometrium tumor') {
				$all_primary_ovary_endometrium_tumors[$tmp_new_dx['DiagnosisMaster']['dx_date']][$tmp_new_dx['DiagnosisMaster']['id']] = $tmp_new_dx['DiagnosisMaster']['id'];
			} else {
				$all_other_dxs[$tmp_new_dx['DiagnosisMaster']['dx_date']][$tmp_new_dx['DiagnosisMaster']['id']] = $tmp_new_dx['DiagnosisMaster']['id'];
			}
		}
		$tmp_studied_dxs = empty($all_primary_ovary_endometrium_tumors)? (empty($all_other_dxs)? array() : $all_other_dxs) : $all_primary_ovary_endometrium_tumors;
		if($tmp_studied_dxs) {
			krsort($tmp_studied_dxs);
			$selected_dxs = array_shift($tmp_studied_dxs);
			krsort($selected_dxs);
			$this->request->data['Collection']['diagnosis_master_id'] = array_shift($selected_dxs);
			$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, $this->request->data['Collection']['diagnosis_master_id'], 'Collection');
			$this->set('diagnosis_data', $diagnosis_data );
			$this->set('found_dx', $found_dx );
		}
	}
	//Set default treatment
	if($tx_data) {
		$all_txs = array();
		foreach($tx_data as $tmp_new_tx) {
			$all_txs[$tmp_new_tx['TreatmentMaster']['start_date']][$tmp_new_tx['TreatmentMaster']['id']] = $tmp_new_tx['TreatmentMaster']['id'];
		}
		krsort($all_txs);
		$selected_txs = array_shift($all_txs);
		krsort($selected_txs);
		$this->request->data['Collection']['treatment_master_id'] = array_shift($selected_txs);
		$found_tx = $this->setForRadiolist($tx_data, 'TreatmentMaster', 'id', $this->request->data, 'Collection', 'treatment_master_id');
		$this->set('tx_data', $tx_data);
		$this->set('found_tx', $found_tx);
	}
	