<?php

	if(!$need_to_save && !empty($ccl_data) && !empty($ccl_data['ClinicalCollectionLink']['misc_identifier_id'])) {
		$MiscIdentifierModel = AppModel::getInstance("Clinicalannotation", "MiscIdentifier", true);
		$misc_ident_data = $MiscIdentifierModel->find('first', array('conditions' => array('MiscIdentifier.id' => $ccl_data['ClinicalCollectionLink']['misc_identifier_id'])));
		
		$BankModel = AppModel::getInstance("Administrate", "Bank", true);
		$pattern = ($misc_ident_data['MiscIdentifierControl']['misc_identifier_name'] == '#FRSQ BR')? 'breast':'ovary';
		$bank_data = $BankModel->find('first', array('conditions' => array("Bank.name LIKE '%$pattern%'")));
		
		if(!empty($bank_data)) {
			$this->set('default_bank_id', $bank_data['Bank']['id']);
		}		
	}
