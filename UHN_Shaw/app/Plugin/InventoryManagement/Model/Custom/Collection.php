<?php

class CollectionCustom extends Collection {
	var $name = 'Collection';
	var $useTable = 'collections';
	
	function validates($options = array()) {
		$res = parent::validates($options);
		if(in_array('uhn_misc_identifier_id', $options['fieldList']) && empty($this->data['Collection']['uhn_misc_identifier_id'])) {
			$this->validationErrors['uhn_misc_identifier_id'][] = 'the tgh number is required';
			return false;
		}		
		return $res;
	}
	
	function beforeSave($options = array()){
		if(isset($this->data['Collection']['collection_datetime']) && $this->data['Collection']['collection_datetime']) {
			if(preg_match('/^[0-9]{2}([0-9]{2})\-[0-9]{2}\-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2}?/', $this->data['Collection']['collection_datetime'], $matches)) {
				$this->data['Collection']['uhn_collection_year'] = $matches[1];
				$this->addWritableField(array('uhn_collection_year'));
			}	
		}
		$ret_val = parent::beforeSave($options);
		return $ret_val;
	}
	
}

?>
