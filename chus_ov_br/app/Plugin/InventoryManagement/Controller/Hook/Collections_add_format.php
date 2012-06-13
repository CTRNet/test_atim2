<?php

	if(!$need_to_save && !empty($collection_data) && !empty($collection_data['Collection']['misc_identifier_id'])) {
		$MiscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);

		$misc_ident_data = $MiscIdentifierModel->find('first', array('conditions' => array('MiscIdentifier.id' => $collection_data['Collection']['misc_identifier_id'])));
	
		$BankModel = AppModel::getInstance("Administrate", "Bank", true);
		$pattern = ($misc_ident_data['MiscIdentifierControl']['misc_identifier_name'] == '#FRSQ BR')? 'breast':'ovary';
		$bank_data = $BankModel->find('first', array('conditions' => array("Bank.name LIKE '%$pattern%'")));
		
		if(!empty($bank_data)) {
			$this->set('default_bank_id', $bank_data['Bank']['id']);
		}		
	}
