<?php 

	$event = __('treatment')." - ".__($tx['TreatmentControl']['tx_method']);
	$chronology_details = '';
	switch($tx['TreatmentControl']['tx_method']) {
		case 'chemotherapy':
		case 'hormonotherapy':
		case 'immunotherapy':
		case 'bone specific therapy':
			$all_linked_drugs = $treatment_extend_model->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id'])));
			$drugs = array();
			foreach($all_linked_drugs as $new_drug) {
				if($new_drug['TreatmentExtendMaster']['drug_id']) {
					$drugs[$new_drug['TreatmentExtendMaster']['drug_id']] = $new_drug['Drug']['generic_name'];
				}
			}
			if($drugs) $chronology_details = implode(' + ', $drugs);
			break;
		case 'other cancer':
			$chronology_details = $other_cancer_tx[$tx['TreatmentDetail']['type']];
			break;
		case 'breast diagnostic event':
			$chronology_details = $beast_dx_intervention[$tx['TreatmentDetail']['type_of_intervention']];
			break;
	}
	
	$chronolgy_data_treatment_start['event'] = $event." (".__("start").")";
	if($chronology_details) $chronolgy_data_treatment_start['chronology_details'] = $chronology_details;
	if($chronolgy_data_treatment_finish) {
		$chronolgy_data_treatment_finish['event'] = $event." (".__("end").")";
		$chronolgy_data_treatment_finish['chronology_details'] = $chronology_details;
	}
