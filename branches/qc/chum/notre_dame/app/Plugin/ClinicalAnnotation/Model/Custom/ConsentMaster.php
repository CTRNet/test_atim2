<?php
class ConsentMasterCustom extends ConsentMaster {
	var $useTable = 'consent_masters';
	var $name = "ConsentMaster";

	//added validation
	function validates($options = array()){
		$result = parent::validates($options);
		if(($this->data['ConsentMaster']['consent_status'] == 'obtained') && (empty($this->data['ConsentMaster']['consent_signed_date']['year']))) {
			$result = false;
			$this->validationErrors['consent_status'][] = 'all obtained consents should have a signed date';
		}
		
		return $result;
	}
}
