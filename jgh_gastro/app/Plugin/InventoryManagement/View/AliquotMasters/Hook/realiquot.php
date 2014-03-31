<?php 

	// --------------------------------------------------------------------------------
	// Prevent the paste operation on aliquot label 
	// -------------------------------------------------------------------------------- 
	$options_children['settings']['paste_disabled_fields'] = array('AliquotMaster.barcode');	

// unset($created_aliquot_override_data['Realiquoting.realiquoting_datetime']);
// unset($created_aliquot_override_data['AliquotMaster.storage_datetime']);
