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
	
	pr('Launch process to progression(s)');
	
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
		
		DiagnosisMaster.id AS dx_id,
		DiagnosisDetail.ca125_progression_time_in_months,
		DiagnosisDetail.progression_time_in_months
		
		FROM diagnosis_masters DiagnosisMaster
		INNER JOIN diagnosis_controls DiagnosisControl ON DiagnosisMaster.diagnosis_control_id = DiagnosisControl.id AND DiagnosisControl.category = 'primary' AND DiagnosisControl.controls_type = 'EOC'
		INNER JOIN qc_tf_dxd_eocs DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
		INNER JOIN participants Participant ON Participant.id = DiagnosisMaster.participant_id AND Participant.deleted != 1
		
		WHERE DiagnosisMaster.deleted != 1 
		AND (DiagnosisDetail.ca125_progression_time_in_months LIKE '' OR DiagnosisDetail.ca125_progression_time_in_months IS NULL OR DiagnosisDetail.progression_time_in_months LIKE '' OR DiagnosisDetail.progression_time_in_months IS NULL)";
	
	$res_eoc_dxs = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_eoc = mysqli_fetch_assoc($res_eoc_dxs)){
		$participant_id = $new_eoc['part_id'];
		$eoc_diagnosis_master_id = $new_eoc['dx_id'];
		
		$patient_description = " See patient with Bank# ".$new_eoc['qc_tf_bank_identifier']." (".$banks_from_id[$new_eoc['qc_tf_bank_id']].") [".$new_eoc['participant_identifier'].']';
		
		$update_progression = strlen($new_eoc['progression_time_in_months'])? false : true;
		$update_ca125_progression = strlen($new_eoc['ca125_progression_time_in_months'])? false : true;
		$eoc_data_to_update = array();
		$eoc_data_to_update_summary = array();
		
		// ** First Ovarectomy Selection **
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
			$messages['WARNING']['NO OVARECTOMY'][] = 'No ovarectomy. Unable to calculate "progression(s)".'.$patient_description;
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
					$messages['WARNING']['OVARECTOMY WITH EMPTY DATE'][] = 'At least one ovarectomy date is empty. Can have a consequence on first ovarectomy selection for "progression(s)" defintion.'.$patient_description;
				}
			} else if($res_first_ovarectomy->num_rows ) {
				$first_ovarectomy = mysqli_fetch_assoc($res_first_ovarectomy);
				$first_ovarectomy_date = $first_ovarectomy['start_date'];
				$first_ovarectomy_date_accuracy = $first_ovarectomy['start_date_accuracy'];
			}
			if(!$first_ovarectomy_date) {
				$messages['WARNING']['OVARECTOMY DATE MISSING'][] = 'Date is missing. Unable to calculate "progressions".'.$patient_description;
			} else if ($first_ovarectomy_date_accuracy != 'c') {
				$messages['WARNING']['OVARECTOMY DATE ACCURACY'][] = 'Date accuracy != c (='.$first_ovarectomy_date_accuracy.'). Unable to calculate "progressions".'.$patient_description;
				$first_ovarectomy_date = null;
				$first_ovarectomy_date_accuracy = null;
			} 
		}		

		// ** Progression **
		if($first_ovarectomy_date && $update_progression) {
			$first_site_recurrence_date = null;
			$first_site_recurrence_date_accuracy = null;
			$query = "
				SELECT
				DiagnosisMaster.id AS dx_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy
				FROM diagnosis_masters DiagnosisMaster
				INNER JOIN diagnosis_controls DiagnosisControl ON DiagnosisMaster.diagnosis_control_id = DiagnosisControl.id AND DiagnosisControl.category = 'secondary' AND DiagnosisControl.controls_type = 'progression and recurrence'
				WHERE DiagnosisMaster.primary_id = $eoc_diagnosis_master_id AND DiagnosisMaster.qc_tf_progression_detection_method = 'site detection' AND DiagnosisMaster.deleted != 1";
			$res_site_recurrences = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			if($res_site_recurrences->num_rows == 0) {
				$messages['WARNING']['NO PROGRESSION ON OTHER SITE'][] = 'No progression on other site. Unable to calculate "Progression Time (months)".'.$patient_description;
			} else {
				if($res_site_recurrences->num_rows > 1) {
					$empty_date = false;
					while($new_site_recurrence = mysqli_fetch_assoc($res_site_recurrences)) {
						if(empty($new_site_recurrence['dx_date'])) $empty_date = true;
						if(!$first_site_recurrence_date) {
							$first_site_recurrence_date = $new_site_recurrence['dx_date'];
							$first_site_recurrence_date_accuracy = $new_site_recurrence['dx_date_accuracy'];
						}
					}
					if($empty_date) {
						$messages['WARNING']['PROGRESSION ON OTHER SITE WITH EMPTY DATE'][] = 'At least one progression (on other site) date is empty. Can have a consequence on "Progression Time (months)" defintion.'.$patient_description;
					}
				} else if($res_site_recurrences->num_rows ) {
					$first_site_recurrence = mysqli_fetch_assoc($res_site_recurrences);
					$first_site_recurrence_date = $first_site_recurrence['dx_date'];
					$first_site_recurrence_date_accuracy = $first_site_recurrence['dx_date_accuracy'];
				}
				if(!$first_site_recurrence_date) {
					$messages['WARNING']['PROGRESSION ON OTHER SITE DATE MISSING'][] = 'Date is missing. Unable to calculate "Progression Time (months)".'.$patient_description;
				} else if ($first_site_recurrence_date_accuracy != 'c') {
					$messages['WARNING']['PROGRESSION ON OTHER SITE DATE ACCURACY'][] = 'Date accuracy != c (='.$first_site_recurrence_date_accuracy.'). Unable to calculate "Progression Time (months)".'.$patient_description;
					$first_site_recurrence_date = null;
					$first_site_recurrence_date_accuracy = null;
				}
			}
			if($first_site_recurrence_date) {
				if($first_site_recurrence_date < $first_ovarectomy_date) {
					$messages['ERROR']['OVARECTOMY DATE & PROGRESSION ON OTHER SITE DATES ERROR'][] = 'Progression on other site Date < ovarectomy date. Unable to calculate "Progression Time (months)"'.$patient_description;
				} else {
					$datetime1 = new DateTime($first_ovarectomy_date);
					$datetime2 = new DateTime($first_site_recurrence_date);
					$interval = $datetime1->diff($datetime2);
					$progression_time_in_months = (($interval->format('%y')*12) + $interval->format('%m'));
					$eoc_data_to_update[] = "progression_time_in_months = '$progression_time_in_months'";
					$eoc_data_to_update_summary[] = " progression-time(in months) = '$progression_time_in_months'";
				}
			}
		}
		
		// ** CA125 Progression **
		if($first_ovarectomy_date && $update_ca125_progression) {
			$first_ca125_recurrence_date = null;
			$first_ca125_recurrence_date_accuracy = null;
			$query = "
				SELECT
				DiagnosisMaster.id AS dx_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy
				FROM diagnosis_masters DiagnosisMaster
				INNER JOIN diagnosis_controls DiagnosisControl ON DiagnosisMaster.diagnosis_control_id = DiagnosisControl.id AND DiagnosisControl.category = 'secondary' AND DiagnosisControl.controls_type = 'progression and recurrence'
				WHERE DiagnosisMaster.primary_id = $eoc_diagnosis_master_id AND DiagnosisMaster.qc_tf_progression_detection_method = 'ca125' AND DiagnosisMaster.deleted != 1";
			$res_ca125_recurrences = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			if($res_ca125_recurrences->num_rows == 0) {
				$messages['WARNING']['NO CA125 PROGRESSION'][] = 'No ca125 progression. Unable to calculate "CA125 progression time in months ".'.$patient_description;
			} else {
				if($res_ca125_recurrences->num_rows > 1) {
					$empty_date = false;
					while($new_ca125_recurrence = mysqli_fetch_assoc($res_ca125_recurrences)) {
						if(empty($new_ca125_recurrence['dx_date'])) $empty_date = true;
						if(!$first_ca125_recurrence_date) {
							$first_ca125_recurrence_date = $new_ca125_recurrence['dx_date'];
							$first_ca125_recurrence_date_accuracy = $new_ca125_recurrence['dx_date_accuracy'];
						}
					}
					if($empty_date) {
						$messages['WARNING']['CA125 PROGRESSION WITH EMPTY DATE'][] = 'At least one ca125 progression date is empty. Can have a consequence on "CA125 progression time in months " defintion.'.$patient_description;
					}
				} else if($res_ca125_recurrences->num_rows ) {
					$first_ca125_recurrence = mysqli_fetch_assoc($res_ca125_recurrences);
					$first_ca125_recurrence_date = $first_ca125_recurrence['dx_date'];
					$first_ca125_recurrence_date_accuracy = $first_ca125_recurrence['dx_date_accuracy'];
				}
				if(!$first_ca125_recurrence_date) {
					$messages['WARNING']['CA125 PROGRESSION DATE MISSING'][] = 'Date is missing. Unable to calculate "CA125 progression time in months ".'.$patient_description;
				} else if ($first_ca125_recurrence_date_accuracy != 'c') {
					$messages['WARNING']['CA125 PROGRESSION DATE ACCURACY'][] = 'Date accuracy != c (='.$first_ca125_recurrence_date_accuracy.'). Unable to calculate "CA125 progression time in months ".'.$patient_description;
					$first_ca125_recurrence_date = null;
					$first_ca125_recurrence_date_accuracy = null;
				}
			}
			if($first_ca125_recurrence_date) {
				if($first_ca125_recurrence_date < $first_ovarectomy_date) {
					$messages['ERROR']['OVARECTOMY DATE & CA125 PROGRESSION DATES ERROR'][] = 'CA125 Progression Date < ovarectomy date. Unable to calculate "CA125 progression time in months "'.$patient_description;
				} else {
					$datetime1 = new DateTime($first_ovarectomy_date);
					$datetime2 = new DateTime($first_ca125_recurrence_date);
					$interval = $datetime1->diff($datetime2);
					$ca125_progression_time_in_months = (($interval->format('%y')*12) + $interval->format('%m'));
					$eoc_data_to_update[] = "ca125_progression_time_in_months = '$ca125_progression_time_in_months'";
					$eoc_data_to_update_summary[] = " ca125-progression-time(in months) = '$ca125_progression_time_in_months'";
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