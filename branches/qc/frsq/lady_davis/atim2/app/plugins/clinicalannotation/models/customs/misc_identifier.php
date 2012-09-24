<?php
class MiscIdentifierCustom extends MiscIdentifier{
	var $name 		= "MiscIdentifier";
	var $useTable 	= "misc_identifiers";
	
	function allowMiscIdentifierDeletion(array $misc_identifier_data){
		$result = null;
		if($misc_identifier_data['MiscIdentifier']['misc_identifier_control_id'] == 9){
			$result = array(
				'allow_deletion'	=> false, 
				'msg' 				=> __('the collection identifier cannot be deleted', true)
			);
		}else{
			$result = array(
				'allow_deletion'	=> true, 
				'msg' 				=> ''
			);
		}
		return $result;
	}
	
	function validates($options = array()){
		$errors = parent::validates($options);
		if(isset($this->validationErrors['identifier_value']) && !is_array($this->validationErrors['identifier_value'])){
			$this->validationErrors['identifier_value'] = array($this->validationErrors['identifier_value']);
		}
		$control_id = null;
		if($this->id){
			$current = $this->findById($this->id);
			$control_id = $current['MiscIdentifier']['misc_identifier_control_id']; 
		}else{
			$control_id = $this->data['MiscIdentifier']['misc_identifier_control_id'];
		}
		if($control_id == 11 && !preg_match("#^(MET|NEO)-[\d]+$#", $this->data['MiscIdentifier']['identifier_value'])){
			$this->validationErrors['identifier_value'][] = sprintf(__('the identifier expected format is %s', true), 'MET-# '.__('or', true).' NEO-#');
			return false;
		}
		return $errors;
	}
}