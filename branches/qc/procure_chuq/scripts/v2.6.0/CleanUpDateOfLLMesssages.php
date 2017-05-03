<?php

//==============================================================================================
//
// Script created to correct the message of Dr Lacombe written into the file  
// 'révision du Dr Lacombe en janvier 2015_final.xls' and used for the migration on 2015-10-08.
//
// The date of the 'Dr Lacombe Revision Message' migrated by script on 2015-10-08 has been imported 
// as an excel value (integer) instead a formated date. Script will update the date of
// this message with the correct format.
//
//==============================================================================================

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "procurechuq";
$db_charset		= "utf8";


global $db_connection;
$db_connection = @mysqli_connect(
	$db_ip.(!empty($db_port)? ":".$db_port : ''),
	$db_user,
	$db_pwd
) or importDie("DB connection: Could not connect to MySQL [".$db_ip.(!empty($db_port)? ":".$db_port : '')." / $db_user]", false);
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("DB connection: Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or importDie("DB connection: DB selection failed [$db_schema]", false);
mysqli_autocommit ($db_connection , false);

$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'system';", __LINE__);
if($query_res->num_rows != 1) importDie("DB connection: No user 'system' into ATiM users table!");
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

$query_res = customQuery("SELECT id FROM event_controls WHERE event_type = 'clinical note' AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 1) importDie("Event Control!");
$event_control_id =  mysqli_fetch_assoc($query_res);
$event_control_id = $event_control_id['id'];

$ll_revision_data = getLLRevisionData();

pr("==============================================================================================");
pr("Script 'CleanUpDateOfLLMessages.php'");
pr($import_date);
pr("To update the revision message of the Dr Lacombe");
pr("of the file 'révision du Dr Lacombe en janvier 2015_final.xls' with the formatted date.");
pr("==============================================================================================");

$errors = array();

$query_res = customQuery("SELECT participant_identifier, EVENT.id as event_master_id, participant_id, event_control_id, event_summary, EVENT.created
	FROM event_masters EVENT 
	INNER JOIN participants PART ON PART.id = EVENT.participant_id 
	WHERE event_summary LIKE '%Opinion LL date de r%cidive : %' 
	AND event_control_id = $event_control_id 
	AND EVENT.deleted <> 1;", __LINE__);
while($new_record =  mysqli_fetch_assoc($query_res)) {
	$participant_identifier = $new_record['participant_identifier'];
	$event_master_id = $new_record['event_master_id'];
	$participant_id = $new_record['participant_id'];
	if(preg_match('/(Opinion LL date de r.cidive : )([0-9]+)/', $new_record['event_summary'], $matches)) {
		if(isset($ll_revision_data[$participant_identifier])) {
			$new_event_summary = str_replace($matches[1].$matches[2], $matches[1].$ll_revision_data[$participant_identifier], $new_record['event_summary']);
			
			pr("-- Participant $participant_identifier ----------------------------------------------------------------");
			pr(" Updated message FROM :");
			pr('['.$new_record['event_summary'].']');
			pr(" TO :");
			pr('['.$new_event_summary.']');
			
			$query = "UPDATE event_masters SET event_summary = '".str_replace("'", "''", $new_event_summary)."', modified = '$import_date', modified_by = '$import_by' WHERE id = $event_master_id;";
			customQuery($query, __LINE__);
		} else {
			$errors[] = "ERROR : Message of the participant $participant_identifier not updated!";
		}
	}
}

if($errors) {
	pr('');
	pr("---------------------------------------------------------------------------------------------");
	foreach($errors as $new_error) {
		pr($new_error);
	}
}

$query = "INSERT INTO event_masters_revs (id,
	event_control_id,
	event_status,
	event_summary,
	event_date,
	event_date_accuracy,
	information_source,
	urgency,
	date_required,
	date_required_accuracy,
	date_requested,
	date_requested_accuracy,
	reference_number,
	participant_id,
	diagnosis_master_id,
	procure_deprecated_field_procure_form_identification,
	procure_created_by_bank,
	version_created,
	modified_by)
	(SELECT id,
	event_control_id,
	event_status,
	event_summary,
	event_date,
	event_date_accuracy,
	information_source,
	urgency,
	date_required,
	date_required_accuracy,
	date_requested,
	date_requested_accuracy,
	reference_number,
	participant_id,
	diagnosis_master_id,
	procure_deprecated_field_procure_form_identification,
	procure_created_by_bank,
	modified,
	modified_by
	FROM event_masters
	WHERE event_control_id = $event_control_id AND modified = '$import_date' AND modified_by = '$import_by');";
customQuery($query, __LINE__);

$query = "INSERT INTO procure_ed_clinical_notes_revs (event_master_id,
	version_created,
	type)
	(SELECT event_master_id,
	modified,
	type
	FROM event_masters INNER JOIN procure_ed_clinical_notes ON id = event_master_id
	WHERE event_control_id = $event_control_id AND modified = '$import_date' AND modified_by = '$import_by');";
customQuery($query, __LINE__);

pr('');
pr("---------------------------------------------------------------------------------------------");
pr('End of the process.');
pr("---------------------------------------------------------------------------------------------");

mysqli_commit($db_connection);

//=========================================================================================================================================================================================================
//
// ******* FUNCTIONS *******
//
//=========================================================================================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function importDie($msg, $rollbak = true) {
	global $db_connection;
	if($rollbak) {
		mysqli_rollback($db_connection);
		echo "$msg";
		die($msg);
	} else {
		// Any error before tables data change
		die($msg);
	}
}

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	if($query_res = mysqli_query($db_connection, $query)) {
		return ($insert)? mysqli_insert_id($db_connection) : $query_res;
	} else {
		echo "Query Error :: ".mysqli_error($db_connection)."\n";
		echo "Line :: $line\n";
		echo "QUERY : [$query]\n\n";
		importDie("Query Error! ERR#_$line");
	}
}

//=========================================================================================================================================================================================================
//
// ******* FUNCTIONS *******
//
//=========================================================================================================================================================================================================

function getLLRevisionData() {
	//Value of the field 'Opinion LL date de récidive' of the file 'révision du Dr Lacombe en janvier 2015_final.xls' imported on 20151008
	return array(
		"PS2P0001" => "2010-08-05",
		"PS2P0003" => "2010-08-30",
		"PS2P0005" => "2010-03-29",
		"PS2P0014" => "2010-09-27",
		"PS2P0024" => "2007-06-15",
		"PS2P0025" => "2008-06-11",
		"PS2P0027" => "2009-06-16",
		"PS2P0028" => "2011-02-11",
		"PS2P0030" => "2009-01-30",
		"PS2P0032" => "Jamais",
		"PS2P0033" => "2009-07-20",
		"PS2P0034" => "2007-06-08",
		"PS2P0036" => "2008-01-29",
		"PS2P0038" => "2011-02-14",
		"PS2P0041" => "2007-07-17",
		"PS2P0045" => "2009-03-11",
		"PS2P0047" => "2008-05-12",
		"PS2P0050" => "2010-02-22",
		"PS2P0052" => "2008-05-21",
		"PS2P0057" => "2008-11-06",
		"PS2P0059" => "2011-08-19",
		"PS2P0069" => "DCD CaP 2010-10-02",
		"PS2P0070" => "2010-04-26",
		"PS2P0072" => "2008-03-04",
		"PS2P0078" => "2009-03-20",
		"PS2P0079" => "2012-02-20",
		"PS2P0087" => "2008-05-26",
		"PS2P0088" => "2010-01-28",
		"PS2P0095" => "2009-02-24",
		"PS2P0100" => "2010-03-01",
		"PS2P0101" => "2008-12-15",
		"PS2P0104" => "2010-02-18",
		"PS2P0110" => "2009-01-16",
		"PS2P0113" => "2013-02-19",
		"PS2P0119" => "2010-09-08",
		"PS2P0123" => "2011-05-17",
		"PS2P0125" => "2009-09-30",
		"PS2P0133" => "2009-05-15",
		"PS2P0136" => "2012-04-24",
		"PS2P0140" => "2009-09-09",
		"PS2P0141" => "2008-12-15",
		"PS2P0145" => "2009-04-29",
		"PS2P0150" => "2010-01-28",
		"PS2P0151" => "2009-11-19",
		"PS2P0152" => "pas échec",
		"PS2P0153" => "2010-11-22",
		"PS2P0154" => "2009-11-16",
		"PS2P0155" => "2008-11-11",
		"PS2P0156" => "2009-01-06",
		"PS2P0162" => "premier APS à 0.29 en 2013-06-25",
		"PS2P0163" => "2009-09-01",
		"PS2P0164" => "2009-03-11",
		"PS2P0166" => "2010-10-15",
		"PS2P0168" => "2010-04-07",
		"PS2P0178" => "2009-05-14",
		"PS2P0182" => "2011-10-24",
		"PS2P0187" => "2009-06-17",
		"PS2P0191" => "2011-02-16",
		"PS2P0194" => "Jamais",
		"PS2P0196" => "Jamais",
		"PS2P0208" => "2012-03-13",
		"PS2P0209" => "2010-02-16",
		"PS2P0211" => "APS 0.26 en oct 2014",
		"PS2P0212" => "2011-07-19",
		"PS2P0213" => "2010-04-01",
		"PS2P0217" => "2011-01-17",
		"PS2P0218" => "2011-05-05",
		"PS2P0226" => "2009-08-04",
		"PS2P0237" => "2010-04-27",
		"PS2P0240" => "2011-05-09",
		"PS2P0247" => "2009-12-02",
		"PS2P0252" => "2009-12-22",
		"PS2P0254" => "2013-11-13",
		"PS2P0261" => "2012-01-18",
		"PS2P0268" => "2010-01-05",
		"PS2P0282" => "2010-04-26",
		"PS2P0283" => "2011-11-28",
		"PS2P0284" => "2010-04-06",
		"PS2P0287" => "Jamais",
		"PS2P0290" => "2012-08-08",
		"PS2P0292" => "2011-05-19",
		"PS2P0300" => "2010-11-11",
		"PS2P0301" => "2011-11-29",
		"PS2P0302" => "2011-06-01",
		"PS2P0307" => "2010-04-07",
		"PS2P0310" => "2012-06-18",
		"PS2P0313" => "2011-07-28",
		"PS2P0314" => "2011-06-22",
		"PS2P0318" => "2010-09-13",
		"PS2P0322" => "2014-02-15",
		"PS2P0329" => "2012-03-14",
		"PS2P0334" => "2012-06-15",
		"PS2P0338" => "2010-12-13",
		"PS2P0350" => "2013-02-27",
		"PS2P0353" => "2011-01-12",
		"PS2P0355" => "2011-03-11",
		"PS2P0361" => "2011-08-24",
		"PS2P0364" => "2011-01-19",
		"PS2P0375" => "2011-02-10",
		"PS2P0379" => "2011-05-02",
		"PS2P0385" => "2011-07-18",
		"PS2P0396" => "2011-10-06",
		"PS2P0409" => "2012-07-23",
		"PS2P0415" => "2012-02-02",
		"PS2P0436" => "2011-12-15",
		"PS2P0442" => "2012-01-13",
		"PS2P0448" => "2012-02-02",
		"PS2P0457" => "2012-06-05",
		"PS2P0466" => "2012-05-24",
		"PS2P0467" => "2013-02-21",
		"PS2P0471" => "2012-03-08",
		"PS2P0492" => "2013-01-28",
		"PS2P0494" => "2013-02-14",
		"PS2P0499" => "2013-05-03",
		"PS2P0501" => "2012-09-24",	
	);
}

?>