<?php
	
	// --------------------------------------------------------------------------------
	//Add thickness and number of slices to tissue
	//--------------------------------------------------------------------------
	if($sample_data['SampleMaster']['sample_type'] == 'tissue') {
		$this->Structures->set('aliquotinternaluses,qc_gastro_tissueinternaluses');
	}
	
?>
