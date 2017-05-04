<?php 
	
	if($drug_data['Drug']['type'] != $this->request->data['Drug']['type']) {
		$change_error = false;
		$drug_used = $this->Drug->tryCatchQuery("SELECT count(*) as drug_used FROM treatment_masters WHERE deleted <> 1 AND procure_drug_id = $drug_id;");
		if($drug_used[0][0]['drug_used']) {
			$this->Drug->validationErrors['type'][] = 'the type of a used drug can not be changed';
			$submitted_data_validates = false;
		}
	}