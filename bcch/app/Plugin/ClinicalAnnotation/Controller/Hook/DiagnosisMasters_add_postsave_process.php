<?php
	
	/* 
	@author Stephen Fung
	@since 2015-12-01
	BB-119
	BB-139
	*/
	//Do I need to load the model here?
	$this->loadModel('DiagnosisControl');
	
	//Get the current oncology form id from the database
	$findOncologyControlId = $this->DiagnosisControl->find('first', array(
		'fields' => array('DiagnosisControl.id'),
		'conditions' => array('DiagnosisControl.category' => 'primary', 'DiagnosisControl.controls_type' => 'oncology'),
		'recursive' => -1
	));
	$oncologyControlId = $findOncologyControlId['DiagnosisControl']['id'];
	
	//The diagnosis control id of the current form entry
	$dxControlId = $this->request->data['DiagnosisMaster']['diagnosis_control_id'];
	
	// Only perform the following if we need ICD-O-3 for Oncology Diagnosis Form
	if($dxControlId == $oncologyControlId) {
		
		$dxPrimaryId = $this->DiagnosisMaster->getLastInsertId();
	
		$dxDate = $this->DiagnosisMaster->find('first', array(
			'fields' => array('DiagnosisMaster.dx_date'),
			'conditions' => array('DiagnosisMaster.id' => $dxPrimaryId),
			'recursive' => 0
		));
		
		//The code below are for inserting the correct ICD-O-3 Code to EventMaster
		
		//fields for event_masters table 
		$eventControlId;
		$eventDate = $dxDate['DiagnosisMaster']['dx_date'];
		$eventDateAccuracy = 'c';
		$modifiedBy;
		$participantId = $this->request->data['DiagnosisMaster']['participant_id'];
		
		// Write entry to Event Master Table
		$query = "INSERT INTO event_masters (event_control_id, event_date, participant_id, diagnosis_master_id, created, modified) VALUES ((SELECT id FROM event_controls WHERE event_type='diagnosis code'),'".$eventDate."',".$participantId.",".$dxPrimaryId.", NOW(), NOW());";
		$this->DiagnosisMaster->tryCatchQuery($query);
		// Do I need to load the model here?
		$this->loadModel('EventMaster');
		$findEventMasterId = $this->EventMaster->find('first', array(
			'fields' => array('EventMaster.id'),
			'order' => array('id' => 'DESC'),
			'recursive' => 0
		));
		
		$eventMasterId = $findEventMasterId['EventMaster']['id'];
		
		//Write to Event Master Log Table
		$query = "INSERT INTO event_masters_revs (id, event_control_id, event_date, participant_id, diagnosis_master_id, version_created) VALUES (".$eventMasterId.", (SELECT id FROM event_controls WHERE event_type='diagnosis code'),'".$eventDate."',".$participantId.",".$dxPrimaryId.", NOW());";
		$this->DiagnosisMaster->tryCatchQuery($query);
		
		//fields for ed_bcch_dx_codes table 
		$codeSource;
		$codeType = 'icd-o-3';
		$codeDescription = $this->request->data['DiagnosisDetail']['final_diagnosis'];
		
		//find code value using code description
		$this->loadModel('CodingIcd.CodingIcdo3Morpho');
		
		$findDiagnosisCode = $this->CodingIcdo3Morpho->find('first', array(
			'conditions' => array('CodingIcdo3Morpho.en_description' => $codeDescription),
			'fields' => array('CodingIcdo3Morpho.id', 'CodingIcdo3Morpho.primary_category', 'CodingIcdo3Morpho.secondary_category', 'CodingIcdo3Morpho.tertiary_category'),
			'recursive' => 0,
		)); 

		$codeValue = $findDiagnosisCode['CodingIcdo3Morpho']['id'];
		
		//Write to Diagnosis Code Table
		$query = "INSERT INTO ed_bcch_dx_codes (code_type, code_value, code_description, event_master_id) VALUES ('".$codeType."', '".$codeValue."', '".$codeDescription."', ".$eventMasterId.");";
		$this->DiagnosisMaster->tryCatchQuery($query);
		
		//Write to Diagnosis Code Table Log
		$query = "INSERT INTO ed_bcch_dx_codes_revs (id, code_type, code_value, code_description, event_master_id, version_created) VALUES ((SELECT id FROM ed_bcch_dx_codes ORDER BY id DESC LIMIT 1), '".$codeType."', '".$codeValue."', '".$codeDescription."', ".$eventMasterId.", NOW());";
		$this->DiagnosisMaster->tryCatchQuery($query);

		/* 
		@author Stephen Fung
		@since 2016--06-15
		BB-193
		Retrieve the categories of the ICD-O-3 value from the database
		Update the relevant diagnosis record using the descriptions
		*/

		$primary_category = $findDiagnosisCode['CodingIcdo3Morpho']['primary_category'];
		$secondary_category = $findDiagnosisCode['CodingIcdo3Morpho']['secondary_category'];
		$tertiary_category = $findDiagnosisCode['CodingIcdo3Morpho']['tertiary_category'];

		$query = "SELECT id FROM dxd_bcch_oncology ORDER BY id DESC LIMIT 1;";
		$findLastOncologyRecordId = $this->DiagnosisMaster->tryCatchQuery($query);
		$lastOncologyRecordId = $findLastOncologyRecordId[0]['dxd_bcch_oncology']['id'];
		pr($lastOncologyRecordId);

		$query = "SELECT version_id FROM dxd_bcch_oncology_revs ORDER BY version_id DESC LIMIT 1;";
		$findLastOncologyLogRecordId = $this->DiagnosisMaster->tryCatchQuery($query);
		$lastOncologyLogRecordId = $findLastOncologyLogRecordId[0]['dxd_bcch_oncology_revs']['version_id'];
		pr($lastOncologyLogRecordId);

		$query = "UPDATE dxd_bcch_oncology, dxd_bcch_oncology_revs SET dxd_bcch_oncology.final_diagnosis_primary_category='".$primary_category."', dxd_bcch_oncology.final_diagnosis_secondary_category='".$secondary_category."' , dxd_bcch_oncology.final_diagnosis_tertiary_category='".$tertiary_category."',  dxd_bcch_oncology_revs.final_diagnosis_primary_category='".$primary_category."', dxd_bcch_oncology_revs.final_diagnosis_secondary_category='".$secondary_category."' , dxd_bcch_oncology_revs.final_diagnosis_tertiary_category='".$tertiary_category."' WHERE dxd_bcch_oncology.id=".$lastOncologyRecordId." AND dxd_bcch_oncology_revs.version_id=".$lastOncologyLogRecordId.";";
		$this->DiagnosisMaster->tryCatchQuery($query);
		
	}
	
	

