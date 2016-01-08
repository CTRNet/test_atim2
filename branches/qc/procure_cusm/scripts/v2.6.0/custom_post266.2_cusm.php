<?php 

//==================================================================================================================================================================================
// DATABSE CONNECTION
//==================================================================================================================================================================================

$db_port = "";
$db_user = "root";
$db_pwd = "";
$db_schemas = "procurecusm";
$db_charset = "utf8";

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("ERR_DATABASE_CONNECTION: Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)) die("ERR_DATABASE_CONNECTION: Invalid charset");

@mysqli_select_db($db_connection,$db_schemas) or die("ERR_CENTRAL_SCHEMA: Unable to use central database : $db_schemas");
mysqli_autocommit ($db_connection , true);

$form_query_res = getSelectQueryResult("SELECT id FROM users WHERE username LIKE 'NicoEn'");
$user_id = $form_query_res[0]['id'];
$form_query_res = getSelectQueryResult("SELECT NOW() as date FROM users WHERE username LIKE 'NicoEn'");
$date = $form_query_res[0]['date'];

global $all_queries;
$all_queries = array();

$query = "SELECT procure_form_identification FROM (
	SELECT count(*) as nbr, TreatmentMaster.procure_form_identification FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id WHERE deleted <> 1 AND TreatmentControl.tx_method IN ('procure medication worksheet') GROUP BY TreatmentMaster.procure_form_identification
) res WHERE res.nbr > 1;";

$form_query_res = getSelectQueryResult($query);
pr("<font color='blue'>".sizeof($form_query_res)." Medication Worksheets Identification are duplicated. Process to merge form run on $date.</font><br>");
$form_identifications_counters = array();
foreach($form_query_res as $new_form) {
	$form_identifications_counters[$new_form['procure_form_identification']] = 0;
	pr(" - See ".$new_form['procure_form_identification']);
}

$treatment_masters_fields = array();
$query_result = customQuery("DESC treatment_masters");
while($row = $query_result->fetch_assoc()) {
	$treatment_masters_fields[] = $row['Field'];
}
$procure_txd_medications_fields = array();
$query_result = customQuery("DESC procure_txd_medications");
while($row = $query_result->fetch_assoc()) {
	$procure_txd_medications_fields[] = $row['Field'];
}

$query = 'SELECT TreatmentMaster.*, TreatmentDetail.*
	FROM treatment_masters AS TreatmentMaster INNER JOIN procure_txd_medications AS TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
	WHERE TreatmentMaster.procure_form_identification IN ("'.implode('","',array_keys($form_identifications_counters)).'")
	AND deleted <> 1 ORDER BY procure_form_identification, start_date;';
$form_query_res = getSelectQueryResult($query);
$data_sorted_by_form_id = array();
$counter = 0;
foreach($form_query_res as $new_form) {
	$data_sorted_by_form_id[$new_form['procure_form_identification']][] = $new_form;
	$counter++;
}
pr("<br><font color='blue'>Process will work on $counter forms.</font><br>");

$forms_merged = array();
$forms_to_work_on = array();
foreach ($data_sorted_by_form_id as $procure_form_identification => $all_records) {
	$records = $all_records;
	$main_record = $records[0];
	$main_record['notes'] = array($main_record['notes']);
	unset($records[0]);
	$can_be_merged = true;
	$other_ids = array();
	foreach($records as $duplicated_record) {	
		$other_ids[] = $duplicated_record['id'];
		foreach($duplicated_record as $field => $value) {
			if(!in_array($field, array('id','notes','created','created_by','modified','modified_by', 'treatment_master_id', 'patient_identity_verified'))) {
				if(strlen($main_record[$field]) && strlen($duplicated_record[$field])) {
					if($main_record[$field] != $duplicated_record[$field]) {
						$can_be_merged = false;
					}
				} else if(strlen($duplicated_record[$field])) {
					if($field == 'start_date') {
						$can_be_merged = false;
					} else {
						$main_record[$field] = $duplicated_record[$field];
					}
				}else if(strlen($main_record[$field]) && $field == 'start_date') {
					$can_be_merged = false;
				}
			}
		}	
		$main_record['notes'][] = $duplicated_record['notes'];
		if($duplicated_record['patient_identity_verified']) $main_record['patient_identity_verified'] = $duplicated_record['patient_identity_verified'];	
	}
	if($can_be_merged) {
		//Merge and record data on first form
		$main_record['notes'] = array_filter($main_record['notes']);
		$main_record['notes'] = implode('. ', $main_record['notes']);
		$forms_merged[] = $main_record['procure_form_identification'];
		$tm_set = array("modified = '$date'",  "modified_by = $user_id");
		foreach($treatment_masters_fields as $field) {
			if(!in_array($field, array('id','created','created_by','modified','modified_by','diagnosis_master_id','protocol_master_id'))) {
				$tm_set[] = "$field = '".str_replace("'", "''", $main_record[$field])."'";
			}
		}
		$query = "UPDATE treatment_masters SET ".implode(',', $tm_set)." WHERE id = ".$main_record['id'];
		customQuery($query);
		$td_set = array();
		foreach($procure_txd_medications_fields as $field) {
			$td_set[] = "$field = '".str_replace("'", "''", $main_record[$field])."'";
		}
		$query = "UPDATE procure_txd_medications SET ".implode(',', $td_set)." WHERE treatment_master_id = ".$main_record['id'];
		customQuery($query);
		//delete the other one
		$query = "UPDATE treatment_masters 
			SET modified = '$date',
			modified_by = $user_id,
			deleted = 1
			WHERE id IN (".implode(',',$other_ids).")";
		customQuery($query);
	} else {
		//Forms Can Not Be Merged
		foreach($all_records as $tmp_id => $new_form) {
			$forms_to_work_on[$new_form['procure_form_identification']] = $new_form['procure_form_identification'];
			$query = "UPDATE treatment_masters 
				SET procure_form_identification = '".$new_form['procure_form_identification']."-dup".($tmp_id+1)."',
				modified = '$date',
				modified_by = $user_id
				WHERE id = ".$new_form['id'];
			customQuery($query);
		}
	}
}

pr("<br><font color='blue'>Medication Worksheets Identification merged together:</font><br>");
foreach($forms_merged as $procure_form_identification) {
	pr(" - See $procure_form_identification");
}

pr("<br><font color='blue'>Medication Worksheets Identification that could not be merged together (to work on after migration):</font><br>");
foreach($forms_to_work_on as $procure_form_identification) {
	pr(" - See $procure_form_identification");
}

//Revs Table

$query = "INSERT INTO treatment_masters_revs(id,treatment_control_id,tx_intent,target_site_icdo,start_date,start_date_accuracy,finish_date,finish_date_accuracy,information_source,
	facility,notes,protocol_master_id,participant_id,diagnosis_master_id,procure_form_identification,procure_created_by_bank,version_created,modified_by)
	(SELECT id,treatment_control_id,tx_intent,target_site_icdo,start_date,start_date_accuracy,finish_date,finish_date_accuracy,information_source,
	facility,notes,protocol_master_id,participant_id,diagnosis_master_id,procure_form_identification,procure_created_by_bank,modified,modified_by FROM treatment_masters 
	WHERE modified = '$date' AND modified_by = $user_id)";
customQuery($query);

$query = "INSERT INTO  procure_txd_medications_revs (patient_identity_verified,medication_for_prostate_cancer,medication_for_benign_prostatic_hyperplasia,medication_for_prostatitis,benign_hyperplasia,benign_hyperplasia_place_and_date,
	benign_hyperplasia_notes,prescribed_drugs_for_other_diseases,list_of_drugs_for_other_diseases,photocopy_of_drugs_for_other_diseases,dosages_of_drugs_for_other_diseases,
	open_sale_drugs,treatment_master_id,version_created)
	(SELECT patient_identity_verified,medication_for_prostate_cancer,medication_for_benign_prostatic_hyperplasia,medication_for_prostatitis,benign_hyperplasia,benign_hyperplasia_place_and_date,
	benign_hyperplasia_notes,prescribed_drugs_for_other_diseases,list_of_drugs_for_other_diseases,photocopy_of_drugs_for_other_diseases,dosages_of_drugs_for_other_diseases,
	open_sale_drugs,treatment_master_id,modified
	FROM treatment_masters INNER JOIN procure_txd_medications ON id = treatment_master_id
	WHERE modified = '$date' AND modified_by = $user_id)";
customQuery($query);


pr("<br><br>=======================================================================================================================================<br>");
foreach($all_queries as $new_query) pr("<i>$new_query</i>");
/**
 * Exeute an sql statement.
 *
 * @param string $query SQL statement
 * @param boolean $insert True for any $query being an INSERT statement
 *
 * @return multitype Id of the insert when $insert set to TRUE else the mysqli_result object
 */
function customQuery($query, $insert = false) {
	global $db_connection;
	global $all_queries;
	$all_queries[] = $query;
	$query_res = mysqli_query($db_connection, $query) or mergeDie(array("ERR_QUERY", mysqli_error($db_connection), $query));
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}

/**
 * Execute an sql SELECT statement and return results into an array.
 *
 * @param string $query SQL statement
 *
 * @return array Query results in an array
 */
function getSelectQueryResult($query) {
	if(!preg_match('/^[\ ]*((SELECT)|(SHOW))/i', $query))  mergeDie(array("ERR_QUERY", "'SELECT' query expected", $query));
	$select_result = array();
	$query_result = customQuery($query);
	while($row = $query_result->fetch_assoc()) {
		$select_result[] = $row;
	}
	return $select_result;
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

?>