<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Barcode
	// -------------------------------------------------------------------------------- 	

	foreach($this->data as $samp_key => $samp_data) {
		foreach($samp_data['children'] as $al_key => $al_data) {
			$this->data[$samp_key]['children'][$al_key]['AliquotMaster']['barcode'] = 'tmp';
		}
	}

?>