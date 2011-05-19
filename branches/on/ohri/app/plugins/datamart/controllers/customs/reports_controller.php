<?php
class ReportsControllerCustom extends ReportsController {
	
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
					$tmp_data = $this->Report->query("SELECT MAX(last_chart_checked_date) AS last_chart_checked_date FROM
						(SELECT MAX(last_chart_checked_date) AS last_chart_checked_date FROM participants WHERE id=".$participant_id."
						UNION
						SELECT MAX(start_date) AS last_chart_checked_date FROM tx_masters WHERE participant_id=".$participant_id."
						UNION
						SELECT MAX(dx_date) AS last_chart_checked_date FROM diagnosis_masters WHERE participant_id=".$participant_id."
						UNION
						SELECT MAX(event_date) AS last_chart_checked_date FROM event_masters WHERE participant_id=".$participant_id.") AS tmp"
					, false);
					
					$fam_history_data = $this->Report->query("SELECT ohri_disease_site FROM family_histories AS FamilyHistory WHERE participant_id=".$participant_id, false);
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
						WHERE event_masters.participant_id=".$participant_id."
						ORDER BY event_masters.event_date DESC");
					$line = array();
					$line[] = $unit['MiscIdentifier']['identifier_value'];
					$line[] = $unit['Participant']['date_of_birth'];
					$line[] = $unit['Participant']['dob_date_accuracy'];
					$line[] = $unit['Participant']['vital_status'];
					$line[] = $unit['Participant']['date_of_death'];
					$line[] = $unit['Participant']['dod_date_accuracy'];
					$line[] = "";//suspected dod
//NL_NOTE: A confirmer avec OHRI => $unit['Participant']['date_of_death']; 
					$line[] = "";//Suspected Date of Death date accuracy
//NL_NOTE: A confirmer avec OHRI => $unit['Participant']['dod_date_accuracy'];
					$line[] = $tmp_data[0][0]['last_chart_checked_date'];
					$line[] = "";//last contact date acc
					$line[] = $family_history;
					$line[] = isset($brca_data[0]['EventDetail']['brca']) ? $brca_data[0]['EventDetail']['brca'] : ""; 
					
					echo implode(csv_separator, $line), "\n";
				}
				++ $i;
			}while(!empty($data));
		}
		
		$participant_ids = array_keys($pid_bid_assoc);
		$participant_ids[] = 0;
		
		//sheet 2 - EOC dx
		{
			echo "\n\nSHEET 2 - EOC - Diagnosis\n";
			
			$title_row = array(
				"Patient Biobank Number (required)",
				"Date of EOC Diagnosis Date",
				"Date of EOC Diagnosis Accuracy",
				"Presence of precursor of benign lesions",
				"fallopian tube lesions	Age at Time of Diagnosis (yr)",
				"Laterality",
				"Histopathology",
				"Grade",
				"FIGO",
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
			$i = 0;
			do{
				$data = $this->Report->query("
					SELECT * FROM diagnosis_masters AS DiagnosisMaster
					INNER JOIN ohri_dx_ovaries AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
					WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.participant_id IN(".implode(", ", $participant_ids).")
					AND DiagnosisMaster.dx_origin='primary' AND DiagnosisMaster.diagnosis_control_id=14
					ORDER BY DiagnosisMaster.participant_id LIMIT 10 OFFSET ".($i * 10), false
				);
//TODO NL_NOTE: Il faudra leur notfier que qq patient n'ont pas de primary 'diagnosis ohri - ovary' et donc n'auront pas de EOC dans atim terrifox ce qui est surprenant....
// >>select id, participant_id, dx_origin, diagnosis_control_id from diagnosis_masters where participant_id in (  select participant_id from diagnosis_masters where id not in (select id FROM diagnosis_masters where dx_origin = 'primary' AND diagnosis_control_id = 14)) order by participant_id;

				foreach($data as $unit){
					
					$residual_disease = null;
					$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
					INNER JOIN tx_masters ON TxDetail.tx_master_id=tx_masters.id
					WHERE tx_masters.diagnosis_master_id=".$unit['DiagnosisMaster']['id'], false);
					if(empty($tx_data)){
						$tx_data = $this->Report->query("SELECT residual_disease FROM ohri_txd_surgeries AS TxDetail
						INNER JOIN tx_masters ON TxDetail.tx_master_id=tx_masters.id
						WHERE tx_masters.participant_id=".$participant_id, false);
					}
					if(count($tx_data) == 1){
						$residual_disease = $tx_data[0]['TxDetail']['residual_disease'];
					}else if(count($tx_data) > 1){
						$residual_disease = "CANNOT FETCH - TOO MANY RELATED TREATMENTS";
					}else{
						$residual_disease = 0;
					}
					
					$line = array();
					$line[] = $pid_bid_assoc[$unit['DiagnosisMaster']['participant_id']];
					$line[] = $unit['DiagnosisMaster']['dx_date'];
					$line[] = $unit['DiagnosisMaster']['dx_date_accuracy'];
					$line[] = "";//Presence of precursor of benign lesions
					$line[] = "";//fallopian tube lesions	Age at Time of Diagnosis (yr)
					$line[] = $unit['DiagnosisDetail']['laterality'];
					$line[] = $unit['DiagnosisDetail']['histopathology'];
					$line[] = $unit['DiagnosisMaster']['tumour_grade'];
					$line[] = $unit['DiagnosisDetail']['figo'];
					$line[] = $residual_disease;
					$line[] = "";//Progression status
					$line[] = "";//Date of Progression/Recurrence Date
					$line[] = "";//Date of Progression/Recurrence Accuracy
					$line[] = "";
					$line[] = "";//Only one site
					$line[] = "";//progression time (months)
					$line[] = "";//Date of Progression of CA125 Date
					$line[] = "";//Date of Progression of CA125 Accuracy
					$line[] = "";//CA125 progression time (months)
					$line[] = "";//Follow-up from ovarectomy (months)
					$line[] = $unit['DiagnosisMaster']['survival_time_months'];
					
					echo implode(csv_separator, $line), "\n";
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
						"ctscan precision"			=> $unit['ed_with_ctscan']['response']
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
						"event"						=> $unit['TxMaster']['tx_control_id'] == 5 ? 'surgery(other)' : 'chimiotheraphy',
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
			echo "\n\nSHEET 5 - Other Primary Cancer - Event\n";
			
			//TODO: $data = $this->Result->query();
			
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
			
			//TODO: Print data
		}	
		
		exit;
	}
	
}