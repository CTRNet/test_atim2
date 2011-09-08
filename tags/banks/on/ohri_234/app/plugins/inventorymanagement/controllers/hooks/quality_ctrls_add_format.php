<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Run Id
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as $key => $new_sample) {	
		$default_run_id =  $new_sample['parent']['ViewSample']['sample_code']. ' / ' . date('Y-m-d');
		$this->data[$key]['children']['0']['QualityCtrl']['run_id'] = $default_run_id;
	}
	
?>