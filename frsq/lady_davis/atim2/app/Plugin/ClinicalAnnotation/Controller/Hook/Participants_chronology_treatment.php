<?php

	if(in_array($tx['TreatmentControl']['tx_method'], array('chemotherapy', 'hormonotherapy', 'immunotherapy'))) {
		$chemo_detail = array();
		if($tx['TreatmentMaster']['protocol_master_id']) $chemo_detail[0] = $protocol_from_id[$tx['TreatmentMaster']['protocol_master_id']];
		foreach($treatment_extend_model->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']))) as $drug) $chemo_detail[1][$drug['TreatmentExtendDetail']['drug_id']] = $drug_from_id[$drug['TreatmentExtendDetail']['drug_id']];
		if(isset($chemo_detail[1])) $chemo_detail[1] = implode(' + ', $chemo_detail[1]);
		$chemo_detail = implode(' : ', $chemo_detail);
		$chronolgy_data_treatment_start['chronology_details'] = $chemo_detail;
		if(!empty($tx['TreatmentMaster']['finish_date'])){
			$chronolgy_data_treatment_finish['chronology_details'] = $chronolgy_data_treatment_start['chronology_details'];
		}
	}
	