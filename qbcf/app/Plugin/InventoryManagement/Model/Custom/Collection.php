<?php

class CollectionCustom extends Collection {
	
	var $useTable = 'collections';
	var $name = 'Collection';
	
	function validates($options = array()) {
		$validate_res = parent::validates($options);
		
		if(array_key_exists('collection_property', $this->data['Collection'])) {
			if($this->data['Collection']['collection_property'] == 'independent collection') {
				if((array_key_exists('collection_datetime', $this->data['Collection']) && $this->data['Collection']['collection_datetime'])) {
					$this->validationErrors[][] = __('independent collection').' : '.__('no field has to be completed');
					$validate_res = false;
				}
			}
		}
		return $validate_res;
	}
	
}

?>
