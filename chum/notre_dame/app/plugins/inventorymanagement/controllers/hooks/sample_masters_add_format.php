<?php
	
	// --------------------------------------------------------------------------------
	// Generate default sequence number based on collection visit label
	// -------------------------------------------------------------------------------- 	
	if(empty($this->data) && (strcmp($sample_control_data['SampleControl']['sample_category'], 'specimen')==0)) {
		$tmp_collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
		if(empty($tmp_collection_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
			
		$visit_label = $tmp_collection_data['Collection']['visit_label'];
						
		if(preg_match('/^V[0]([0-9]*)$/', $visit_label, $res)){
			$this->set('default_sequence_number', $res[1]);				
		}
	}
	
?>
