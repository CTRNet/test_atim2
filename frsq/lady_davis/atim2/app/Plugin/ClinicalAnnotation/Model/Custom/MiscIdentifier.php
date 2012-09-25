<?php
class MiscIdentifierCustom extends MiscIdentifier{
	var $name 		= "MiscIdentifier";
	var $useTable 	= "misc_identifiers";
	
	function validates($options = array()){
		$errors = parent::validates($options);
		if(isset($this->validationErrors['identifier_value']) && !is_array($this->validationErrors['identifier_value'])){
			$this->validationErrors['identifier_value'] = array($this->validationErrors['identifier_value']);
		}
		
		$current = ($this->id)? $this->findById($this->id) : $this->data;
		if($current['MiscIdentifier']['misc_identifier_control_id'] == 11 && !preg_match("#^(MET|NEO)-[\d]+$#", $current['MiscIdentifier']['identifier_value'])){
			$this->validationErrors['identifier_value'][] = sprintf(__('the identifier expected format is %s', true), 'MET-# '.__('or', true).' NEO-#');
			return false;
		}
		
		return $errors;
	}
}