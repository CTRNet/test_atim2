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
	
	function beforeSave($options = array()){
		if(array_key_exists('ConsentMaster', $this->data) && array_key_exists('qc_nd_file_name', $this->data['ConsentMaster'])) {
			$this->data['ConsentMaster']['qc_nd_file_name'] = preg_replace('/[\\\]+/', '/', $this->data['ConsentMaster']['qc_nd_file_name']);
		}
		$ret_val = parent::beforeSave($options);
		return $ret_val;
	}
}
