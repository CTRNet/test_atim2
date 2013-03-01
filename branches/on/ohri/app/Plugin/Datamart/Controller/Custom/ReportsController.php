<?php
class ReportsControllerCustom extends ReportsController {
	
	function terryFox(array $parameters){
		global $tfri_report_allowed_values;
		global $tfri_report_warnings;
		global $new_line;
		
		$new_line = "\n";	
		
		$not_exported_field = '## Not Exported ##';
		
		$tfri_report_warnings = array();
		$tfri_report_allowed_values = array();
		//Sheet 1
		$tfri_report_allowed_values['vital_status'] = array('alive', 'dead', 'unknown', 'deceased');
		$tfri_report_allowed_values['fam_history'] = array('breast cancer', 'colon and breast cancer', 'colon and endometrial cancer', 'colon cancer', 'endometrial cancer', 'no', 'ovarian and breast cancer', 'ovarian and colon cancer', 'ovarian and endometrial cancer', 'ovarian cancer', 'precursor of benign ovarian lesions', 'unknown', 'ovarian, endometrial and colon cancer');
		$tfri_report_allowed_values['brca_status'] = array('BRCA mutation known but not identified', 'BRCA1 mutated', 'BRCA1/2 mutated', 'BRCA2 mutated', 'unknown', 'wild type');
		//Sheet 2 & 4
		$tfri_report_allowed_values['laterality'] = array('bilateral', 'left', 'right', 'unknown', 'not applicable');
		$tfri_report_allowed_values['histopathology'] = array('high grade serous', 'low grade serous', 'mucinous', 'clear cells', 'endometrioid', 'mixed', 'undifferentiated','serous','other','unknown','non applicable');
		$tfri_report_allowed_values['grade'] = array('0', '1', '2', '3');
		$tfri_report_allowed_values['residual_disease'] = array('1-2cm', '<1cm', '>2cm', 'miliary', 'none', 'unknown', 'suboptimal', 'yes unknown');
		$tfri_report_allowed_values['stage'] = array('Ia', 'Ib', 'Ic', 'IIa', 'IIb', 'IIc', 'IIIa', 'IIIb', 'IIIc', 'IV', 'unknown', 'III');
		$tfri_report_allowed_values['fallopian_tube_lesions'] = array('benign tumors', 'malignant tumors', 'no', 'salpingitis', 'unknown', 'yes');
		$tfri_report_allowed_values['benign_lesions'] = array('benign or borderline tumours', 'endometriosis', 'endosalpingiosis', 'no', 'ovarian cysts', 'unknown');
		$tfri_report_allowed_values['progression_status'] = array('yes', 'progressive disease', 'bouncer', 'no', 'unknown');		
		$tfri_report_allowed_values['tumor_site'] = array('Breast-Breast', 'Central Nervous System-Brain', 'Central Nervous System-Other Central Nervous System', 'Central Nervous System-Spinal Cord', 'Digestive-Anal', 'Digestive-Appendix', 'Digestive-Bile Ducts', 'Digestive-Colonic', 'Digestive-Esophageal', 'Digestive-Gallbladder', 'Digestive-Liver', 'Digestive-Other Digestive', 'Digestive-Pancreas', 'Digestive-Rectal', 'Digestive-Small Intestine', 'Digestive-Stomach', 'Female Genital-Cervical', 'Female Genital-Endometrium', 'Female Genital-Fallopian Tube', 'Female Genital-Gestational Trophoblastic Neoplasia', 'Female Genital-Other Female Genital', 'Female Genital-Ovary', 'Female Genital-Peritoneal Pelvis Abdomen', 'Female Genital-Uterine', 'Female Genital-Vagina', 'Female Genital-Vulva', "Haematological-Hodgkin's Disease", 'Haematological-Leukemia', 'Haematological-Lymphoma', "Haematological-Non-Hodgkin's Lymphomas", 'Haematological-Other Haematological', 'Head & Neck-Larynx', 'Head & Neck-Lip and Oral Cavity', 'Head & Neck-Nasal Cavity and Sinuses', 'Head & Neck-Other Head & Neck', 'Head & Neck-Pharynx', 'Head & Neck-Salivary Glands', 'Head & Neck-Thyroid', 'Musculoskeletal Sites-Bone', 'Musculoskeletal Sites-Other Bone', 'Musculoskeletal Sites-Soft Tissue Sarcoma', 'Ophthalmic-Eye', 'Ophthalmic-Other Eye', 'Other-Gross Metastatic Disease', 'Other-Primary Unknown', 'Skin-Melanoma', 'Skin-Non Melanomas', 'Skin-Other Skin', 'Thoracic-Lung', 'Thoracic-Mesothelioma', 'Thoracic-Other Thoracic', 'Urinary Tract-Bladder', 'Urinary Tract-Kidney', 'Urinary Tract-Other Urinary Tract', 'Urinary Tract-Renal Pelvis and Ureter', 'Urinary Tract-Urethra', 'not applicable', 'unknown', 'ascite');
		//Sheet 3 & 5
		$tfri_report_allowed_values['ct_scan'] = array('negative', 'positive', 'unknown');
		$tfri_report_allowed_values['drugs'] = array('cisplatinum', 'carboplatinum', 'oxaliplatinum', 'paclitaxel', 'topotecan', 'ectoposide', 'tamoxifen', 'doxetaxel', 'doxorubicin', 'other', 'etoposide', 'gemcitabine', 'procytox', 'vinorelbine', 'cyclophosphamide');
		
		$bank_nbrs = array();
		$participant_ids = array();
		
		if(array_key_exists('participant_identifier_with_file_upload', $parameters['Participant']) && !empty($parameters['Participant']['participant_identifier_with_file_upload']['tmp_name'])) {
			// set $DATA array based on contents of uploaded FILE
			$handle = fopen($parameters['Participant']['participant_identifier_with_file_upload']['tmp_name'], "r");
			while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
				$bank_nbrs[] = $csv_data[0];
			}
			fclose($handle);
			unset($parameters['Participant']['participant_identifier_with_file_upload']);
		} else if(array_key_exists('participant_identifier_start', $parameters['Participant'])) {
			// Range
			for($new_bank_nbr = $parameters['Participant']['participant_identifier_start']; $new_bank_nbr <= $parameters['Participant']['participant_identifier_end']; $new_bank_nbr++) $bank_nbrs[] = $new_bank_nbr;
		} else if(array_key_exists('participant_identifier', $parameters['Participant'])) {
			$bank_nbrs = $parameters['Participant']['participant_identifier'];
		} else if(array_key_exists('id', $parameters['Participant'])) {
			$participant_ids = $parameters['Participant']['id'];
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Get participant
		
		$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$conditions = array();
		if($participant_ids) $conditions['Participant.id'] = $participant_ids;
		if($bank_nbrs) $conditions['Participant.participant_identifier'] = $bank_nbrs;
		$participant_data = $this->Participant->find('all', array('conditions' => $conditions, 'order' => array('Participant.id ASC')));
		
		if(empty($participant_data)) {
			return array('header' => null, 'data' => null, 'columns_names' => null, 'error_msg' => 'terry_fox_report_no_participant');
		} else if(sizeof($participant_data) > 300) {		
			return array('header' => null, 'data' => null, 'columns_names' => null, 'error_msg' => 'terry_fox_report_too_many_participants');
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
} else {
	$new_line = '<br>';
}
		
		// *********************************************** SHEET 1 - Patients ***********************************************
		
		{
			$sheet = "SHEET 1 - Patients";
			echo $sheet."$new_line";
				
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
			
			echo implode(csv_separator, $title_row),"$new_line";
			
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
				$line[] = $not_exported_field;	//suspected dod : Won't be accessible
				$line[] = $not_exported_field;	//Suspected Date of Death date accuracy : Won't be accessible
				$line[] = "$last_contact_date";
				$line[] = "$last_contact_date_accuracy";
				$line[] = $family_history;
				$line[] = $brca_value;
				$line[] = $not_exported_field;	//notes
				
				echo implode(csv_separator, $line), "$new_line";
			}
			unset($participant_data);

			if(!empty($bank_nbrs) && sizeof($bank_nbrs) != sizeof($participant_ids)) {
				foreach($bank_nbrs as $new_bank_nbr) {
					if($new_bank_nbr && !in_array($new_bank_nbr, $pid_bid_assoc)) $tfri_report_warnings[$sheet]["Not all Bank# submitted match a participant of your bank"][$new_bank_nbr] = $new_bank_nbr;
				}
			}
			
			$this->displayTfriReportWarning($sheet);
			echo "$new_line";
		}	

		// *********************************************** SHEET 2 - EOC - Diagnosis ***********************************************
		
		{
			$sheet = 'SHEET 2 - EOC - Diagnosis';
			echo "$new_line$new_line$sheet$new_line";
			
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
			
			echo implode(csv_separator, $title_row),"$new_line";	
			
			$all_eoc_prim_and_sec_dx_mst_ids = array('-1');
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
					$tx_data = $this->Report->query("SELECT residual_disease 
						FROM ohri_txd_surgeries AS TreatmentDetail
						INNER JOIN treatment_masters ON TreatmentDetail.treatment_master_id=treatment_masters.id
						WHERE treatment_masters.deleted = 0 
						AND TreatmentDetail.description = 'ovarectomy'
						AND treatment_masters.diagnosis_master_id IN (".implode(',',$prim_and_sec_dx_mst_ids_of_studied_eoc).")", false);
					if(count($tx_data) == 1){
						$residual_disease = $tx_data[0]['TreatmentDetail']['residual_disease'];
					}else if(count($tx_data) > 1){
						$tfri_report_warnings[$sheet]["Too many ovarectomies to define the residual disease value: data not imported"][$pid_bid_assoc[$participant_id]] = $pid_bid_assoc[$participant_id];
					}
					$residual_disease = str_replace(array('< 1cm', '> 2cm', 'undefined'), array('<1cm', '>2cm', 'none', 'unknown'), $residual_disease);
					
					// Get ca125 progression
					$ca_125_data = $this->Report->query("
						SELECT * FROM event_masters AS EventMaster
						INNER JOIN ohri_ed_lab_chemistries AS EventDetail ON EventDetail.event_master_id=EventMaster.id
						INNER JOIN event_controls AS EventControl ON EventControl.id = EventMaster.event_control_id
						WHERE EventMaster.deleted=0 AND EventControl.event_type = 'chemistry' AND EventControl.flag_active = 1
						AND EventDetail.ca125_progression = 'y'
						AND EventMaster.diagnosis_master_id IN(".implode(", ", $prim_and_sec_dx_mst_ids_of_studied_eoc).")
						ORDER BY EventMaster.participant_id ASC, EventMaster.event_date ASC", false);
					$ca125_progressions = array();
					foreach($ca_125_data as $new_ca125_progression) {
						$key = $new_ca125_progression['EventMaster']['event_date'].'#'.(empty($new_ca125_progression['EventMaster']['event_date'])? '' : (empty($new_ca125_progression['EventMaster']['event_date_accuracy'])? 'c' : $new_ca125_progression['EventMaster']['event_date_accuracy']));
						$ca125_progressions[$key] = '';
					}
					$ca125_progression_date = '';
					$ca125_progression_date_acc = '';
					if(!empty($ca125_progressions)) {
						$date_and_acc_key = key($ca125_progressions);
						$key_data = explode('#',$date_and_acc_key);
						$ca125_progression_date = $key_data[0];
						$ca125_progression_date_acc = $key_data[1];
						unset($ca125_progressions[$date_and_acc_key]);
					}
					
					// Records first diagnosis line data
					$this->validateTfriReportValue($unit['DiagnosisDetail']['laterality'], 'laterality', "Laterality", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['histopathology'], 'histopathology', "Histopathology", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisMaster']['tumour_grade'], 'grade', "Grade", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['figo'], 'stage', "FIGO", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($residual_disease, 'residual_disease', "Residual Disease", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($progression_site_1, 'tumor_site', "Site 1 of Primary Tumor Progression (metastasis)  If Applicable", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($progression_site_2, 'tumor_site', "Site 2 of Primary Tumor Progression (metastasis)  If applicable", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['fallopian_tube_lesions'], 'fallopian_tube_lesions', "Fallopian tube lesions", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['precursor_of_benign_lesions'], 'benign_lesions', "Presence of precursor of benign lesions", $sheet, $pid_bid_assoc[$participant_id]);
					$this->validateTfriReportValue($unit['DiagnosisDetail']['progression_status'], 'progression_status', "Progression status", $sheet, $pid_bid_assoc[$participant_id]);
												
					$line = array();
					$line[] = $pid_bid_assoc[$participant_id]; 
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? (empty($unit['DiagnosisMaster']['dx_date_accuracy'])? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']): '');
					$line[] = $unit['DiagnosisDetail']['precursor_of_benign_lesions'];
					$line[] = $unit['DiagnosisDetail']['fallopian_tube_lesions'];
					$line[] = $unit['DiagnosisMaster']['age_at_dx'];
					$line[] = $unit['DiagnosisDetail']['laterality'];
					$line[] = $unit['DiagnosisDetail']['histopathology'];
					$line[] = $unit['DiagnosisMaster']['tumour_grade'];
					$line[] = $unit['DiagnosisDetail']['figo'];
					$line[] = $residual_disease;
					$line[] = $unit['DiagnosisDetail']['progression_status'];
					$line[] = $progression_date;
					$line[] = (!empty($progression_date)? $progression_date_acc: '');
					$line[] = $progression_site_1;
					$line[] = $progression_site_2;
					$line[] = $not_exported_field;	// progression time (months) : Will be calculated by ctrnet import process
					$line[] = $ca125_progression_date;
					$line[] = $ca125_progression_date_acc;		
					$line[] = $not_exported_field;	// CA125 progression time (months) : Will be calculated by ctrnet import process
					$line[] = $not_exported_field;	// Follow-up from ovarectomy (months) : Will be calculated by ctrnet import process
					$line[] = $unit['DiagnosisMaster']['survival_time_months'];
				
					echo implode(csv_separator, $line), "$new_line";
					
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
						
						$this->validateTfriReportValue($progression_site_1, 'tumor_site', "Site 1 of Primary Tumor Progression (metastasis)  If Applicable", $sheet, $pid_bid_assoc[$participant_id]);
						$this->validateTfriReportValue($progression_site_2, 'tumor_site', "Site 2 of Primary Tumor Progression (metastasis)  If applicable", $sheet, $pid_bid_assoc[$participant_id]);
						
						$line = array();
						$line[] = $pid_bid_assoc[$participant_id];
						$line[] = $unit['DiagnosisMaster']['dx_date'];
						$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? $unit['DiagnosisMaster']['dx_date_accuracy']: '');
						$line[] = "";
						$line[] = "";			
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = $progression_date;
						$line[] = (!empty($progression_date)? $progression_date_acc: '');
						$line[] = $progression_site_1;
						$line[] = $progression_site_2;
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
					
						echo implode(csv_separator, $line), "$new_line";
					}
					
					// Records other ca125 progressions
					while(!empty($ca125_progressions)) {
						reset($ca125_progressions);
						$date_and_acc_key = key($ca125_progressions);
						$key_data = explode('#',$date_and_acc_key);
					
						$ca125_progression_date = $key_data[0];
						$ca125_progression_date_acc = $key_data[1];
					
						unset($ca125_progressions[$date_and_acc_key]);
					
						$line = array();
						$line[] = $pid_bid_assoc[$participant_id];
						$line[] = $unit['DiagnosisMaster']['dx_date'];
						$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? $unit['DiagnosisMaster']['dx_date_accuracy']: '');
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = "";
						$line[] = $ca125_progression_date;
						$line[] = $ca125_progression_date_acc;		
						$line[] = "";
						$line[] = "";
						$line[] = "";
							
						echo implode(csv_separator, $line), "$new_line";
					}
				}
			}
			unset($data);
			
			foreach($pid_bid_assoc as $new_participant_id => $new_bank_nbr) {
				if(!isset($all_eoc_dx_mst_id_from_participant_id[$new_participant_id])) $tfri_report_warnings[$sheet]["Not all participants are linked to an EOC diagnosis"][$new_bank_nbr] = $new_bank_nbr;
			}

			$this->displayTfriReportWarning($sheet);
			echo "$new_line";
		}	
					
		// *********************************************** SHEET 3 - EOC Event ***********************************************
		
		{
			$sheet = "SHEET 3 - EOC";
			echo "$new_line$new_line$sheet$new_line";
			
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
			
			echo implode(csv_separator, $title_row),"$new_line";
			
			$eoc_event_from_participant_id = array();

			// CT-Scan
			
			$ct_scan_data = $this->Report->query("
				SELECT * FROM event_masters AS EventMaster 
				INNER JOIN ohri_ed_clinical_ctscans AS EventDetail ON EventDetail.event_master_id=EventMaster.id
				INNER JOIN event_controls AS EventControl ON EventControl.id = EventMaster.event_control_id 
				WHERE EventMaster.deleted=0 AND EventControl.event_type = 'ctscan' AND EventControl.flag_active = 1
				AND EventMaster.diagnosis_master_id IN(".implode(", ", $all_eoc_prim_and_sec_dx_mst_ids).")
				ORDER BY EventMaster.participant_id ASC, EventMaster.event_date ASC", false);
			foreach($ct_scan_data as $index => $unit){
				$participant_id = $unit['EventMaster']['participant_id'];
				$ct_scan_precision = null;
				if($unit['EventDetail']['response'] == 'unknown'){
					$ct_scan_precision = 'unknown'; 
				}else if($unit['EventDetail']['response'] == "complete"){
					$ct_scan_precision = 'negative';
				}else if(strlen($unit['EventDetail']['response']) > 0){
					$ct_scan_precision = 'positive';
				}else{
					$ct_scan_precision = '';
				}
				$this->validateTfriReportValue($ct_scan_precision, 'ct_scan', "CT Scan Precision", $sheet, $pid_bid_assoc[$participant_id]);
				$eoc_event_from_participant_id[$participant_id][] = array(
					"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
					"event"						=> 'CT scan',
					"event_start"				=> $unit['EventMaster']['event_date'],
					"event_start_accuracy"		=> (empty($unit['EventMaster']['event_date'])? '' : (empty($unit['EventMaster']['event_date_accuracy'])? 'c' : $unit['EventMaster']['event_date_accuracy'])),
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
			unset($ct_scan_data);
			
			// CA 125
			
			$ca_125_data = $this->Report->query("
				SELECT * FROM event_masters AS EventMaster 
				INNER JOIN ohri_ed_lab_chemistries AS EventDetail ON EventDetail.event_master_id=EventMaster.id
				INNER JOIN event_controls AS EventControl ON EventControl.id = EventMaster.event_control_id 
				WHERE EventMaster.deleted=0 AND EventControl.event_type = 'chemistry' AND EventControl.flag_active = 1
				AND EventMaster.diagnosis_master_id IN(".implode(", ", $all_eoc_prim_and_sec_dx_mst_ids).")
				ORDER BY EventMaster.participant_id ASC, EventMaster.event_date ASC", false);	
			foreach($ca_125_data as $index => $unit){
				$participant_id = $unit['EventMaster']['participant_id'];
				$eoc_event_from_participant_id[$participant_id][] = array(
					"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
					"event"						=> 'CA125',
					"event_start"				=> $unit['EventMaster']['event_date'],
					"event_start_accuracy"		=> (empty($unit['EventMaster']['event_date'])? '' : (empty($unit['EventMaster']['event_date_accuracy'])? 'c' : $unit['EventMaster']['event_date_accuracy'])),
					"event_end"					=> "",
					"event_end_accuracy"		=> "",
					"drug1"						=> "",
					"drug2"						=> "",
					"drug3"						=> "",
					"drug4"						=> "",
					"ca125"						=> $unit['EventDetail']['CA125_u_ml'],
					"ctscan precision"			=> ""
				);
			}
			unset($ca_125_data);

			// Biopsy, Surgery
			
			$tx_data = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster 
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				INNER JOIN ohri_txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'surgery'
				AND TreatmentMaster.diagnosis_master_id IN(".implode(", ", $all_eoc_prim_and_sec_dx_mst_ids).")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);			
			foreach($tx_data as $index => $unit){
				$participant_id = $unit['TreatmentMaster']['participant_id'];
				$event = '';
				switch($unit['TreatmentDetail']['description']) {
					case 'biopsy':
						$event = 'biopsy';
						break;
					case 'ovarectomy':
						$event = 'surgery(ovarectomy)';
						break;
					default:
						$event = 'surgery(other)';
				}
				$eoc_event_from_participant_id[$participant_id][] = array(
					"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
					"event"						=> $event,
					"event_start"				=> $unit['TreatmentMaster']['start_date'],
					"event_start_accuracy"		=> (empty($unit['TreatmentMaster']['start_date'])? '' : (empty($unit['TreatmentMaster']['start_date_accuracy'])? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
					"event_end"					=> "",
					"event_end_accuracy"		=> "",
					"drug1"						=> "",
					"drug2"						=> "",
					"drug3"						=> "",
					"drug4"						=> "",
					"ca125"						=> "",
					"ctscan precision"			=> ""
				);
			}
			unset($tx_data);
	
			// Chemotherapy
			
			$tx_data = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'chemotherapy'
				AND TreatmentMaster.diagnosis_master_id IN(".implode(", ", $all_eoc_prim_and_sec_dx_mst_ids).")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
			foreach($tx_data as $index => $unit){
				$participant_id = $unit['TreatmentMaster']['participant_id'];
				$drug_data = $this->Report->query("
					SELECT * FROM txe_chemos
					INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
					WHERE txe_chemos.treatment_master_id = ".$unit['TreatmentMaster']['id']."
					AND txe_chemos.deleted = 0"
				);
				$drugs = array();
				$new_drug = current($drug_data);
				while($new_drug != null) {
					$drug = strtolower($new_drug['drugs']['generic_name']);
					$this->validateTfriReportValue($drug, 'drugs', "Drug", $sheet, $pid_bid_assoc[$participant_id]);
					$drugs[] = $drug;
					$new_drug = next($drug_data);
				}
				if(sizeof($drugs) > 4) $tfri_report_warnings[$sheet]["More than 4 drugs associated to a chemo"][$pid_bid_assoc[$participant_id]] = $pid_bid_assoc[$participant_id];
				$eoc_event_from_participant_id[$participant_id][] = array(
					"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
					"event"						=> 'chemotherapy',
					"event_start"				=> $unit['TreatmentMaster']['start_date'],
					"event_start_accuracy"		=> (empty($unit['TreatmentMaster']['start_date'])? '' : (empty($unit['TreatmentMaster']['start_date_accuracy'])? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
					"event_end"					=> $unit['TreatmentMaster']['finish_date'],
					"event_end_accuracy"		=> (empty($unit['TreatmentMaster']['finish_date'])? '' : (empty($unit['TreatmentMaster']['finish_date_accuracy'])? 'c' : $unit['TreatmentMaster']['finish_date_accuracy'])),
					"drug1"						=> (isset($drugs[0])? $drugs[0] : ''),
					"drug2"						=> (isset($drugs[1])? $drugs[1] : ''),
					"drug3"						=> (isset($drugs[2])? $drugs[2] : ''),
					"drug4"						=> (isset($drugs[3])? $drugs[3] : ''),
					"ca125"						=> "",
					"ctscan precision"			=> ""
				);
			}
			unset($tx_data);
			
			ksort($eoc_event_from_participant_id);
			foreach($eoc_event_from_participant_id as $participant_events) {
				foreach($participant_events as $line) echo implode(csv_separator, $line), "$new_line";
			}
			unset($eoc_event_from_participant_id);
			
			$this->displayTfriReportWarning($sheet);
			echo "$new_line";
		}
		
		// *********************************************** SHEET 4 - Other Primary Cancer -Diagnosis ***********************************************
		
		{
			$sheet = 'SHEET 4 - Other Primary Cancer -Diagnosis';
			echo "$new_line$new_line$sheet$new_line";
				
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
						
			echo implode(csv_separator, $title_row),"$new_line";
			
			$all_other_prim_and_sec_dx_mst_ids = array('-1');
			
			$data = $this->Report->query("
				SELECT *
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN diagnosis_controls AS DiagnosisControl ON DiagnosisControl.id = DiagnosisMaster.diagnosis_control_id
				LEFT JOIN ohri_dx_others AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
				WHERE DiagnosisMaster.deleted != 1 AND DiagnosisControl.controls_type != 'ovary' AND DiagnosisControl.category != 'primary'
				AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
				ORDER BY DiagnosisMaster.participant_id ASC");
			foreach($data as $unit){
				$participant_id = $unit['DiagnosisMaster']['participant_id'];
				$other_diagnosis_master_id = $unit['DiagnosisMaster']['id'];
				
				$all_other_prim_and_sec_dx_mst_ids[] = $other_diagnosis_master_id;
				
				// Get secondary then progression
				$secondary_data = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
					WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.primary_id != DiagnosisMaster.id
					AND DiagnosisMaster.primary_id = $other_diagnosis_master_id
					ORDER BY DiagnosisMaster.dx_date ASC");
				$secondary_tumors = array();
				foreach($secondary_data as $new_secondary) {
					$all_other_prim_and_sec_dx_mst_ids[] = $new_secondary['DiagnosisMaster']['id'];
					$key = $new_secondary['DiagnosisMaster']['dx_date'].'#'.(empty($new_secondary['DiagnosisMaster']['dx_date'])? '' : (empty($new_secondary['DiagnosisMaster']['dx_date_accuracy'])? 'c' : $new_secondary['DiagnosisMaster']['dx_date_accuracy']));
					$secondary_tumors[$key][] = $new_secondary['DiagnosisMaster']['ohri_tumor_site'];
				}
				$progression_date = '';
				$progression_date_acc = '';
				$progression_site = '';
				if(!empty($secondary_tumors)) {
					$date_and_acc_key = key($secondary_tumors);
					$key_data = explode('#',$date_and_acc_key);
					$progression_date = $key_data[0];
					$progression_date_acc = $key_data[1];
					$progression_site = array_shift($secondary_tumors[$date_and_acc_key]);
					if(empty($secondary_tumors[$date_and_acc_key])) unset($secondary_tumors[$date_and_acc_key]);
				}
				
				// Get Stage
				$stage = '';
				if($unit['DiagnosisMaster']['path_stage_summary']) {
					$stage = $unit['DiagnosisMaster']['path_stage_summary'];
				} else if($unit['DiagnosisMaster']['clinical_stage_summary']) {
					$stage = $unit['DiagnosisMaster']['clinical_stage_summary'];
				}
				
				// Records first diagnosis line data
				
				$unit['DiagnosisMaster']['ohri_tumor_site'];
				
				$this->validateTfriReportValue($unit['DiagnosisMaster']['ohri_tumor_site'], 'tumor_site', "Tumor Site", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($unit['DiagnosisDetail']['laterality'], 'laterality', "Laterality", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($unit['DiagnosisDetail']['histopathology'], 'histopathology', "Histopathology", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($unit['DiagnosisMaster']['tumour_grade'], 'grade', "Grade", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($progression_site, 'tumor_site', "Site of Tumor Progression (metastasis)  If Applicable", $sheet, $pid_bid_assoc[$participant_id]);
				$this->validateTfriReportValue($stage, 'stage', "Stage", $sheet, $pid_bid_assoc[$participant_id]);
				
				$line = array();
				$line[] = $pid_bid_assoc[$participant_id];
				$line[] = $unit['DiagnosisMaster']['dx_date'];
				$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? (empty($unit['DiagnosisMaster']['dx_date_accuracy'])? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']): '');
				$line[] = $unit['DiagnosisMaster']['ohri_tumor_site'];
				$line[] = $unit['DiagnosisMaster']['age_at_dx'];
				$line[] = $unit['DiagnosisDetail']['laterality'];
				$line[] = $unit['DiagnosisDetail']['histopathology'];
				$line[] = $unit['DiagnosisMaster']['tumour_grade'];
				$line[] = $stage;
				$line[] = $progression_date;
				$line[] = (!empty($progression_date)? $progression_date_acc: '');
				$line[] = $progression_site;
				$line[] = $unit['DiagnosisMaster']['survival_time_months'];
		
				echo implode(csv_separator, $line), "$new_line";
				
				// Records other progressions
				while(!empty($secondary_tumors)) {
					reset($secondary_tumors);
					$date_and_acc_key = key($secondary_tumors);
					$key_data = explode('#',$date_and_acc_key);
			
					$progression_date = $key_data[0];
					$progression_date_acc = $key_data[1];
					$progression_site = array_shift($secondary_tumors[$date_and_acc_key]);
				
					if(empty($secondary_tumors[$date_and_acc_key])) unset($secondary_tumors[$date_and_acc_key]);
			
					$this->validateTfriReportValue($progression_site, 'tumor_site', "Site of Tumor Progression (metastasis)  If Applicable", $sheet, $pid_bid_assoc[$participant_id]);
					
					$line = array();
					$line[] = $pid_bid_assoc[$participant_id];
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? (empty($unit['DiagnosisMaster']['dx_date_accuracy'])? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']): '');
					$line[] = $unit['DiagnosisMaster']['ohri_tumor_site'];
					$line[] = "";
					$line[] = "";
					$line[] = "";
					$line[] = "";
					$line[] = "";
					$line[] = $progression_date;
					$line[] = (!empty($progression_date)? $progression_date_acc: '');
					$line[] = $progression_site;
					$line[] = "";
						
					echo implode(csv_separator, $line), "$new_line";
				}	
			}
			unset($data);
			
			$this->displayTfriReportWarning($sheet);
			echo "$new_line";
		}

		// *********************************************** "SHEET 5 - Other Primary Cancer - Event ***********************************************
		
		{
			$sheet = "SHEET 5 - Other Primary Cancer - Event";
			echo "$new_line$new_line$sheet$new_line";
			
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
				"Chemotherapy Precision Drug4"
			);
			
			echo implode(csv_separator, $title_row),"$new_line";
			
			$other_event_from_participant_id = array();

			// Biopsy, Surgery
			
			$tx_data = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster 
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				INNER JOIN ohri_txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'surgery'
				AND TreatmentMaster.diagnosis_master_id IN(".implode(", ", $all_other_prim_and_sec_dx_mst_ids).")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);			
			foreach($tx_data as $index => $unit){
				$participant_id = $unit['TreatmentMaster']['participant_id'];
				$event = '';
				switch($unit['TreatmentDetail']['description']) {
					case 'biopsy':
						$event = 'biopsy';
						break;
					default:
						$event = 'surger';
				}
				$other_event_from_participant_id[$participant_id][] = array(
					"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
					"event"						=> $event,
					"event_start"				=> $unit['TreatmentMaster']['start_date'],
					"event_start_accuracy"		=> (empty($unit['TreatmentMaster']['start_date'])? '' : (empty($unit['TreatmentMaster']['start_date_accuracy'])? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
					"event_end"					=> "",
					"event_end_accuracy"		=> "",
					"drug1"						=> "",
					"drug2"						=> "",
					"drug3"						=> "",
					"drug4"						=> ""
				);
			}
			unset($tx_data);
	
			// Chemotherapy
			
			$tx_data = $this->Report->query("
					SELECT * FROM treatment_masters AS TreatmentMaster
					INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
					WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'chemotherapy'
					AND TreatmentMaster.diagnosis_master_id IN(".implode(", ", $all_other_prim_and_sec_dx_mst_ids).")
					ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
			foreach($tx_data as $index => $unit){
				$participant_id = $unit['TreatmentMaster']['participant_id'];
				$drug_data = $this->Report->query("
					SELECT * FROM txe_chemos
					INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
					WHERE txe_chemos.treatment_master_id = ".$unit['TreatmentMaster']['id']."
					AND txe_chemos.deleted = 0"
				);
				$drugs = array();
				$new_drug = current($drug_data);
				while($new_drug != null) {
					$drug = strtolower($new_drug['drugs']['generic_name']);
					$this->validateTfriReportValue($drug, 'drugs', "Drug", $sheet, $pid_bid_assoc[$participant_id]);
					$drugs[] = $drug;
					$new_drug = next($drug_data);
				}
				if(sizeof($drugs) > 4) $tfri_report_warnings[$sheet]["More than 4 drugs associated to a chemo"][$pid_bid_assoc[$participant_id]] = $pid_bid_assoc[$participant_id];
				$other_event_from_participant_id[$participant_id][] = array(
						"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
						"event"						=> 'chemotherapy',
						"event_start"				=> $unit['TreatmentMaster']['start_date'],
						"event_start_accuracy"		=> (empty($unit['TreatmentMaster']['start_date'])? '' : (empty($unit['TreatmentMaster']['start_date_accuracy'])? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
						"event_end"					=> $unit['TreatmentMaster']['finish_date'],
						"event_end_accuracy"		=> (empty($unit['TreatmentMaster']['finish_date'])? '' : (empty($unit['TreatmentMaster']['finish_date_accuracy'])? 'c' : $unit['TreatmentMaster']['finish_date_accuracy'])),
						"drug1"						=> (isset($drugs[0])? $drugs[0] : ''),
						"drug2"						=> (isset($drugs[1])? $drugs[1] : ''),
						"drug3"						=> (isset($drugs[2])? $drugs[2] : ''),
						"drug4"						=> (isset($drugs[3])? $drugs[3] : '')
				);
			}
			unset($tx_data);
			
			// Radiotherapy
				
			$tx_data = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster 
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'radiation'
				AND TreatmentMaster.diagnosis_master_id IN(".implode(", ", $all_other_prim_and_sec_dx_mst_ids).")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);			
			foreach($tx_data as $index => $unit){
				$participant_id = $unit['TreatmentMaster']['participant_id'];
				$event = '';
				$other_event_from_participant_id[$participant_id][] = array(
					"participant_biobank_id"	=> $pid_bid_assoc[$participant_id],
					"event"						=> 'radiotherapy',
					"event_start"				=> $unit['TreatmentMaster']['start_date'],
					"event_start_accuracy"		=> (empty($unit['TreatmentMaster']['start_date'])? '' : (empty($unit['TreatmentMaster']['start_date_accuracy'])? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
					"event_end"					=> $unit['TreatmentMaster']['finish_date'],
					"event_end_accuracy"		=> (empty($unit['TreatmentMaster']['finish_date'])? '' : (empty($unit['TreatmentMaster']['finish_date_accuracy'])? 'c' : $unit['TreatmentMaster']['finish_date_accuracy'])),
					"drug1"						=> "",
					"drug2"						=> "",
					"drug3"						=> "",
					"drug4"						=> ""
				);
			}
			unset($tx_data);
			
			ksort($other_event_from_participant_id);
			foreach($other_event_from_participant_id as $participant_events) {
				foreach($participant_events as $line) echo implode(csv_separator, $line), "$new_line";
			}
			unset($other_event_from_participant_id);
			
			$this->displayTfriReportWarning($sheet);
			echo "$new_line";
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
		global $new_line;
		
		echo "$new_line";
		if(isset($tfri_report_warnings[$sheet])) {
			foreach($tfri_report_warnings[$sheet] as $msg => $participant_ids) echo "$msg. See Bank# : ".implode (', ',$participant_ids)."$new_line";
		}
		echo "$new_line";
	}
}