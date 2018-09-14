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
$db_schema	= "procurechuq";

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

//array('NoProcure', 'déterminé par PI local en  Jan 2015', 'déterminé par PI local au printemps 2018', 'date de récidive selon  Dr lacombe'    
$psaData = array(
xxxxxxx0001', '1', '', '2010-08-05'),
xxxxxxx0003', '1', '', '2010-08-30'),
xxxxxxx0005', '1', '', '2010-03-29'),
xxxxxxx0010', '', '1', '2013-06-26'),
xxxxxxx0012', '', '1', '2017-02-20'),
xxxxxxx0014', '1', '', '2010-09-27'),
xxxxxxx0017', '', '1', '2014-07-01'),
xxxxxxx0024', '1', '', '2007-06-15'),
xxxxxxx0025', '1', '', '2008-06-11'),
xxxxxxx0027', '1', '', '2009-06-16'),
xxxxxxx0028', '1', '', '2011-02-11'),
xxxxxxx0030', '1', '', '2009-01-30'),
xxxxxxx0033', '1', '', '2009-07-20'),
xxxxxxx0034', '1', '', '2007-06-08'),
xxxxxxx0036', '1', '', '2008-01-29'),
xxxxxxx0038', '1', '', '2011-02-14'),
xxxxxxx0040', '', '1', '2014-11-06'),
xxxxxxx0041', '1', '', '2007-07-17'),
xxxxxxx0045', '1', '', '2009-03-11'),
xxxxxxx0047', '1', '', '2008-05-12'),
xxxxxxx0050', '1', '', '2010-02-22'),
xxxxxxx0052', '1', '', '2008-05-21'),
xxxxxxx0057', '1', '', '2008-11-06'),
xxxxxxx0059', '1', '', '2011-08-19'),
xxxxxxx0068', '', '1', '2015-01-26'),
xxxxxxx0070', '1', '', '2010-04-26'),
xxxxxxx0072', '1', '', '2008-03-04'),
xxxxxxx0078', '1', '', '2009-03-20'),
xxxxxxx0079', '1', '', '2012-02-20'),
xxxxxxx0087', '1', '', '2008-05-26'),
xxxxxxx0088', '1', '', '2010-01-28'),
xxxxxxx0095', '1', '', '2009-02-24'),
xxxxxxx0100', '1', '', '2010-03-01'),
xxxxxxx0101', '1', '', '2008-12-15'),
xxxxxxx0104', '1', '', '2010-02-18'),
xxxxxxx0106', '', '1', '2014-07-07'),
xxxxxxx0110', '1', '', '2009-01-16'),
xxxxxxx0113', '1', '', '2013-02-19'),
xxxxxxx0119', '1', '', '2010-09-08'),
xxxxxxx0123', '1', '', '2011-05-17'),
xxxxxxx0125', '1', '', '2009-09-30'),
xxxxxxx0133', '1', '', '2009-05-15'),
xxxxxxx0135', '', '1', '2013-12-20'),
xxxxxxx0136', '1', '', '2012-04-24'),
xxxxxxx0137', '', '1', '2015-10-08'),
xxxxxxx0138', '', '1', '2014-08-20'),
xxxxxxx0139', '', '1', '2015-11-02'),
xxxxxxx0140', '1', '', '2009-09-09'),
xxxxxxx0141', '1', '', '2008-12-15'),
xxxxxxx0145', '1', '', '2009-04-29'),
xxxxxxx0150', '1', '', '2010-01-28'),
xxxxxxx0151', '1', '', '2009-11-19'),
xxxxxxx0153', '1', '', '2010-11-22'),
xxxxxxx0154', '1', '', '2009-11-16'),
xxxxxxx0155', '1', '', '2008-11-11'),
xxxxxxx0156', '1', '', '2009-01-06'),
xxxxxxx0158', '', '1', '2014-06-13'),
xxxxxxx0162', '1', '', '2013-06-25'),
xxxxxxx0163', '1', '', '2009-09-01'),
xxxxxxx0164', '1', '', '2009-03-11'),
xxxxxxx0166', '1', '', '2010-10-20'),
xxxxxxx0167', '', '1', '2014-02-11'),
xxxxxxx0168', '1', '', '2010-04-07'),
xxxxxxx0169', '', '1', '2014-02-04'),
xxxxxxx0171', '', '1', '2014-02-05'),
xxxxxxx0178', '1', '', '2009-05-14'),
xxxxxxx0180', '', '1', '2015-06-30'),
xxxxxxx0182', '1', '', '2011-10-24'),
xxxxxxx0187', '1', '', '2009-06-17'),
xxxxxxx0191', '1', '', '2011-02-16'),
xxxxxxx0207', '', '1', '2012-12-19'),
xxxxxxx0208', '1', '', '2012-03-13'),
xxxxxxx0209', '1', '', '2010-02-16'),
xxxxxxx0211', '1', '', '2014-10-16'),
xxxxxxx0212', '1', '', '2011-07-19'),
xxxxxxx0213', '1', '', '2010-04-01'),
xxxxxxx0216', '', '1', '2015-10-07'),
xxxxxxx0217', '1', '', '2011-01-17'),
xxxxxxx0218', '1', '', '2011-05-05'),
xxxxxxx0226', '1', '', '2009-08-04'),
xxxxxxx0229', '', '1', '2015-08-18'),
xxxxxxx0233', '', '1', '2013-05-06'),
xxxxxxx0237', '1', '', '2010-04-27'),
xxxxxxx0240', '1', '', '2011-05-09'),
xxxxxxx0242', '', '1', '2014-06-09'),
xxxxxxx0247', '1', '', '2009-12-02'),
xxxxxxx0252', '1', '', '2009-12-22'),
xxxxxxx0254', '1', '', '2013-11-13'),
xxxxxxx0259', '', '1', '2013-12-12'),
xxxxxxx0261', '1', '', '2012-01-18'),
xxxxxxx0263', '', '1', '2016-11-08'),
xxxxxxx0268', '1', '', '2010-01-05'),
xxxxxxx0277', '', '1', '2017-04-10'),
xxxxxxx0282', '1', '', '2010-04-26'),
xxxxxxx0283', '1', '', '2011-11-28'),
xxxxxxx0284', '1', '', '2010-04-06'),
xxxxxxx0290', '1', '', '2012-08-08'),
xxxxxxx0292', '1', '', '2011-05-19'),
xxxxxxx0300', '1', '', '2010-11-11'),
xxxxxxx0301', '1', '', '2011-11-29'),
xxxxxxx0302', '1', '', '2011-06-01'),
xxxxxxx0307', '1', '', '2010-04-07'),
xxxxxxx0310', '1', '', '2012-06-18'),
xxxxxxx0312', '', '1', '2015-01-19'),
xxxxxxx0313', '1', '', '2011-07-28'),
xxxxxxx0314', '1', '', '2011-06-22'),
xxxxxxx0318', '1', '', '2010-09-13'),
xxxxxxx0322', '1', '', '2014-02-15'),
xxxxxxx0329', '1', '', '2012-03-14'),
xxxxxxx0332', '', '1', '2016-02-29'),
xxxxxxx0334', '1', '', '2012-06-15'),
xxxxxxx0335', '', '1', '2013-10-18'),
xxxxxxx0338', '1', '', '2010-12-13'),
xxxxxxx0340', '', '1', '2016-08-24'),
xxxxxxx0342', '', '1', '2015-03-10'),
xxxxxxx0350', '1', '', '2013-02-27'),
xxxxxxx0353', '1', '', '2011-01-12'),
xxxxxxx0355', '1', '', '2011-03-11'),
xxxxxxx0361', '1', '', '2011-08-24'),
xxxxxxx0363', '', '1', '2014-03-13'),
xxxxxxx0364', '1', '', '2011-01-19'),
xxxxxxx0365', '', '1', '2014-11-03'),
xxxxxxx0375', '1', '', '2011-02-10'),
xxxxxxx0378', '', '1', '2014-08-01'),
xxxxxxx0379', '1', '', '2011-05-02'),
xxxxxxx0385', '1', '', '2011-07-18'),
xxxxxxx0391', '', '1', '2013-11-06'),
xxxxxxx0396', '1', '', '2011-10-06'),
xxxxxxx0398', '', '1', '2013-04-03'),
xxxxxxx0402', '', '1', '2016-04-29'),
xxxxxxx0407', '', '1', '2016-01-05'),
xxxxxxx0409', '1', '', '2012-07-23'),
xxxxxxx0411', '', '1', '2015-02-05'),
xxxxxxx0415', '1', '', '2012-02-02'),
xxxxxxx0422', '', '1', '2013-04-25'),
xxxxxxx0425', '', '1', '2015-05-07'),
xxxxxxx0429', '', '1', '2016-09-15'),
xxxxxxx0432', '', '1', '2015-01-19'),
xxxxxxx0433', '', '1', '2013-11-25'),
xxxxxxx0436', '1', '', '2011-12-15'),
xxxxxxx0442', '1', '', '2012-01-13'),
xxxxxxx0443', '', '1', '2013-10-04'),
xxxxxxx0446', '', '1', '2016-06-17'),
xxxxxxx0448', '1', '', '2012-02-02'),
xxxxxxx0457', '1', '', '2012-06-05'),
xxxxxxx0466', '1', '', '2012-05-24'),
xxxxxxx0467', '1', '', '2013-02-21'),
xxxxxxx0471', '1', '', '2012-03-08'),
xxxxxxx0477', '', '1', '2016-09-20'),
xxxxxxx0487', '', '1', '2015-08-06'),
xxxxxxx0492', '1', '', '2013-01-28'),
xxxxxxx0494', '1', '', '2013-02-14'),
xxxxxxx0496', '', '1', '2016-03-21'),
xxxxxxx0499', '1', '', '2013-05-03'),
xxxxxxx0500', '', '1', '2015-07-14'),
xxxxxxx0501', '1', '', '2012-09-24'),
xxxxxxx0417', '', '1', '2016-09-21'),
xxxxxxx0474', '', '1', '2017-11-24'),
xxxxxxx0475', '', '1', '2017-10-05'),
xxxxxxx0325', '', '1', '2017-05-15')
    );

//=========================================================================================================================================================

$query = "SELECT id FROM event_controls WHERE event_type = 'laboratory' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$psa_event_control_id = $res['id'];

$query = "UPDATE event_masters EventMaster, procure_ed_laboratories EventDetail
    SET EventDetail.biochemical_relapse = '', 
    EventMaster.modified = '$modified', 
    EventMaster.modified_by = $modified_by
    WHERE EventMaster.deleted <> 1
    AND EventDetail.event_master_id = EventMaster.id
    AND EventMaster.event_control_id = $psa_event_control_id
    AND EventDetail.biochemical_relapse = 'y';";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$errorAndMsg = array('PSA updated' => 0); 
foreach($psaData as $newbcr) {
    list($psNbr, $jan2015, $fall2018, $date) = $newbcr;
    if($jan2015 != '1' && $fall2018 != '1') die('errr');
    $query = "SELECT EventMaster.id
        FROM participants Participant
        INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
        INNER JOIN procure_ed_laboratories EventDetail ON EventDetail.event_master_id = EventMaster.id
        WHERE EventMaster.deleted <> 1
        AND EventMaster.event_control_id = $psa_event_control_id
        AND EventMaster.event_date = '$date'
        AND Participant.participant_identifier = '$psNbr'";
    $psa_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
    if(!$psa_res->num_rows) {
        $errorAndMsg["PSA not found"][] = "See PSA on '$date' for participant '$psNbr'.";
    } else if ($psa_res->num_rows > 1) {
        $errorAndMsg["Too many PSA on same date"][] = "See PSA on '$date' for participant '$psNbr'.";
    } else {
        $new_psa = mysqli_fetch_assoc($psa_res);
        $notes = array();
        if($jan2015 == '1') $notes[] = 'déterminé par PI local en Janvier 2015';
        if($fall2018 == '1') $notes[] = 'déterminé par PI local au printemps 2018';
        $notes = 'BCR '.implode(' & ', $notes).'.';
        $query = "UPDATE event_masters EventMaster, procure_ed_laboratories EventDetail
            SET EventDetail.biochemical_relapse = 'y',
            EventMaster.modified = '$modified',
            EventMaster.modified_by = $modified_by,
            EventMaster.event_summary = CONCAT('$notes', IFNULL(event_summary, ''))
            WHERE EventMaster.deleted <> 1
            AND EventDetail.event_master_id = EventMaster.id
            AND EventMaster.event_control_id = $psa_event_control_id
            AND EventMaster.id = ".$new_psa['id'].";";
        mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
        $errorAndMsg['PSA updated']++;
    }
}

//Revs
$query = "INSERT INTO event_masters_revs (id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, version_created, modified_by)
    (SELECT id, event_control_id, event_status, event_summary, event_date, event_date_accuracy, information_source, urgency, date_required, date_required_accuracy, date_requested, date_requested_accuracy, reference_number, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, modified, modified_by
    FROM event_masters
    WHERE event_control_id = $psa_event_control_id AND modified = '$modified' AND modified_by = $modified_by);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query = "INSERT INTO procure_ed_laboratories_revs (psa_total_ngml, event_master_id, biochemical_relapse, procure_chuq_minimum, testosterone_nmoll, procure_deprecated_field_psa_free_ngml, bcr_definition_precision, system_biochemical_relapse, version_created)
	(SELECT psa_total_ngml, event_master_id, biochemical_relapse, procure_chuq_minimum, testosterone_nmoll, procure_deprecated_field_psa_free_ngml, bcr_definition_precision, system_biochemical_relapse, modified
	FROM event_masters, procure_ed_laboratories 
	WHERE id = event_master_id AND event_control_id = $psa_event_control_id AND modified = '$modified' AND modified_by = $modified_by);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

echo "\nProcess Done\n";

pr($errorAndMsg);

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
