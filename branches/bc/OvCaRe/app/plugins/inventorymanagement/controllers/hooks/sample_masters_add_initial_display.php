<?php
 	
	if($this->data['SampleControl']['sample_type'] == 'tissue') {
		$this->data['SampleDetail']['tissue_size_unit'] = 'cm';
		$this->data['SampleDetail']['tissue_weight_unit'] = 'gr';
	}
	
?>
