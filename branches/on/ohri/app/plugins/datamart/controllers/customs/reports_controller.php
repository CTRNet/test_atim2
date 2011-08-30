<?php
class ReportsControllerCustom extends ReportsController {
	
	function manageReport($report_id, $csv_creation = false) {
		if($report_id == 7){
			if(isset($this->data['Participant']['id'])){
				$this->terryFox($this->data);
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
				"BRCA status"
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
					
//TODO validate with user we should take in consideration the last date of event, dx, trt as it's done below...

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
						WHERE event_masters.participant_id=".$participant_id." AND deleted != 1
						ORDER BY event_masters.event_date DESC");
					$line = array();
					$line[] = "OHRI-COEUR";
					$line[] = $unit['MiscIdentifier']['identifier_value'];
					$line[] = $unit['Participant']['date_of_birth'];
					$line[] = $unit['Participant']['date_of_birth_accuracy'];
					$line[] = $unit['Participant']['vital_status'];
					$line[] = $unit['Participant']['date_of_death'];
					$line[] = $unit['Participant']['date_of_death_accuracy'];
					$line[] = "";//suspected dod
					$line[] = "";//Suspected Date of Death date accuracy
					$line[] = $tmp_data[0][0]['last_contact_date'];
					$line[] = "";//last contact date acc
					$line[] = $family_history;
					$line[] = isset($brca_data[0]['EventDetail']['brca']) ? $brca_data[0]['EventDetail']['brca'] : ""; 
					
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
			echo "\n", implode(csv_separator, array("CANNOT FETCH ALL PARTICIPANTS - CHECK ALL HAVE A BANK NUMBER")), "\n";
		}
		$participant_ids[] = 0;
				
		//get nbre of diagnosis per particiapnt for dx, event, trt analysis
		
		$more_than_one_primary = array();
		$tmp_data = $this->Report->query("SELECT res.participant_id
			FROM (
				SELECT count( * ) AS nbr, participant_id FROM `diagnosis_masters` 
				WHERE deleted !=1 AND dx_origin IN ('primary','unknown') 
				AND participant_id IN(".implode(", ", $participant_ids).") GROUP BY participant_id
			) AS res WHERE res.nbr > 1", false);
		foreach($tmp_data as $res) $more_than_one_primary[] = $res['res']['participant_id'];
		
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
				'unknown'		=> 'undefined',
				''				=> ''
			);
			$i = 0;
			do{
				
//TODO Validate the change we did on diagnosis data (see custom sql file) with user to create primary for all scondary...
//TODO Some ovarian cancer are secondary... check with user it's true because they will be linked to other primary.			
//TODO When only one dx is recorded for one participant, should we link all trt, event to this dx when trt or event dx.id is null.			
				
				$data = $this->Report->query("
					SELECT * FROM diagnosis_masters AS DiagnosisMaster
					INNER JOIN ohri_dx_ovaries AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
					WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
					AND DiagnosisMaster.dx_origin='primary' AND DiagnosisMaster.diagnosis_control_id=14
					ORDER BY DiagnosisMaster.participant_id LIMIT 10 OFFSET ".($i * 10), false
				);
								
				foreach($data as $unit){
					
					// Get residual disease
					
					$warning = '';
					$residual_disease = null;
					$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
					INNER JOIN tx_masters ON TxDetail.tx_master_id=tx_masters.id
					WHERE tx_masters.deleted = 0 AND tx_masters.diagnosis_master_id=".$unit['DiagnosisMaster']['id'], false);
					if(empty($tx_data)){
						$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
						INNER JOIN tx_masters ON TxDetail.tx_master_id=tx_masters.id
						WHERE tx_masters.deleted = 0 AND tx_masters.participant_id=".$participant_id, false);
						if(!empty($tx_data) && in_array($participant_id, $more_than_one_primary)) {
							$warning = "CANNOT FETCH - TOO MANY UNLINKED PRIMARY DIAGNOSES";
						}
					}
					
					if(!empty($warning)) {
						$residual_disease = $warning;
					}else if(count($tx_data) == 1){
						$residual_disease = $residual_disease_array[$tx_data[0]['TxDetail']['residual_disease']];
					}else if(count($tx_data) > 1){
						$residual_disease = "CANNOT FETCH - TOO MANY RELATED TREATMENTS";
					}else{
						$residual_disease = 0;
					}
					
					// Get progression
					
					$secondary_tumors = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
						WHERE DiagnosisMaster.deleted=0 
						AND DiagnosisMaster.primary_number = ".$unit['DiagnosisMaster']['primary_number']."
						AND DiagnosisMaster.participant_id = ".$participant_id."
						AND DiagnosisMaster.dx_origin='secondary' ORDER BY DiagnosisMaster.dx_date ASC", false
					);
					
					$secondary_tumors_tmp = array();
					foreach($secondary_tumors as $new_secondary) {
						$key = $new_secondary['DiagnosisMaster']['dx_date'].'#'.$new_secondary['DiagnosisMaster']['dx_date_accuracy'];
						if(!array_key_exists($key, $secondary_tumors_tmp)) $secondary_tumors_tmp[$key] = array();
						
						$sub_key = sizeof($secondary_tumors_tmp[$key]);
						if(!empty($sub_key)) $sub_key--;					
						if(sizeof($secondary_tumors_tmp[$key][$sub_key]) == 2) $sub_key++;
						$secondary_tumors_tmp[$key][$sub_key][] = $new_secondary['DiagnosisMaster']['ohri_tumor_site'];	
					}
					$secondary_tumors=array();
					foreach($secondary_tumors_tmp as $key => $sub_array) {
						foreach($sub_array as $sub_key => $sub_sub_array) {
							$secondary_tumors[$key.'#'.$sub_key] = $sub_sub_array;
						}
					}
						
					$progression_date = '';
					$progression_date_acc = '';
					$progression_site_1 = '';
					$progression_site_2 = '';
					if(!empty($secondary_tumors)) {
						$key_to_split = key($secondary_tumors);
						$key_data = explode('#',$key_to_split);
						$progression_date = $key_data[0];
						$progression_date_acc = $key_data[1];
						$progression_site_1 = $secondary_tumors[$key_to_split][0];
						$progression_site_2 = (isset($secondary_tumors[$key_to_split][1]))? $secondary_tumors[$key_to_split][1] : '';
						next($secondary_tumors);
					}
					
					// Records first diagnosis line data
					
					$line = array();
					$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']]; //Patient Biobank Number (required)
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = $unit['DiagnosisMaster']['dx_date_accuracy'];
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
					$line[] = $progression_date_acc;//Date of Progression/Recurrence Accuracy
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
					while($key_to_split = key($secondary_tumors)) {
						$key_data = explode('#',$key_to_split);
						$progression_date = $key_data[0];
						$progression_date_acc = $key_data[1];
						$progression_site_1 = $secondary_tumors[$key_to_split][0];
						$progression_site_2 = (isset($secondary_tumors[$key_to_split][1]))? $secondary_tumors[$key_to_split][1] : '';
						
						$line = array();
						$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']]; //Patient Biobank Number (required)
						$line[] = $unit['DiagnosisMaster']['dx_date'];
						$line[] = $unit['DiagnosisMaster']['dx_date_accuracy'];
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
						$line[] = $progression_date_acc;//Date of Progression/Recurrence Accuracy
						$line[] = $progression_site_1;//Site 1 of Primary Tumor Progression (metastasis)  If Applicable
						$line[] = $progression_site_2;//Site 2 of Primary Tumor Progression (metastasis)  If applicable
						$line[] = "";//progression time (months)
						$line[] = "";//Date of Progression of CA125 Date
						$line[] = "";//Date of Progression of CA125 Accuracy
						$line[] = "";//CA125 progression time (months)
						$line[] = "";//Follow-up from ovarectomy (months)
						$line[] = "";//$unit['DiagnosisMaster']['survival_time_months'];
					
						echo implode(csv_separator, $line), "\n";
					
						next($secondary_tumors);
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
				"Chimiotherapy Precision Drug1",
				"Chimiotherapy Precision Drug2",
				"Chimiotherapy Precision Drug3",
				"Chimiotherapy Precision Drug4",
				"CA125  Precision (U)",
				"CT Scan Precision"
			);
			
			echo implode(csv_separator, $title_row),"\n";
			
			$i = 0;
			$data = array();
			do{
				$data1 = $this->Report->query("
					SELECT * FROM event_masters AS EventMaster 
					LEFT JOIN ohri_ed_lab_chemistries AS ed_with_ca125 ON ed_with_ca125.event_master_id=EventMaster.id
					LEFT JOIN ohri_ed_clinical_ctscans AS ed_with_ctscan ON ed_with_ctscan.event_master_id=EventMaster.id
					WHERE EventMaster.deleted=0 AND EventMaster.event_control_id IN(37, 39) AND EventMaster.participant_id IN(".implode(", ", $participant_ids).")
					LIMIT 10 OFFSET ".$i * 10, false
				);
				$data2 = $this->Report->query("
					SELECT * FROM tx_masters AS TxMaster 
					WHERE TxMaster.deleted=0 AND TxMaster.tx_control_id IN(5, 7) AND TxMaster.participant_id IN(".implode(", ", $participant_ids).")
					LIMIT 10 OFFSET ".$i * 10, false
				);
				
				foreach($data1 as $index => $unit){
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
					
					$data[sprintf("%010s_%s_b", $unit['EventMaster']['participant_id'], $index)] = array(
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
						"ca125"						=> $unit['ed_with_ca125']['CA125_u_ml'],
						"ctscan precision"			=> $ct_scan_precision
					);
				}
				
				foreach($data2 as $index => $unit){
					$drug1 = "";
					$drug2 = "";
					$drug3 = "";
					$drug4 = "";
					if($unit['TxMaster']['tx_control_id'] == 7){
						$tmp_data = $this->Report->query("
							SELECT * FROM txe_chemos 
							INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
							WHERE tx_master_id
						");
						if(($tmp_unit = current($tmp_data)) != null){
							$drug1 = $tmp_unit['drugs']['generic_name'];
						}
						if(($tmp_unit = next($tmp_data)) != null){
							$drug2 = $tmp_unit['drugs']['generic_name'];
						}
						if(($tmp_unit = next($tmp_data)) != null){
							$drug3 = $tmp_unit['drugs']['generic_name'];
						}
						if(($tmp_unit = next($tmp_data)) != null){
							$drug4 = $tmp_unit['drugs']['generic_name'];
						}
					}
					$data[sprintf("%010s_%s_b", $unit['TxMaster']['participant_id'], $index)] = array(
						"participant_biobank_id" 	=> $pid_bid_assoc[$unit['TxMaster']['participant_id']],
						"event"						=> $unit['TxMaster']['tx_control_id'] == 5 ? 'surgery (other)' : 'chimiotherapy',
						"event_start"				=> $unit['TxMaster']['start_date'],
						"event_start_accuracy"		=> $unit['TxMaster']['start_date_accuracy'],
						"event_end"					=> $unit['TxMaster']['finish_date'],
						"event_end_accuracy"		=> $unit['TxMaster']['finish_date_accuracy'],
						"drug1"						=> $drug1,
						"drug2"						=> $drug2,
						"drug3"						=> $drug3,
						"drug4"						=> $drug4,
						"ca125"						=> "",
						"ctscan precision"			=> ""//TODO
					);
				}

				++ $i;
			}while(!empty($data1) || !empty($data2));
			
			ksort($data);
			
			foreach($data as $line){
				echo implode(csv_separator, $line), "\n";
			}
		}
		
		//sheet 4 - Other Primary Cancer - Dx
		{
			echo "\n\nSHEET 4 - Other Primary Cancer -Diagnosis\n";
			$data = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN ohri_dx_others AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
				WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
				ORDER BY DiagnosisMaster.participant_id
			");
			
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
			
			foreach($data as $unit){
				$line = array();
				$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']];
				$line[] = $unit['DiagnosisMaster']['dx_date'];
				$line[] = $unit['DiagnosisMaster']['dx_date_accuracy'];
				$line[] = $unit['DiagnosisMaster']['ohri_tumor_site'];
				$line[] = $unit['DiagnosisMaster']['age_at_dx'];
				$line[] = $unit['DiagnosisDetail']['laterality'];
				$line[] = $unit['DiagnosisDetail']['histopathology'];
				$line[] = $unit['DiagnosisMaster']['tumour_grade'];
				$line[] = "";//Stage (clinical or pathologic??)
				$line[] = "";//Date of Progression/Recurrence Date
				$line[] = "";//Date of Progression/Recurrence Accuracy
				$line[] = "";//Site of Tumor Progression (metastasis)  If Applicable
				
				$line[] = $unit['DiagnosisMaster']['survival_time_months'];
				echo implode(csv_separator, $line), "\n";
			}
		}
		
		//sheet 5 - Other Primary Cancer - Event
		{
			//blank sheet, only the header
			echo "\n\nSHEET 5 - Other Primary Cancer - Event\n";
			
			$title_row = array(
				"Patient Biobank Number (required)",
				"Date of event (beginning) Date",
				"Date of event (beginning) Accuracy",
				"Date of event (end) Date",
				"Date of event (end) Accuracy",
				"Event Type",
				"Chimiotherapy Precision Drug1",
				"Chimiotherapy Precision Drug2",
				"Chimiotherapy Precision Drug3",
				"Chimiotherapy Precision Drug4"
			);
			
			echo implode(csv_separator, $title_row),"\n";
		}
		
		//sheet 6 - inventory
		{
			//blank sheet, only the header line
			echo "\n\nSHEET 6 - Inventory\n";
			$title_row = array(
				"Patient Biobank Number (required)",
				"Collected Specimen Type",
				"Date of Specimen Collection Date",
				"Date of Specimen Collection Accuracy",
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
				"Blood Precision Buffy coat"
			);
			
			echo implode(csv_separator, $title_row),"\n";
		}
		
		exit;
	}
	
}