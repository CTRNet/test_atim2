<?php

class AliquotMasterCustom extends AliquotMaster {	
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	function validates($options = array()){
		$val_res = parent::validates($options);
		
		if(isset($this->data['AliquotDetail']['block_type']) 
		&& !in_array(($this->data['AliquotDetail']['block_type'].$this->data['AliquotDetail']['procure_freezing_type']), array('frozen','frozenISO','frozenISO+OCT','paraffin'))) {
			$this->validationErrors['procure_freezing_type'][] = 'only frozen blocks can be associated to a freezing type';
		}

		return $val_res;
	}
}