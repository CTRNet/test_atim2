<?php
	
	if(!strlen($this->request->data['Collection']['qcroc_biopsy_type'].$this->request->data['Collection']['qcroc_banking_nbr'])) {
		$this->AliquotMaster->validationErrors['qcroc_biopsy_type'][] = 'either banking # or biopsy type fields has to be entered';
		$submitted_data_validates = false;
	} else if(strlen($this->request->data['Collection']['qcroc_biopsy_type'].$this->request->data['Collection']['qcroc_radiologist'].$this->request->data['Collection']['qcroc_coordinator']) && strlen($this->request->data['Collection']['qcroc_banking_nbr'])) {
		$this->AliquotMaster->validationErrors['qcroc_biopsy_type'][] = 'you can not enter both blood collection fields and biopsy fields for the same collection';
		$submitted_data_validates = false;
	}
