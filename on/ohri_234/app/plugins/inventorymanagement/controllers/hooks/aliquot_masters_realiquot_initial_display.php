<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as $key => $new_parent) {
		$this->data[$key]['children'][0]['AliquotMaster']['aliquot_label'] = preg_replace('/([1-9]+)$/','?', $new_parent['parent']['AliquotMaster']['aliquot_label']);
	}
	
?>