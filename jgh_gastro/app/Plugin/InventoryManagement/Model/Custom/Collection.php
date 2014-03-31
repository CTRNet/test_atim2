<?php

class CollectionCustom extends Collection {	
	var $name = "Collection";
	var $useTable = "collections";

	function validates($options = array()){
		$errors = parent::validates($options);
		if(array_key_exists('acquisition_label', $this->data['Collection'])) {
			if(preg_match('/^([0-9]{0,1})([0-9])$/', $this->data['Collection']['acquisition_label'], $matches)) {
				if(!strlen($matches[1])) $this->data['Collection']['acquisition_label'] = '0'.$matches[2];			
			} else {
				$submitted_data_validates = false;
				$this->validationErrors['acquisition_label'] = __('collection id format is wrong', true);
				return false;	
			}
		}
	
		return $errors;
	}
}

?>
