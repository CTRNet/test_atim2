<?php

class AliquotMasterCustom extends AliquotMaster {	
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	function validates($options = array()){
		$val_res = parent::validates($options);
		
		if(array_key_exists('block_type', $this->data['AliquotDetail']) 
		&& !in_array(($this->data['AliquotDetail']['block_type'].$this->data['AliquotDetail']['procure_freezing_type']), array('frozen','frozenISO','frozenISO+OCT','paraffin'))) {
			$this->validationErrors['procure_freezing_type'][] = 'only frozen blocks can be associated to a freezing type';
			$val_res = false;
		}
		if(array_key_exists('procure_card_completed_datetime', $this->data['AliquotDetail']) && strlen($this->data['AliquotMaster']['storage_datetime'])) {
			$this->validationErrors['storage_datetime'][] = 'no storage datetime has to be completed for whatman paper';
			$val_res = false;
		}	
		
		return $val_res;
	}
}