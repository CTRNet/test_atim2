<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Review Code
	// -------------------------------------------------------------------------------- 	
	
	if(empty($this->data)) {
		$specimen_review_data['SpecimenReviewMaster']['review_code'] = $sample_data['SampleMaster']['sample_code']. ' / ' . date('Y-m-d');
	}
	
?>