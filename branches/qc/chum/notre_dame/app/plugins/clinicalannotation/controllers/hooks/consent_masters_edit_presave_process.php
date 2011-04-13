<?php
	
	if(($this->data['ConsentMaster']['consent_status'] == 'obtained') && (empty($this->data['ConsentMaster']['consent_signed_date']['year']))) {
		$submitted_data_validates = false;
		$this->ConsentMaster->validationErrors['consent_status'][] = 'all obtained consents should have a signed date';
	}
		
?>