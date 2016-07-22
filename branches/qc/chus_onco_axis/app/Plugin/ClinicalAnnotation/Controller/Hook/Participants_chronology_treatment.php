<?php 

	switch($tx['TreatmentControl']['tx_method']) {
		case 'biopsy':
		case 'surgery':
		case 'radiotherapy':
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
	