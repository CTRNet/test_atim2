<?php
 	
	if($this->request->data['SampleControl']['sample_type'] == 'tissue') {
		$this->request->data['SampleDetail']['tissue_size_unit'] = 'cm';
		$this->request->data['SampleDetail']['tissue_weight_unit'] = 'gr';
	}
	
?>
