<?php 
	
	if($drug_data['Drug']['type'] != $this->request->data['Drug']['type']) {
		$change_error = false;
		foreach(array('procure_txd_followup_worksheet_treatments','procure_txd_medication_drugs') as $table_name) {
			$drug_used = $this->Drug->tryCatchQuery("SELECT count(*) as drug_used FROM treatment_masters INNER JOIN $table_name ON id = treatment_master_id WHERE deleted <> 1 AND drug_id = $drug_id;");
			if($drug_used[0][0]['drug_used']) $change_error = true;
		}
		if($change_error) {
			$this->Drug->validationErrors['type'][] = 'the type of a used drug can not be changed';
			$submitted_data_validates = false;
		}
	}