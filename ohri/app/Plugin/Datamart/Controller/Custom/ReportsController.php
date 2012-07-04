<?php
class ReportsControllerCustom extends ReportsController {
	
	function manageReport($report_id, $csv_creation = false) {
		if($report_id == 7){
			if(isset($this->request->data['Participant']['id'])){
				$this->terryFox($this->request->data);
			}else{
				$report = $this->Report->find('first',array('conditions' => array('Report.id' => $report_id, 'Report.flag_active' => '1')));
				$this->flash(__($report['Report']['description'],true) .'!<br> '. __('terryFox_report_no_participant',true), '/datamart/reports/index');
			}
		}else{
			parent::manageReport($report_id, $csv_creation);
		}
	}
	
	function terryFox(array $parameters){
		header ( "Content-Type: application/force-download" ); 
		header ( "Content-Type: application/octet-stream" ); 
		header ( "Content-Type: application/download" ); 
		header ( "Content-Type: text/csv" ); 
		header("Content-disposition:attachment;filename=terry_fox_".date('YMd_Hi').'.csv');
			
		App::import('model', 'Clinicalannotation.MiscIdentifier');
		$misc_identifier_model = new MiscIdentifier();
		
		$pid_bid_assoc = array();//participant id - biobank id association

		$supported_drugs = array(
			'cisplatinum' => 'cisplatinum',
			'carboplatinum' => 'carboplatinum',
			'oxaliplatinum' => 'oxaliplatinum',
			'paclitaxel' => 'paclitaxel',
			'topotecan' => 'topotecan',
			'ectoposide' => 'ectoposide',
			'tamoxifen' => 'tamoxifen',
			'doxetaxel' => 'doxetaxel',
			'doxorubicin' => 'doxorubicin',
			'other' => 'other',
			'etoposide' => 'etoposide',
			'gemcitabine' => 'gemcitabine',
			'procytox' => 'procytox',
			'vinorelbine' => 'vinorelbine',
			'cyclophosphamide' => 'cyclophosphamide',
		
			'carboplatin' => 'carboplatinum',
			'taxol' => 'paclitaxel');
		
		 $unsupported_drugs	= array();
		
		//sheet 1 - find all patients within the date range who have the bank id
		{	
			echo "SHEET 1 - Patients\n";
			$misc_identifier_model->bindModel(array('belongsTo' => array(
				'Participant' => array(
					'className' => 'Clinicalannotation.Participant',
					'foreignKey' => 'participant_id'),
				)));
			
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
			
			$i = 0;
			do{
				$data = $misc_identifier_model->find('all', array(
					'conditions'	=> array('MiscIdentifier.misc_identifier_control_id' => 2, 'MiscIdentifier.participant_id' => array_filter($parameters['Participant']['id'])), 
					'order'			=> array('MiscIdentifier.participant_id'),
					'limit' 		=> 10,
					'offset'		=> $i * 10));
				foreach($data as $unit){
					$participant_id = $unit['Participant']['id'];
					$pid_bid_assoc[$participant_id] = $unit['MiscIdentifier']['identifier_value'];
					
					$tmp_data = $this->Report->query("SELECT MAX(last_contact_date) AS last_contact_date FROM
						(SELECT MAX(consent_signed_date) AS last_contact_date FROM consent_masters WHERE id=".$participant_id." AND deleted != 1
						UNION
						SELECT MAX(start_date) AS last_contact_date FROM tx_masters WHERE participant_id=".$participant_id." AND deleted != 1
						UNION
						SELECT MAX(dx_date) AS last_contact_date FROM diagnosis_masters WHERE participant_id=".$participant_id." AND deleted != 1
						UNION
						SELECT MAX(event_date) AS last_contact_date FROM event_masters WHERE participant_id=".$participant_id." AND deleted != 1) AS tmp"
					, false);
					
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
					$line = array();
					$line[] = "OHRI-COEUR";
					$line[] = $unit['MiscIdentifier']['identifier_value'];
					$line[] = $unit['Participant']['date_of_birth'];
					$line[] = (!empty($unit['Participant']['date_of_birth'])? $unit['Participant']['date_of_birth_accuracy']: '');
					$line[] = $unit['Participant']['vital_status'];
					$line[] = $unit['Participant']['date_of_death'];
					$line[] = (!empty($unit['Participant']['date_of_death'])? $unit['Participant']['date_of_death_accuracy']: '');
					$line[] = "";//suspected dod
					$line[] = "";//Suspected Date of Death date accuracy
					$line[] = $tmp_data[0][0]['last_contact_date'];
					$line[] = "";//last contact date acc
					$line[] = $family_history;
					$line[] = isset($brca_data[0]['EventDetail']['brca']) ? $brca_data[0]['EventDetail']['brca'] : ""; 
					$line[] = "";//notes
					
					echo implode(csv_separator, $line), "\n";
				}
				++ $i;
			}while(!empty($data));
		}
		
		$submitted_participant_ids = array_filter($parameters['Participant']['id']);
		$participant_ids = array_keys($pid_bid_assoc);
		if(empty($submitted_participant_ids)) {
			echo "\n", implode(csv_separator, array("CANNOT FETCH PARTICIPANTS - NO PARTICIPANT SELECTED")), "\n";
		} else if(sizeof($participant_ids) != sizeof($submitted_participant_ids)) {
			$tmp_ids = array_diff($submitted_participant_ids, $participant_ids);
			$tmp_ids[] = 0;
			$missing_participants = $this->Report->query("SELECT participant_identifier FROM participants WHERE deleted != 1 AND id IN (".implode(", ", $tmp_ids).")", false);
			$echo_string = '';
			foreach($missing_participants as $tmp) {
				$echo_string .= ' ['.$tmp['participants']['participant_identifier'].'] ';
			}
			echo "\n", implode(csv_separator, array("CANNOT FETCH ALL PARTICIPANTS - CHECK BANK NUMBER EXISTS FOR FOLLOWING PARTICIPANT SYSTEM CODES : ".$echo_string)), "\n";
		}
		$participant_ids[] = 0;

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
		
		//sheet 2 - EOC dx
		{
			echo "\n\nSHEET 2 - EOC - Diagnosis\n";
			
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
			
			$residual_disease_array = array(
				'1-2cm' 		=> '1-2cm',
				'< 1cm' 		=> '<1cm',
				'> 2cm' 		=> '>2cm',
				'none visible'	=> 'none',
				'undefined'		=> 'unknown',
				''				=> ''
			);
			$i = 0;
			do{				
				$data = $this->Report->query("
					SELECT * FROM diagnosis_masters AS DiagnosisMaster
					INNER JOIN ohri_dx_ovaries AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
					WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
					AND DiagnosisMaster.dx_origin='primary' AND DiagnosisMaster.diagnosis_control_id=14
					ORDER BY DiagnosisMaster.participant_id LIMIT 10 OFFSET ".($i * 10), false
				);
								
				foreach($data as $unit){
					
					// Set eoc diagnosis master ids
					
					$eoc_diagnosis_master_ids['primary'][] = $unit['DiagnosisMaster']['id'];
					$secondary_data = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
						WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id = ".$unit['DiagnosisMaster']['participant_id']."
						AND DiagnosisMaster.dx_origin='secondary' AND DiagnosisMaster.primary_number =".$unit['DiagnosisMaster']['primary_number'], false);					
					foreach($secondary_data as $tmp) {
						$eoc_diagnosis_master_ids['secondary'][] = $tmp['DiagnosisMaster']['id'];
					}					
					
					// Get residual disease
					
					$warning = '';
					$residual_disease = null;
					$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
					INNER JOIN tx_masters ON TxDetail.tx_master_id=tx_masters.id
					WHERE tx_masters.deleted = 0 AND tx_masters.diagnosis_master_id=".$unit['DiagnosisMaster']['id'], false);
					if(empty($tx_data)){
						$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
						INNER JOIN tx_masters ON TxDetail.tx_master_id=tx_masters.id
						WHERE tx_masters.deleted = 0 AND tx_masters.participant_id=".$unit['DiagnosisMaster']['participant_id'], false);
						if(!empty($tx_data) && in_array($unit['DiagnosisMaster']['participant_id'], $paticipants_multi_primary)) {
							$warning = "CANNOT FETCH - TOO MANY UNLINKED PRIMARY DIAGNOSES";
						}
					}
					
					if(!empty($warning)) {
						$residual_disease = $warning;
					}else if(count($tx_data) == 1){
						$residual_disease = array_key_exists($tx_data[0]['TxDetail']['residual_disease'], $residual_disease_array)? $residual_disease_array[$tx_data[0]['TxDetail']['residual_disease']] : '';
					}else if(count($tx_data) > 1){
						$residual_disease = "CANNOT FETCH - TOO MANY RELATED TREATMENTS";
					}else{
						$residual_disease = '';
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
					
					// Records first diagnosis line data
					
					$line = array();
					$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']]; //Patient Biobank Number (required)
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = (!empty($unit['DiagnosisMaster']['dx_date'])? $unit['DiagnosisMaster']['dx_date_accuracy']: '');
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
						
						$line = array();
						$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']]; //Patient Biobank Number (required)
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
				++ $i;
			}while(!empty($data));
		}	
		
		//sheet 3 - EOC Event
		
		{
			echo "\n\nSHEET 3 - EOC\n";
			
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
					SELECT * FROM tx_masters AS TxMaster 
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
							WHERE txe_chemos.tx_master_id = ".$unit['TxMaster']['id']."
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
					SELECT * FROM tx_masters AS TxMaster 
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
							WHERE txe_chemos.tx_master_id = ".$unit['TxMaster']['id']."
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
	
}