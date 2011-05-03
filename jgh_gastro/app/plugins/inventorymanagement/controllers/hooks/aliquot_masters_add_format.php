<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// -------------------------------------------------------------------------------- 	
	$default_aliquot_barcodes = array();
	foreach($samples as $view_sample){
		$initial_specimen_sample_id = $view_sample['ViewSample']['initial_specimen_sample_id'];
		$initial_specimen_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $initial_specimen_sample_id), 'recursive' => 0));
		$default_aliquot_barcode = $initial_specimen_sample_data['Collection']['acquisition_label'].
			'-'.
			$initial_specimen_sample_data['SpecimenDetail']['specimen_biobank_id'].
			'-';
		$default_aliquot_barcodes[$view_sample['ViewSample']['sample_master_id']] = $default_aliquot_barcode;
	}
	$this->set('default_aliquot_barcodes', $default_aliquot_barcodes);
	
?>
