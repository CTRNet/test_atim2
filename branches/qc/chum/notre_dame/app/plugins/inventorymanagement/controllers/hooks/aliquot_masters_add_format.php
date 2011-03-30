<?php
	
	// --------------------------------------------------------------------------------
	// Set custom initial data including default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	if($is_intial_display){
		$custom_initial_data = array();
		foreach($samples as $view_sample){
			$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($view_sample, $aliquot_control);
			$custom_initial_data[] = array('parent' => $view_sample, 'children' => array(array('AliquotMaster'=>array('aliquot_label' => $default_aliquot_label))));
		}
		$this->set('custom_initial_data', $custom_initial_data);	
	}
	
?>
