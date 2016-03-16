<?php 
	
	if($chronolgy_data_treatment_start) $chronolgy_data_treatment_start['event'] = __('treatment')." - ".__($tx['TreatmentControl']['tx_method'])." (".__("start").")";
	if($chronolgy_data_treatment_finish) $chronolgy_data_treatment_finish['event'] = __('treatment')." - ".__($tx['TreatmentControl']['tx_method'])." (".__("end").")";
	switch($tx['TreatmentControl']['tx_method']) {
		case 'chemotherapy':
		case 'hormonotherapy':
		case 'immunotherapy':
		case 'bone specific therapy':
			$all_linked_drugs = $treatment_extend_model->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id'])));
			$drugs = array();
			foreach($all_linked_drugs as $new_drug) {
				if(isset($new_drug['TreatmentExtendDetail']['drug_id']) && isset($all_drugs[$new_drug['TreatmentExtendDetail']['drug_id']])) {
					$drugs[$all_drugs[$new_drug['TreatmentExtendDetail']['drug_id']]] = $all_drugs[$new_drug['TreatmentExtendDetail']['drug_id']];
				}
			}
			if($drugs) {
				$chronolgy_data_treatment_start['chronology_details'] = implode(' + ', $drugs);
				$chronolgy_data_treatment_finish['chronology_details'] = implode(' + ', $drugs);
			}
			break;
		case 'other cancer':
			$detail = 
				(isset($ctrnet_submission_disease_site_values[$tx['TreatmentDetail']['cancer_site']])? $ctrnet_submission_disease_site_values[$tx['TreatmentDetail']['cancer_site']] : $tx['TreatmentDetail']['cancer_site']).' :: '.
				(isset($other_cancer_tx[$tx['TreatmentDetail']['type']])? $other_cancer_tx[$tx['TreatmentDetail']['type']] : $tx['TreatmentDetail']['type']);
			$chronolgy_data_treatment_start['chronology_details'] = $detail;
			$chronolgy_data_treatment_finish['chronology_details'] = $detail;
			break;
	}
