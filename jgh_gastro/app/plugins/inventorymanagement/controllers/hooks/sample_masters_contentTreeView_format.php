<?php
	
	// --------------------------------------------------------------------------------
	//Temporary Fix: Get all sample control types to build the add to selected button
	//--------------------------------------------------------------------------
	if(!$is_ajax){
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => array('ParentToDerivativeSampleControl.parent_sample_control_id IS NULL', 'ParentToDerivativeSampleControl.flag_active' => true), 'fields' => array('DerivativeControl.*')));
		foreach($controls as $control){
			$specimen_sample_controls_list[]['SampleControl'] = $control['DerivativeControl'];	
		}
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);	
	}
	
?>
