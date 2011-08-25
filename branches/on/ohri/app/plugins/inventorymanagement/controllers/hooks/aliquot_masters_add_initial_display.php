<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 
	foreach($this->data as $key => $new_sample) {	
		$inital_data = $this->getDefaultLabel($new_sample['parent']['ViewSample'], $aliquot_control_id);
		if(!empty($inital_data)) $this->data[$key]['children'] = $inital_data;
	}
	
?>