<?php 
		
    pr($participant_id);
    pr($diagnosis_master_id);
    pr($dx_master_data);
    pr($this->request->data);

    $controls_category = $dx_master_data['DiagnosisControl']['category'];
    $controls_type = $dx_master_data['DiagnosisControl']['controls_type'];

    // Date that is updated
    $diagnosis_details = $this->request->data['DiagnosisDetail'];

    if($controls_type == 'neurology') {
        
        unset($diagnosis_details['id']);
        unset($diagnosis_details['diagnosis_department']);
        unset($diagnosis_details['diagnosis_master_id']);

        // Set all Symptom Conditions to "NO"
        $query = "UPDATE dxd_bcch_neurology SET `cond_seizure_and_epilepsy` = 'no', `cond_headaches`='no', `cond_infectious_inflammatory_immune_mediated`='no', `cond_neonatal_and_neuromuscular`='no', `cond_developmental_intellect_psychiartic`='no', `cond_others`='no' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
        $this->DiagnosisMaster->tryCatchQuery($query);

        // Remove all coding linkages
        $query = "UPDATE event_masters SET `deleted` = 1 WHERE `diagnosis_master_id`=" . $diagnosis_master_id . " AND `participant_id`=" . $participant_id .";";
        $this->DiagnosisMaster->tryCatchQuery($query);

        // $field_array store the field keys that are required to add ICD-10 Codes
        $fields_array = array();

        foreach($diagnosis_details as $key => $value) {

            if(substr($key, 0, 2) == "s_" && $value == "yes") {

                // If a value is yes, then update the field to yes
                $query = "UPDATE dxd_bcch_neurology SET `cond_seizure_and_epilepsy`='yes' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
                $this->DiagnosisMaster->tryCatchQuery($query);

                array_push($fields_array, $key);

            } else if (substr($key, 0, 2) == "h_" && $value == "yes") {

                $query = "UPDATE dxd_bcch_neurology SET `cond_headaches`='yes' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
                $this->DiagnosisMaster->tryCatchQuery($query);

                array_push($fields_array, $key);

            } else if (substr($key, 0, 2) == "i_" && $value == "yes") {

                $query = "UPDATE dxd_bcch_neurology SET `cond_infectious_inflammatory_immune_mediated`='yes' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
                $this->DiagnosisMaster->tryCatchQuery($query);

                array_push($fields_array, $key);
                
            } else if (substr($key, 0, 2) == "n_" && $value == "yes") {

                $query = "UPDATE dxd_bcch_neurology SET `cond_neonatal_and_neuromuscular`='yes' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
                $this->DiagnosisMaster->tryCatchQuery($query);

                array_push($fields_array, $key);
                
            } else if (substr($key, 0, 2) == "d_" && $value == "yes") {

                $query = "UPDATE dxd_bcch_neurology SET `cond_developmental_intellect_psychiartic`='yes' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
                $this->DiagnosisMaster->tryCatchQuery($query);

                array_push($fields_array, $key);
                
            } else if (substr($key, 0, 2) == "o_" && $value == "yes") {

                $query = "UPDATE dxd_bcch_neurology SET `cond_others`='yes' WHERE `diagnosis_master_id`=" . $diagnosis_master_id .  ";"; 
                $this->DiagnosisMaster->tryCatchQuery($query);

                array_push($fields_array, $key);
                
            }

            
        }

        pr($fields_array);


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

                $this->loadModel('EventMaster');
                $findEventMasterId = $this->EventMaster->find('first', array(
                    'fields' => array('EventMaster.id'),
                    'order' => array('id' => 'DESC'),
                    'recursive' => 0
                ));
                
                $eventMasterId = $findEventMasterId['EventMaster']['id'];
                pr($eventMasterId);
                
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

        //exit();
    }

