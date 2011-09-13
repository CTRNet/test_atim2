<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 
	foreach($this->data as $key => $new_sample) {
		$this->data[$key]['children'][0]['AliquotMaster']['aliquot_label'] = $new_sample['parent']['ViewSample']['acquisition_label'];
	}
		
?>