<?php

	$errors = array();
	if($qc_data['SampleControl'] == 'dna') {
		if($this->request->data['QualityCtrl']['type'] != 'picogreen gel') $errors['type'][] = 'quality control type and sample type mismatch';
		if(!empty($this->request->data['QualityCtrl']['unit'])) $errors['unit'][] = 'quality control score unit and sample type mismatch';
	} else {
		if($this->request->data['QualityCtrl']['type'] != 'bioanalyzer') $errors['type'][] = 'quality control type and sample type mismatch';
		if($this->request->data['QualityCtrl']['unit'] != 'rin') $errors['unit'][] = 'quality control score unit and sample type mismatch';
	}
	if($errors) {
		$submitted_data_validates = false;
		$this->QualityCtrl->validationErrors = $errors;
	}
