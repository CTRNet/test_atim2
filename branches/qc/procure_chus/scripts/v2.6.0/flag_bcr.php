<?php

/*
 * Flag BCR
*/

set_time_limit('3600');

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

global $db_schema;

$is_server = false;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_charset		= "utf8";
$db_schema	= "procurechus";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed 1");
mysqli_autocommit($db_connection, false);

//--------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;
global $modified;

$query = "SELECT id, NOW() as modified FROM users WHERE username = 'NicoEn';";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$data = mysqli_fetch_assoc($res);
if($data) {
	$modified_by = $data['id'];
	$modified = $data['modified'];
} else {
	die('ERR 9993999399');
}

//=========================================================================================================================================================

$query = "SELECT id FROM event_controls WHERE event_type = 'procure follow-up worksheet - aps' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$psa_event_control_id = $res['id'];

$query = "SELECT id FROM treatment_controls WHERE tx_method = 'procure follow-up worksheet - treatment' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$tx_control_id = $res['id'];

$participant_id = null;
$prostatectomy_date = null;
$all_patient_psa = array();
$bcr_detected = false;

$query = "SELECT Participant.id as participant_id, Participant.participant_identifier, EventMaster.id, EventMaster.event_date, EventDetail.total_ngml, EventDetail.biochemical_relapse
	FROM participants Participant 
	INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
	INNER JOIN procure_ed_clinical_followup_worksheet_aps EventDetail ON EventDetail.event_master_id = EventMaster.id 
	WHERE EventMaster.deleted <> 1 
	AND EventMaster.event_control_id = $psa_event_control_id 
	AND event_date IS NOT NULL AND event_date NOT LIKE '' 
	ORDER BY participant_id, event_date ASC";
$psa_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
While($new_psa = mysqli_fetch_assoc($psa_res)) {
	if(is_null($participant_id) || $participant_id != $new_psa['participant_id']) {
		$participant_id = $new_psa['participant_id'];
		$prostatectomy_date = null;
		$all_patient_psa = array();
		$bcr_detected = false;
		$bcr_validated = false;
		$query = "SELECT TreatmentMaster.start_date
			FROM treatment_masters TreatmentMaster
			INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
			WHERE TreatmentMaster.deleted <> 1 
			AND TreatmentMaster.treatment_control_id = $tx_control_id
			AND TreatmentDetail.treatment_type = 'prostatectomy' 
			AND start_date IS NOT NULL AND start_date NOT LIKE ''
			AND participant_id = $participant_id ORDER BY TreatmentMaster.start_date";
		$prostatectomy_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
		if($prostatectomy_res->num_rows == 0) {
			echo "****** Patient ".$new_psa['participant_identifier']." (participant_id = ".$new_psa['participant_id'].") ******\n";
			echo "No prostatectomy defintion. BCR won't be updated.\n";
		} else {
			//if($prostatectomy_res->num_rows > 1) echo "2 prostatectomy defintions. First one will be considered.\n";
			$prostatectomy_data = mysqli_fetch_assoc($prostatectomy_res);
			$prostatectomy_date = $prostatectomy_data['start_date'];
		}
	}
	if($prostatectomy_date) {
		if($prostatectomy_date < $new_psa['event_date']) {
			array_unshift($all_patient_psa, $new_psa);
			if(sizeof($all_patient_psa) > 1 && $all_patient_psa[0]['total_ngml'] >= 0.2 && $all_patient_psa[1]['total_ngml'] >= 0.2 && !$bcr_detected) {
				echo "****** Patient ".$new_psa['participant_identifier']." (participant_id = ".$new_psa['participant_id'].") ******\n";
				if($all_patient_psa[1]['biochemical_relapse'] == 'y') {
					echo "BCR already set on ".$all_patient_psa[1]['event_date'].".\n";
				} else {
					echo "Flagged PSA as BCR on ".$all_patient_psa[1]['event_date'].".\n";
					$query = "UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_aps EventDetail
						SET EventDetail.biochemical_relapse = 'y', EventMaster.modified = '$modified', EventMaster.modified_by = $modified_by
						WHERE EventMaster.id = ".$all_patient_psa[1]['id']." AND EventMaster.id = EventDetail.event_master_id;";
					mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
				}
				$all_patient_psa[1]['biochemical_relapse'] = 'y';	
				$bcr_detected = true;
			}
		}
	}
}

//Revs
$query = "INSERT INTO event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, version_created, modified_by)
	(SELECT id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, modified, modified_by FROM event_masters WHERE event_control_id = $psa_event_control_id AND modified = '$modified' AND modified_by = $modified_by);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query = "INSERT INTO procure_ed_clinical_followup_worksheet_aps_revs (total_ngml,event_master_id,biochemical_relapse, version_created)
	(SELECT total_ngml,event_master_id,biochemical_relapse, modified FROM event_masters, procure_ed_clinical_followup_worksheet_aps WHERE id = event_master_id AND event_control_id = $psa_event_control_id AND modified = '$modified' AND modified_by = $modified_by);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

echo "\nProcess Done\n";

//Dup Check
$query = "SELECT participant_id, participant_identifier 
	FROM (
		SELECT Participant.id as participant_id, Participant.participant_identifier, count(*) AS nbr
		FROM participants Participant
		INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
		INNER JOIN procure_ed_clinical_followup_worksheet_aps EventDetail ON EventDetail.event_master_id = EventMaster.id
		WHERE EventMaster.deleted <> 1
		AND EventMaster.event_control_id = $psa_event_control_id
		AND biochemical_relapse = 'y'
		GROUP BY Participant.id, Participant.participant_identifier
	) res WHERE  res.nbr > 1";
$bcr_dup_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
While($new_patient = mysqli_fetch_assoc($bcr_dup_res)) {
	echo $new_patient['participant_identifier']." is linked to more than one BCR\n";
}

mysqli_commit($db_connection);
echo "\nProcess Commited\n";

//=========================================================================================================================================================
//=========================================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

?>
