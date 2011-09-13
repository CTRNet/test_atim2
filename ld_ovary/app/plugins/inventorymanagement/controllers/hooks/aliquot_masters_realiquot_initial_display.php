<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as $key => $new_parent) {
		$this->data[$key]['children'][0]['AliquotMaster']['aliquot_label'] = $new_parent['parent']['AliquotMaster']['aliquot_label'];
	}
	
?>