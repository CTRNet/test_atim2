<?php  


$filename = '\study_patient_rein_20181207.csv';
$bank = 'kidney bank';
pr('--------------------------------------------------------------------------------------------------------------');
pr('--');
pr('-- IMPORT STUDYIDENTIFIERs AND CONSENTs');
pr('--');
pr("-- bank : $bank");
pr("-- file : $filename");
pr('--');
pr('--');
pr('--------------------------------------------------------------------------------------------------------------');

$filename = 'C:\_NicolasLuc\Server\www'.$filename;

//-------------------------------------------------------------------------------------------------------------------------

$db_ip				= "localhost";
$db_port 			= "";
$db_user 			= "root";
$db_pwd				= "";
$db_schema	= "chumoncoaxis";
$db_charset			= "utf8";

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("DB connection: Could not connect to MySQL [".$db_ip.(!empty($db_port)? ":".$db_port : '')." / $db_user]");
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("DB connection: Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or die("DB connection: DB selection failed [$db_schema]");
mysqli_autocommit ($db_connection , false);

//-------------------------------------------------------------------------------------------------------------------------

$misc_identifier_name = $bank.' no lab';
$query = "SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = '$misc_identifier_name' AND flag_active = 1;";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$banq_misc_identifier_control_id = $res['id'];
if(empty($banq_misc_identifier_control_id)) die('err 0');

$misc_identifier_name = 'study number';
$query = "SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = '$misc_identifier_name' AND flag_active = 1;";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$study_misc_identifier_control_id = $res['id'];
if(empty($study_misc_identifier_control_id)) die('err 1');

$query = "SELECT NOW() as creation_date FROM aros LIMIT 0,1;";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$created = $res['creation_date'];
if(empty($created)) die('err 2');

pr('-- Date '.$created);
pr('--------------------------------------------------------------------------------------------------------------');

$created_by = '9';

$study_summary_name = 'Banque de données du cancer du rein(CKCIS)';
$query = "SELECT id FROM study_summaries WHERE title = '$study_summary_name' AND deleted <> 1";
$query_res = customQuery($query, __LINE__);
$study_summary_id =  mysqli_fetch_assoc($query_res);
$study_summary_id = $study_summary_id['id'];
if(empty($study_summary_id)) die('err 3');

$controls_type = 'study consent';
$query = "SELECT id FROM consent_controls WHERE controls_type = '$controls_type' AND flag_active = 1;";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$consent_control_id = $res['id'];
if(empty($consent_control_id)) die('err 1');

// Read file

$handle = fopen($filename, 'r');
if(!$handle) die('err 4');
$header = array();
while (($row = fgetcsv($handle, 1000, ';')) !== FALSE)
{
    if(!$header) {
        $header = $row;
    } else {
        //Parse data
        //----------------------------------------------------
        $data = array_combine($header, $row);
        $no_labo = $data['# BIOBANQUE REIN'];
        $identifier_value = utf8_encode($data['#  CKCIs']);
        $consent_date = $data['DATE signature du FC CKCiS'];
        if(preg_match('/^([0-9]{2})\-([A-Z]{3})\-([0-9]{4})/', $consent_date, $matches)) {
            $consent_date = $matches[3].'-'.$matches[2].'-'.$matches[1];
            $consent_date = str_replace(
                array('JAN', 'FEB', 'FEV', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'),
                array('01', '02', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'),
                $consent_date
            );
        } elseif(preg_match('/^([0-9]{1})\-([A-Z]{3})\-([0-9]{4})/', $consent_date, $matches)) {
            $consent_date = $matches[3].'-'.$matches[2].'-0'.$matches[1];
            $consent_date = str_replace(
                array('JAN', 'FEB', 'FEV', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'),
                array('01', '02', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'),
                $consent_date
            );
        } elseif(!preg_match('/^([0-9]{4})\-([A-Z]{3})\-([0-9]{2})/', $consent_date, $matche2s)) {
            $consent_date = $matche2s[1].'-'.$matche2s[2].'-'.$matche2s[3];
            $consent_date = str_replace(
                array('JAN', 'FEB', 'FEV', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'),
                array('01', '02', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'),
                $consent_date
            );
        } else {
            die('err 5 : ' . $consent_date);
        }
        if(!preg_match('/^([0-9]{4})\-([0-9]{2})\-([0-9]{2})/', $consent_date, $matches)) die('err 6 : ' . $consent_date);
        // Get participant
        //----------------------------------------------------
        $query = "SELECT participant_id FROM misc_identifiers WHERE misc_identifier_control_id = $banq_misc_identifier_control_id AND deleted <> 1 AND identifier_value = '$no_labo'";
        $query_res = customQuery($query, __LINE__);
        $participant_id =  mysqli_fetch_assoc($query_res);
        $participant_id = $participant_id['participant_id'];
        if(empty($participant_id)) die('err 5 ' . $identifier_value . ' ' .$query);
        //Insert misc identifier
        //----------------------------------------------------
        if(empty($identifier_value)) die('err 6 ' . $identifier_value);
        $query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, study_summary_id,
            `modified`, `created`, `created_by`, `modified_by`, tmp_deleted, deleted) 
            VALUES
            ('$identifier_value', $study_misc_identifier_control_id, $participant_id, $study_summary_id,
            '$created', '$created', $created_by, $created_by, 0, 0);";
        customQuery($query, __LINE__);
        //Insert consent
        //----------------------------------------------------
        $query = "INSERT INTO `consent_masters` (`consent_status`, `consent_signed_date`, `consent_signed_date_accuracy`, `participant_id`, `consent_control_id`, `study_summary_id`, 
            `modified`, `created`, `created_by`, `modified_by`) 
         VALUES 
            ('obtained', '$consent_date', 'c', $participant_id, $consent_control_id, $study_summary_id,
            '$created', '$created', $created_by, $created_by);";   
        customQuery($query, __LINE__);
        //----------------------------------------------------
        pr("Created '$study_summary_name' study #'$identifier_value' and consent on '$consent_date' for banque #'$no_labo'.");
    }
}

//Insert revs
//----------------------------------------------------

$query = "INSERT INTO misc_identifiers_revs (id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified_by`, `version_created`)
(SELECT id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified_by`, `modified`
FROM misc_identifiers
WHERE misc_identifier_control_id = $study_misc_identifier_control_id
AND created = '$created' AND created_by = $created_by);";
customQuery($query, __LINE__);
$query = "INSERT INTO `consent_masters_revs` (`participant_id`, `consent_control_id`, `consent_version_date`, `consent_language`, `invitation_date`, `consent_status`, `status_date`, `consent_signed_date`, `reason_denied`, `qc_nd_file_name`, `notes`, `study_summary_id`, `consent_signed_date_accuracy`, `status_date_accuracy`, `modified_by`, `id`, `version_created`) 
(SELECT `participant_id`, `consent_control_id`, `consent_version_date`, `consent_language`, `invitation_date`, `consent_status`, `status_date`, `consent_signed_date`, `reason_denied`, `qc_nd_file_name`, `notes`, `study_summary_id`, `consent_signed_date_accuracy`, `status_date_accuracy`, `modified_by`, `id`, `modified`
FROM consent_masters WHERE created = '$created' AND created_by = $created_by AND consent_control_id = $consent_control_id);";
customQuery($query, __LINE__);
$query = "INSERT INTO `cd_nationals` (`consent_master_id`) (SELECT id FROM consent_masters WHERE created = '$created' AND created_by = $created_by AND consent_control_id = $consent_control_id);";
customQuery($query, __LINE__);
$query = "INSERT INTO `cd_nationals_revs` (`consent_master_id`, `version_created`) (SELECT id,`created` FROM consent_masters WHERE created = '$created' AND created_by = $created_by AND consent_control_id = $consent_control_id);";
customQuery($query, __LINE__);


fclose($handle);

pr('--------------------------------------------------------------------------------------------------------------');
pr('PROCESS DONE');

mysqli_commit($db_connection);

//-------------------------------------------------------------------------------------------------------------------------

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	if($query_res = mysqli_query($db_connection, $query)) {
		return ($insert)? mysqli_insert_id($db_connection) : $query_res;
	} else {
		echo "Query Error :: ".mysqli_error($db_connection)."\n";
		echo "Line :: $line\n";
		echo "QUERY : [$query]\n\n";
		die("Query Error! ERR#_$line");
	}
}

function pr($var) {
	echo "\n";
	print_r($var);
	echo "\n";
}

?>