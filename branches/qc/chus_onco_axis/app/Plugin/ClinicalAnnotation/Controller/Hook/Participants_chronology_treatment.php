<?php 

	switch($tx['TreatmentControl']['tx_method']) {
		case 'biopsy':
		case 'surgery':
			$tmps_sites = array();
			foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $tmp_new_tx_extend) {
				$tmp_icd_description = $this->CodingIcdo3Topo->getDescription($tmp_new_tx_extend['TreatmentExtendDetail']['surgical_site']);
				if($tmp_icd_description) $tmps_sites[$tmp_icd_description] = $tmp_icd_description;
			}
			ksort($tmps_sites);
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = implode(', ', $tmps_sites);
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = implode(', ', $tmps_sites);
			break;
		case 'radiotherapy':
			$tmps_sites = array();
			foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $tmp_new_tx_extend) {
				$tmp_icd_description = $this->CodingIcdo3Topo->getDescription($tmp_new_tx_extend['TreatmentExtendDetail']['site']);
				if($tmp_icd_description) $tmps_sites[$tmp_icd_description] = $tmp_icd_description;
			}
			ksort($tmps_sites);
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = implode(', ', $tmps_sites);
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = implode(', ', $tmps_sites);
			break;
			break;
		case 'systemic therapy':
			$drugs = array();
			foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $new_drug) {
				if(isset($new_drug['TreatmentExtendDetail']['drug_id']) && isset($all_drugs[$new_drug['TreatmentExtendDetail']['drug_id']])) {
					$drugs[$all_drugs[$new_drug['TreatmentExtendDetail']['drug_id']]] = $all_drugs[$new_drug['TreatmentExtendDetail']['drug_id']];
				}
			}
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = implode(', ', $drugs);
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = implode(', ', $drugs);
			break;
		case 'medication history':
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = $tx['TreatmentDetail']['medication'];
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = $tx['TreatmentDetail']['medication'];
			break;
	}
	