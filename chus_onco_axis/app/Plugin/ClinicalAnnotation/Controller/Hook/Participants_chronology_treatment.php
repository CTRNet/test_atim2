<?php 
	
	switch($tx['TreatmentControl']['tx_method']) {
		case 'biopsy':
		case 'surgery':
		case 'radiotherapy':
			$sites = array();
			foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $new_site) {
				if(isset($new_site['TreatmentExtendDetail']['site'])) {
					$site = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Digestive System Treatment Sites', $new_site['TreatmentExtendDetail']['site']);
					$sites[$site] = $site;
				}
			}
			ksort($sites);
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = implode(', ', $sites);
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = implode(', ', $sites);
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
	}
	