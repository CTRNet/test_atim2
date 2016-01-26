<?php 

//==================================================================================================================================================================================
// DATABSE CONNECTION
//==================================================================================================================================================================================

$db_ip = "localhost";
$db_port = "";
$db_user = "root";
$db_pwd = "";
$db_schemas = "procurechus";
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

$query = "SELECT AliquotMaster.id AS aliquot_master_id, Participant.participant_identifier, Collection.procure_visit, AliquotMaster.barcode, AliquotMaster.aliquot_label, AliquotDetail.block_type
	FROM participants Participant
	INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
	INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
	INNER JOIN ad_blocks AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
	WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\ ')
	AND AliquotDetail.block_type = 'paraffin'
	AND aliquot_control_id = (
		SELECT AliquotControl.id FROM sample_controls SampleControl INNER JOIN aliquot_controls AliquotControl ON SampleControl.id = AliquotControl.sample_control_id
		WHERE sample_type = 'tissue' AND aliquot_type = 'block')";
$query_res = getSelectQueryResult($query);
pr("<font color='blue'>Process will update the barcode and the label of ".sizeof($query_res)." paraffin blocks (on $date).</font><br>");
foreach($query_res as $new_aliquot) {
	if(strlen($new_aliquot['aliquot_label'])) die('ERR 84894949');
	
	$participant_identifier = $new_aliquot['participant_identifier'];
	$procure_visit = $new_aliquot['procure_visit'];
	$barcode = $new_aliquot['barcode'];
	
	if(preg_match('/\ [A-Z]([0-9][0-9\-]*)$/', $barcode, $matches)) {
		$new_barcode = "$participant_identifier $procure_visit -PAR".$matches[1];
	} else {
		pr("Unable to get paraffin block number from barcode [$barcode]");
		$new_barcode = "$participant_identifier $procure_visit -PAR1";
	}
	$query = "UPDATE aliquot_masters SET barcode = '$new_barcode', aliquot_label = '$barcode', modified = '$date', modified_by = $user_id WHERE id = ".$new_aliquot['aliquot_master_id'];
	customQuery($query);
	pr(" - See barcode changed from [$barcode] to [$new_barcode]");
}

$query = "SELECT AliquotMaster.id AS aliquot_master_id, Participant.participant_identifier, Collection.procure_visit, AliquotMaster.barcode, AliquotMaster.aliquot_label
	FROM participants Participant
	INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
	INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
	WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\ ')
	AND aliquot_control_id = (
		SELECT AliquotControl.id FROM sample_controls SampleControl INNER JOIN aliquot_controls AliquotControl ON SampleControl.id = AliquotControl.sample_control_id
		WHERE sample_type = 'tissue' AND aliquot_type = 'slide')";
$query_res = getSelectQueryResult($query);
pr("<font color='blue'>Process will update the barcode and the label of ".sizeof($query_res)." tissue slides (on $date).</font><br>");
foreach($query_res as $new_aliquot) {
	if(strlen($new_aliquot['aliquot_label'])) die('ERR 84894949');

	$participant_identifier = $new_aliquot['participant_identifier'];
	$procure_visit = $new_aliquot['procure_visit'];
	$barcode = $new_aliquot['barcode'];

	if(preg_match('/\ [A-Z]([0-9][0-9\-]*)$/', $barcode, $matches)) {
		$new_barcode = "$participant_identifier $procure_visit -SLI".$matches[1];
	} else {
		pr("Unable to get paraffin block number from barcode [$barcode]");
		$new_barcode = "$participant_identifier $procure_visit -SLI1";
	}
	$query = "UPDATE aliquot_masters SET barcode = '$new_barcode', aliquot_label = '$barcode', modified = '$date', modified_by = $user_id WHERE id = ".$new_aliquot['aliquot_master_id'];
	customQuery($query);
	pr(" - See barcode changed from [$barcode] to [$new_barcode]");
}

// Check barcode error

pr("<font color='blue'>Aliquot Barcode Control : Check barcodes match participant_identifier + visit (Check done after data clean up).</font><br>");
$query = "SELECT Participant.participant_identifier, Collection.procure_visit, AliquotMaster.barcode
	FROM participants Participant
	INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
	INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
	WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\ ');";
$query_res = getSelectQueryResult($query);	
foreach($query_res as $new_aliquot) {
	$barcode = $new_aliquot['barcode'];
	$participant_identifier = $new_aliquot['participant_identifier'];
	$procure_visit = $new_aliquot['procure_visit'];
	pr(" - See barcode [$barcode] (see patient $participant_identifier and $procure_visit");
}

pr("<font color='blue'>Duplicated aliquot barcodes.</font><br>");
$query = "select barcode from (select count(*) as nbr, barcode from aliquot_masters WHERE deleted <> 1 group by barcode) res where res.nbr > 1;";
$query_res = getSelectQueryResult($query);
foreach($query_res as $new_aliquot) {
	$barcode = $new_aliquot['barcode'];
	pr(" - See barcode [$barcode]");
}

//Revs Table

$query = "INSERT INTO aliquot_masters_revs(id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,
use_counter,study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
procure_created_by_bank,version_created,modified_by)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,
use_counter,study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
procure_created_by_bank,modified,modified_by FROM aliquot_masters
WHERE modified = '$date' AND modified_by = $user_id)";
customQuery($query);

$query = "INSERT INTO  ad_tissue_slides_revs (aliquot_master_id, immunochemistry, version_created)
(SELECT aliquot_master_id, immunochemistry, modified
FROM aliquot_masters INNER JOIN ad_tissue_slides ON id = aliquot_master_id
WHERE modified = '$date' AND modified_by = $user_id)";
customQuery($query);

$query = "INSERT INTO  ad_blocks_revs (aliquot_master_id,block_type,procure_freezing_type,patho_dpt_block_code,procure_freezing_ending_time,procure_origin_of_slice,procure_dimensions,
time_spent_collection_to_freezing_end_mn,procure_classification,procure_chus_classification_precision,procure_chus_origin_of_slice_precision, version_created)
(SELECT aliquot_master_id,block_type,procure_freezing_type,patho_dpt_block_code,procure_freezing_ending_time,procure_origin_of_slice,procure_dimensions,
time_spent_collection_to_freezing_end_mn,procure_classification,procure_chus_classification_precision,procure_chus_origin_of_slice_precision, modified
FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id
WHERE modified = '$date' AND modified_by = $user_id)";
customQuery($query);

// Print queries

pr("<br><br>=======================================================================================================================================<br>");
foreach($all_queries as $new_query) pr("<i>$new_query</i>");

//==========================================================================================================================================================
//==========================================================================================================================================================


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
	$query_res = mysqli_query($db_connection, $query) or die("ERR_QUERY ($query) : ".mysqli_error($db_connection));
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
	if(!preg_match('/^[\ ]*((SELECT)|(SHOW))/i', $query))  die("ERR_QUERY 007 ($query)");
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