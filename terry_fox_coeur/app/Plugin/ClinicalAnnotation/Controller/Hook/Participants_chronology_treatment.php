<?php 
	
    $eoc_flag = ($tx['TreatmentControl']['disease_site'] == 'EOC')? ' ['.__('EOC').']' : '';
    
	switch($tx['TreatmentControl']['tx_method']) {
		case 'chemotherapy':
			//Set event
			$event = __($tx['TreatmentControl']['tx_method']);
			$chronolgy_data_treatment_start['event'] = $event.$eoc_flag.' '.$start_suffix_msg;
			if($chronolgy_data_treatment_finish) {
				$chronolgy_data_treatment_finish['event'] = $event.$eoc_flag.' '.$finish_suffix_msg;
			}
			//Set details
			$all_linked_drugs = $this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id'])));
			$drugs = array();
			foreach($all_linked_drugs as $new_drug) {
				if($new_drug['TreatmentExtendMaster']['drug_id']) {
					$drugs[$new_drug['TreatmentExtendMaster']['drug_id']] = $new_drug['Drug']['generic_name'];
				}
			}
			if($drugs) {
				$chronolgy_data_treatment_start['chronology_details'] = implode(' + ', $drugs);
				if($chronolgy_data_treatment_finish) {
					if($drugs) $chronolgy_data_treatment_finish['chronology_details'] = implode(' + ', $drugs);
				}
			}
			break;
		case 'radiotherapy':
		case 'surgery':
			//Set event
			$chronolgy_data_treatment_start['event'] = __($tx['TreatmentControl']['tx_method']).$eoc_flag;
			break;
		case 'ovarectomy':
		case 'hormonal therapy':
			//Set event
			$chronolgy_data_treatment_start['event'] = __($tx['TreatmentControl']['tx_method']);
			break;
	}
	
	