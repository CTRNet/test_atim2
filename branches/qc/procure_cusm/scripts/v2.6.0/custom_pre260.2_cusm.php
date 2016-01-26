<?php 

//==================================================================================================================================================================================
// DATABSE CONNECTION
//==================================================================================================================================================================================

$db_ip = "localhost";
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

$query = "SELECT Participant.participant_identifier, TreatmentMaster.id, TreatmentMaster.participant_id, TreatmentMaster.procure_form_identification, TreatmentMaster.notes, TreatmentDetail.*
	FROM treatment_masters TreatmentMaster,  treatment_controls TreatmentControl, participants Participant, procure_txd_medications TreatmentDetail
	WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
	AND Participant.id = TreatmentMaster.participant_id
	AND procure_form_identification REGEXP CONCAT('^',Participant.participant_identifier, ' V[0]{1,2} -MED')
	AND TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet'
	AND TreatmentMaster.id = TreatmentDetail.treatment_master_id";	
$form_query_res = getSelectQueryResult($query);
pr(sizeof($form_query_res)." Medication Worksheets have identification visit like 'V0' or 'V00'. Process will try to clean up forms.");

$form_with_empty_date = array();
$empty_form_to_delete = array();
$patient_with_no_collection_date = array();
$patient_with_many_collection_date = array();
$creation_messages = array();
$V01_creation_messages_with_warning = array();

foreach($form_query_res as $new_form) {
	$is_empty = true;
	foreach($new_form as $field => $value) {
		if(strlen(trim($value)) && !in_array($field, array('participant_identifier', 'procure_form_identification', 'treatment_master_id', 'patient_identity_verified'))) {
			$is_empty = false;
		}
	}
	if($is_empty) {
		$empty_form_to_delete[$new_form['id']] = $new_form['procure_form_identification'];
	} else if(empty($new_form['id_confirmation_date'])) {
		//Unable to set visit
		$form_with_empty_date[$new_form['id']] = $new_form['procure_form_identification'];
	} else {
		$query = "SELECT DISTINCT collection_datetime, collection_datetime_accuracy
			FROM collections Collection
			INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
			INNER JOIN sample_controls SampleControl ON SampleControl.sample_type = 'tissue' AND SampleControl.id = SampleMaster.sample_control_id
			WHERE SampleMaster.deleted <> 1 AND collection_datetime IS NOT NULL AND Collection.participant_id = ".$new_form['participant_id'];
		$collection_query_res = getSelectQueryResult($query);
		if($collection_query_res) {
			if(sizeof($collection_query_res) == 1) {
				$new_medication_form = '';
				$prostatectomy_date = substr($collection_query_res[0]['collection_datetime'], 0, strpos($collection_query_res[0]['collection_datetime'], ' '));
				$visit_date = $new_form['id_confirmation_date'];
				$prostatectomy_date_ob = new DateTime($prostatectomy_date);
				$visit_date_ob = new DateTime($visit_date);
				$interval = $prostatectomy_date_ob->diff($visit_date_ob);
				$interval_year =round(($interval->y*12 + $interval->m)/12);
				$visit = $interval_year+1;
				$visit = (strlen($visit) == 1)? "V0$visit" : "V$visit";
				if($interval_year > 18) {
					pr("ERROR#1 Vist > V19: See Medication Form [".$new_form['procure_form_identification']."] based on Prostatectomy Date [$prostatectomy_date] and Id confirmation date (Visite Date) [$visit_date] (=".(($interval->invert)? '-' : '').($interval->y*12 + $interval->m)." months)");
				} else if($interval->invert && $interval_year != 0) {
					$new_medication_form = preg_replace('/ V[0]{1,2} -MED/', " V01 -MED", $new_form['procure_form_identification']);
					$V01_creation_messages_with_warning[] = "Medication Form [".$new_form['procure_form_identification']."] of patient [".$new_form['participant_identifier']."] changed to [$new_medication_form] based on Prostatectomy Date [$prostatectomy_date] and Id confirmation date (Visite Date) [$visit_date] (=".(($interval->invert)? '-' : '').($interval->y*12 + $interval->m)." months)";
				} else {
					$new_medication_form = preg_replace('/ V[0]{1,2} -MED/', " $visit -MED", $new_form['procure_form_identification']);
					$creation_messages[] = "Medication Form [".$new_form['procure_form_identification']."] of patient [".$new_form['participant_identifier']."] changed to [$new_medication_form] based on Prostatectomy Date [$prostatectomy_date] and Id confirmation date (Visite Date) [$visit_date] (=".(($interval->invert)? '-' : '').($interval->y*12 + $interval->m)." months)";
				}
				if($new_medication_form) {
					$query = "UPDATE treatment_masters SET procure_form_identification = '$new_medication_form' WHERE id = ".$new_form['id'];
					customQuery($query);
				}
			} else {
				$patient_with_many_collection_date[$new_form['id']] = $new_form['procure_form_identification'];
			}
		} else {
			$patient_with_no_collection_date[$new_form['id']] = $new_form['procure_form_identification'];
		}
	}	
}

$summary_data = array(
	"Medication Form With No Data (to delete manually)" => $empty_form_to_delete, 
	"Medication Form With No Visit Date (to set date and update form identification manually)" => $form_with_empty_date,
	"No Tissue Collection (Prostatectomy) Date (to update form identification manually)" => $patient_with_no_collection_date,
	"More Than One Tissue Collection (Prostatectomy) Date (to update form identification manually)" => $patient_with_many_collection_date,
	"Form identification updated with no warning" => $creation_messages,
	"Form identification updated to V01 but an error on dates seams to exist (to check and validate)" => $V01_creation_messages_with_warning);
foreach($summary_data as $title => $data) {
	if($data) {
		pr("<font color='blue'>$title (".sizeof($data).")</font><br>");
		foreach($data as $msg) pr(" => $msg<br>");
		pr("<br>");
	}
}

$query = "UPDATE treatment_masters TreatmentMaster, treatment_masters_revs TreatmentMasterRevs
SET TreatmentMasterRevs.procure_form_identification = TreatmentMaster.procure_form_identification
WHERE TreatmentMasterRevs.procure_form_identification != TreatmentMaster.procure_form_identification AND TreatmentMasterRevs.id = TreatmentMaster.id;";
customQuery($query);

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