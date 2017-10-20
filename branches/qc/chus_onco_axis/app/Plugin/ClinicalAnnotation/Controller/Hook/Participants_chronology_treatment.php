<?php 

    $chronolgy_data_annotation['event'] = __($tx['TreatmentControl']['tx_method']);
	switch($tx['TreatmentControl']['tx_method']) {
		case 'biopsy':
		case 'surgery':
		case 'radiotherapy':
			$tmps_sites = array();
			foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $tmp_new_tx_extend) {
				$tmp_icd_description = $this->CodingIcdo3Topo->getDescription($tmp_new_tx_extend['TreatmentExtendDetail'][(($tx['TreatmentControl']['tx_method'] == 'radiotherapy')? 'site' : 'surgical_site')]);
				if($tmp_icd_description) $tmps_sites[$tmp_icd_description] = $tmp_icd_description;
			}
			ksort($tmps_sites);
			$tmps_sites = implode(' & ', $tmps_sites);
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = $tmps_sites;
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = $tmps_sites;
			break;
		case 'systemic therapy':
			$drugs = array();
			foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $new_drug) {
			    if(strlen($new_drug['Drug']['generic_name'])) {
			        $drugs[$new_drug['Drug']['generic_name']] = $new_drug['Drug']['generic_name'];
			    }
			}
			ksort($drugs);
			$drugs = implode(', ', $drugs);
			if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['chronology_details'] = $drugs;
			if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['chronology_details'] = $drugs;
			break;
	}
	