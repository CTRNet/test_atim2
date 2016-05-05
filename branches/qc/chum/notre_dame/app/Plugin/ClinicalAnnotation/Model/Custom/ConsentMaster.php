<?php
class ConsentMasterCustom extends ConsentMaster {
	var $useTable = 'consent_masters';
	var $name = "ConsentMaster";

	//added validation
	function validates($options = array()){
		$result = parent::validates($options);
		if(($this->data['ConsentMaster']['consent_status'] == 'obtained') && (empty($this->data['ConsentMaster']['consent_signed_date']))) {
			$result = false;
			$this->validationErrors['consent_status'][] = 'all obtained consents should have a signed date';
		}
		foreach(array('biological_material_use', 'use_of_blood', 'additional_tumor_collection') as $new_field) {
			if(array_key_exists($new_field, $this->data['ConsentDetail']) && array_key_exists($new_field.'_not_applicable', $this->data['ConsentDetail'])) {
				if(strlen($this->data['ConsentDetail'][$new_field] && $this->data['ConsentDetail'][$new_field.'_not_applicable'])) {
					$result = false;
					$this->validationErrors[$new_field.'_not_applicable'][] = 'no value has to be completed for agreement if not applicable';
				}
			}
		}	
		return $result;
	}
}
