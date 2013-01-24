<?php
class ReportsControllerCustom extends ReportsController {
	
	function terryFox(array $parameters){
		global $tfri_report_allowed_values;
		global $tfri_report_warnings;
		
		$tfri_report_warnings = array();
		$tfri_report_allowed_values = array();
		//Sheet 1
		$tfri_report_allowed_values['vital_status'] = array('alive', 'dead', 'unknown', 'deceased');
		$tfri_report_allowed_values['fam_history'] = array('breast cancer', 'colon and breast cancer', 'colon and endometrial cancer', 'colon cancer', 'endometrial cancer', 'no', 'ovarian and breast cancer', 'ovarian and colon cancer', 'ovarian and endometrial cancer', 'ovarian cancer', 'precursor of benign ovarian lesions', 'unknown', 'ovarian, endometrial and colon cancer');
		$tfri_report_allowed_values['brca_status'] = array('BRCA mutation known but not identified', 'BRCA1 mutated', 'BRCA1/2 mutated', 'BRCA2 mutated', 'unknown', 'wild type');
		//Sheet 2
		$tfri_report_allowed_values['laterality'] = array('bilateral', 'left', 'right', 'unknown', 'not applicable');
		$tfri_report_allowed_values['histopathology'] = array('high grade serous', 'low grade serous', 'mucinous', 'clear cells', 'endometrioid', 'mixed', 'undifferentiated');
		$tfri_report_allowed_values['grade'] = array('0', '1', '2', '3');
		$tfri_report_allowed_values['residual_disease'] = array('1-2cm' => '1-2cm', '< 1cm' => '<1cm', '> 2cm' => '>2cm', 'none visible' => 'none', 'undefined'	=> 'unknown');
		$tfri_report_allowed_values['progression'] = array('no', 'yes', 'progressive disease', 'bouncer', 'unknown');
		$tfri_report_allowed_values['stage'] = array('Ia', 'Ib', 'Ic', 'IIa', 'IIb', 'IIc', 'IIIa', 'IIIb', 'IIIc', 'IV', 'unknown', 'III');
			
		
		
		
		
		
			$tfri_report_allowed_values['benign_lesions'] = array('benign or borderline tumours', 'endometriosis', 'endosalpingiosis', 'no', 'ovarian cysts', 'unknown');
			$tfri_report_allowed_values['fallopian_tube_lesions'] = array('benign tumors', 'malignant tumors', 'no', 'salpingitis', 'unknown', 'yes');
			$tfri_report_allowed_values['tumor_site'] = array('Breast-Breast', 'Central Nervous System-Brain', 'Central Nervous System-Other Central Nervous System', 'Central Nervous System-Spinal Cord', 'Digestive-Anal', 'Digestive-Appendix', 'Digestive-Bile Ducts', 'Digestive-Colonic', 'Digestive-Esophageal', 'Digestive-Gallbladder', 'Digestive-Liver', 'Digestive-Other Digestive', 'Digestive-Pancreas', 'Digestive-Rectal', 'Digestive-Small Intestine', 'Digestive-Stomach', 'Female Genital-Cervical', 'Female Genital-Endometrium', 'Female Genital-Fallopian Tube', 'Female Genital-Gestational Trophoblastic Neoplasia', 'Female Genital-Other Female Genital', 'Female Genital-Ovary', 'Female Genital-Peritoneal Pelvis Abdomen', 'Female Genital-Uterine', 'Female Genital-Vagina', 'Female Genital-Vulva', "Haematological-Hodgkin's Disease", 'Haematological-Leukemia', 'Haematological-Lymphoma', "Haematological-Non-Hodgkin's Lymphomas", 'Haematological-Other Haematological', 'Head & Neck-Larynx', 'Head & Neck-Lip and Oral Cavity', 'Head & Neck-Nasal Cavity and Sinuses', 'Head & Neck-Other Head & Neck', 'Head & Neck-Pharynx', 'Head & Neck-Salivary Glands', 'Head & Neck-Thyroid', 'Musculoskeletal Sites-Bone', 'Musculoskeletal Sites-Other Bone', 'Musculoskeletal Sites-Soft Tissue Sarcoma', 'Ophthalmic-Eye', 'Ophthalmic-Other Eye', 'Other-Gross Metastatic Disease', 'Other-Primary Unknown', 'Skin-Melanoma', 'Skin-Non Melanomas', 'Skin-Other Skin', 'Thoracic-Lung', 'Thoracic-Mesothelioma', 'Thoracic-Other Thoracic', 'Urinary Tract-Bladder', 'Urinary Tract-Kidney', 'Urinary Tract-Other Urinary Tract', 'Urinary Tract-Renal Pelvis and Ureter', 'Urinary Tract-Urethra', 'not applicable', 'unknown', 'ascite');
			$tfri_report_allowed_values['drugs'] = array('cisplatinum ', 'carboplatinum ', 'oxaliplatinum ', 'paclitaxel ', 'topotecan ', 'ectoposide ', 'tamoxifen ', 'doxetaxel ', 'doxorubicin ', 'other ', 'etoposide ', 'gemcitabine ', 'procytox ', 'vinorelbine ', 'cyclophosphamide');
			$tfri_report_allowed_values['ct_scan'] = array('negative', 'positive', 'unknown');
			$tfri_report_allowed_values['collected_tissue_type'] = array('ovary', 'peritoneum', 'omentum', 'normal fallopian tub', 'normal endometrium');
			$tfri_report_allowed_values['tissue_laterality'] = array('left', 'right', 'unknown', 'not applicable');
			$tfri_report_allowed_values['fft_volume_unit'] = array('tube', 'ml', 'mm3', 'gr');
	
			
		$bank_nbrs = array();
		$participant_ids = array();
		$url_of_previous_form = '';
		
		if(array_key_exists('participant_identifier_with_file_upload', $parameters['Participant']) && !empty($parameters['Participant']['participant_identifier_with_file_upload']['tmp_name'])) {
			// set $DATA array based on contents of uploaded FILE
			$handle = fopen($parameters['Participant']['participant_identifier_with_file_upload']['tmp_name'], "r");
			while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
				$bank_nbrs[] = $csv_data[0];
			}
			fclose($handle);
			unset($parameters['Participant']['participant_identifier_with_file_upload']);
		} else if(!empty($parameters['Participant']['participant_identifier'])) {
			$bank_nbrs = $parameters['Participant']['participant_identifier'];
			if(isset($parameters['BatchSet']['id'])) $url_of_previous_form = '/Datamart/BatchSets/listall/'.$parameters['BatchSet']['id'];
		} else if($parameters['Participant']['id']) {
			$participant_ids = $parameters['Participant']['id'];
		}

		// Get participant
		
		$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$conditions = array();
		if($participant_ids) $conditions['Participant.id'] = $participant_ids;
		if($bank_nbrs) $conditions['Participant.participant_identifier'] = $bank_nbrs;
		$participant_data = $this->Participant->find('all', array('conditions' => $conditions, 'order' => array('Participant.id ASC')));
		
		if(empty($participant_data)) {
			return array('header' => null, 'data' => null, 'columns_names' => null, 'error_msg' => 'terry_fox_report_no_participant');
		}
		
		// terry_fox_export_description
		
		$pid_bid_assoc = array();
		$participant_ids = array();
				
	if(true) {	
		header ( "Content-Type: application/force-download" ); 
		header ( "Content-Type: application/octet-stream" ); 
		header ( "Content-Type: application/download" ); 
		header ( "Content-Type: text/csv" ); 
		header( "Content-disposition:attachment;filename=terry_fox_".date('YMd_Hi').'.csv');
	}
		// ** SHEET 1 - Patients **
		
		{
			$sheet = "SHEET 1 - Patients";
			echo $sheet."\n";
				
			$title_row = array(
				"Bank",
				"Patient Biobank Number (required & unique)",
				"Date of Birth Date",
				"Date of Birth date accuracy",
				"Death Death",
				"Registered Date of Death Date",
				"Registered Date of Death date accuracy",
				"Suspected Date of Death Date",
				"Suspected Date of Death date accuracy",
				"Date of Last Contact Date",
				"Date of Last Contact date accuracy",
				"family history",
				"BRCA status",
				"notes"
			);
			
			echo implode(csv_separator, $title_row),"\n";
			
			foreach($participant_data as $unit){			
				$participant_id = $unit['Participant']['id'];
				$pid_bid_assoc[$participant_id] = $unit['Participant']['participant_identifier'];
				$participant_ids[] = $participant_id;
					
				// last_contact_date
				
				$last_contact_data = $this->Report->query("SELECT last_contact_date, last_contact_date_accuracy FROM 
					(
						SELECT consent_signed_date AS last_contact_date, consent_signed_date_accuracy AS last_contact_date_accuracy 
						FROM consent_masters WHERE participant_id=".$participant_id." AND deleted != 1
					UNION
						SELECT start_date AS last_contact_date, start_date_accuracy AS last_contact_date_accuracy 
						FROM treatment_masters WHERE participant_id=".$participant_id." AND deleted != 1
					UNION
						SELECT dx_date AS last_contact_date, dx_date_accuracy AS last_contact_date_accuracy 
						FROM diagnosis_masters WHERE participant_id=".$participant_id." AND deleted != 1
					UNION
						SELECT event_date AS last_contact_date, event_date_accuracy AS last_contact_date_accuracy  
						FROM event_masters WHERE participant_id=".$participant_id." AND deleted != 1
					) AS tmp ORDER BY last_contact_date DESC LIMIT 0, 1;", false);
				$last_contact_date = '';
				$last_contact_date_accuracy = '';
				if(!empty($last_contact_data)) {
					$last_contact_date  = $last_contact_data[0]['tmp']['last_contact_date'];
					$last_contact_date_accuracy  = empty($last_contact_data[0]['tmp']['last_contact_date_accuracy'])? 'c' : $last_contact_data[0]['tmp']['last_contact_date_accuracy'];
				}
				
				// family_history
				
				$fam_history_data = $this->Report->query("SELECT ohri_disease_site FROM family_histories AS FamilyHistory WHERE deleted != 1 AND participant_id=".$participant_id, false);			
				$fam_history_data_count = array_fill_keys(array('other', 'breast', 'ovary'), 0);		
				foreach($fam_history_data as $ohri_disease_site){
					$fam_history_data_count[$ohri_disease_site['FamilyHistory']['ohri_disease_site']] ++;
				}
				$family_history = null;
				if($fam_history_data_count['ovary'] > 0 && $fam_history_data_count['breast'] > 0){
					$family_history = 'ovarian and breast cancer';
				}else if($fam_history_data_count['ovary'] > 0){
					$family_history = 'ovarian cancer';
				}else if($fam_history_data_count['breast'] > 0){
					$family_history = 'breast cancer';
				}else if($fam_history_data_count['other'] > 0){
					$family_history = 'unknown';
				}else{
					$family_history = "";
				}
					
				$brca_data = $this->Report->query("SELECT brca FROM ohri_ed_lab_markers AS EventDetail
						INNER JOIN event_masters ON EventDetail.event_master_id=event_masters.id
						WHERE event_masters.participant_id=".$participant_id." AND event_masters.deleted != 1
						ORDER BY event_masters.event_date DESC");
				$brca_value = isset($brca_data[0]['EventDetail']['brca']) ? $brca_data[0]['EventDetail']['brca'] : "";
				
				$this->validateTfriReportValue($unit['Participant']['vital_status'], 'vital_status', "Death Death", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($family_history, 'fam_history', "family history", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($brca_value, 'brca_status', "BRCA status", $sheet, $pid_bid_assoc[$participant_id]);						
				
				$line = array();
				$line[] = "OHRI-COEUR";
				$line[] = $unit['Participant']['participant_identifier'];
				$line[] = $unit['Participant']['date_of_birth'];
				$line[] = (!empty($unit['Participant']['date_of_birth'])? $unit['Participant']['date_of_birth_accuracy']: '');
				$line[] = $unit['Participant']['vital_status'];
				$line[] = $unit['Participant']['date_of_death'];
				$line[] = (!empty($unit['Participant']['date_of_death'])? $unit['Participant']['date_of_death_accuracy']: '');
				$line[] = "";//suspected dod
				$line[] = "";//Suspected Date of Death date accuracy
				$line[] = "$last_contact_date";
				$line[] = "$last_contact_date_accuracy";//last contact date acc
				$line[] = $family_history;
				$line[] = $brca_value;
				$line[] = "";//notes
				
				echo implode(csv_separator, $line), "\n";
			}

			$this->displayTfriReportWarning($sheet);
			echo "\n";
		}	
		
		// ** SHEET 2 - EOC - Diagnosis **


		/*
		
		$submitted_participant_ids = array_filter($parameters['Participant']['id']);
		$participant_ids = array_keys($pid_bid_assoc);


		//Get statistics on dx_origin to allow following data extraction
		$paticipants_multi_primary = array();
		$tmp_data = $this->Report->query("SELECT res.participant_id FROM ( 
				SELECT count( * ) AS nbr, participant_id FROM `diagnosis_masters` 
				WHERE deleted !=1 AND dx_origin IN ('primary','unknown') AND participant_id IN(".implode(", ", $participant_ids).") GROUP BY participant_id
			) AS res WHERE res.nbr > 1", false);
		foreach($tmp_data as $res) $paticipants_multi_primary[] = $res['res']['participant_id'];
		$paticipants_multi_primary[] = 0;
		
		$paticipants_only_eoc_primary = array();
		$tmp_data = $this->Report->query("SELECT DISTINCT participant_id FROM diagnosis_masters 
		WHERE participant_id NOT IN (
			SELECT participant_id FROM diagnosis_masters WHERE dx_origin = 'unknown' OR (dx_origin = 'primary' AND ohri_tumor_site != 'Female Genital-Ovary') AND deleted != 1
		) AND participant_id IN(".implode(", ", $participant_ids).") AND deleted != 1", false);
		foreach($tmp_data as $res) $paticipants_only_eoc_primary[] = $res['diagnosis_masters']['participant_id'];		
		$paticipants_only_eoc_primary[] = 0;
		
		$paticipants_only_other_primary = array();
		$tmp_data = $this->Report->query("SELECT DISTINCT participant_id FROM diagnosis_masters 
			WHERE participant_id NOT IN (
				SELECT participant_id FROM diagnosis_masters WHERE dx_origin = 'unknown' OR (dx_origin = 'primary' AND ohri_tumor_site = 'Female Genital-Ovary') AND deleted != 1
			) AND participant_id IN(".implode(", ", $participant_ids).") AND deleted != 1", false);
		foreach($tmp_data as $res) $paticipants_only_other_primary[] = $res['diagnosis_masters']['participant_id'];		
		$paticipants_only_other_primary[] = 0;
		
		$paticipants_unknown_eoc_other_primary = array();
		$tmp_data = $this->Report->query("SELECT DISTINCT participant_id FROM diagnosis_masters 
			WHERE participant_id NOT IN (".implode(", ", $paticipants_only_eoc_primary).") AND participant_id NOT IN (".implode(", ", $paticipants_only_other_primary).") 
			AND participant_id IN(".implode(", ", $participant_ids).") AND deleted != 1", false);
		foreach($tmp_data as $res) $paticipants_unknown_eoc_other_primary[] = $res['diagnosis_masters']['participant_id'];
		$paticipants_unknown_eoc_other_primary[] = 0;
		
		$eoc_diagnosis_master_ids = array('primary'=>array('0'), 'secondary' => array('0'));
		$other_diagnosis_master_ids = array('primary'=>array('0'), 'secondary' => array('0'));
		
		if(!empty($paticipants_unknown_eoc_other_primary)) {
			$participants = $this->Report->query("SELECT participant_identifier FROM participants WHERE deleted != 1 AND id IN (".implode(", ", $paticipants_unknown_eoc_other_primary).")", false);
			$echo_string = '';
			foreach($participants as $tmp) {
				$echo_string .= ' ['.$tmp['participants']['participant_identifier'].']';
			}
			echo "\n", implode(csv_separator, array("CANNOT FETCH ALL EOC/OTHER EVENT CORRECTLY (PROBABLY) - CHECK MORE IN DEEP PARTICIPANTS HAVING FOLLOWING SYSTEM CODES : $echo_string")), "\n";
		}
		
		*/
		
		//sheet 2 - EOC dx
		{
			$sheet = 'SHEET 2 - EOC - Diagnosis';
			echo "\n\n$sheet\n";
			
			$title_row = array(
				"Patient Biobank Number (required)",
				"Date of EOC Diagnosis Date",
				"Date of EOC Diagnosis Accuracy",
				"Presence of precursor of benign lesions",
				"fallopian tube lesions",
				"Age at Time of Diagnosis (yr)",
				"Laterality",
				"Histopathology",
				"Grade",
				"FIGO ",
				"Residual Disease",
				"Progression status",
				"Date of Progression/Recurrence Date",
				"Date of Progression/Recurrence Accuracy",
				"Site 1 of Primary Tumor Progression (metastasis)  If Applicable",
				"Site 2 of Primary Tumor Progression (metastasis)  If applicable",
				"progression time (months)",
				"Date of Progression of CA125 Date",
				"Date of Progression of CA125 Accuracy",
				"CA125 progression time (months)",
				"Follow-up from ovarectomy (months)",
				"Survival from diagnosis (months)"
			);
			
			echo implode(csv_separator, $title_row),"\n";	
			
			$all_eoc_prim_and_sec_dx_mst_ids = array();
			$all_eoc_dx_mst_id_from_participant_id = array();
			
			$data = $this->Report->query("
				SELECT * 
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN ohri_dx_ovaries AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
				INNER JOIN diagnosis_controls AS DiagnosisControl ON DiagnosisControl.id = DiagnosisMaster.diagnosis_control_id
				WHERE DiagnosisMaster.deleted != 1 AND DiagnosisControl.controls_type = 'ovary'
				AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
				ORDER BY DiagnosisMaster.participant_id ASC");						
			foreach($data as $unit){
				if($unit['DiagnosisControl']['category'] != 'primary') {
					$tfri_report_warnings[$sheet]["EOC defined as secondary: not imported"][$pid_bid_assoc[$participant_id]] = $pid_bid_assoc[$participant_id];
				} else if(isset($all_eoc_dx_mst_id_from_participant_id[$unit['DiagnosisMaster']['participant_id']])) {
					$tfri_report_warnings[$sheet]["EOC primary defined twice: second one not imported"][$pid_bid_assoc[$participant_id]] = $pid_bid_assoc[$participant_id];
				} else {
					$participant_id = $unit['DiagnosisMaster']['participant_id'];
					$eoc_diagnosis_master_id = $unit['DiagnosisMaster']['id'];
					$prim_and_sec_dx_mst_ids_of_studied_eoc = array();
					
					$all_eoc_prim_and_sec_dx_mst_ids[] = $eoc_diagnosis_master_id;
					$all_eoc_dx_mst_id_from_participant_id[$participant_id] = $eoc_diagnosis_master_id;
					$prim_and_sec_dx_mst_ids_of_studied_eoc[] = $eoc_diagnosis_master_id;
					
					// Get secondary then progression
					$secondary_data = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
						WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.primary_id != DiagnosisMaster.id
						AND DiagnosisMaster.primary_id = $eoc_diagnosis_master_id
						ORDER BY DiagnosisMaster.dx_date ASC");	
					$secondary_tumors = array();
					foreach($secondary_data as $new_secondary) {
						$prim_and_sec_dx_mst_ids_of_studied_eoc[] = $new_secondary['DiagnosisMaster']['id'];
						$all_eoc_prim_and_sec_dx_mst_ids[] = $new_secondary['DiagnosisMaster']['id'];
						$key = $new_secondary['DiagnosisMaster']['dx_date'].'#'.(empty($new_secondary['DiagnosisMaster']['dx_date'])? '' : (empty($new_secondary['DiagnosisMaster']['dx_date_accuracy'])? 'c' : $new_secondary['DiagnosisMaster']['dx_date_accuracy']));
						$secondary_tumors[$key][] = $new_secondary['DiagnosisMaster']['ohri_tumor_site'];
					}
					$progression_date = '';
					$progression_date_acc = '';
					$progression_site_1 = '';
					$progression_site_2 = '';
					if(!empty($secondary_tumors)) {
						$date_and_acc_key = key($secondary_tumors);
						$key_data = explode('#',$date_and_acc_key);
						$progression_date = $key_data[0];
						$progression_date_acc = $key_data[1];
						$progression_site_1 = array_shift($secondary_tumors[$date_and_acc_key]);
						$progression_site_2 = array_shift($secondary_tumors[$date_and_acc_key]);
						if(empty($secondary_tumors[$date_and_acc_key])) unset($secondary_tumors[$date_and_acc_key]);
					}
					
					// Get residual disease
					$residual_disease = '';
					$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
						INNER JOIN treatment_masters ON TxDetail.treatment_master_id=treatment_masters.id
						WHERE treatment_masters.deleted = 0 AND treatment_masters.diagnosis_master_id IN (".implode(',',$prim_and_sec_dx_mst_ids_of_studied_eoc).")", false);
					if(count($tx_data) == 1){
						$residual_disease = $tx_data[0]['TxDetail']['residual_disease'];
					}else if(count($tx_data) > 1){
						$tfri_report_warnings[$sheet]["Too many suregires to define the residual disease value: data not imported"][$pid_bid_assoc[$participant_id]] = $pid_bid_assoc[$participant_id];
					}
					
					// Records first diagnosis line data
					$this->validateTfriReportValue($unit['DiagnosisDetail']['laterality'], 'laterality', "Laterality", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['histopathology'], 'histopathology', "Histopathology", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisMaster']['tumour_grade'], 'grade', "Grade", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['figo'], 'stage', "FIGO", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($residual_disease, 'residual_disease', "Residual Disease", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($progression_site_1, 'progression', "Site 1 of Primary Tumor Progression (metastasis)  If Applicable", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($progression_site_2, 'progression', "Site 2 of Primary Tumor Progression (metastasis)  If applicable", $sheet, $pid_bid_assoc[$participant_id]);
					
					$line = array();
					$line[] = $pid_bid_assoc[$participant_id]; //Patient Biobank Number (required)
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? (empty($unit['DiagnosisMaster']['dx_date_accuracy'])? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']): '');
					$line[] = "";//Presence of precursor of benign lesions
					$line[] = "";//fallopian tube lesions	
					$line[] = $unit['DiagnosisMaster']['age_at_dx'];//Age at Time of Diagnosis (yr)
					$line[] = $unit['DiagnosisDetail']['laterality'];
					$line[] = $unit['DiagnosisDetail']['histopathology'];
					$line[] = $unit['DiagnosisMaster']['tumour_grade'];
					$line[] = $unit['DiagnosisDetail']['figo'];
					$line[] = $residual_disease;
					$line[] = "";//Progression status
					$line[] = $progression_date;//Date of Progression/Recurrence Date
					$line[] = (!empty($progression_date)? $progression_date_acc: '');//Date of Progression/Recurrence Accuracy
					$line[] = $progression_site_1;//Site 1 of Primary Tumor Progression (metastasis)  If Applicable
					$line[] = $progression_site_2;//Site 2 of Primary Tumor Progression (metastasis)  If applicable
					$line[] = "";//progression time (months)
					$line[] = "";//Date of Progression of CA125 Date
					$line[] = "";//Date of Progression of CA125 Accuracy
					$line[] = "";//CA125 progression time (months)
					$line[] = "";//Follow-up from ovarectomy (months)
					$line[] = $unit['DiagnosisMaster']['survival_time_months'];
				
					echo implode(csv_separator, $line), "\n";
					
					// Records other progressions
					while(!empty($secondary_tumors)) {
						reset($secondary_tumors);
						$date_and_acc_key = key($secondary_tumors);
						$key_data = explode('#',$date_and_acc_key);
						
						$progression_date = $key_data[0];
						$progression_date_acc = $key_data[1];
						$progression_site_1 = array_shift($secondary_tumors[$date_and_acc_key]);
						$progression_site_2 = array_shift($secondary_tumors[$date_and_acc_key]);
						
						if(empty($secondary_tumors[$date_and_acc_key])) unset($secondary_tumors[$date_and_acc_key]);
						
						$this->validateTfriReportValue($progression_site_1, 'progression', "Site 1 of Primary Tumor Progression (metastasis)  If Applicable", $sheet, $pid_bid_assoc[$participant_id]);
						$this->validateTfriReportValue($progression_site_2, 'progression', "Site 2 of Primary Tumor Progression (metastasis)  If applicable", $sheet, $pid_bid_assoc[$participant_id]);
						
						$line = array();
						$line[] = $pid_bid_assoc[$$participant_id]; //Patient Biobank Number (required)
						$line[] = $unit['DiagnosisMaster']['dx_date'];
						$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? $unit['DiagnosisMaster']['dx_date_accuracy']: '');
						$line[] = "";//Presence of precursor of benign lesions
						$line[] = "";//fallopian tube lesions	
						$line[] = "";//$unit['DiagnosisMaster']['age_at_dx'];//Age at Time of Diagnosis (yr)
						$line[] = "";//$unit['DiagnosisDetail']['laterality'];
						$line[] = "";//$unit['DiagnosisDetail']['histopathology'];
						$line[] = "";//$unit['DiagnosisMaster']['tumour_grade'];
						$line[] = "";//$unit['DiagnosisDetail']['figo'];
						$line[] = "";//$residual_disease;
						$line[] = "";//Progression status
						$line[] = $progression_date;//Date of Progression/Recurrence Date
						$line[] = (!empty($progression_date)? $progression_date_acc: '');//Date of Progression/Recurrence Accuracy
						$line[] = $progression_site_1;//Site 1 of Primary Tumor Progression (metastasis)  If Applicable
						$line[] = $progression_site_2;//Site 2 of Primary Tumor Progression (metastasis)  If applicable
						$line[] = "";//progression time (months)
						$line[] = "";//Date of Progression of CA125 Date
						$line[] = "";//Date of Progression of CA125 Accuracy
						$line[] = "";//CA125 progression time (months)
						$line[] = "";//Follow-up from ovarectomy (months)
						$line[] = "";//$unit['DiagnosisMaster']['survival_time_months'];
					
						echo implode(csv_separator, $line), "\n";
					}
				}
			}

			$this->displayTfriReportWarning($sheet);
			echo "\n";
		}	
		
		
		
		//TODO ici
		exit;
		
		//sheet 3 - EOC Event
		
		{
			$sheet = "SHEET 3 - EOC";
			echo "\n\n$sheet\n";
			
			$title_row = array(
				"Patient Biobank Number (required)",
				"Event Type",
				"Date of event (beginning) Date",
				"Date of event (beginning) Accuracy",
				"Date of event (end) Date",
				"Date of event (end) Accuracy",
				"Chemotherapy Precision Drug1",
				"Chemotherapy Precision Drug2",
				"Chemotherapy Precision Drug3",
				"Chemotherapy Precision Drug4",
				"CA125  Precision (U)",
				"CT Scan Precision"
			);
			
			echo implode(csv_separator, $title_row),"\n";

			$i = 0;
			$data = array();
			do{
				// CT-Scan
				
				$ct_scan_data = $this->Report->query("
					SELECT * FROM event_masters AS EventMaster 
					INNER JOIN ohri_ed_clinical_ctscans AS ed_with_ctscan ON ed_with_ctscan.event_master_id=EventMaster.id
					WHERE EventMaster.deleted=0 AND EventMaster.event_control_id IN(39) 
					AND (EventMaster.participant_id IN(".implode(", ", $paticipants_only_eoc_primary).") 
					OR EventMaster.diagnosis_master_id IN (".implode(", ", $eoc_diagnosis_master_ids['primary']).") 
					OR EventMaster.diagnosis_master_id IN (".implode(", ", $eoc_diagnosis_master_ids['secondary'])."))
					LIMIT 10 OFFSET ".$i * 10, false
				);
						
				foreach($ct_scan_data as $index => $unit){
					$ct_scan_precision = null;
					if($unit['ed_with_ctscan']['response'] == 'unknown'){
						$ct_scan_precision = 'unknown'; 
					}else if($unit['ed_with_ctscan']['response'] == "complete"){
						$ct_scan_precision = 'negative';
					}else if(strlen($unit['ed_with_ctscan']['response']) > 0){
						$ct_scan_precision = 'positive';
					}else{
						$ct_scan_precision = '';
					}
					//complet = negative
					// other = positive
					
					$data[sprintf("%010s_%s_%s_%s_ct_scan", $unit['EventMaster']['participant_id'], $unit['EventMaster']['event_date'], $i, $index)] = array(
						"participant_biobank_id"	=> $pid_bid_assoc[$unit['EventMaster']['participant_id']],
						"event"						=> 'CT scan',
						"event_start"				=> $unit['EventMaster']['event_date'],
						"event_start_accuracy"		=> "",
						"event_end"					=> "",
						"event_end_accuracy"		=> "",
						"drug1"						=> "",
						"drug2"						=> "",
						"drug3"						=> "",
						"drug4"						=> "",
						"ca125"						=> "",
						"ctscan precision"			=> $ct_scan_precision
					);
				}				
				
				// CA 125
				
				$ca_125_data = $this->Report->query("
					SELECT * FROM event_masters AS EventMaster 
					INNER JOIN ohri_ed_lab_chemistries AS ed_with_ca125 ON ed_with_ca125.event_master_id=EventMaster.id
					WHERE EventMaster.deleted=0 AND EventMaster.event_control_id IN(37) 
					AND (EventMaster.participant_id IN(".implode(", ", $paticipants_only_eoc_primary).")
					OR EventMaster.diagnosis_master_id IN (".implode(", ", $eoc_diagnosis_master_ids['primary']).") 
					OR EventMaster.diagnosis_master_id IN (".implode(", ", $eoc_diagnosis_master_ids['secondary'])."))
					LIMIT 10 OFFSET ".$i * 10, false
				);
				
				foreach($ca_125_data as $index => $unit){
					$data[sprintf("%010s_%s_%s_%s_ca125", $unit['EventMaster']['participant_id'], $unit['EventMaster']['event_date'], $i, $index)] = array(
						"participant_biobank_id"	=> $pid_bid_assoc[$unit['EventMaster']['participant_id']],
						"event"						=> 'CA125',
						"event_start"				=> $unit['EventMaster']['event_date'],
						"event_start_accuracy"		=> "",
						"event_end"					=> "",
						"event_end_accuracy"		=> "",
						"drug1"						=> "",
						"drug2"						=> "",
						"drug3"						=> "",
						"drug4"						=> "",
						"ca125"						=> $unit['ed_with_ca125']['CA125_u_ml'],
						"ctscan precision"			=> "",
					);
				}
				
				// Trt
				
				$tx_data = $this->Report->query("
					SELECT * FROM treatment_masters AS TxMaster 
					WHERE TxMaster.deleted=0 AND TxMaster.tx_control_id IN(5, 7) 
					AND (TxMaster.participant_id IN(".implode(", ", $paticipants_only_eoc_primary).") 
					OR TxMaster.diagnosis_master_id IN (".implode(", ", $eoc_diagnosis_master_ids['primary']).") 
					OR TxMaster.diagnosis_master_id IN (".implode(", ", $eoc_diagnosis_master_ids['secondary'])."))
					LIMIT 10 OFFSET ".$i * 10, false
				);
								
				foreach($tx_data as $index => $unit){
					$drugs = array();
					if($unit['TxMaster']['tx_control_id'] == 7){
						$tmp_data = $this->Report->query("
							SELECT * FROM txe_chemos 
							INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
							WHERE txe_chemos.treatment_master_id = ".$unit['TxMaster']['id']."
							AND txe_chemos.deleted = 0"
						);											
						$drug_id = 0;
						$tmp_unit = current($tmp_data);
						while(($tmp_unit != null) && ($drug_id < 4)) {
							$drug = $tmp_unit['drugs']['generic_name'];
							if(array_key_exists(strtolower($drug), $supported_drugs)) {
								$drugs[] = $supported_drugs[strtolower($drug)];
							} else {
								$unsupported_drugs[$drug] = $drug;
							}
							$drug_id++;	
							$tmp_unit = next($tmp_data);
						}
					}
					
					$data[sprintf("%010s_%s_%s_%s_tx", $unit['TxMaster']['participant_id'], $unit['TxMaster']['start_date'], $i, $index)] = array(
						"participant_biobank_id" 	=> $pid_bid_assoc[$unit['TxMaster']['participant_id']],
						"event"						=> $unit['TxMaster']['tx_control_id'] == 5 ? 'surgery(other)' : 'chemotherapy',
						"event_start"				=> $unit['TxMaster']['start_date'],
						"event_start_accuracy"		=> (!empty($unit['TxMaster']['start_date'])? $unit['TxMaster']['start_date_accuracy']: ''),
						"event_end"					=> $unit['TxMaster']['finish_date'],
						"event_end_accuracy"		=> (!empty($unit['TxMaster']['finish_date'])? $unit['TxMaster']['finish_date_accuracy']: ''),
						"drug1"						=> (isset($drugs[0])? $drugs[0] : ''),
						"drug2"						=> (isset($drugs[1])? $drugs[1] : ''),
						"drug3"						=> (isset($drugs[2])? $drugs[2] : ''),
						"drug4"						=> (isset($drugs[3])? $drugs[3] : ''),
						"ca125"						=> "",
						"ctscan precision"			=> ""
					);
				}

				++ $i;
			}while(!empty($tx_data) || !empty($ca_125_data) || !empty($ct_scan_data));
			
			ksort($data);
			
			foreach($data as $line){
				echo implode(csv_separator, $line), "\n";
			}
		}
		
		//sheet 4 - Other Primary Cancer - Dx
		
		{
			echo "\n\nSHEET 4 - Other Primary Cancer -Diagnosis\n";
			
			$title_row = array(
				"Patient Biobank Number (required)",
				"Date of Diagnosis Date",
				"Date of Diagnosis Accuracy",
				"Tumor Site",
				"Age at Time of Diagnosis (yr)",
				"Laterality",
				"Histopathology",
				"Grade",
				"Stage",
				"Date of Progression/Recurrence	Date",
				"Date of Progression/Recurrence	Accuracy",
				"Site of Tumor Progression (metastasis)  If Applicable",
				"Survival (months)"
			);
			
			echo implode(csv_separator, $title_row),"\n";
			
			$i = 0;
			do{				
				$data = $this->Report->query("
					SELECT * FROM diagnosis_masters AS DiagnosisMaster
					INNER JOIN ohri_dx_others AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
					WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
					AND DiagnosisMaster.dx_origin='primary' AND DiagnosisMaster.diagnosis_control_id=15
					ORDER BY DiagnosisMaster.participant_id LIMIT 10 OFFSET ".($i * 10), false
				);				
								
				foreach($data as $unit){
					
					// Set eoc diagnosis master ids
					
					$other_diagnosis_master_ids['primary'][] = $unit['DiagnosisMaster']['id'];
					$secondary_data = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
						WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id = ".$unit['DiagnosisMaster']['participant_id']."
						AND DiagnosisMaster.dx_origin='secondary' AND DiagnosisMaster.primary_number =".$unit['DiagnosisMaster']['primary_number'], false);					
					foreach($secondary_data as $tmp) {
						$other_diagnosis_master_ids['secondary'][] = $tmp['DiagnosisMaster']['id'];
					}					
					
					// Get progression
					
					$secondary_tumors = array();
					foreach($secondary_data as $new_secondary) {
						$key = $new_secondary['DiagnosisMaster']['dx_date'].'#'.$new_secondary['DiagnosisMaster']['dx_date_accuracy'];
						$secondary_tumors[$key][] = $new_secondary['DiagnosisMaster']['ohri_tumor_site'];
					}
					
					$progression_date = '';
					$progression_date_acc = '';
					$progression_site_1 = '';
					if(!empty($secondary_tumors)) {
						$date_and_acc_key = key($secondary_tumors);
						$key_data = explode('#',$date_and_acc_key);					
						$progression_date = $key_data[0];
						$progression_date_acc = $key_data[1];
						$progression_site_1 = array_shift($secondary_tumors[$date_and_acc_key]);	
										
						if(empty($secondary_tumors[$date_and_acc_key])) unset($secondary_tumors[$date_and_acc_key]);
					}
					
					// Records first diagnosis line data
					
					$line = array();
					$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']];
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? $unit['DiagnosisMaster']['dx_date_accuracy']: '');
					$line[] = $unit['DiagnosisMaster']['ohri_tumor_site'];
					$line[] = $unit['DiagnosisMaster']['age_at_dx'];
					$line[] = $unit['DiagnosisDetail']['laterality'];
					$line[] = $unit['DiagnosisDetail']['histopathology'];
					$line[] = $unit['DiagnosisMaster']['tumour_grade'];
					$line[] = empty($unit['DiagnosisMaster']['path_stage_summary'])? $unit['DiagnosisMaster']['clinical_stage_summary'] : $unit['DiagnosisMaster']['path_stage_summary'];
					$line[] = $progression_date;
					$line[] = (!empty($progression_date)?$progression_date_acc : '');
					$line[] = $progression_site_1;
					$line[] = $unit['DiagnosisMaster']['survival_time_months'];
					
					echo implode(csv_separator, $line), "\n";
					
					// Records other progressions
					while(!empty($secondary_tumors)) {
						reset($secondary_tumors);
						$date_and_acc_key = key($secondary_tumors);
						$key_data = explode('#',$date_and_acc_key);
						
						$progression_date = $key_data[0];
						$progression_date_acc = $key_data[1];
						$progression_site_1 = array_shift($secondary_tumors[$date_and_acc_key]);
						
						if(empty($secondary_tumors[$date_and_acc_key])) unset($secondary_tumors[$date_and_acc_key]);
						
						$line = array();
						$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']];
						$line[] = $unit['DiagnosisMaster']['dx_date'];
						$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? $unit['DiagnosisMaster']['dx_date_accuracy']: '');
						$line[] = "";//$unit['DiagnosisMaster']['ohri_tumor_site'];
						$line[] = "";//$unit['DiagnosisMaster']['age_at_dx'];
						$line[] = "";//$unit['DiagnosisDetail']['laterality'];
						$line[] = "";//$unit['DiagnosisDetail']['histopathology'];
						$line[] = "";//$unit['DiagnosisMaster']['tumour_grade'];
						$line[] = "";//empty($unit['DiagnosisMaster']['path_stage_summary'])? $unit['DiagnosisMaster']['clinical_stage_summary'] : $unit['DiagnosisMaster']['path_stage_summary'];
						$line[] = $progression_date;
						$line[] = (!empty($progression_date)? $progression_date_acc: '');
						$line[] = $progression_site_1;
						$line[] = "";//$unit['DiagnosisMaster']['survival_time_months'];
					
						echo implode(csv_separator, $line), "\n";
					}
				}
				++ $i;
			}while(!empty($data));
		}		
		
		//sheet 5 - Other Primary Cancer - Event
		
		{
			echo "\n\nSHEET 5 - Other Primary Cancer - Event\n";
			
			$title_row = array(
				"Patient Biobank Number (required)",
				"Date of event (beginning) Date",
				"Date of event (beginning) Accuracy",
				"Date of event (end) Date",
				"Date of event (end) Accuracy",
				"Event Type",
				"Chemotherapy Precision Drug1",
				"Chemotherapy Precision Drug2",
				"Chemotherapy Precision Drug3",
				"Chemotherapy Precision Drug4"
			);
			
			echo implode(csv_separator, $title_row),"\n";

			$tx_controls = array('5'=>'surgery', '6'=>'radiology', '7'=>'chemotherapy');
			
			$i = 0;
			$data = array();
			do{

				// Trt
				
				$tx_data = $this->Report->query("
					SELECT * FROM treatment_masters AS TxMaster 
					WHERE TxMaster.deleted=0 AND TxMaster.tx_control_id IN(5, 7, 6) 
					AND (TxMaster.participant_id IN(".implode(", ", $paticipants_only_other_primary).") 
					OR TxMaster.diagnosis_master_id IN (".implode(", ", $other_diagnosis_master_ids['primary']).") 
					OR TxMaster.diagnosis_master_id IN (".implode(", ", $other_diagnosis_master_ids['secondary'])."))
					LIMIT 10 OFFSET ".$i * 10, false
				);
								
				foreach($tx_data as $index => $unit){
					$drugs = array();
					if($unit['TxMaster']['tx_control_id'] == 7){
						$tmp_data = $this->Report->query("
							SELECT * FROM txe_chemos 
							INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
							WHERE txe_chemos.treatment_master_id = ".$unit['TxMaster']['id']."
							AND txe_chemos.deleted = 0"
						);						
						$drug_id = 0;
						$tmp_unit = current($tmp_data);
						while(($tmp_unit != null) && ($drug_id < 4)) {
							$drug = $tmp_unit['drugs']['generic_name'];
							if(array_key_exists(strtolower($drug), $supported_drugs)) {
								$drugs[] = $supported_drugs[strtolower($drug)];
							} else {
								$unsupported_drugs[$drug] = $drug;
							}
							$drug_id++;	
							$tmp_unit = next($tmp_data);
						}
					}
					
					$data[sprintf("%010s_%s_%s_%s_tx", $unit['TxMaster']['participant_id'], $unit['TxMaster']['start_date'], $i, $index)] = array(
						"participant_biobank_id" 	=> $pid_bid_assoc[$unit['TxMaster']['participant_id']],
						"event_start"				=> $unit['TxMaster']['start_date'],
						"event_start_accuracy"		=> (!empty( $unit['TxMaster']['start_date'])? $unit['TxMaster']['start_date_accuracy']: ''),
						"event_end"					=> $unit['TxMaster']['finish_date'],
						"event_end_accuracy"		=> (!empty($unit['TxMaster']['finish_date'])? $unit['TxMaster']['finish_date_accuracy']: ''),
						"event"						=> $tx_controls[$unit['TxMaster']['tx_control_id']],
						"drug1"						=> (isset($drugs[0])? $drugs[0] : ''),
						"drug2"						=> (isset($drugs[1])? $drugs[1] : ''),
						"drug3"						=> (isset($drugs[2])? $drugs[2] : ''),
						"drug4"						=> (isset($drugs[3])? $drugs[3] : '')
					);
				}
				
				++ $i;
			}while(!empty($tx_data));
			
			ksort($data);
			
			foreach($data as $line){
				echo implode(csv_separator, $line), "\n";
			}
		}
		
		if(!empty($unsupported_drugs)) {
			$echo_string = '';
			foreach($unsupported_drugs as $drug) {
				$echo_string .= ' ['.$drug.'] ';
			}
			echo "\n", implode(csv_separator, array("CANNOT FETCH ALL RDUGS - FOLLOWING DRUGS ARE NOT IMPORTED : ".$echo_string)), "\n";
		}
		
		//sheet 6 - inventory
		
		{
			//blank sheet, only the header line
			echo "\n\nSHEET 6 - Inventory\n";
			$title_row = array(
				"Bank",
				"Patient Biobank Number (required)",
				"Collected Specimen Type",
				"Date of Specimen Collection Date",
				"Date of Specimen Collection Accuracy",
				"Tissue Precision Tissue Source",
				"Tissue Precision Tissue Type",
				"Tissue Precision Tissue Laterality",
				"Tissue Precision Flash Frozen Tissues  Volume",
				"Tissue Precision Flash Frozen Tissues  Volume Unit",
				"Tissue Precision OCT Frozen Tissues Volume (mm3)",
				"Tissue Precision Formalin Fixed Paraffin Embedded Tissues Volume (nbr blocks)",
				"Ascite Precision Ascites Fluids Volume (ml)",
				"Blood Precision Frozen Serum Volume (ml)",
				"Blood Precision Frozen Plasma Volume (ml)",
				"Blood Precision Blood DNA Volume (ug)",
				"Blood Precision Buffy coat (ul)",
				"notes"
			);
			
			echo implode(csv_separator, $title_row),"\n";
		}
				
		exit;
	}
	
	function validateTfriReportValue($value, $key, $excel_field, $sheet, $participant_bank_nbr) {
		global $tfri_report_allowed_values;
		global $tfri_report_warnings;
		
		if($value != null && $value != '') {
			if(!in_array($value, $tfri_report_allowed_values[$key])) {
				$tfri_report_warnings[$sheet]["Value '$value' not supported for field '$excel_field'"][$participant_bank_nbr] = $participant_bank_nbr;
			}
		}
			
		return;
	}
	
	function displayTfriReportWarning($sheet) {
		global $tfri_report_warnings;
		echo "\n";
		if(isset($tfri_report_warnings[$sheet])) {
			foreach($tfri_report_warnings[$sheet] as $msg => $participant_ids) echo "$msg. See Bank# : ".implode (', ',$participant_ids)."\n";
		}
		echo "\n";
	}
}