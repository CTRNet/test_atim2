<?php

	 if(!$is_specimen && $parent_sample_data['SampleControl']['sample_type'] == 'cell culture' && $sample_control_data['SampleControl']['sample_type'] == 'cell culture') {
	 	$this->request->data['SampleDetail']['uhn_is_cell_line'] = $parent_sample_data['SampleDetail']['uhn_is_cell_line'];
	 	$this->request->data['SampleDetail']['uhn_gene_insertion'] = $parent_sample_data['SampleDetail']['uhn_gene_insertion'];	
	 	$this->request->data['SampleDetail']['uhn_gene_deletion'] = $parent_sample_data['SampleDetail']['uhn_gene_deletion'];
	 }

?>
