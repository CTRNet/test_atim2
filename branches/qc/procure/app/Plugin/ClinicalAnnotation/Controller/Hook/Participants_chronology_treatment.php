<?php 
	
	switch($tx['TreatmentControl']['tx_method']) {
		case 'procure follow-up worksheet - treatment':
			$treatment_type = $tx['TreatmentDetail']['treatment_type']? $procure_followup_treatment_types_values[$tx['TreatmentDetail']['treatment_type']] : '?';			
			$treatment_details = array();
			$treatment_details[] = $tx['TreatmentDetail']['treatment_precision']? $procure_treatment_precision_values[$tx['TreatmentDetail']['treatment_precision']] : '';
			$treatment_details[] = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Radiotherapy Sites', $tx['TreatmentDetail']['treatment_site']);
			if($tx['TreatmentDetail']['drug_id']) $treatment_details[] = $all_drugs[$tx['TreatmentDetail']['drug_id']];
			$treatment_details = array_filter($treatment_details);
			$treatment_details = implode(' - ', $treatment_details);
			$chronolgy_data_treatment_start['event'] = "$treatment_type (".__("start").")";
			$chronolgy_data_treatment_start['chronology_details'] = $treatment_details;
			if(!empty($tx['TreatmentMaster']['finish_date'])){	
				$chronolgy_data_treatment_finish['event'] = "$treatment_type (".__("end").")";
				$chronolgy_data_treatment_finish['chronology_details'] = $treatment_details;
			}
			break;
		case 'procure medication worksheet - drug':
			$drug_name = '';
			if($tx['TreatmentDetail']['drug_id']) $drug_name = $all_drugs[$tx['TreatmentDetail']['drug_id']];
			$chronolgy_data_treatment_start['event'] = __("drug")." (".__("start").")";
			$chronolgy_data_treatment_start['chronology_details'] = $drug_name;
			if(!empty($tx['TreatmentMaster']['finish_date'])){
				$chronolgy_data_treatment_finish['event'] =  __("drug")." (".__("end").")";
				$chronolgy_data_treatment_finish['chronology_details'] = $drug_name;
			}
			break;
		case 'procure follow-up worksheet - other tumor tx':
			$treatment_details = array();
			$treatment_details[] = $tx['TreatmentDetail']['tumor_site']? $procure_other_tumor_sites_values[$tx['TreatmentDetail']['tumor_site']] : '?';
			$treatment_details[] = $tx['TreatmentDetail']['treatment_type']? $procure_followup_treatment_types_values[$tx['TreatmentDetail']['treatment_type']] : '?';
			$treatment_details = array_filter($treatment_details);
			$treatment_details = implode(' - ', $treatment_details);
			$chronolgy_data_treatment_start['event'] = __('other tumor - treatment')." (".__("start").")";
			$chronolgy_data_treatment_start['chronology_details'] = $treatment_details;
			if(!empty($tx['TreatmentMaster']['finish_date'])){
				$chronolgy_data_treatment_finish['event'] =  __('other tumor - treatment')." (".__("end").")";
				$chronolgy_data_treatment_finish['chronology_details'] = $treatment_details;
			}
			break;
		default:
			$chronolgy_data_treatment_start['event'] = __($tx['TreatmentControl']['tx_method']);
			$chronolgy_data_treatment_start['chronology_details'] = $tx['TreatmentMaster']['procure_form_identification'];
			break;
	}
