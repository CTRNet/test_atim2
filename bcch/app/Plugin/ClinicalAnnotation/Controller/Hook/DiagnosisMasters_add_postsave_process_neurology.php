<?php

    /* 
	@author Stephen Fung
	@since 2016-09-29
	BB-192
	*/

    $this->loadModel('DiagnosisControl');
		
	//Get the current oncology form id from the database
	$findNeuologyControlId = $this->DiagnosisControl->find('first', array(
		'fields' => array('DiagnosisControl.id'),
		'conditions' => array('DiagnosisControl.category' => 'primary', 'DiagnosisControl.controls_type' => 'neurology'),
		'recursive' => -1
	));

	$neurologyControlId = $findNeuologyControlId['DiagnosisControl']['id'];
    $dxControlId = $this->request->data['DiagnosisMaster']['diagnosis_control_id'];

    if($dxControlId == $neurologyControlId) {

        $neurologyDiagnosisDetails = $this->request->data['DiagnosisDetail'];
        unset($neurologyDiagnosisDetails['diagnosis_department']); //Remove the diagnosis department key value pair from the array

        // Hold the field keys that are required to add ICD-10 Codes
        $fields_array = array();

        // Set all the conditions to "no"

        $query = "UPDATE dxd_bcch_neurology SET `cond_seizure_and_epilepsy` = 'no', `cond_headaches`='no', `cond_infectious_inflammatory_immune_mediated`='no', `cond_neonatal_and_neuromuscular`='no', `cond_developmental_intellect_psychiartic`='no', `cond_others`='no' ORDER BY `id` DESC LIMIT 1;"; 
        $this->DiagnosisMaster->tryCatchQuery($query);

        // Go through each detail symptoms, if yes is found, set condition to "yes"
        foreach($neurologyDiagnosisDetails as $key => $value) {

            if(!empty($value) && $value == 'yes') {

                if(substr($key, 0, 2) == "s_") {
                    $query = "UPDATE dxd_bcch_neurology SET `cond_seizure_and_epilepsy`='yes' ORDER BY `id` DESC LIMIT 1;";
                    $this->DiagnosisMaster->tryCatchQuery($query);
                } else if (substr($key, 0, 2) == "h_") {
                    $query = "UPDATE dxd_bcch_neurology SET `cond_headaches`='yes' ORDER BY `id` DESC LIMIT 1;";
                    $this->DiagnosisMaster->tryCatchQuery($query);
                } else if (substr($key, 0, 2) == "i_") {
                    $query = "UPDATE dxd_bcch_neurology SET `cond_infectious_inflammatory_immune_mediated`='yes' ORDER BY `id` DESC LIMIT 1;";
                    $this->DiagnosisMaster->tryCatchQuery($query);
                } else if (substr($key, 0, 2) == "n_") {
                    $query = "UPDATE dxd_bcch_neurology SET `cond_neonatal_and_neuromuscular`='yes' ORDER BY `id` DESC LIMIT 1;";
                    $this->DiagnosisMaster->tryCatchQuery($query);
                } else if (substr($key, 0, 2) == "d_") {
                    $query = "UPDATE dxd_bcch_neurology SET `cond_developmental_intellect_psychiartic`='yes' ORDER BY `id` DESC LIMIT 1;";
                    $this->DiagnosisMaster->tryCatchQuery($query);
                } else if (substr($key, 0, 2) == "o_") {
                    $query = "UPDATE dxd_bcch_neurology SET `cond_others`='yes' ORDER BY `id` DESC LIMIT 1;";
                    $this->DiagnosisMaster->tryCatchQuery($query);
                }

                array_push($fields_array, $key);
            }

        }
        
        if(!empty($fields_array)) {

            foreach($fields_array as $field) {

                $query = "SELECT `id`, `category`, `en_description` FROM coding_icd_10_neurology WHERE `field_name` = '" . $field . "';";
                $result = $this->DiagnosisMaster->tryCatchQuery($query);

                $icd10_code = $result[0]['coding_icd_10_neurology']['id'];
                $category = $result[0]['coding_icd_10_neurology']['category'];
                $description = $result[0]['coding_icd_10_neurology']['en_description'];
                $code_type = 'icd-10-who';
                $dx_date = $this->request->data['DiagnosisMaster']['dx_date'];

                $event_date = $dx_date['year'] . '-' . $dx_date['month'] . '-' . $dx_date['day'];
 

                // Write entry to Event Master Table
		        $query = "INSERT INTO event_masters (event_control_id, event_date, participant_id, diagnosis_master_id, created, modified) VALUES ((SELECT id FROM event_controls WHERE event_type='diagnosis code'),'".$event_date."',".$participant_id.",".$diagnosis_master_id.", NOW(), NOW());";
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
                $query = "INSERT INTO event_masters_revs (id, event_control_id, event_date, participant_id, diagnosis_master_id, version_created) VALUES (".$eventMasterId.", (SELECT id FROM event_controls WHERE event_type='diagnosis code'),'".$event_date."',".$participant_id.",".$diagnosis_master_id.", NOW());";
                $this->DiagnosisMaster->tryCatchQuery($query);

                //Write to Diagnosis Code Table
                $query = "INSERT INTO ed_bcch_dx_codes (code_type, code_value, code_description, event_master_id) VALUES ('".$code_type."', '".$icd10_code."', '".$description."', ".$eventMasterId.");";
                $this->DiagnosisMaster->tryCatchQuery($query);
                
                //Write to Diagnosis Code Table Log
                $query = "INSERT INTO ed_bcch_dx_codes_revs (`id`, `code_type`, `code_value`, `code_description`, `event_master_id`, `version_created`) SELECT `id`, `code_type`, `code_value`, `code_description`, `event_master_id`, NOW() FROM ed_bcch_dx_codes ORDER BY `id` DESC LIMIT 1;";
                $this->DiagnosisMaster->tryCatchQuery($query);
                
            }

        }


    }