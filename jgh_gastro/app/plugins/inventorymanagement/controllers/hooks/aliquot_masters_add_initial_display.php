<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as &$new_parent_and_children_set){
		$initial_specimen_sample_id = $new_parent_and_children_set['parent']['ViewSample']['initial_specimen_sample_id'];
		$initial_specimen_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $initial_specimen_sample_id), 'recursive' => 0));
	
		$default_aliquot_barcode = $initial_specimen_sample_data['Collection']['acquisition_label'].
			'-'.
			$initial_specimen_sample_data['SpecimenDetail']['specimen_biobank_id'].
			'-';
		$new_parent_and_children_set['children'][0] = array('AliquotMaster'=>array('barcode'=>$default_aliquot_barcode));
	}
	
?>
