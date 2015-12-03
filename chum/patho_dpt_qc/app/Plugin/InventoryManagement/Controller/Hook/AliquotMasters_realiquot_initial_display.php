<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 
	$chum_patho_default_category = array();
	foreach($this->data as $new_data_set){
		$chum_patho_default_category[$new_data_set['parent']['AliquotMaster']['id']] = $new_data_set['parent']['AliquotDetail']['chum_patho_default_category'];
	}
	$this->set('chum_patho_default_category', $chum_patho_default_category);
	
?>
