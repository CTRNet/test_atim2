<?php
 
 	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 	
	 $this->data['SampleMaster']['qc_cusm_sample_label'] = $this->getSampleLabel($collection_id, $this->data['SampleMaster'], (isset($this->data['SampleDetail'])? $this->data['SampleDetail'] : null));
	
?>
