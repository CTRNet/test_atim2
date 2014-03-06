<?php 

	// --------------------------------------------------------------------------------
	// Prevent the paste operation on aliquot label 
	// -------------------------------------------------------------------------------- 
	if(sizeof($this->request->data) -1) $options_children['settings']['paste_disabled_fields'] = array('AliquotMaster.aliquot_label', 'AliquotMaster.barcode');	
	
	
?>
