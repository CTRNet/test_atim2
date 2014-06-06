<?php

/*
 * Migrate all data from icm v2.6.2 with procure data to procure v262
 */

set_time_limit('3600');

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------


global $db_icm_schema;
global $db_procure_schema;

$is_server = false;

$db_icm_ip			= "127.0.0.1";
$db_icm_port 		= "";
$db_icm_user 		= "root";
$db_icm_pwd			= "";
$db_icm_schema		= "icm";
$db_icm_charset		= "utf8";

$db_procure_ip			= "127.0.0.1";
$db_procure_port 		= "";
$db_procure_user 		= "root";
$db_procure_pwd			= "";
$db_procure_schema		= "procurechum";
$db_procure_charset		= "utf8";

if($is_server) {
	$db_icm_ip			= "localhost";
	$db_icm_port 		= "";
	$db_icm_user 		= "root";
	$db_icm_pwd			= "am3-y-4606";
	$db_icm_schema		= "icmtmp";
	$db_icm_charset		= "utf8";
	
	$db_procure_ip			= "localhost";
	$db_procure_port 		= "";
	$db_procure_user 		= "root";
	$db_procure_pwd			= "am3-y-4606";
	$db_procure_schema		= "procuretmp";
	$db_procure_charset		= "utf8";

}

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_icm_connection;
$db_icm_connection = @mysqli_connect(
		$db_icm_ip.(!empty($db_icm_port)? ":".$db_icm_port : ''),
		$db_icm_user,
		$db_icm_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_icm_connection, $db_icm_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_icm_connection, $db_icm_schema) or die("db selection failed");

global $db_procure_connection;
$db_procure_connection = @mysqli_connect(
		$db_procure_ip.(!empty($db_procure_port)? ":".$db_procure_port : ''),
		$db_procure_user,
		$db_procure_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_procure_connection, $db_procure_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_procure_connection, $db_procure_schema) or die("db selection failed");
mysqli_autocommit($db_procure_connection, true);

//--------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;
global $modified;

$modified_by = '9';

$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

//--------------------------------------------------------------------------------------------------------------------------------------------

$bank_identification = 'PS1P';

$no_labo_to_db_data = array();
$query = "SELECT p.id AS participant_id, m.identifier_value, cm.consent_signed_date
	FROM participants p
	INNER JOIN misc_identifiers m ON m.participant_id = p.id AND m.deleted <> 1 
	INNER JOIN misc_identifier_controls mc ON mc.id = m.misc_identifier_control_id
	LEFT JOIN consent_masters cm ON cm.participant_id = p.id
	WHERE p.deleted <> 1 AND m.deleted <> 1 AND mc.misc_identifier_name = 'prostate bank no lab' AND cm.deleted <> 1
	ORDER BY p.id ASC, cm.consent_signed_date DESC";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
While($res = mysqli_fetch_assoc($query_res)) {
	if(!isset($no_labo_to_db_data[$res['identifier_value']])) {
		$no_labo_to_db_data[$res['identifier_value']] = array(
			'participant_id' => $res['participant_id'],
			'consent_signed_date' => $res['consent_signed_date']);
	}
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Trunkate : to remove
//TODO
//--------------------------------------------------------------------------------------------------------------------------------------------

foreignKeyCheck(0);
$truncate_arr = array(
	'participants', 
	'misc_identifiers',
	'consent_masters', 
	'procure_cd_sigantures', 
	'participant_messages',
	'participant_contacts', 
	'event_masters',
	'procure_ed_lifestyle_quest_admin_worksheets', 
	'storage_masters','std_rooms','std_cupboards','std_nitro_locates','std_incubators','std_fridges','std_freezers','std_boxs','std_racks','std_shelfs','std_tma_blocks',
	'collections',
	'study_summaries',
		
	'sample_masters', 
	'specimen_details', 
	'derivative_details', 
	'sd_spe_bloods',
	'sd_der_pbmcs', 
	'sd_der_serums',
	'sd_der_plasmas',
	'sd_spe_urines',
	'sd_der_urine_cents',
	'sd_spe_tissues',
	'sd_der_dnas',
	'sd_der_rnas',
		
	'aliquot_masters',
	'ad_whatman_papers',
	'ad_tubes',
	'ad_blocks',
	'source_aliquots',
	'quality_ctrls',
	'aliquot_internal_uses'
);
foreach($truncate_arr as $tablename) {
	mysqli_query($db_procure_connection, "TRUNCATE $tablename;") or die("query failed ["."TRUNCATE $tablename;"."]: " . mysqli_error($db_procure_connection)."]");
	mysqli_query($db_procure_connection, "TRUNCATE ".$tablename."_revs;") or die("query failed ["."TRUNCATE $tablename;"."]: " . mysqli_error($db_procure_connection)."]");
}
foreignKeyCheck(1);

//--------------------------------------------------------------------------------------------------------------------------------------------
// USERS/GROUPS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** USERS/GROUPS ******************************<br>";
echo "** Import banks,group,users<br>";
echo "** In-activated all users no in group 'Users Prostate'<br>";
echo "**************************************************************<br><br>";

foreach(array('users','groups','banks') as $tablename) {
	$query = "DELETE FROM $db_procure_schema.$tablename;";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
foreach(array('banks','groups','users') as $tablename) {
	$query = "INSERT INTO $db_procure_schema.$tablename (SELECT * FROM $db_icm_schema.$tablename);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
$tablename = 'banks';
$revs_tablename = $tablename."_revs";
$query = "TRUNCATE $revs_tablename;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.$revs_tablename (SELECT * FROM $db_icm_schema.$revs_tablename);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

$query = "SELECT count(*) AS count FROM groups WHERE bank_id NOT IN (SELECT id FROM banks);";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['count']) die('ERR 7387383989309.1');

$query = "SELECT count(*) AS count  FROM users WHERE group_id NOT IN (SELECT id FROM groups);";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['count']) die('ERR 7387383989309.2');

$query = "UPDATE users SET flag_active = 0 WHERE group_id != (SELECT id FROM groups WHERE name = 'Users Prostate') AND username != 'NicoEn';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

foreach(array('aros','acos','aros_acos','system_vars','user_logs','configs') as $tablename) {
	$query = "TRUNCATE $db_procure_schema.$tablename;";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$query = "INSERT INTO $db_procure_schema.$tablename (SELECT * FROM $db_icm_schema.$tablename);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// PARTICIPANTS & MISC-IDENTIFIERS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** PARTICIPANTS ******************************<br>";
echo "** Following participants fields wont't be migrated : cod_icd10_code(cause décés), language_preferred, sex, last_visit_date (does not exist in ICM form), sardo_participant_id, sardo_medical_record_number, last_sardo_import_date, qc_nd_from_center, is_anonymous, anonymous_reason, anonymous_precision<br>";
$participants_fields = array(
	'id',
	'first_name',
	'last_name',
	'date_of_birth',
	'date_of_birth_accuracy',
	'vital_status',
	'language_preferred',
	'notes',
	'date_of_death',
	'date_of_death_accuracy',
	'last_chart_checked_date',
	'last_chart_checked_date_accuracy',
	'last_modification',
	'last_modification_ds_id',
	'qc_nd_last_contact'
);
echo "** Following field will be migrated : ".implode(', ',$participants_fields)."<br>";
echo "** Participant Identifier will be replaced by bare-code<br>";;
echo "** Import following identifiers: Prostate NoLabo, St luc hospital number, hd hospital number, nd hospital number, ramq, old no labo<br>";
echo "**************************************************************<br><br>";

//Record data into participants
$fields = implode(', ', array_merge($participants_fields, array('created','created_by','modified','modified_by','deleted')));
$query = "REPLACE INTO $db_procure_schema.participants ($fields) (SELECT $fields FROM $db_icm_schema.participants);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$fields = implode(', ', array_merge($participants_fields, array('modified_by','version_id','version_created')));
$query = "REPLACE INTO $db_procure_schema.participants_revs ($fields) (SELECT $fields FROM $db_icm_schema.participants_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Check all participants linked to No Labo Prostate (IN ICM)
$query = "SELECT id FROM participants WHERE deleted <> 1 AND id NOT IN (SELECT mid.participant_id FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc ON midc.id = mid.misc_identifier_control_id WHERE midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1)
		UNION ALL
		SELECT mid.participant_id FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc ON midc.id = mid.misc_identifier_control_id WHERE midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value NOT REGEXP '^(([0-9]{3,4})|([Ss]1-P[0-9]{3}))$';";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have no barcode or barcode with a wrong format<br><br>";
$participant_ids_with_no_barcode = $participant_identifiers;
//Record Misc Identifier data
mysqli_query($db_procure_connection, "DELETE FROM misc_identifier_controls;") or die("query failed ["."DELETE FROM misc_identifier_controls;"."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifier_controls (SELECT * FROM $db_icm_schema.misc_identifier_controls);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifiers (SELECT * FROM $db_icm_schema.misc_identifiers);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifiers_revs (SELECT * FROM $db_icm_schema.misc_identifiers_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Replace participant_identifier by $bank_identification+code barre
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc 
	SET part.participant_identifier = CONCAT('$bank_identification', mid.identifier_value), part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value REGEXP '^[0-9]{4}$';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc
	SET part.participant_identifier = CONCAT('$bank_identification','0', mid.identifier_value), part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value REGEXP '^[0-9]{3}$';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc
	SET part.participant_identifier = CONCAT('$bank_identification','0', REPLACE( mid.identifier_value , 'S1-P' , '')), part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value REGEXP '^[Ss]1-P[0-9]{3}$';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE participants SET participant_identifier = CONCAT('$bank_identification', '0000') WHERE id IN (".implode(',',$participant_ids_with_no_barcode).");";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "SELECT part.participant_identifier, part.res FROM (SELECT count(*) AS res, participant_identifier FROM participants WHERE deleted <> 1 GROUP BY participant_identifier) as part WHERE part.res > 1;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$dup_counter = 0;
While($res = mysqli_fetch_assoc($query_res)) {
	$dup_counter++;
	$p_ident = $res['participant_identifier'];
	$p_ident_res = $res['res'];
	echo "ERROR: $p_ident_res patient have been migrated with participant identifier = $p_ident.<br><br>";
	$query = "UPDATE participants SET participant_identifier = CONCAT(participant_identifier,'(',$dup_counter,')') WHERE participant_identifier = '$p_ident';";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
//approximate_date_of_death if required
$query = "select id, participant_identifier, approximate_date_of_death, approximate_date_of_death_accuracy FROM participants WHERE approximate_date_of_death IS NOT NULL AND approximate_date_of_death NOT LIKE '' AND (date_of_death IS NULL OR date_of_death LIKE '') AND deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_identifier'];
	$query = "UPDATE participants SET date_of_death = '".$res['approximate_date_of_death']."', date_of_death_accuracy = '".$res['approximate_date_of_death_accuracy']."' WHERE id = ".$res['id'].";";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
if($participant_identifiers) echo "Message : Participants (#syst code = ".implode(', ',$participant_identifiers).") have an approximate date of death in ICM version : Dates won't be migrated<br><br>";
//ADd new line in rev table
$fields = implode(', ', array_merge($participants_fields, array('modified_by','modified')));
$fields_revs = implode(', ', array_merge($participants_fields, array('modified_by','version_created')));
$query = "INSERT INTO participants_revs ($fields_revs) (SELECT $fields FROM participants);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Delete all No Labo Prostate
$query = "UPDATE misc_identifiers mid, misc_identifier_controls midc SET mid.deleted = 1, mid.modified = '$modified', mid.modified_by = $modified_by WHERE midc.id = mid.misc_identifier_control_id AND midc.misc_identifier_name = 'code-barre';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO misc_identifiers_revs (id,identifier_value,misc_identifier_control_id,participant_id,tmp_deleted,flag_unique,modified_by,version_created) 
	(SELECT mid.id,mid.identifier_value,mid.misc_identifier_control_id,mid.participant_id,mid.tmp_deleted,mid.flag_unique,mid.modified_by,mid.modified
	FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc WHERE midc.id = mid.misc_identifier_control_id AND midc.misc_identifier_name = 'code-barre');";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE misc_identifier_controls midc SET midc.flag_active = 0 WHERE midc.misc_identifier_name = 'code-barre';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Track new code-barre
$no_labo_to_ps1p = array();
$query = "
	SELECT p.participant_identifier as 'ps1p', mi.identifier_value as 'no_labo'
	FROM participants p 
	INNER JOIN misc_identifiers mi ON mi.participant_id = p.id AND mi.deleted <> 1
	INNER JOIN misc_identifier_controls mc ON mc.id = mi.misc_identifier_control_id
	WHERE mc.misc_identifier_name = 'prostate bank no lab';";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
While($res = mysqli_fetch_assoc($query_res)) {
	$no_labo_to_ps1p[$res['no_labo']] = $res['ps1p'];
}

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// CONSENTS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** CONSENTS ******************************<br>";
$cst_detail_fields = array(
	'consent_master_id',
	'qc_nd_biological_material_use',
	'qc_nd_use_of_urine',
	'qc_nd_use_of_blood',
	'qc_nd_research_other_disease',
	'qc_nd_urine_blood_use_for_followup',
	'qc_nd_stop_followup',
	'qc_nd_stop_followup_date',
	'qc_nd_allow_questionnaire',
	'qc_nd_stop_questionnaire',
	'qc_nd_stop_questionnaire_date',
	'qc_nd_contact_for_additional_data',
	'qc_nd_inform_significant_discovery',
	'qc_nd_inform_discovery_on_other_disease');
echo "** Following fields will be migrated :  qc_nd_consent_version_date, consent_language, consent_signed_date, consent_signed_date_accuracy,notes, ".implode(', ',$cst_detail_fields)."<br>";
echo "** Following consents fields won't be migrated : invitation_date, consent_status, status_date, reason_denied, (consent_control_id)<br>";
echo "**********************************************************<br><br>";

$query = "SELECT * FROM (SELECT count(*) as count, participant_id FROM consent_masters WHERE deleted <> 1 GROUP BY participant_id) AS res WHERE res.count > 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have 2 consents<br><br>";
$participant_ids_with_2_csts = $participant_identifiers;

$query = "SELECT participant_id FROM consent_masters WHERE consent_status <> 'obtained' AND deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have consent status != obtained<br><br>";

$query = "SELECT participant_id FROM consent_masters WHERE consent_control_id != (SELECT id FROM consent_controls WHERE flag_active = 1 AND controls_type = 'procure') AND deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have consent different than  'procure' consent<br><br>";

$query = "select id from consent_controls WHERE controls_type = 'procure consent form signature';";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$consent_control_id = $res['id'];

//Consent Master
$query = "INSERT INTO $db_procure_schema.consent_masters (id, participant_id, consent_control_id, qc_nd_consent_version_date, procure_form_identification, form_version, consent_signed_date, consent_signed_date_accuracy,notes,created,created_by,modified,modified_by,deleted)
	(SELECT id, participant_id, $consent_control_id, consent_version_date, id, consent_language,consent_signed_date, consent_signed_date_accuracy,notes,created,created_by,modified,modified_by,deleted from $db_icm_schema.consent_masters);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.consent_masters_revs (id, participant_id, consent_control_id, qc_nd_consent_version_date, procure_form_identification, form_version, consent_signed_date, consent_signed_date_accuracy,notes,modified_by,version_id,version_created)
	(SELECT id, participant_id, $consent_control_id, consent_version_date, id, consent_language,consent_signed_date, consent_signed_date_accuracy,notes,modified_by,version_id,version_created from $db_icm_schema.consent_masters_revs);";
$queries = array(
	"UPDATE consent_masters SET form_version = 'english' WHERE form_version = 'en';",
	"UPDATE consent_masters_revs SET form_version = 'english' WHERE form_version = 'en';",
	"UPDATE consent_masters SET form_version = 'french' WHERE form_version = 'fr';",
	"UPDATE consent_masters_revs SET form_version = 'french' WHERE form_version = 'fr';",
	"UPDATE consent_masters SET consent_signed_date_accuracy = 'h' WHERE consent_signed_date_accuracy IN ('c','');",
	"UPDATE consent_masters_revs SET consent_signed_date_accuracy = 'h' WHERE consent_signed_date_accuracy IN ('c','');",
	"UPDATE consent_masters cst, participants p SET cst.procure_form_identification = CONCAT(p.participant_identifier, ' V0 -CSF1') WHERE p.id = cst.participant_id;",
	"UPDATE consent_masters_revs cst, participants p SET cst.procure_form_identification = CONCAT(p.participant_identifier, ' V0 -CSF1') WHERE p.id = cst.participant_id;");
foreach($queries as $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Consent Detail
$fields = implode(', ', $cst_detail_fields);
$fields_icm = str_replace('qc_nd_','',$fields);
$query = "INSERT INTO $db_procure_schema.procure_cd_sigantures ($fields) (SELECT $fields_icm FROM $db_icm_schema.cd_icm_generics);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$fields_revs = implode(', ', array_merge($cst_detail_fields, array('version_id','version_created')));
$fields_revs_icm = str_replace('qc_nd_','',$fields_revs);
$query = "INSERT INTO $db_procure_schema.procure_cd_sigantures_revs ($fields_revs) (SELECT $fields_revs_icm FROM $db_icm_schema.cd_icm_generics_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Update Identification (cst.) for patient having more than 1 cst
$query = "SELECT cst.participant_id, p.participant_identifier, cst.id AS consent_master_id FROM consent_masters cst INNER JOIN participants p ON p.id = cst.participant_id WHERE participant_id IN (".implode(',',$participant_ids_with_2_csts).") AND cst.deleted <> 1 ORDER BY cst.participant_id, cst.consent_signed_date;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$std_p_id = null;
$sct_nbr = null;
while($res = mysqli_fetch_assoc($query_res)) {	
	if($std_p_id != $res['participant_id']) {
		$std_p_id = $res['participant_id'];
		$sct_nbr = 0;
	}
	$sct_nbr++;
	$queries = array(
		"UPDATE consent_masters SET procure_form_identification = CONCAT('".$res['participant_identifier']."', ' V0 -CSF', $sct_nbr) WHERE id = ".$res['consent_master_id'].";",
		"UPDATE consent_masters_revs SET procure_form_identification = CONCAT('".$res['participant_identifier']."', ' V0 -CSF', $sct_nbr) WHERE id = ".$res['consent_master_id'].";");
	foreach($queries as $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
//Custom list
$procure_control_id = migrateCustomList('qc consent version', 'Consent version date');
$query = "DELETE FROM structure_permissible_values_customs WHERE control_id = $procure_control_id AND value NOT IN (SELECT DISTINCT qc_nd_consent_version_date FROM consent_masters);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//consent control
$query = "SELECT count(*) as nbr, 'consent_masters' as type FROM consent_masters
	UNION ALL
	SELECT count(*) as nbr, 'procure_cd_sigantures' as type FROM procure_cd_sigantures;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$consent_masters_count = null;
$procure_cd_sigantures_count = null;
while($res = mysqli_fetch_assoc($query_res)) {	
	switch($res['type']) {
		case 'consent_masters':
			$consent_masters_count = $res['nbr'];
			break;
		case 'procure_cd_sigantures':
			$procure_cd_sigantures_count = $res['nbr'];
			break;
	}
}
if($consent_masters_count != $procure_cd_sigantures_count) die('ERR 2387 62876 32873 ');

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// Questionnaire
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** QUESTIONNAIRES ******************************<br>";
echo "** Mirgation from excel file<br>";
echo "****************************************************************<br><br>";

$query = "SELECT id FROM event_controls WHERE event_type = 'procure questionnaire administration worksheet';";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$event_control_id = $res['id'];
require_once 'Excel/reader.php';
$file_path = "C:/_Perso/Server/procure_chum/data/BiobanqueProCureQuestionnaire_20140605.xls";
if($is_server) $file_path = "/ATiM/icm/v2/ATiM-Split/Test3/BiobanqueProCureQuestionnaire_20140605.xls";
$XlsReader = new Spreadsheet_Excel_Reader();
$XlsReader->read($file_path);
foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
$headers = array();
$nl_labos_linked_to_approximative_date_equal_to_cst_date = array();
$nl_labos_with_no_questionnaire = array();
$line_counter = 0;
$q_errors = array('empty date' => array(), 'no_labo_unknown' => array(), 'more than one' => array());
foreach($XlsReader->sheets[$sheets_nbr['Cas complet']]['cells'] as $line => $new_line) {
	$line_counter++;
	if($line_counter == 1) {
		$headers = $new_line;
	} else {
		//Get line data
		$new_line_data = array();
		foreach($headers as $key => $field) {
			if(isset($new_line[$key])) {
				$new_line_data[utf8_encode($field)] = utf8_encode($new_line[$key]);
			} else {
				$new_line_data[utf8_encode($field)] = '';
			}
		}
		//Manage data
		$approximative_date = '';
		$q_no_labo = ((strlen($new_line_data['NoLabo']) == '3')? '500' : '50').$new_line_data['NoLabo'];	
		$q_revision_date_tmp = getDateAndAccuracy($new_line_data['Date de révision'], 'Date de révision', $line_counter, true);
		$q_revision_date = $q_revision_date_accuracy = null;
		if($q_revision_date_tmp) {
			$q_revision_date = $q_revision_date_tmp['date'];
			$q_revision_date_accuracy = $q_revision_date_tmp['accuracy'];
			$approximative_date = $q_revision_date;
		}
		$q_reception_date_tmp = getDateAndAccuracy($new_line_data['Date de reception'], 'Date de reception', $line_counter, true);
		$q_reception_date = $q_reception_date_accuracy = null;
		if($q_reception_date_tmp) {
			$q_reception_date = $q_reception_date_tmp['date'];
			$q_reception_date_accuracy = $q_reception_date_tmp['accuracy'];
			$approximative_date = $q_reception_date;
		}
		if(isset($no_labo_to_db_data[$q_no_labo])) {
			if(isset($no_labo_to_db_data[$q_no_labo]['qc_done']) && $no_labo_to_db_data[$q_no_labo]['qc_done']) {
				$q_errors['more than one'][] = $q_no_labo;
			} else {
				$no_labo_to_db_data[$q_no_labo]['qc_done'] = true;
				if(!$approximative_date)  {
					if(isset($no_labo_to_ps1p[$q_no_labo]) && preg_match('/^PS1P([0-9]{4})$/', $no_labo_to_ps1p[$q_no_labo], $matches)) {
						$ps1p = ltrim($matches[1], "0");
						if(25 <= $ps1p && $ps1p <= 154) {
							$approximative_date = '2007-01-01';
						} else if(156 <= $ps1p && $ps1p <= 273) {
							$approximative_date = '2008-01-01';
						} else  if(275 <= $ps1p && $ps1p <= 386) {
							$approximative_date = '2009-01-01';
						} else  if(387 <= $ps1p && $ps1p <= 484) {
							$approximative_date = '2010-01-01';
						} else  if(484 <= $ps1p && $ps1p <= 594) {
							$approximative_date = '2011-01-01';
						} else  if(595 <= $ps1p && $ps1p <= 624) {
							$approximative_date = '2012-01-01';
						} 
					}	
				}
				if(!$approximative_date)  {
					if(empty($no_labo_to_db_data[$q_no_labo]['consent_signed_date'])) {
						$q_errors['empty date'][] = $q_no_labo;
					} else {
						$approximative_date = $no_labo_to_db_data[$q_no_labo]['consent_signed_date'];
						$nl_labos_linked_to_approximative_date_equal_to_cst_date[] = $q_no_labo;
					}
				}
				if($approximative_date) {
					$detail_data = array();
					foreach(array('Distribué', 'Reçu', 'Vérifié', 'Révisé', 'Complet') as $excel_field) if(!in_array($new_line_data[$excel_field], array('0','1', ''))) die('ERR 2376 287632 ');
					if($new_line_data['Révisé'] || $q_revision_date) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'",
							'recovery_date' => "'".($q_reception_date? $q_reception_date : $approximative_date)."'", 'recovery_date_accuracy' => ($q_reception_date? "'$q_reception_date_accuracy'" : "'y'"),
							'verification_date' => "'$approximative_date'", 'verification_date_accuracy' => "'y'",
							'revision_date' => "'".($q_revision_date? $q_revision_date : $approximative_date)."'", 'revision_date_accuracy' => ($q_revision_date? "'$q_revision_date_accuracy'" : "'y'"),
							'verification_result' => ($new_line_data['Complet'] == '1')? "'complete'" : (($new_line_data['Complet'] == '0')? "'incomplete'" : "''"));
					} else if($new_line_data['Vérifié']) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'",
							'recovery_date' => "'".($q_reception_date? $q_reception_date : $approximative_date)."'", 'recovery_date_accuracy' => ($q_reception_date? "'$q_reception_date_accuracy'" : "'y'"),
							'verification_date' => "'$approximative_date'", 'verification_date_accuracy' => "'y'",
							'verification_result' => ($new_line_data['Complet'] == '1')? "'complete'" : (($new_line_data['Complet'] == '0')? "'incomplete'" : "''"));
					} else if($new_line_data['Reçu'] || $q_reception_date) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'",
							'recovery_date' => "'".($q_reception_date? $q_reception_date : $approximative_date)."'", 'recovery_date_accuracy' => ($q_reception_date? "'$q_reception_date_accuracy'" : "'y'"));
					} else if($new_line_data['Distribué']) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'");
					}
					if($detail_data) {
						//EventMaster
						$query = "INSERT INTO $db_procure_schema.event_masters (participant_id, event_control_id, procure_form_identification, event_summary,created,created_by,modified,modified_by)
							VALUES
							(".$no_labo_to_db_data[$q_no_labo]['participant_id'].", $event_control_id, '', '', '$modified', $modified_by, '$modified', $modified_by);";
						
						mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
						$event_master_id = mysqli_insert_id($db_procure_connection);
						//EventDetail
						$fields = 'event_master_id,'.implode(', ', array_keys($detail_data));
						$values = $event_master_id.','.implode(', ', $detail_data);
						$query = "INSERT INTO $db_procure_schema.procure_ed_lifestyle_quest_admin_worksheets ($fields) VALUES ($values);";
						
						mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
					} else {
						$nl_labos_with_no_questionnaire[] = $q_no_labo;
						if($new_line_data['Complet']) die('ERR 23 7687326 872 '.$line_counter);					
					}
				}
			}
		} else {
			$q_errors['no_labo_unknown'][] = $q_no_labo;
		}
	}
}
//procure_form_identification
$query = "UPDATE $db_procure_schema.event_masters ev, $db_procure_schema.participants p SET ev.procure_form_identification = CONCAT(p.participant_identifier, ' V0 -QUE1') WHERE p.id = ev.participant_id AND ev.event_control_id = $event_control_id;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Revs table
$query = "INSERT INTO $db_procure_schema.event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_summary, modified_by, version_created)
	(SELECT id, participant_id, event_control_id, procure_form_identification, event_summary, modified_by, modified from $db_procure_schema.event_masters WHERE event_control_id = $event_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.procure_ed_lifestyle_quest_admin_worksheets_revs (event_master_id, delivery_date, recovery_date, verification_date, revision_date, verification_result, version_created)
	(SELECT event_master_id, delivery_date, recovery_date, verification_date, revision_date, verification_result, modified FROM $db_procure_schema.procure_ed_lifestyle_quest_admin_worksheets INNER JOIN $db_procure_schema.event_masters ON event_masters.id = event_master_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//Messages
if($q_errors['empty date']) echo "Error: NoLabos [".implode(', ',$q_errors['empty date'])."] defined into questionnaire is both not linked to a date into questionnaire excel file and not linked to a consent date into ATiM database : unable to set a questionnaire approximative date so no questionnaire will be created<br><br>";
if($q_errors['no_labo_unknown']) echo "Error: NoLabos [".implode(', ',$q_errors['no_labo_unknown'])."] defined into questionnaire excel file does not match a patient into ATiM database<br><br>";
if($q_errors['more than one']) echo "Error: NoLabos [".implode(', ',$q_errors['more than one'])."] are linked to more than one questionnaire. Only the first one will be created<br><br>";
if($nl_labos_with_no_questionnaire) echo "Error: NoLabos [".implode(', ',$nl_labos_with_no_questionnaire)."] defined into questionnaire are not linked to questionnaire data : no questionnaire will be created<br><br>";
if($nl_labos_linked_to_approximative_date_equal_to_cst_date) echo "Error: NoLabos [".implode(', ',$nl_labos_linked_to_approximative_date_equal_to_cst_date)."] defined into questionnaire are not linked to questionnaire date : used consent date as approximative date<br><br>";

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// Contacts & Messages
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** CONTACTS & MESSAGES ******************************<br>";
$message_fields = array('id',
	'date_requested',
	'date_requested_accuracy',
	'author',
	'message_type',
	'title',
	'description',
	'due_date',
	'due_date_accuracy',
	'expiry_date',
	'expiry_date_accuracy',
	'participant_id',
	'done',
	'status');
echo "** Migration of fields : ".implode(',', $message_fields)."<br>";
echo "***************************************************************<br><br>";

foreach(array('participant_contacts', 'participant_contacts_revs') as $tablename) {
	$query = "INSERT INTO $db_procure_schema.$tablename (SELECT * FROM $db_icm_schema.$tablename);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
$fields = implode(',',$message_fields).',created,created_by,modified,modified_by,deleted';
$query = "INSERT INTO $db_procure_schema.participant_messages (".str_replace('status','qc_nd_status',$fields).") (SELECT $fields FROM $db_icm_schema.participant_messages);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$fields = implode(',',$message_fields).',modified_by,version_id,version_created';
$query = "INSERT INTO $db_procure_schema.participant_messages_revs (".str_replace('status','qc_nd_status',$fields).") (SELECT $fields FROM $db_icm_schema.participant_messages_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// STORAGES
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** STORAGES ******************************<br>";
echo "all field will be migrated<br>";
echo "**********************************************************<br><br>";

$query = "DELETE FROM storage_controls;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");		
$query = "INSERT INTO $db_procure_schema.storage_controls (SELECT * FROM $db_icm_schema.storage_controls);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
foreignKeyCheck(0);
//Master
$new_table = 'storage_masters';
$query = "INSERT INTO $db_procure_schema.$new_table (SELECT * FROM $db_icm_schema.$new_table);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$new_table = $new_table.'_revs';
$query = "INSERT INTO $db_procure_schema.$new_table (SELECT * FROM $db_icm_schema.$new_table);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
foreignKeyCheck(1);
//FK control
$query = "SELECT count(*) as failed FROM storage_masters WHERE parent_id IS NOT NULL AND parent_id NOT IN (SELECT id FROM storage_masters);";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['failed']) die('ERR 23876287632 ');
$query = "SELECT count(*) as failed FROM storage_masters WHERE storage_control_id NOT IN (SELECT id FROM storage_controls);";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['failed']) die('ERR 23876287633 ');
//Detail tables
$storage_tables = array('std_rooms','std_cupboards','std_nitro_locates','std_incubators','std_fridges','std_freezers','std_boxs','std_racks','std_shelfs','std_tma_blocks');
foreach($storage_tables as $new_table) {
	$query = "INSERT INTO $db_procure_schema.$new_table (SELECT * FROM $db_icm_schema.$new_table);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$new_table = $new_table.'_revs';
	$query = "INSERT INTO $db_procure_schema.$new_table (SELECT * FROM $db_icm_schema.$new_table);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// STUDY
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** STUDIES ******************************<br>";
echo "** Following fields will be migrated : title, start_date, start_date_accuracy,end_date,end_date_accuracy,summary<br>";
echo "** Following fields won't be migrated : qc_nd_researcher, qc_nd_contact, qc_nd_code<br>";
echo "*********************************************************<br><br>";

$fields = array(
	'id',
	'title',
	'start_date',
	'start_date_accuracy',
	'end_date',
	'end_date_accuracy',
	'summary');	
$field_strg = implode(', ', array_merge($fields, array('created','created_by','modified','modified_by','deleted')));
$query = "INSERT INTO $db_procure_schema.study_summaries ($field_strg) (SELECT $field_strg FROM $db_icm_schema.study_summaries);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$field_strg = implode(', ', array_merge($fields, array('modified_by','version_id','version_created')));
$query = "INSERT INTO $db_procure_schema.study_summaries_revs ($field_strg) (SELECT $field_strg FROM $db_icm_schema.study_summaries_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// ORDER
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** ORDERS ******************************<br><br>";

echo "Nothing migrated<br><br>";

flush();

//--------------------------------------------------------------------------------------------------------------------------------------------
// INVENTORY
//--------------------------------------------------------------------------------------------------------------------------------------------

// -- COLLECTION --------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** COLLECTIONS ******************************<br>";

$procure_control_id = migrateCustomList('Specimen Collection Sites%', 'Specimen Collection Sites%');
$query = "DELETE FROM $db_procure_schema.structure_permissible_values_customs WHERE control_id = $procure_control_id AND value NOT IN (SELECT distinct collection_site FROM $db_icm_schema.collections WHERE collection_site IS NOT NULL);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

$fields = array(
	'id',
	'collection_site',
	'collection_datetime',
	'collection_datetime_accuracy',
	'collection_property',
	'collection_notes',
	'participant_id',
	'procure_visit');
echo "** Following fields will be migrated : ".implode(', ', $fields)."<br>";
echo "*****************************************************************<br><br>";

$field_strg = implode(', ', array_merge($fields, array('created','created_by','modified','modified_by','deleted')));
$query = "INSERT INTO $db_procure_schema.collections ($field_strg) (SELECT ".str_replace('procure_visit', 'visit_label', $field_strg)." FROM $db_icm_schema.collections);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$field_strg = implode(', ', array_merge($fields, array('modified_by','version_id','version_created')));
$query = "INSERT INTO $db_procure_schema.collections_revs ($field_strg) (SELECT ".str_replace('procure_visit', 'visit_label', $field_strg)." FROM $db_icm_schema.collections_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

// -- SAMPLES --------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** SAMPLES ******************************<br>";
$sample_master_fields = "id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,notes,created,created_by,modified,modified_by,deleted";
$specimen_fields = "sample_master_id,supplier_dept,time_at_room_temp_mn,reception_by,reception_datetime,reception_datetime_accuracy";
$derivative_fields = "sample_master_id,creation_by,creation_datetime,creation_datetime_accuracy";
echo "** Sample fields $sample_master_fields will be migrated!<br>";
echo "** Warning: Sample fields qc_nd_sample_label, is_problematic won't be migrated!<br>";
echo "** Specimen fields $specimen_fields will be migrated!<br>";
echo "** Warning: Specimen fields type_code, sequence_number won't be migrated!<br>";
echo "** Derivative fields $derivative_fields will be migrated!<br>";
echo "** Warning: Derivative fields creation_site won't be migrated!<br>";
echo "** Warning: Blood cell will be migrated to pbmc!<br>";
echo "** Warning: concentrated urine will be migrated to centrifuged urine!<br>";
echo "*********************************************************<br><br>";

//SAMPLE MASTERS

$migrated_sample_types = array('blood','blood cell','centrifuged urine','concentrated urine','dna','pbmc','plasma','rna','serum','tissue','urine');
$query = "SELECT sample_type, id FROM sample_controls WHERE id IN (SELECT DISTINCT sample_control_id FROM sample_masters WHERE deleted <> 1)";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$unmigrated_sample_types = array();
$sample_controls_data = array();
while ($res = mysqli_fetch_assoc($query_res)) {
	if(!in_array($res['sample_type'], $migrated_sample_types)) $unmigrated_sample_types[] = $res['sample_type'];
	else $sample_controls_data[$res['sample_type']] = $res['id'];
}
if($unmigrated_sample_types) echo "Error: SampleType [".implode(', ',$unmigrated_sample_types)."] exists into ICM database : samples won't be migrated!<br><br>";
$query = "SELECT sample_type, id FROM sample_controls WHERE id IN (SELECT DISTINCT sample_control_id FROM sample_masters WHERE deleted <> 1)";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
while ($res = mysqli_fetch_assoc($query_res)) {
	if(!isset($sample_controls_data[$res['sample_type']])) die('ERR 23 762387 623 2.1');
	if($sample_controls_data[$res['sample_type']] != $res['id']) die('ERR 23 762387 623 2.2');
}
$sample_control_ids = implode(',',$sample_controls_data);
$query = "INSERT INTO $db_procure_schema.sample_masters ($sample_master_fields) (SELECT $sample_master_fields from $db_icm_schema.sample_masters WHERE sample_control_id IN ($sample_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = str_replace(array('sample_masters', 'created,created_by,modified,modified_by,deleted'), array('sample_masters_revs', 'modified_by,version_id,version_created'), $query);
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

//SPECIMENS

$query = "INSERT INTO $db_procure_schema.specimen_details ($specimen_fields) (SELECT $specimen_fields FROM $db_icm_schema.specimen_details INNER JOIN $db_icm_schema.sample_masters ON id = sample_master_id WHERE sample_control_id IN ($sample_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = str_replace(array('specimen_details', ',reception_datetime_accuracy'), array('specimen_details_revs',',reception_datetime_accuracy,version_id,version_created'), $query);
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//custom list
$procure_control_id = migrateCustomList('Laboratory Staff', 'Laboratory Staff');
$query_distinct = "SELECT DISTINCT res.lab_staff FROM (
	SELECT DISTINCT added_by AS lab_staff FROM order_items UNION ALL
	SELECT DISTINCT shipped_by AS lab_staff FROM shipments UNION ALL
	SELECT DISTINCT run_by AS lab_staff FROM quality_ctrls UNION ALL
	SELECT DISTINCT used_by AS lab_staff FROM aliquot_internal_uses UNION ALL
	SELECT DISTINCT stored_by AS lab_staff FROM aliquot_masters UNION ALL
	SELECT DISTINCT realiquoted_by AS lab_staff FROM realiquotings UNION ALL
	SELECT DISTINCT used_by AS lab_staff FROM view_aliquot_uses UNION ALL
	SELECT DISTINCT realiquoted_by AS lab_staff FROM lbd_slide_creations UNION ALL
	SELECT DISTINCT creation_by AS lab_staff FROM lbd_dna_extractions UNION ALL
	SELECT DISTINCT reception_by AS lab_staff FROM specimen_details UNION ALL
	SELECT DISTINCT creation_by AS lab_staff FROM derivative_details UNION ALL
	SELECT DISTINCT qc_nd_contact AS lab_staff FROM study_summaries) res WHERE res.lab_staff IS NOT NULL AND res.lab_staff NOT LIKE ''";
$query = "DELETE FROM structure_permissible_values_customs WHERE control_id = $procure_control_id AND value NOT IN ($query_distinct);";
mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$query = "DELETE FROM structure_permissible_values_customs_revs WHERE control_id = $procure_control_id AND value NOT IN ($query_distinct);";
mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$procure_control_id = migrateCustomList('Specimen Supplier Departments', 'Specimen Supplier Departments');
$query = "DELETE FROM structure_permissible_values_customs WHERE control_id = $procure_control_id AND value NOT IN (SELECT DISTINCT supplier_dept FROM specimen_details)";
mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$query = "DELETE FROM structure_permissible_values_customs_revs WHERE control_id = $procure_control_id AND value NOT IN (SELECT DISTINCT supplier_dept FROM specimen_details)";
mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");

//DERIVATIVE

$query = "INSERT INTO $db_procure_schema.derivative_details ($derivative_fields) (SELECT $derivative_fields FROM $db_icm_schema.derivative_details INNER JOIN $db_icm_schema.sample_masters ON id = sample_master_id WHERE sample_control_id IN ($sample_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = str_replace(array('derivative_details', ',reception_datetime_accuracy'), array('derivative_details_revs',',creation_datetime_accuracy,version_id,version_created'), $query);
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  BLOOD - - - - - - - - - -<br><br>";

$fields = 'sample_master_id,blood_type,collected_tube_nbr,collected_volume,collected_volume_unit';
$query = "INSERT INTO $db_procure_schema.sd_spe_bloods ($fields) (SELECT $fields FROM $db_icm_schema.sd_spe_bloods);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_spe_bloods_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.sd_spe_bloods_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
echo "Warning: Blood fields collected_tube_nbr, collected_volume will be migrated but not dispalyed!<br><br>";
$query = "select sample_code, blood_type from sd_spe_bloods INNER JOIN sample_masters ON id = sample_master_id WHERE (blood_type NOT IN ('EDTA','gel SST','heparin','paxgene','ZCSA') OR blood_type IS NULL) AND deleted <> 1;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$blood_to_review = array();
while ($res = mysqli_fetch_assoc($query_res)) $blood_to_review[] = $res['sample_code'];
if($blood_to_review) echo "Error: Samples with codes [".implode(', ',$blood_to_review)."] have no blood type. To complete<br><br>";
$query = "UPDATE sd_spe_bloods SET blood_type = 'serum' WHERE blood_type = 'gel SST';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
mysqli_query($db_procure_connection, str_replace('sd_spe_bloods', 'sd_spe_bloods_revs', $query)) or die("query failed [".str_replace('sd_spe_bloods', 'sd_spe_bloods_revs', $query)."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sd_spe_bloods SET blood_type = 'k2-EDTA' WHERE blood_type = 'EDTA';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
mysqli_query($db_procure_connection, str_replace('sd_spe_bloods', 'sd_spe_bloods_revs', $query)) or die("query failed [".str_replace('sd_spe_bloods', 'sd_spe_bloods_revs', $query)."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  PBMC/BLOOD CELL - - - - - - - - - -<br><br>";

$fields = 'sample_master_id';
$query = "INSERT INTO $db_procure_schema.sd_der_pbmcs ($fields) (SELECT $fields FROM $db_icm_schema.sd_der_pbmcs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_pbmcs_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.sd_der_pbmcs_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_pbmcs ($fields) (SELECT $fields FROM $db_icm_schema.sd_der_blood_cells);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_pbmcs_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.sd_der_blood_cells_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters SET sample_control_id = ".$sample_controls_data['pbmc']." WHERE sample_control_id = ".$sample_controls_data['blood cell'].";";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters_revs SET sample_control_id = ".$sample_controls_data['pbmc']." WHERE sample_control_id = ".$sample_controls_data['blood cell'].";";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");		
$query = "UPDATE sample_masters SET parent_sample_type = 'pbmc' WHERE parent_sample_type = 'blood cell';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters_revs SET parent_sample_type = 'pbmc' WHERE parent_sample_type = 'blood cell';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  PLASMA - - - - - - - - - -<br><br>";

$fields = 'sample_master_id';
$query = "INSERT INTO $db_procure_schema.sd_der_plasmas ($fields) (SELECT $fields FROM $db_icm_schema.sd_der_plasmas);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_plasmas_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.sd_der_plasmas_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  SERUM - - - - - - - - - -<br><br>";

$fields = 'sample_master_id';
$query = "INSERT INTO $db_procure_schema.sd_der_serums ($fields) (SELECT $fields FROM $db_icm_schema.sd_der_serums);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_serums_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.sd_der_serums_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  URINE - - - - - - - - - -<br><br>";

$fields = 'sample_master_id,urine_aspect,collected_volume,collected_volume_unit,pellet_signs,pellet_volume,pellet_volume_unit';
$query = "INSERT INTO $db_procure_schema.sd_spe_urines ($fields) (SELECT $fields FROM $db_icm_schema.sd_spe_urines);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_spe_urines_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.sd_spe_urines_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "SELECT sample_master_id, sample_code FROM sample_masters INNER JOIN sd_spe_urines ON id = sample_master_id WHERE deleted <> 1 AND collected_volume_unit != 'ml' AND collected_volume IS NOT NULL";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$sample_codes = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$sample_codes[] = $res['sample_code'];
}
if($sample_codes) echo "ERROR: Urines (#sample syst code = ".implode(', ',$sample_codes).") have collected volume different than ml. Set to ml.<br><br>";
$query = "UPDATE sd_spe_urines SET collected_volume_unit = 'ml';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sd_spe_urines_revs SET collected_volume_unit = 'ml';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  URINE CONCENTRÉ/CENTRIFUGÉE - - - - - - - - - -<br><br>";

$fields = 'sample_master_id';
$query = "INSERT INTO $db_procure_schema.sd_der_urine_cents ($fields ,qc_nd_concentrated) (SELECT $fields, 'y' FROM $db_icm_schema.sd_der_urine_cons);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_urine_cents_revs ($fields ,qc_nd_concentrated,version_id,version_created) (SELECT $fields ,'y',version_id,version_created FROM $db_icm_schema.sd_der_urine_cons_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_urine_cents ($fields) (SELECT $fields FROM $db_icm_schema.sd_der_urine_cents);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_urine_cents_revs ($fields ,version_created) (SELECT $fields ,version_created FROM $db_icm_schema.sd_der_urine_cents_revs ORDER BY version_id ASC);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters SET sample_control_id = ".$sample_controls_data['centrifuged urine']." WHERE sample_control_id = ".$sample_controls_data['concentrated urine'].";";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters_revs SET sample_control_id = ".$sample_controls_data['centrifuged urine']." WHERE sample_control_id = ".$sample_controls_data['concentrated urine'].";";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters SET parent_sample_type = 'centrifuged urine' WHERE parent_sample_type = 'concentrated urine';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters_revs SET parent_sample_type = 'centrifuged urine' WHERE parent_sample_type = 'concentrated urine';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  TISSUE - - - - - - - - - -<br><br>";

echo "Warning: Tissue fields tmp_buffer_use won't be migrated!<br><br>";

$tissue_fields = 'sample_master_id,pathology_reception_datetime,pathology_reception_datetime_accuracy,tissue_size,tissue_size_unit,tissue_weight,tissue_weight_unit';
$query = "INSERT INTO $db_procure_schema.sd_spe_tissues ($tissue_fields ,procure_transfer_to_pathology_on_ice) (SELECT $tissue_fields,SUBSTRING(tmp_on_ice,1,1) FROM $db_icm_schema.sd_spe_tissues);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_spe_tissues_revs ($tissue_fields ,procure_transfer_to_pathology_on_ice) (SELECT $tissue_fields,SUBSTRING(tmp_on_ice,1,1) FROM $db_icm_schema.sd_spe_tissues_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");	
$query = "SELECT * FROM (
	SELECT sm.id AS sample_master_id, sm.sample_code, substr(collection_datetime,1,10) AS collection_datetime, substr(pathology_reception_datetime,1,10) AS pathology_reception_date, substr(pathology_reception_datetime,12,5) AS pathology_reception_time
	FROM collections col
	INNER JOIN sample_masters sm ON sm.collection_id = col.id
	INNER JOIN sd_spe_tissues ts ON ts.sample_master_id = sm.id
	WHERE pathology_reception_datetime is not null AND pathology_reception_datetime_accuracy in('c','') AND pathology_reception_datetime != '0000-00-00' AND sm.deleted <> 1
) AS res WHERE res.collection_datetime != res.pathology_reception_date";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$sample_codes = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$sample_codes[] = $res['sample_code'];
}
if($sample_codes) echo "ERROR: Tissue (#sample syst code = ".implode(', ',$sample_codes).") have collection date != pathology reception date. See icm database.<br><br>";
$query = "UPDATE sd_spe_tissues SET procure_arrival_in_pathology_time =  substr(pathology_reception_datetime,12,5) WHERE pathology_reception_datetime is not null AND pathology_reception_datetime_accuracy in('c','') AND pathology_reception_datetime != '0000-00-00'";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sd_spe_tissues SET pathology_reception_datetime =  '', pathology_reception_datetime_accuracy = '';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sd_spe_tissues ts, participants p, collections col, sample_masters sm
	SET procure_tissue_identification = CONCAT(participant_identifier, ' ', procure_visit, ' ', ' -PST1')
	WHERE p.id = col.participant_id AND col.id = sm.collection_id AND sm.id = ts.sample_master_id AND sm.deleted <> 1;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE sample_masters SET modified = '$modified', modified_by = '$modified_by' WHERE sample_control_id IN (".$sample_controls_data['tissue'].")";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
//add new line in rev table for tissue
$tmp_fields = str_replace('created,created_by,modified,modified_by,deleted', '', $sample_master_fields);;
$query = "INSERT INTO sample_masters_revs ($tmp_fields modified_by,version_created) (SELECT $tmp_fields modified_by, modified from sample_masters WHERE sample_control_id IN (".$sample_controls_data['tissue']."));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO specimen_details_revs ($specimen_fields, version_created) (SELECT $specimen_fields, modified from sample_masters INNER JOIN specimen_details ON id = sample_master_id WHERE sample_control_id IN (".$sample_controls_data['tissue']."));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO sd_spe_tissues_revs ($tissue_fields, procure_tissue_identification, version_created) (SELECT $tissue_fields,procure_tissue_identification, modified from sample_masters INNER JOIN sd_spe_tissues ON id = sample_master_id WHERE sample_control_id IN (".$sample_controls_data['tissue']."));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  DNA - - - - - - - - - -<br><br>";
echo "Warning: DNA fields source_cell_passage_number, source_temperature, source_temp_unit, tmp_source_milieu, tmp_source_storage_method won't be migrated!<br><br>";
$query = "INSERT INTO $db_procure_schema.sd_der_dnas (sample_master_id,qc_nd_extraction_method) (SELECT sample_master_id,tmp_extraction_method FROM $db_icm_schema.sd_der_dnas);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_dnas_revs (sample_master_id,qc_nd_extraction_method ,version_id,version_created) (SELECT sample_master_id,tmp_extraction_method ,version_id,version_created FROM $db_icm_schema.sd_der_dnas_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
migrateCustomList('DNA : Extraction method', 'DNA : Extraction method');

echo "<br>- - - - - - - - -  RNA - - - - - - - - - -<br><br>";
echo "Warning: RNA fields source_cell_passage_number, source_temperature, source_temp_unit, tmp_source_milieu, tmp_source_storage_method won't be migrated!<br><br>";
$query = "INSERT INTO $db_procure_schema.sd_der_rnas (sample_master_id,qc_nd_extraction_method) (SELECT sample_master_id,tmp_extraction_method FROM $db_icm_schema.sd_der_rnas);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.sd_der_rnas_revs (sample_master_id,qc_nd_extraction_method ,version_id,version_created) (SELECT sample_master_id,tmp_extraction_method ,version_id,version_created FROM $db_icm_schema.sd_der_rnas_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
migrateCustomList('RNA : Extraction method', 'RNA : Extraction method');

echo "<br>- - - - - - - - -  Sample Migration Control - - - - - - - - - -<br><br>";

$query = "SELECT count(*) as nbr, deleted from sample_masters WHERE id NOT IN (SELECT sample_master_id FROM specimen_details UNION ALL SELECT sample_master_id FROM derivative_details) GROUP BY deleted;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
WHILE($res = mysqli_fetch_assoc($query_res)) {
	if($res['nbr']) echo "ERROR: ".$res['nbr']." sample_masters records with deleted = ".$res['deleted']." are not linked to specimen_details or derivatvie_details tables.<br><br>";
}
$query = "SELECT count(*) as nbr, deleted from sample_masters WHERE id NOT IN (SELECT sample_master_id FROM sd_spe_bloods UNION ALL
	SELECT sample_master_id FROM sd_der_plasmas UNION ALL
	SELECT sample_master_id FROM sd_der_pbmcs UNION ALL
	SELECT sample_master_id FROM sd_der_serums UNION ALL
	SELECT sample_master_id FROM sd_spe_urines UNION ALL
	SELECT sample_master_id FROM sd_der_urine_cents UNION ALL
	SELECT sample_master_id FROM sd_spe_tissues UNION ALL
	SELECT sample_master_id FROM sd_der_dnas UNION ALL
	SELECT sample_master_id FROM sd_der_rnas) GROUP BY deleted;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
WHILE($res = mysqli_fetch_assoc($query_res)) {
	if($res['nbr']) echo "ERROR: ".$res['nbr']." sample_masters records with deleted = ".$res['deleted']." are not linked to details table.<br><br>";
}

flush();

// -- ALIQUOTS --------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** ALIQUOTS ******************************<br>";
$aliquot_master_fields = "id, collection_id, sample_master_id, initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,notes,created,created_by,modified,modified_by,deleted";
echo "** Aliquot fields $aliquot_master_fields will be migrated!<br>";
echo "** Aliquot label will be migrated to barcode and changed to unique value if required!<br>";
echo "** Warning: Aliquot fields sop_master_id,product_code,lot # won't be migrated!<br>";
echo "*********************************************************<br><br>";

//ALIQUOT MASTERS

//aliquot controls check
$query = "SELECT sc.sample_type, sc.id AS sample_control_id, ac.id AS aliquot_control_id, aliquot_type, ac.detail_tablename, ac.volume_unit
	FROM sample_controls sc INNER JOIN aliquot_controls ac ON ac.sample_control_id = sc.id
	WHERE ac.flag_active = '1' AND sc.sample_type IN ('".implode("','", $migrated_sample_types)."')";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$aliquot_control_data = array();
while ($res = mysqli_fetch_assoc($query_res)) {
	$aliquot_control_data[$res['sample_type']][$res['aliquot_type']]['procure_aliquot_control_id'] = $res['aliquot_control_id'];
	$aliquot_control_data[$res['sample_type']][$res['aliquot_type']]['detail_tablename'] = $res['detail_tablename'];
	$aliquot_control_data[$res['sample_type']][$res['aliquot_type']]['volume_unit'] = $res['volume_unit'];
}
$query = "SELECT sc.sample_type, sc.id AS sample_control_id, ac.id AS aliquot_control_id, aliquot_type, ac.detail_tablename, ac.volume_unit
	FROM sample_controls sc INNER JOIN aliquot_controls ac ON ac.sample_control_id = sc.id
	WHERE ac.flag_active = '1' AND ac.id IN (SELECT DISTINCT aliquot_control_id FROM aliquot_masters WHERE deleted <> 1)";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$icm_blood_cell_tube_ctrl_id = null;
$icm_concentrated_urine_ctrl_id = null;
while ($res = mysqli_fetch_assoc($query_res)) {
	$sample_type = $res['sample_type'];
	$aliquot_type = $res['aliquot_type'];
	$aliquot_control_id = $res['aliquot_control_id'];
	$detail_tablename = $res['detail_tablename'];
	if($sample_type == 'concentrated urine' && $aliquot_type == 'tube') {
		$icm_concentrated_urine_ctrl_id =$aliquot_control_id;
		if($aliquot_control_data['centrifuged urine'][$aliquot_type]['detail_tablename'] != $detail_tablename) die('ERR 2387 6287 633 '.$sample_type.' '.$aliquot_type.' '.$detail_tablename);
		if($aliquot_control_data['centrifuged urine'][$aliquot_type]['volume_unit'] != $res['volume_unit']) die('ERR 2387 6287 633 22'.$sample_type.' '.$aliquot_type.' '.$detail_tablename);
		$aliquot_control_data['*** concentrated urine ***'] = $aliquot_control_data['centrifuged urine'];
		$aliquot_control_data['*** concentrated urine ***'][$aliquot_type]['icm_aliquot_control_id'] = $aliquot_control_id;
	} else if($sample_type == 'blood cell' && $aliquot_type == 'tube') {
		$icm_blood_cell_tube_ctrl_id = $aliquot_control_id;
		if($aliquot_control_data['pbmc'][$aliquot_type]['detail_tablename'] != $detail_tablename) die('ERR 2387 6287 633 '.$sample_type.' '.$aliquot_type.' '.$detail_tablename);
		if($aliquot_control_data['pbmc'][$aliquot_type]['volume_unit'] != $res['volume_unit']) die('ERR 2387 6287 633 22'.$sample_type.' '.$aliquot_type.' '.$detail_tablename);
		$aliquot_control_data['*** blood cell ***'] = $aliquot_control_data['pbmc'];
		$aliquot_control_data['*** blood cell ***'][$aliquot_type]['icm_aliquot_control_id'] = $aliquot_control_id;
	} else if(array_key_exists($sample_type, $aliquot_control_data)) {
		if($sample_type == 'urine' && $aliquot_type == 'tube') {
			echo "WARNING: Urine tube will be migrated to urine cup<br><br>";
			$aliquot_type = 'cup';
		}
		if(!array_key_exists($aliquot_type, $aliquot_control_data[$sample_type])) die('ERR 2387 6287 632 '.$sample_type.' '.$aliquot_type);
		if($aliquot_control_data[$sample_type][$aliquot_type]['detail_tablename'] != $detail_tablename) die('ERR 2387 6287 633 '.$sample_type.' '.$aliquot_type.' '.$detail_tablename);
		if($aliquot_control_data[$sample_type][$aliquot_type]['volume_unit'] != $res['volume_unit']) die('ERR 2387 6287 633 22'.$sample_type.' '.$aliquot_type.' '.$detail_tablename);
		$aliquot_control_data[$sample_type][$aliquot_type]['icm_aliquot_control_id'] = $aliquot_control_id;
	} else {
		echo "WARNING: $sample_type $aliquot_type won't be migrated<br><br>";
	}
}
//aliquot_masters
foreach($aliquot_control_data as $sample_type => $new_ctr_tmp) {
	foreach($new_ctr_tmp as $aliquot_type => $new_ctr) {
		if(array_key_exists('icm_aliquot_control_id', $new_ctr)) {
			$procure_fields = "aliquot_control_id,barcode,aliquot_label, $aliquot_master_fields";
			$icm_fields = $new_ctr['procure_aliquot_control_id'].",barcode,aliquot_label, $aliquot_master_fields";
			$query = "INSERT INTO $db_procure_schema.aliquot_masters ($procure_fields) (SELECT $icm_fields from $db_icm_schema.aliquot_masters WHERE aliquot_control_id = ".$new_ctr['icm_aliquot_control_id'].");";		
			mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
			$query = str_replace(array('aliquot_masters', 'created,created_by,modified,modified_by,deleted'), array('aliquot_masters_revs', 'modified_by,version_id,version_created'), $query);
			mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
		} else {
			echo "Message: No $sample_type $aliquot_type exists into icm database<br><br>";
		}
	}
}

echo "<br>- - - - - - - - -  Blood: Whatman Paper - - - - - - - - - -<br><br>";

echo "Warning: Wahtman Paper field used volume won't be migrated!<br><br>";
$fields = 'aliquot_master_id';
$query = "INSERT INTO $db_procure_schema.ad_whatman_papers ($fields) (SELECT $fields FROM $db_icm_schema.ad_whatman_papers);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_whatman_papers_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_whatman_papers_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "select am.id aliquot_master_id, storage_datetime, storage_datetime_accuracy, REPLACE(REPLACE(REPLACE(REPLACE(lower(am.notes), ' ', ''), 'à', 'a'), 'é', 'e'), 'è', 'e') as notes, notes as unformated_notes
	FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
	WHERE ac.aliquot_type = 'whatman paper' AND am.notes NOT LIKE '' AND am.notes is not null and am.deleted <> 1 order by notes;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
while ($res = mysqli_fetch_assoc($query_res)) {
	$aliquot_master_id = $res['aliquot_master_id'];
	$storage_datetime = $res['storage_datetime'];
	$storage_datetime_accuracy = $res['storage_datetime_accuracy'];
	$notes = $res['notes'];
	$unformated_notes = $res['unformated_notes'];
	$procure_card_sealed_date = null;
	$procure_card_sealed_time = null;
	$procure_card_completed_at_date = null;
	$procure_card_completed_at_time = null;
	if(preg_match('/(complet|fait|effec)/', $notes)) {
		if(preg_match('/complet[a-z]{2,4}(((0[1-9])|([12][0-9])|(3[01]))-((0{0,1}[1-9])|(1[0-2]))-((19|20)[0-9]{2}))[a-z]{0,2}((([1-9])|([01][0-9])|(2[0-4]))[:h\.]([0-6][0-9]){0,1})/', $notes, $matches)) {
			//ompletee le 23-07-2012 a 14:(53)
			$procure_card_completed_at_date = $matches[9].'-'.$matches[6].'-'.$matches[2];
			$procure_card_completed_at_time = $matches[11].((isset($matches[16]) && strlen($matches[16]))? '' : '00');
		} else if(preg_match('/complet[a-z]{2,4}((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])([a-z]{2,4}(((0[1-9])|([12][0-9])|(3[01]))-((0{0,1}[1-9])|(1[0-2]))-((19|20)[0-9]{2}))){0,1}/', $notes, $matches)) {
			//completee a 16:10 (le 12-03-2001)
			if(isset($matches[7]) && strlen($matches[7])) $procure_card_completed_at_date = $matches[15].'-'.$matches[12].'-'.$matches[8];
			$procure_card_completed_at_time = $matches[1];
		} else if(preg_match('/complet[a-z]{2,4}(((0[1-9])|([12][0-9])|(3[01]))([a-z\.]{2,10})((19|20)[0-9]{2}))[a-z]{1,2}((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])/', $notes, $matches)) {
			//completee le 28 octobre 2010 a 15:58
			$match_arr = array('octobre'=> '10', 'jin'=> '06', 'juin'=> '06', 'oct.'=> '10');
			if(!in_array($matches[6], array_keys($match_arr))) die('ERR 238 762987 3298 732 '.$matches[6]);
			$procure_card_completed_at_date = $matches[7].'-'.str_replace(array_keys($match_arr),$match_arr, $matches[6]).'-'.$matches[2];
			$procure_card_completed_at_time = $matches[9];
		} else if(preg_match('/effect[a-z]{2,5}((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])([a-z]{2,4}(((0[1-9])|([12][0-9])|(3[01]))-((0{0,1}[1-9])|(1[0-2]))-((19|20)[0-9]{2}))){0,1}/', $notes, $matches)) {
			//effectue a 10h11 (le 12-03-2001)
			if(isset($matches[7])) $procure_card_completed_at_date = $matches[15].'-'.$matches[12].'-'.$matches[8];
			$procure_card_completed_at_time = $matches[1];
		} else if(preg_match('/(fait|effecute)a((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])/', $notes, $matches)) {
			//fait a 15h52
			$procure_card_completed_at_time = $matches[2];
		} else if(preg_match('/complet[a-z]{2,4}(((0[1-9])|([12][0-9])|(3[01]))[a-z\.]{2,10})[a-z]{1,2}((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])/', $notes, $matches)) {
			//completee le 28 octobre a 15:58
			$procure_card_completed_at_time = $matches[6];
			echo "MESSAGE: Aliquot (id=$aliquot_master_id) - Partial completion date (day+month) extracted from notes (".$unformated_notes."). Check it's consistant with storage date ".$storage_datetime."<br>";
		} else {
			echo "WARNING: Aliquot (id=$aliquot_master_id) - Unable to extract completion time from (".$unformated_notes."). To do manually after migration.<br>";
		}
		if($procure_card_completed_at_time) {
			$procure_card_completed_at_time = str_replace(array('h', '.'), array(':', ':'), (((strlen($procure_card_completed_at_time) == 4)? '0' : '').$procure_card_completed_at_time));
		}
		if($procure_card_completed_at_date) {
			$tmp = explode('-', $procure_card_completed_at_date);
			$procure_card_completed_at_date = $tmp[0].'-'.((strlen($tmp[1]) == 1)? '0':'').$tmp[1].'-'.((strlen($tmp[2]) == 1)? '0':'').$tmp[2];
		}
	}
	if(preg_match('/scell|seale/', $notes)) {
		if(preg_match('/scelle[a-z]{2,4}(((0[1-9])|([12][0-9])|(3[01]))-((0{0,1}[1-9])|(1[0-2]))-((19|20)[0-9]{2}))[a-z]{1,2}(((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9]))/', $notes, $matches)) {
			//scellee le 31-03-2010 a 9:54
			$procure_card_sealed_date = $matches[9].'-'.$matches[6].'-'.$matches[2];
			$procure_card_sealed_time =$matches[11];
		} else if(preg_match('/(scell{0,1}e[a-z]{2,4}|scellea)((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])([a-z]{1,3}((0[1-9])|([12][0-9])|(3[01]))-((0{0,1}[1-9])|(1[0-2]))-((19|20)[0-9]{2})){0,1}/', $notes, $matches)) {
			//scellee a 18.39h le 12-02-2010
			//scellea10h52le16-02-2012
			if(isset($matches[7])) $procure_card_sealed_date = $matches[15].'-'.$matches[12].'-'.$matches[8];
			$procure_card_sealed_time =$matches[2];
		} else if(preg_match('/sealedat((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])/', $notes, $matches)) {
			//sealed at 16:31
			$procure_card_sealed_time =$matches[1];
		} else if(preg_match('/scell{0,1}e[a-z:]{2,4}(((0[1-9])|([12][0-9])|(3[01]))([a-z]{2,10})((19|20)[0-9]{2}))[a-z]{1,2}((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])/', $notes, $matches)) {
			//scellee le 19 mai 2010 a 09:50
			$procure_card_sealed_time =$matches[9];
			$match_arr = array('decembre'=> '12', 'janvier'=> '01', 'mai'=> '05');
			if(!in_array($matches[6], array_keys($match_arr))) die('ERR 238 762987 3298 732 '.$matches[6]);
			$procure_card_sealed_date = $matches[7].'-'.str_replace(array_keys($match_arr),$match_arr, $matches[6]).'-'.$matches[2];
		} else if(preg_match('/scell{0,1}e[a-z:]{2,4}(((0[1-9])|([12][0-9])|(3[01]))([a-z]{2,10}))[a-z]{1,2}((([1-9])|([01][0-9])|(2[0-4]))[:h\.][0-6][0-9])/', $notes, $matches)) {
			//scellee le 19 mai a 09:50
			echo "MESSAGE: Aliquot (id=$aliquot_master_id) - Partial seal date (day+month) extracted from notes (".$unformated_notes."). Check it's consistant with storage date ".$storage_datetime."<br>";
			$procure_card_sealed_time =$matches[7];
		} else if(preg_match('/scell{0,1}e[a-z]{2,4}((([1-9])|([01][0-9])|(2[0-4]))[:h\.])/', $notes, $matches)) {
			//scellee a 18h
			$procure_card_sealed_time =$matches[2].':00';
		} else if(preg_match('/scell.{2,6}(((0[1-9])|([12][0-9])|(3[01]))-((0{0,1}[1-9])|(1[0-2]))-((19|20)[0-9]{2}))/', $notes, $matches)) {
			$procure_card_sealed_date = $matches[9].'-'.$matches[6].'-'.$matches[2];
		} else {
			echo "WARNING: Aliquot (id=$aliquot_master_id) - Unable to extract seal date and time from notes (".$unformated_notes."). To do manually after migration.<br>";
		}
		if($procure_card_sealed_time) {
			$procure_card_sealed_time = str_replace(array('h', '.'), array(':', ':'), (((strlen($procure_card_sealed_time) == 4)? '0' : '').$procure_card_sealed_time));
		}
		if($procure_card_sealed_date) {
			$tmp = explode('-', $procure_card_sealed_date);
			$procure_card_sealed_date = $tmp[0].'-'.((strlen($tmp[1]) == 1)? '0':'').$tmp[1].'-'.((strlen($tmp[2]) == 1)? '0':'').$tmp[2];
		}
	}
	$storage_date = null;
	if($storage_datetime) {
		$storage_date = substr($storage_datetime, 0, 10);
		if($procure_card_sealed_date && $procure_card_completed_at_date && $procure_card_completed_at_date < $procure_card_sealed_date) 
			echo "ERROR: Aliquot (id=$aliquot_master_id) - seal date $procure_card_sealed_date is after completion date $procure_card_completed_at_date.<br>";
		if($procure_card_sealed_date && $storage_date && $storage_date < $procure_card_sealed_date)
			echo "ERROR: Aliquot (id=$aliquot_master_id) - seal date $procure_card_sealed_date is after storage date $storage_date.<br>";
		if($storage_date && $procure_card_completed_at_date && $storage_date < $procure_card_completed_at_date)
			echo "ERROR: Aliquot (id=$aliquot_master_id) - Completion date $procure_card_completed_at_date is after storage date $storage_date.<br>";
		if(!$procure_card_sealed_date) {
			if($procure_card_completed_at_date) {
				$use_compeltiond_date_for_sealed_date[] = $aliquot_master_id;
				$procure_card_sealed_date = $procure_card_completed_at_date;
			} else if($storage_date) {
				$procure_card_sealed_date = $storage_date;
				$use_storage_date_for_sealed_date[] = $aliquot_master_id;
			} 
		}
	}
	$data_to_update = array();
	if($procure_card_completed_at_time) $data_to_update[] = "procure_card_completed_at = '$procure_card_completed_at_time'";
	if($procure_card_sealed_time) {
		if($procure_card_sealed_date) {
			$data_to_update[] = "procure_card_sealed_date = '$procure_card_sealed_date $procure_card_sealed_time'";
			$data_to_update[] = "procure_card_sealed_date_accuracy = '".($procure_card_sealed_time? 'c' : 'h')."'";
		} else {
			echo "ERROR: Aliquot (id=$aliquot_master_id) - No storage date, seal date or completion date exists but a sealed time has been defined in notes : ".$unformated_notes.".<br>";
		}
	}
	if($data_to_update) {
		$query = "UPDATE ad_whatman_papers SET ".implode(',',$data_to_update)." WHERE aliquot_master_id = $aliquot_master_id";
		mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
		$query = "UPDATE ad_whatman_papers_revs SET ".implode(',',$data_to_update)." WHERE aliquot_master_id = $aliquot_master_id";
		mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	}
}
if($use_compeltiond_date_for_sealed_date) echo "<br>MESSAGE: System used completion date to set the seal date for following aliquots (ids) : ".implode(', ',$use_compeltiond_date_for_sealed_date)." .<br>"; 
if($use_storage_date_for_sealed_date) echo "<br>MESSAGE: System used storage date to set the seal date for following aliquots (ids) : ".implode(', ',$use_compeltiond_date_for_sealed_date)." .<br>";

echo "<br>- - - - - - - - -  Blood: Tube - - - - - - - - - -<br><br>";

$fields = 'aliquot_master_id';
$icm_aliquot_control_id = $aliquot_control_data['blood']['tube']['icm_aliquot_control_id'];
$query = "INSERT INTO $db_procure_schema.ad_tubes ($fields) (SELECT $fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  PBMC/blood cell: Tube - - - - - - - - - -<br><br>";

$fields = 'aliquot_master_id';
echo "Warning: Fields cell_count, concentration, tmp_storage_solution won't be migrated!<br><br>";
$icm_aliquot_control_ids = $aliquot_control_data['*** blood cell ***']['tube']['icm_aliquot_control_id']; //.','.$aliquot_control_data['pbmc']['tube']['icm_aliquot_control_id'];
$query = "INSERT INTO $db_procure_schema.ad_tubes ($fields) (SELECT $fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id IN ($icm_aliquot_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id IN ($icm_aliquot_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  Plasma: Tube - - - - - - - - - -<br><br>";

$fields = 'aliquot_master_id,hemolysis_signs';
echo "Fields hemolysis_signs will be migrated!<br><br>";
$icm_aliquot_control_id = $aliquot_control_data['plasma']['tube']['icm_aliquot_control_id'];
$query = "INSERT INTO $db_procure_schema.ad_tubes ($fields) (SELECT $fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  SERUM: Tube - - - - - - - - - -<br><br>";

$fields = 'aliquot_master_id,hemolysis_signs';
echo "Fields hemolysis_signs will be migrated!<br><br>";
$icm_aliquot_control_id = $aliquot_control_data['serum']['tube']['icm_aliquot_control_id'];
$query = "INSERT INTO $db_procure_schema.ad_tubes ($fields) (SELECT $fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  Urine: Tube - - - - - - - - - -<br><br>";

$fields = 'aliquot_master_id';
$icm_aliquot_control_id = $aliquot_control_data['urine']['cup']['icm_aliquot_control_id'];
$query = "INSERT INTO $db_procure_schema.ad_tubes ($fields) (SELECT $fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  centrifuged urine,concentrated urine - - - - - - - - - -<br><br>";

$fields = 'aliquot_master_id';
$icm_aliquot_control_ids = $aliquot_control_data['*** concentrated urine ***']['tube']['icm_aliquot_control_id'].','.$aliquot_control_data['centrifuged urine']['tube']['icm_aliquot_control_id'];
$query = "INSERT INTO $db_procure_schema.ad_tubes ($fields) (SELECT $fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id IN ($icm_aliquot_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($fields ,version_id,version_created) (SELECT $fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id IN ($icm_aliquot_control_ids));";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  Tissue: Block - - - - - - - - - -<br><br>";

echo "Message: Fields [qc_nd_gleason_primary_grade, qc_nd_gleason_secondary_grade, qc_nd_tissue_primary_desc, qc_nd_tissue_secondary_desc,qc_nd_tumor_presence, qc_nd_sample_position_code, procure_origin_of_slice] Will be migrated<br><br>";
echo "Mesage: If ICM.block_type = OCT => procure.block_type = frozen &  procure.procure_freezing_type = OCT<br>";
echo "Mesage: If ICM.block_type = isopentane + OCT => procure.block_type = frozen &  procure.procure_freezing_type = ISO+OCT<br>";
echo "Mesage: If ICM.block_type = paraffin => procure.block_type = paraffin &  procure.procure_freezing_type = ''<br>";
$fields = 'aliquot_master_id';
$icm_aliquot_control_id = $aliquot_control_data['tissue']['block']['icm_aliquot_control_id'];
$block_matches = array(
	'OCT' => array('block_type' => 'frozen', 'procure_freezing_type' => 'OCT'),	
	'isopentane + OCT' => array('block_type' => 'frozen', 'procure_freezing_type' => 'ISO+OCT'),
	'paraffin' => array('block_type' => 'paraffin', 'procure_freezing_type' => ''));
foreach($block_matches as $icm_bloc_type => $procure_block_data) {
	$procure_block_type = $procure_block_data['block_type'];
	$procure_freezing_type = $procure_block_data['procure_freezing_type'];
	$icm_fields = "aliquot_master_id, '$procure_block_type', '$procure_freezing_type', tmp_gleason_primary_grade, tmp_gleason_secondary_grade, tmp_tissue_primary_desc, tmp_tissue_secondary_desc,tumor_presence, sample_position_code, procure_origin_of_slice, patho_dpt_block_code";
	$procure_fields = "aliquot_master_id, block_type,procure_freezing_type,qc_nd_gleason_primary_grade, qc_nd_gleason_secondary_grade, qc_nd_tissue_primary_desc, qc_nd_tissue_secondary_desc,qc_nd_tumor_presence, qc_nd_sample_position_code, procure_origin_of_slice, patho_dpt_block_code";
	$query = "INSERT INTO $db_procure_schema.ad_blocks ($procure_fields) (SELECT $icm_fields FROM $db_icm_schema.ad_blocks INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id AND block_type = '$icm_bloc_type');";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$query = "INSERT INTO $db_procure_schema.ad_blocks_revs ($procure_fields ,version_id,version_created) (SELECT $icm_fields ,version_id,version_created FROM $db_icm_schema.ad_blocks_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id AND block_type = '$icm_bloc_type');";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}
echo "Message: Block Patho Nb (patho_dpt_block_code) will be moved to tissue level.<br><br>";
$query = "SELECT res2.sample_master_id FROM (
		SELECT res.sample_master_id, count(*) as nbr FROM (
			SELECT DISTINCT ad.patho_dpt_block_code, am.sample_master_id
			FROM ad_blocks ad
			INNER JOIN aliquot_masters am ON am.id = ad.aliquot_master_id
			WHERE am.deleted <> 1 AND ad.patho_dpt_block_code IS NOT NULL AND ad.patho_dpt_block_code NOT LIKE '') AS res
		GROUP BY res.sample_master_id) AS res2
	WHERE res2.nbr > 1";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$sample_codes = array();
while ($res = mysqli_fetch_assoc($query_res)) {
	$sample_codes[] = $res['sample_master_id'];
}
$tmp_exclusion_conditions = '';
if($sample_codes) {
	$query = "
		SELECT DISTINCT ad.patho_dpt_block_code, am.sample_master_id
		FROM ad_blocks ad
		INNER JOIN aliquot_masters am ON am.id = ad.aliquot_master_id
		WHERE am.deleted <> 1 AND ad.patho_dpt_block_code IS NOT NULL AND ad.patho_dpt_block_code NOT LIKE '' AND sample_master_id IN (".implode(',', $sample_codes).") ORDER BY sample_master_id;";
	$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$tmp_patho_nbr_summary = array();
	while ($res = mysqli_fetch_assoc($query_res)) {
		$tmp_patho_nbr_summary[$res['sample_master_id']][$res['patho_dpt_block_code']] = $res['patho_dpt_block_code'];
	}
	foreach($tmp_patho_nbr_summary as $samp_id => $block_codes) {
		echo "ERROR: Tissue with sample code= [$samp_id] is linked to more than one pathology report numbers [".implode(', ',$block_codes)."]. To clean up manually after migration.<br>";
	}
	echo "<br>";
	$tmp_exclusion_conditions = " AND am.sample_master_id NOT IN (".implode(', ',$sample_codes).")";
}
$query = "UPDATE ad_blocks ad, aliquot_masters am, sd_spe_tissues sd
	SET sd.procure_report_number = ad.patho_dpt_block_code
	WHERE am.id = ad.aliquot_master_id AND am.sample_master_id = sd.sample_master_id
	AND am.deleted <> 1 AND ad.patho_dpt_block_code IS NOT NULL AND ad.patho_dpt_block_code NOT LIKE '' $tmp_exclusion_conditions";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  DNA: tube - - - - - - - - - -<br><br>";

echo "Fields qc_nd_storage_solution will be migrated!<br><br>";
$icm_aliquot_control_id = $aliquot_control_data['dna']['tube']['icm_aliquot_control_id'];
$icm_fields = 'aliquot_master_id,tmp_storage_solution';
$procure_fields = 'aliquot_master_id,qc_nd_storage_solution';
$query = "INSERT INTO $db_procure_schema.ad_tubes ($procure_fields) (SELECT $icm_fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($procure_fields ,version_id,version_created) (SELECT $icm_fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
migrateCustomList('DNA RNA : Storage solution','DNA RNA : Storage solution');

echo "<br>- - - - - - - - -  RNA: tube - - - - - - - - - -<br><br>";

echo "Fields qc_nd_storage_solution, qc_nd_purification_method will be migrated!<br><br>";
$icm_aliquot_control_id = $aliquot_control_data['rna']['tube']['icm_aliquot_control_id'];
$icm_fields = 'aliquot_master_id,tmp_storage_solution,chum_purification_method';
$procure_fields = 'aliquot_master_id,qc_nd_storage_solution,qc_nd_purification_method';
$query = "INSERT INTO $db_procure_schema.ad_tubes ($procure_fields) (SELECT $icm_fields FROM $db_icm_schema.ad_tubes INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.ad_tubes_revs ($procure_fields ,version_id,version_created) (SELECT $icm_fields ,version_id,version_created FROM $db_icm_schema.ad_tubes_revs INNER JOIN $db_icm_schema.aliquot_masters ON id = aliquot_master_id WHERE aliquot_control_id = $icm_aliquot_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
migrateCustomList('RNA purification method','RNA purification method');

echo "<br>- - - - - - - - -  Sample Migration Control - - - - - - - - - -<br><br>";

$query = "SELECT count(*) as nbr, deleted from aliquot_masters WHERE id NOT IN (
	SELECT aliquot_master_id FROM ad_tubes UNION ALL
	SELECT aliquot_master_id FROM ad_blocks UNION ALL
	SELECT aliquot_master_id FROM ad_whatman_papers) GROUP BY deleted;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
WHILE($res = mysqli_fetch_assoc($query_res)) {
	if($res['nbr']) echo "ERROR: ".$res['nbr']." aliquot_masters records with deleted = ".$res['deleted']." are not linked to details table.<br><br>";
}

flush();

echo "<br>- - - - - - - - -  Barcode Clean Up - - - - - - - - - -<br><br>";

$queries = array(
	"UPDATE aliquot_masters SET barcode = CONCAT('tmp_#',id);",
		
	"UPDATE aliquot_masters am
	SET am.barcode = am.aliquot_label
	WHERE am.deleted <> 1
	AND am.aliquot_label IN ( 
		SELECT aliquot_label 
		FROM(
			SELECT count(*) AS nbr, aliquot_label 
			FROM aliquot_masters 
			WHERE deleted <> 1 AND aliquot_label REGEXP '^PS1P[0-9]{4}\ V[0-9]{1,2}\ \-[A-Z]{3,4}[0-9]{1,2}$' 
			GROUP BY aliquot_label) grouped_am
		WHERE grouped_am.nbr = 1
	);",
		
	"UPDATE aliquot_masters SET aliquot_label = '' WHERE barcode NOT LIKE 'tmp_#%';",
		
	"UPDATE aliquot_masters am 
	INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
	INNER JOIN  sample_masters sm ON sm.id = am.sample_master_id 
	INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id
	INNER JOIN collections col ON col.id = sm.collection_id
	INNER JOIN participants p ON p.id = col.participant_id
	LEFT JOIN sd_spe_bloods bl ON bl.sample_master_id = sm.id
	LEFT JOIN ad_blocks block ON block.aliquot_master_id = am.id 
	SET am.barcode = CONCAT(p.participant_identifier, ' ', col.procure_visit, ' -##', sc.sample_type, '##', ac.aliquot_type, '##', IF(bl.blood_type IS NULL,'',bl.blood_type), '##', IF(block.block_type IS NULL,'',block.block_type))
	WHERE am.barcode LIKE 'tmp_#%' AND am.deleted <> 1;");
foreach($queries as $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

$query = "SELECT id , barcode FROM aliquot_masters WHERE barcode like '%-##%' ORDER BY barcode, id ASC;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$barcode_counter = 1;
$last_barcode = null;
while ($res = mysqli_fetch_assoc($query_res)) {
	$barcode = $res['barcode'];
	$aliquot_master_id = $res['id'];
	if($last_barcode != $barcode) {
		$last_barcode = $barcode;
		$barcode_counter = 1;
	}
	if(!preg_match('/^(.+\-)##([a-z\ ]+)##([a-z\ ]+)##([A-Za-z\ \-0-9]*)##([a-z\ ]*)$/', $barcode, $matches)) die('ERR 23 76287 62876287 2 '.$barcode);
	$suffix = '';
	Switch($matches[2].'/'.$matches[3]) {
		case 'blood/whatman paper':
			$suffix = 'WHT';
			break;
		case 'blood/tube':
			$suffix = str_replace(array('paxgene','k2-EDTA','serum'), array('RNB','EDB','SRB'), $matches[4]);
			break;
		case 'pbmc/tube':
			$suffix = 'BFC';
			break;
		case 'plasma/tube':
			$suffix = 'PLA';
			break;
		case 'serum/tube':
			$suffix = 'SER';
			break;
		case 'dna/tube':
			$suffix = 'DNA';
			break;
		case 'rna/tube':
			$suffix = 'RNA';
			break;			
		case 'urine/cup':
			$suffix = 'URI';
			break;
		case 'centrifuged urine/tube':
			$suffix = 'URN';
			break;
		case 'tissue/block':
			if($matches[5] == 'paraffin') {
				$suffix = 'PAR';
			} else {
				$suffix = 'FRZ';
			}
			break;
		default:
			$suffix = '???';
	}
	$barcode = $matches[1].$suffix.$barcode_counter;
	$query = "UPDATE aliquot_masters SET barcode = '$barcode' WHERE id = $aliquot_master_id";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$barcode_counter++;
}
$query = "SELECT res.barcode FROM (SELECT barcode, count(*) as dub FROM aliquot_masters WHERE deleted <> 1 GROUP BY barcode) as res WHERE res.dub > 1;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$dup_barcodes = array();
$dup_barcodes_counter = 0;
while($res = mysqli_fetch_assoc($query_res)) {
	$dup_barcodes[$res['barcode']] = $res['barcode'];
	$dup_barcodes_counter++;
}
if($dup_barcodes_counter) echo "Error : $dup_barcodes_counter barcodes are duplicated : ".implode(', ',$dup_barcodes)."<br><br>";
//Insert one line in rev table
$query = "UPDATE aliquot_masters SET modified = '$modified', modified_by = '$modified_by' WHERE deleted <> 1";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$master_field = "id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,
	in_stock,in_stock_detail,use_counter,study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,
	storage_coord_y,product_code,notes,qc_nd_stored_by";
$query = "INSERT INTO aliquot_masters_revs ($master_field, modified_by,version_created) (SELECT $master_field, modified_by, modified from aliquot_masters);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$detail_fields = array(
	'ad_tubes' => "aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,
		procure_tube_weight_gr,procure_total_quantity_ug,qc_nd_storage_solution,qc_nd_purification_method",
	'ad_blocks' => "aliquot_master_id,block_type,procure_freezing_type,patho_dpt_block_code,procure_freezing_ending_time,procure_origin_of_slice,procure_dimensions,
		time_spent_collection_to_freezing_end_mn,procure_classification,qc_nd_gleason_primary_grade,qc_nd_gleason_secondary_grade,qc_nd_tissue_primary_desc,
		qc_nd_tissue_secondary_desc,qc_nd_tumor_presence,qc_nd_sample_position_code",
	'ad_whatman_papers' => "aliquot_master_id,used_blood_volume,used_blood_volume_unit,procure_card_completed_at,procure_card_sealed_date,procure_card_sealed_date_accuracy");
foreach($detail_fields as $tablename => $fields) {
	$query = "INSERT INTO ".$tablename."_revs ($fields, version_created) (SELECT $fields, modified from aliquot_masters INNER JOIN ".$tablename." ON id = aliquot_master_id);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}

echo "<br>- - - - - - - - -  Source Aliquots - - - - - - - - - -<br><br>";

$query = "INSERT INTO $db_procure_schema.source_aliquots (SELECT * FROM $db_icm_schema.source_aliquots);";
$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = str_replace('source_aliquots', 'source_aliquots_revs', $query);
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  aliquot_internal_uses - - - - - - - - - -<br><br>";

$query = "INSERT INTO $db_procure_schema.aliquot_internal_uses (SELECT * FROM $db_icm_schema.aliquot_internal_uses);";
$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = str_replace('aliquot_internal_uses', 'aliquot_internal_uses_revs', $query);
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

echo "<br>- - - - - - - - -  quality controls - - - - - - - - - -<br><br>";

echo "Fields qc_code, run_by, date, type, score, unit, used_volume, notes will be migreated will be migrated!<br><br>";
echo "Fields qc_type_precision,chip_model,tool,run_id,position_into_run,conclusion won't be migreated as field... added to note.!<br><br>";
echo "Fields qc_nd_is_irrelevant won't be migreated !<br><br>";
$icm_fields = "id,sample_master_id,aliquot_master_id,qc_code,run_by, date, date_accuracy, type, score, unit, used_volume, CONCAT('[Type:',IF(qc_type_precision IS NULL,'',qc_type_precision),'|Chip:',IF(chip_model IS NULL,'',chip_model),'|Tool:',IF(tool IS NULL,'',tool),'|Run#:',IF(run_id IS NULL,'',run_id),'|Position:',IF(position_into_run IS NULL,'',position_into_run),'|Conclusion:',IF(conclusion IS NULL,'',conclusion),'] ',IF(notes IS NULL,'',notes)), created,created_by,modified,modified_by,deleted";
$procure_fields = 'id,sample_master_id,aliquot_master_id,qc_code,procure_analysis_by, date, date_accuracy, type, score, unit, used_volume, notes, created,created_by,modified,modified_by,deleted';
$query = "INSERT INTO $db_procure_schema.quality_ctrls ($procure_fields) (SELECT $icm_fields FROM $db_icm_schema.quality_ctrls);";
$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = str_replace(array('quality_ctrls','created,created_by,modified,modified_by,deleted'), array('quality_ctrls_revs','modified_by,version_id,version_created'), $query);
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE $db_procure_schema.quality_ctrls SET notes = REPLACE(notes, '[Type:|Chip:|Tool:|Run#:|Position:|Conclusion:]', '');";
$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE $db_procure_schema.quality_ctrls_revs SET notes = REPLACE(notes, '[Type:|Chip:|Tool:|Run#:|Position:|Conclusion:]', '');";
$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

pr('done');

$query = "UPDATE versions SET permissions_regenerated = '0';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");

//====================================================================================================================================================
//Migration Summary
//====================================================================================================================================================

echo "<br><br>****************** ALIQUOTS ******************************<br>";

echo "<br>- - - - - - - - -  Participants Number - - - - - - - - - -<br><br>";

$query = "SELECT count(*) as 'nbr_participant' FROM participants WHERE deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
$res = mysqli_fetch_assoc($query_res);
echo "ICM: ".$res['nbr_participant']."<br><br>";

$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
echo "PROCURE: ".$res['nbr_participant']."<br><br>";

echo "<br>- - - - - - - - -  ICM ALiquots - - - - - - - - - -<br><br>";

$query = "SELECT count(*) as 'nbr_aliquots', sample_type, aliquot_type, deleted
	FROM aliquot_masters am
	INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
	INNER JOIN sample_controls sm ON sm.id = ac.sample_control_id
	GROUP BY sample_type, aliquot_type, deleted
	ORDER BY sample_type, aliquot_type, deleted;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_icm_connection)."]");
while($res = mysqli_fetch_assoc($query_res)) {
	echo "ICM: ".$res['sample_type']." - ".$res['aliquot_type']." (deleted - ".$res['deleted']."): ".$res['nbr_aliquots']."<br><br>";
}

$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
while($res = mysqli_fetch_assoc($query_res)) {
	echo "PROCURE: ".$res['sample_type']." - ".$res['aliquot_type']." (deleted - ".$res['deleted']."): ".$res['nbr_aliquots']."<br><br>";
}

//====================================================================================================================================================
//====================================================================================================================================================

function foreignKeyCheck($id) {
	global $db_procure_connection;
	$query = "SET foreign_key_checks = $id;";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

function getDateAndAccuracy($date, $field, $line, $change_date_format = false) {
	$date_matches = array(
		'janv' => '01', 
		'février' => '02', 
		'mars' => '03', 
		'avr' => '04', 
		'avril' => '04', 
		'mai' => '05', 
		'juin' => '06', 
		'déc' => '12');
	$date = str_replace(array(' (v02)', '13-7-2010'), array('', '13-07-2010'), strtolower($date));
	$res = null;
	if(empty($date)) {
		return null;
	} else if(preg_match('/^([0-9]{5})$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date(($change_date_format? "Y-d-m" : "Y-m-d"), $php_offset + (($date - $xls_offset) * 86400));
		$res = array('date' => $date, 'accuracy' => 'c', 'format' => '# 1 #');
	} else if(preg_match('/^(0[1-9]|1[0-2])\-(19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[2].$matches[3].'-'.$matches[1].'-01', 'accuracy' => 'd', 'format' => '# 2 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\/](0[1-9]|1[0-2])[\-\/](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 3 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\/](0[1-9]|1[0-2])[\-\/]([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => '20'.$matches[3].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 4 #');
	} else if(preg_match('/^([1-9])[\-\/](0[1-9]|1[0-2])[\-\/](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.$matches[2].'-0'.$matches[1], 'accuracy' => 'c', 'format' => '# 5 #');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[1].$matches[2].'-01-01', 'accuracy' => 'm', 'format' => '# 6 #');
	} else if(preg_match('/^([1-9])[\-\ ]('.implode('|', array_keys($date_matches)).')[\-\ ](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[2]).'-0'.$matches[1], 'accuracy' => 'c', 'format' => '# 7 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\ ]('.implode('|', array_keys($date_matches)).')[\-\ ](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[2]).'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 8 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\ ]('.implode('|', array_keys($date_matches)).')[\-\ ]([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => '20'.$matches[3].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[2]).'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 9 #');
	} else if(preg_match('/^('.implode('|', array_keys($date_matches)).')\ (19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[2].$matches[3].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[1]).'-01', 'accuracy' => 'd', 'format' => '# 10 #');
	} else {
		echo "Format of date '$date' is not supported! [field '$field' - line: $line]<br>";
		return null;
	}
	if(!preg_match('/^(19|20)([0-9]{2})\-(0[1-9]|1[0-2])\-(0[1-9]|[12][0-9]|3[0-1])$/',$res['date'], $matches)) {
		echo "Format of date '$date' is not supported! [field '$field' - line: $line]<br>";
		return null;
	}
	return $res;
}

function migrateCustomList($icm_list_name, $procure_list_name) {
	global $db_procure_connection;
	global $db_procure_schema;
	global $db_icm_schema;
	
	$query = "SELECT id FROM $db_icm_schema.structure_permissible_values_custom_controls WHERE name LIKE '$icm_list_name'";
	$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$res = mysqli_fetch_assoc($res);
	$icm_control_id = $res['id'];
	
	$query = "SELECT id FROM $db_procure_schema.structure_permissible_values_custom_controls WHERE name LIKE '$procure_list_name'";
	$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	$res = mysqli_fetch_assoc($res);
	$procure_control_id = $res['id'];	
	
	if(!$icm_control_id) die('ERR 32 28792873 '.$icm_list_name);
	if(!$procure_control_id) die('ERR 32 28792874 '.$procure_list_name);
	
	$queries = array(
			"DELETE FROM $db_procure_schema.structure_permissible_values_customs WHERE control_id = $procure_control_id;",
			"DELETE FROM $db_procure_schema.structure_permissible_values_customs_revs WHERE control_id = $procure_control_id;",
			"INSERT INTO $db_procure_schema.structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted) 
				(SELECT $procure_control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted FROM $db_icm_schema.structure_permissible_values_customs WHERE control_id = $icm_control_id);",
			"INSERT INTO $db_procure_schema.structure_permissible_values_customs_revs (id, control_id, value, en, fr, display_order, use_as_input, modified_by, version_created) (SELECT id, control_id, value, en, fr, display_order, use_as_input, modified_by, modified FROM $db_procure_schema.structure_permissible_values_customs WHERE control_id = $procure_control_id);");
	foreach($queries AS $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_procure_connection)."]");
	
	return $procure_control_id;
}

?>