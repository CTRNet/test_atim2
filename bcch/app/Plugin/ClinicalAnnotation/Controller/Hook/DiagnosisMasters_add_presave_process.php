<?php	
    
    /* 
	@author Stephen Fung
	@since 2015-01-20
	BB-119
	BB-139
	*/
    
    // This hook is for checking if the final diagnosis entered by the the user is from the ICD-O-3 data dictionary before saving the form
    
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
    
    if($dxControlId == $oncologyControlId) {
     
        $final_diagnosis = $this->request->data['DiagnosisDetail']['final_diagnosis'];
        
        //Check final diagnosis entered against the database data dictionary    
		// BB-223
		#new
		$query = "SELECT en_description FROM coding_icd_o_3_morphology WHERE en_description = :final_diagnosis";
		$db = $this->DiagnosisMaster->getDataSource();
		$findCodeDescription = $db->fetchAll(
			$query,
			array('final_diagnosis' => $final_diagnosis)
		);
		//pr($findCodeDescription);

		/*
		#original
        $query = "SELECT en_description FROM coding_icd_o_3_morphology WHERE en_description='".$final_diagnosis."';";
        $findCodeDescription = $this->DiagnosisMaster->tryCatchQuery($query);
		*/

		
        //If the final diagnosis is incorrect, display error message and reset the data entry form
        if(empty($findCodeDescription)) {
            $this->atimFlash(__('You must enter a correct final diagnosis'), '/ClinicalAnnotation/DiagnosisMasters/add/'.$participant_id.'/'.$dx_control_id.'/'.$parent_id.'/');
        }
    }
        