<?php

	// FILE created to update data directly into DB.
	// Not a file of the dataimporter
	
	//-----------------------------------------------------------------------------------------------------------------------------
	$db_ip			= "127.0.0.1";
	$db_port 		= "3306";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_schema		= "coeur";
	$db_charset		= "utf8";
	//-----------------------------------------------------------------------------------------------------------------------------
	$db_connection = @mysqli_connect(
			$db_ip.":".$db_port,
			$db_user,
			$db_pwd
	) or die("Could not connect to MySQL");
	if(!mysqli_set_charset($db_connection, $db_charset)){
		die("Invalid charset");
	}
	@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
	mysqli_autocommit($db_connection, true);	
	//-----------------------------------------------------------------------------------------------------------------------------
	
	$messages = array('ERROR'=>array(), 'WARNING'=>array(), 'MESSAGE'=>array());
	
	pr('Launch process to calculate missing survival and follow-up');
	
	// ** Clean-up PARTICIPANTS **

	$banks_from_id = array();
	$query = "SELECT id, name FROM banks;";
	$banks_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");	
	while($new_bank = mysqli_fetch_assoc($banks_res)) $banks_from_id[$new_bank['id']] = $new_bank['name'];

	$query = "
		SELECT
		
		Participant.id AS part_id,
		Participant.participant_identifier,
		Participant.qc_tf_bank_identifier,
		Participant.qc_tf_bank_id,
		Participant.qc_tf_last_contact,
		Participant.qc_tf_last_contact_accuracy,
		
		DiagnosisMaster.id AS dx_id,
		DiagnosisMaster.dx_date,
		DiagnosisMaster.dx_date_accuracy,
		DiagnosisDetail.follow_up_from_ovarectomy_in_months,
		DiagnosisDetail.survival_from_ovarectomy_in_months
		
		FROM diagnosis_masters DiagnosisMaster
		INNER JOIN diagnosis_controls DiagnosisControl ON DiagnosisMaster.diagnosis_control_id = DiagnosisControl.id AND DiagnosisControl.category = 'primary' AND DiagnosisControl.controls_type = 'EOC'
		INNER JOIN qc_tf_dxd_eocs DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
		INNER JOIN participants Participant ON Participant.id = DiagnosisMaster.participant_id AND Participant.deleted != 1
		WHERE DiagnosisMaster.deleted != 1 AND (DiagnosisDetail.follow_up_from_ovarectomy_in_months LIKE '' OR DiagnosisDetail.follow_up_from_ovarectomy_in_months IS NULL
		OR DiagnosisDetail.survival_from_ovarectomy_in_months LIKE '' OR DiagnosisDetail.survival_from_ovarectomy_in_months IS NULL)";
	$res_eoc_dxs = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_eoc = mysqli_fetch_assoc($res_eoc_dxs)){
		$participant_id = $new_eoc['part_id'];
		$eoc_diagnosis_master_id = $new_eoc['dx_id'];
		$qc_tf_last_contact = $new_eoc['qc_tf_last_contact'];
		$qc_tf_last_contact_accuracy = $new_eoc['qc_tf_last_contact_accuracy'];
		
		$patient_description = " See patient with Bank# ".$new_eoc['qc_tf_bank_identifier']." (".$banks_from_id[$new_eoc['qc_tf_bank_id']].") [".$new_eoc['participant_identifier'].']';
		
		$update_follow_up = strlen($new_eoc['follow_up_from_ovarectomy_in_months'])? false : true;
		$update_survival = strlen($new_eoc['survival_from_ovarectomy_in_months'])? false : true;
		
		if(!$qc_tf_last_contact) {
			$messages['WARNING']['LAST CONTACT DATE MISSING'][] = 'Date is missing. Unable to calculate'.($update_follow_up? ' "follow up"': '').($update_survival? ' "Survival"': '').$patient_description;
		} else if($qc_tf_last_contact_accuracy != 'c') {
			$messages['WARNING']['LAST CONTACT DATE ACCURACY'][] = 'Date accuracy != c (='.$qc_tf_last_contact_accuracy.'). Unable to calculate'.($update_follow_up? ' "follow up"': '').($update_survival? ' "Survival"': '').$patient_description;
		} else {
			$eoc_data_to_update = array();
			$eoc_data_to_update_summary = array();
			
			if($update_survival) {
				$eoc_dx_date = $new_eoc['dx_date'];
				$eoc_dx_date_accuracy = $new_eoc['dx_date_accuracy'];
				
				// Survival
				if(!$eoc_dx_date) {
					$messages['WARNING']['EOC DX DATE MISSING'][] = 'Date is missing. Unable to calculate "Survival".'.$patient_description;
				} else if($eoc_dx_date_accuracy != 'c') {
					$messages['WARNING']['EOC DX DATE ACCURACY'][] = 'Date accuracy != c (='.$eoc_dx_date_accuracy.'). Unable to calculate "Survival".'.$patient_description;
				} else {
					if($qc_tf_last_contact < $eoc_dx_date) {
						$messages['ERROR']['EOC & LAST CONTACT DATES ERROR'][] = 'Last Contact Date < EOC date. Unable to calculate "Survival".'.$patient_description;
					} else {
						$datetime1 = new DateTime($eoc_dx_date);
						$datetime2 = new DateTime($qc_tf_last_contact);
						$interval = $datetime1->diff($datetime2);	
						$survival_from_ovarectomy_in_months = (($interval->format('%y')*12) + $interval->format('%m'));	
						$eoc_data_to_update[] = "survival_from_ovarectomy_in_months = '$survival_from_ovarectomy_in_months'";
						$eoc_data_to_update_summary[] = " survival = '$survival_from_ovarectomy_in_months' ";
					}
				}
			}
			
			if($update_follow_up) {		
				//First Ovarectomy Selection		
				$first_ovarectomy_date = null;
				$first_ovarectomy_date_accuracy = null;
				$query = "
					SELECT
					TreatmentMaster.id,
					TreatmentMaster.participant_id,
					TreatmentMaster.start_date,
					TreatmentMaster.start_date_accuracy
					FROM treatment_masters TreatmentMaster
					INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id AND TreatmentControl.disease_site = 'EOC' AND TreatmentControl.tx_method = 'ovarectomy'
					WHERE TreatmentMaster.deleted != 1 AND TreatmentMaster.diagnosis_master_id = $eoc_diagnosis_master_id AND TreatmentMaster.participant_id = $participant_id
					ORDER BY TreatmentMaster.start_date ASC";
				$res_first_ovarectomy = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
				if($res_first_ovarectomy->num_rows == 0) {
					$messages['WARNING']['NO OVARECTOMY'][] = 'No ovarectomy. Unable to calculate "followup".'.$patient_description;
				} else {
					if($res_first_ovarectomy->num_rows > 1) {
						$empty_date = false;
						while($new_ovarectomy = mysqli_fetch_assoc($res_first_ovarectomy)) {
							if(empty($new_ovarectomy['start_date'])) $empty_date = true;
							if(!$first_ovarectomy_date) {
								$first_ovarectomy_date = $new_ovarectomy['start_date'];
								$first_ovarectomy_date_accuracy = $new_ovarectomy['start_date_accuracy'];
							}
						}
						if($empty_date) {
							$messages['WARNING']['OVARECTOMY WITH EMPTY DATE'][] = 'At least one ovarectomy date is empty. Can have a consequence on first ovarectomy selection for "follow up" defintion.'.$patient_description;
						}
					} else if($res_first_ovarectomy->num_rows ) {
						$first_ovarectomy = mysqli_fetch_assoc($res_first_ovarectomy);
						$first_ovarectomy_date = $first_ovarectomy['start_date'];
						$first_ovarectomy_date_accuracy = $first_ovarectomy['start_date_accuracy'];
					} else {
						
					}
					//First Ovarectomy Selection
					if(!$first_ovarectomy_date) {
						$messages['WARNING']['OVARECTOMY DATE MISSING'][] = 'Date is missing. Unable to calculate "followup".'.$patient_description;
					} else if ($first_ovarectomy_date_accuracy != 'c') {
						$messages['WARNING']['OVARECTOMY DATE ACCURACY'][] = 'Date accuracy != c (='.$first_ovarectomy_date_accuracy.'). Unable to calculate "followup".'.$patient_description;
					} else {
						if($qc_tf_last_contact < $first_ovarectomy_date) {
							$messages['ERROR']['OVARECTOMY DATE & LAST CONTACT DATES ERROR'][] = 'Last Contact Date < ovarectomy date. nable to calculate "followup"'.$patient_description;
						} else {
							$datetime1 = new DateTime($first_ovarectomy_date);
							$datetime2 = new DateTime($qc_tf_last_contact);
							$interval = $datetime1->diff($datetime2);	
							$follow_up_from_ovarectomy_in_months = (($interval->format('%y')*12) + $interval->format('%m'));
							$eoc_data_to_update[] = "follow_up_from_ovarectomy_in_months = '$follow_up_from_ovarectomy_in_months'";
							$eoc_data_to_update_summary[] = " follow-up= '$follow_up_from_ovarectomy_in_months'";
						}	
					}
				}				
					
				if(!empty($eoc_data_to_update)) {
					$messages['MESSAGE']['DATA UPDATE SUMMARY'][] = $patient_description.' = = = => '.implode('&', $eoc_data_to_update_summary);
					
					$query = "UPDATE qc_tf_dxd_eocs SET ".implode(',',$eoc_data_to_update)." WHERE diagnosis_master_id = $eoc_diagnosis_master_id";
					mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
					$query = str_replace("qc_tf_dxd_eocs", "qc_tf_dxd_eocs_revs", $query);
					mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
				}	
			}
		}
	}
	
	$line_break_tag = '<BR>';
	foreach($messages as $message_type => $msg_arr) {
		$color = str_replace(array('ERROR','WARNING','MESSAGE'),array('red','orange','green'),$message_type);
		
		echo "".$line_break_tag."".$line_break_tag."<FONT COLOR=\"".$color."\" >
		=====================================================================".$line_break_tag."".$line_break_tag."
		PROCESS SUMMARY: $message_type
		".$line_break_tag."".$line_break_tag."=====================================================================
		</FONT>".$line_break_tag."";

		foreach($msg_arr as $type => $msgs) {
			echo "".$line_break_tag." --> <FONT COLOR=\"".$color."\" >". utf8_decode($type) . "</FONT>".$line_break_tag."";
			foreach($msgs as $msg) echo "$msg".$line_break_tag."";
		}
	}
	
//====================================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}
	
?>