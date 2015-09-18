<?php
	
	/*
	// @author Stephen Fung
	// @since 2015-06-23
	// Generate barcode and specimen label during Re-aliquoting
	// BB-29	
	*/
	
	//Generate and assign barcodes to the re-aliquoted aliquots
	$this->AliquotMaster->generateAliquotBarcode($new_aliquot_ids);
	
	//Get the first aliquot id from the list of aliquot ids
	$first_aliquot_id = $new_aliquot_ids[0];
	
	//Obtain the necessary objects for the generateAliquotLabel()
	$aliquot_master_id = $this->AliquotMaster->find('first', array(
		'conditions' => array('AliquotMaster.id' => $first_aliquot_id), 
		'fields' => array('AliquotMaster.aliquot_control_id', 'AliquotMaster.sample_master_id')
		));
	
	$aliquot_control_id = $aliquot_master_id['AliquotMaster']['aliquot_control_id'];
	$sample_master_id = $aliquot_master_id['AliquotMaster']['sample_master_id'];	
	
	$aliquot_control = $this->AliquotControl->find('first', array(
		'conditions' => array('AliquotControl.id' => $aliquot_control_id), 'recursive' => -1)
		);
	
	$sample_master_data = $this->ViewSample->find('first', array(
		'conditions' => array('ViewSample.sample_master_id' => $sample_master_id), 'recursive' => -1)
		);

	//Generate and assign specimen labels using aliquot ids
	$this->AliquotMaster->generateAliquotLabel($sample_master_data, $aliquot_control, $new_aliquot_ids);
	
	