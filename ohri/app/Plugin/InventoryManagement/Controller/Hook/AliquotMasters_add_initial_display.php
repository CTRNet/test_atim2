<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 
	foreach($this->request->data as $key => $new_sample) {	
		$inital_data = $this->AliquotMaster->getDefaultLabel($new_sample['parent']['ViewSample'], $aliquot_control_id);
		if(!empty($inital_data)){
			$this->request->data[$key]['children'] = $inital_data;
		}
	}
	
?>