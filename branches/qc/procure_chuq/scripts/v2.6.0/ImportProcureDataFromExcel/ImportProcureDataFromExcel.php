<?php

//err a revoir:
//TODO [ER#14] Treatment To Create Manually (type not supported)
//TODO [ER#21] Patient Identification Unknown
//TODO [ER#17] New Drug - Created hormonotherapy drug [HORMONO ADJUVANTE DE COURTE DURÉE ET CONCOMITANTE AVEC RADIO]!
//TODO [ER#31] No collection created but tissue blocks defined in path block file
//TODO [ER#35] Unrecorded Patient Surgery data
//TODO [ER#40] Patient defined twice
//TODO [ER#42] Urine defined as not available but urine samples defined
//TODO [ER#44] Date Format Error: - Format of date '6.7688' is not supported! [field Nanodrop date analyse - file ARN sang paxgene_v_r_20151005.xls (V02) - line: 29]...
//TODO [ER#45] No paxgene tube
//TODO [ER#51] No aliquot matching barcode

//TODO: Supprimer le contenu de toute cellule égale à '¯' ou égale à '­', ' ­' dans Inventaire et RNA files et patho. Surtout patho car les --- devrait être supprimé sinon création d'un barcode
//TODO: Dans patho, formater vol. prost. Atteint en % en text standard
require_once 'Files/ClinicalAnnotation.php';
require_once 'Files/Inventory.php';

set_time_limit('3600');

//==============================================================================================
// Variables
//==============================================================================================

global $patients_to_import;
//TODO set to empty
$patients_to_import = array('PSP0001','PSP0042');

//$patients_to_import = array();
$files_name = array(
	'patient' => 'Patients_to_build_on_migration_day_v_b_20150900_v_r_20151005.xls',
	'patient_status' => 'Deces juin 2015_v_r_20150918_v_r_20151005.xls',
	'consent' => '5-05-2015Copie de consentement_v20150420_v_r_20151005.xls',
	'psa' => 'r_vis. 30 mars 2015 APS et traitements_v_r_20151005.xls',	
	'treatment' => 'r_vis. 30 mars 2015 APS et traitements_v_r_20151005.xls',	
	'frozen block' => 'taille tissus_v_r_20151005.xls',
	'paraffin block' => 'sortie de blocs procure_v_r_20151005.xls',
	'inventory' => 'inventaire procure CHU Quebec_v_r_20151005.xls',
	'arn' => 'ARN sang paxgene_v_r_20151005.xls',
	'biopsy' => 'Biopsies_v_r_20151005.xls',
	'patho' => 'patho ATIM juin 2015 pour Nicolas_v_r_20151005.xls',
	'imagery' => 'Req_Imagerie 24-04-2015.xls',
	'other tumor' => 'autres cancer_v_r_20151005.xls',
	'sent to processing site' => 'résumé des sorties échantillon pour ATIM_v_r_20151005.xls',
	'revision' => 'revision du Dr Lacombe en janvier 2015.xls'
);
foreach($files_name as $key => $val) $files_name[$key] = utf8_decode($val);

$files_path = 'C:\\_NicolasLuc\\Server\\www\\procure_chuq\\data\\';
//$files_path = "/ATiM/atim-procure/TmpChuq/data/";
require_once 'Excel/reader.php';

global $import_summary;
$import_summary = array();

global $db_schema;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_charset		= "utf8";

$db_pwd			= "";
$db_schema	= "procurechuq";


global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed 2 $db_user $db_schema ");

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE id = '1';", __FILE__, __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user Migration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

global $controls;
$controls = loadATiMControlData();

global $sample_code;
$sample_code = 0;

global $sample_storage_types;
$sample_storage_types = array(
	'tissue' => 'box27 1A-9C',
	'serum' => 'box81',
	'plasma' => 'box81',
	'pbmc' => 'box81',
	'whatman' => 'box',
	'urine' => 'box49',
	'concentrated urine' => 'box81',
	'rna' => 'box81'
);

global $storage_master_ids;
$storage_master_ids = array();

global $last_storage_code;
$last_storage_code = 0;

echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
PROCURE - Data Migration to ATiM<br>
$import_date<br>
=====================================================================</FONT><br>";

echo "<br><FONT COLOR=\"red\" ><b>Check all dates in excel have been formated to date format 2000-00-00 (including treatment worksheet)</b></FONT><br><br>";

//TODO
truncate();

//==============================================================================================
//Clinical Annotation
//==============================================================================================

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Patient - File(s) : ".$files_name['patient']." && ".$files_name['patient_status']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$patients_status = loadVitalStatus($XlsReader, $files_path, $files_name['patient_status']);
$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_participant_id_and_patho = loadPatients($XlsReader, $files_path, $files_name['patient'], $patients_status);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Consent & Questionnaire - File(s) : ".$files_name['consent']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadConsents($XlsReader, $files_path, $files_name['consent'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Biopy) : ".$files_name['biopsy']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadBiopsy($XlsReader, $files_path, $files_name['biopsy'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Patho - File(s) : ".$files_name['patho']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$prostatectomy_data_from_patho = loadPathos($XlsReader, $files_path, $files_name['patho'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - PSA - File(s) : ".$files_name['psa']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadPSAs($XlsReader, $files_path, $files_name['psa'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Treatment - File(s) : ".$files_name['treatment']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$created_prostatectomy = loadTreatments($XlsReader, $files_path, $files_name['treatment'], $psp_nbr_to_participant_id_and_patho, $prostatectomy_data_from_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Imagery - File(s) : ".$files_name['imagery']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadImagery($XlsReader, $files_path, $files_name['imagery'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Other Tumor Dx - File(s) : ".$files_name['other tumor']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadOtherDx($XlsReader, $files_path, $files_name['other tumor'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Dr Lacombe Revision - File(s) : ".$files_name['revision']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadRevision($XlsReader, $files_path, $files_name['revision'], $psp_nbr_to_participant_id_and_patho);

//==============================================================================================
//Inventory
//==============================================================================================

echo "<br><FONT COLOR=\"green\" >*** Inventory (Tissue) - File(s) : ".$files_name['frozen block']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_frozen_blocks_data = loadFrozenBlock($XlsReader, $files_path, $files_name['frozen block']);

echo "<br><FONT COLOR=\"green\" >*** Inventory (Tissue) - File(s) : ".$files_name['paraffin block']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_paraffin_blocks_data = loadParaffinBlock($XlsReader, $files_path, $files_name['paraffin block']);

echo "<br><FONT COLOR=\"green\" >*** Inventory - File(s) : ".$files_name['inventory']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadInventory($XlsReader, $files_path, $files_name['inventory'], $psp_nbr_to_frozen_blocks_data, $psp_nbr_to_paraffin_blocks_data, $psp_nbr_to_participant_id_and_patho, $created_prostatectomy, $prostatectomy_data_from_patho);
unset($psp_nbr_to_frozen_blocks_data);
unset($psp_nbr_to_paraffin_blocks_data);
unset($created_prostatectomy);

echo "<br><FONT COLOR=\"green\" >*** Inventory - File(s) : ".$files_name['arn']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadRNA($XlsReader, $files_path, $files_name['arn']);

echo "<br><FONT COLOR=\"green\" >*** Inventory Sent To Processing Site - File(s) : ".$files_name['sent to processing site']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadAliquotSentToProcSite($XlsReader, $files_path, $files_name['sent to processing site']);

//codes and barcodes update

$query = "UPDATE sample_masters SET sample_code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_category = 'specimen');";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE storage_masters SET code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "SELECT barcode FROM (SELECT barcode, count(*) AS tx FROM aliquot_masters WHERE deleted <> 1 GROUP BY barcode) AS test WHERE test.tx > 1;";
$results = customQuery($query, __FILE__, __LINE__);
while($row = $results->fetch_assoc()){
	$import_summary['Inventory - Tissue (V01)']['@@ERROR@@']['Duplicated Barcodes'][] = "The migration process created duplciated barcode : ".$row['barcode'];
}
$query = "UPDATE quality_ctrls SET qc_code = id;";
customQuery($query, __FILE__, __LINE__);

//last contact date update

$query = "UPDATE participants, (
	SELECT MAX(last_date) last_date, participant_id
	FROM (
			SELECT MAX(CONCAT(SUBSTRING(collection_datetime ,1 , 10 ), '#', collection_datetime_accuracy)) AS last_date, participant_id, 'Col' AS type FROM collections WHERE deleted <> 1 AND collection_datetime IS NOT NULL  GROUP BY participant_id
			UNION All
			SELECT MAX(CONCAT(start_date, '#', start_date_accuracy)) AS last_date, participant_id, 'Tx_start' AS type FROM treatment_masters WHERE deleted <> 1 AND start_date IS NOT NULL GROUP BY participant_id
			UNION All
			SELECT MAX(CONCAT(finish_date, '#', finish_date_accuracy)) AS last_date, participant_id, 'Tx_finish' AS type FROM treatment_masters WHERE deleted <> 1 AND finish_date IS NOT NULL GROUP BY participant_id
			UNION All
			SELECT MAX(CONCAT(event_date, '#', event_date_accuracy)) AS event_date, participant_id, 'Ev' AS type FROM event_masters WHERE deleted <> 1 AND event_date IS NOT NULL GROUP BY participant_id
	) AS res GROUP BY participant_id
) AS summary
SET procure_chuq_last_contact_date = SUBSTRING(last_date ,1 , 10 ), procure_chuq_last_contact_date_accuracy = SUBSTRING(last_date ,12 , 1 )
WHERE summary.participant_id = id;";
customQuery($query, __FILE__, __LINE__);

//==============================================================================================
//End of the process
//==============================================================================================

// _by_bank field record

$queries = array(
	"UPDATE participants SET procure_last_modification_by_bank = '2';",
	"UPDATE participants_revs SET procure_last_modification_by_bank = '2';",
	"UPDATE consent_masters SET procure_created_by_bank = '2';",
	"UPDATE consent_masters_revs SET procure_created_by_bank = '2';",
	"UPDATE event_masters SET procure_created_by_bank = '2';",
	"UPDATE event_masters_revs SET procure_created_by_bank = '2';",
	"UPDATE treatment_masters SET procure_created_by_bank = '2';",
	"UPDATE treatment_masters_revs SET procure_created_by_bank = '2';",

	"UPDATE collections SET procure_collected_by_bank = '2';",
	"UPDATE collections_revs SET procure_collected_by_bank = '2';",
	"UPDATE sample_masters SET procure_created_by_bank = '2';",
	"UPDATE sample_masters_revs SET procure_created_by_bank = '2';",
	"UPDATE aliquot_masters SET procure_created_by_bank = '2';",
	"UPDATE aliquot_masters_revs SET procure_created_by_bank = '2';",
	"UPDATE aliquot_internal_uses SET procure_created_by_bank = '2';",
	"UPDATE aliquot_internal_uses_revs SET procure_created_by_bank = '2';",
	"UPDATE quality_ctrls SET procure_created_by_bank = '2';",
	"UPDATE quality_ctrls_revs SET procure_created_by_bank = '2';");
foreach($queries as $query) customQuery($query, __FILE__, __LINE__);

// *** SQL TO CHECK DATA INTEGRITY ***

$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT participant_identifier AS '### MESSAGE ### Wrong participant_identifier format to correct', id AS participant_id FROM participants WHERE deleted <> 1 AND participant_identifier NOT REGEXP'^PS2P0[0-9]+$';
SELECT id AS '### MESSAGE ### participant_id with withdrawn date or withdrawn reason but not flagged as withdrawn: To flag' 
FROM participants WHERE deleted <> 1 
AND ((procure_patient_withdrawn_date IS NOT NULL AND procure_patient_withdrawn_date NOT LIKE '') OR (procure_patient_withdrawn_reason IS NOT NULL AND procure_patient_withdrawn_reason NOT LIKE ''))
AND procure_patient_withdrawn <> 1;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Duplicated procure_form_identification to correct' FROM (SELECT count(*) as nbr, procure_form_identification FROM consent_masters WHERE deleted <> 1 GROUP BY procure_form_identification) res WHERE res.nbr > 1;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong consent_masters.procure_form_identification format to correct',participant_id, id AS consent_master_id FROM consent_masters WHERE deleted <> 1 AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ V((0[1-9])|(1[0-9])) -CSF[0-9]+$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Duplicated procure_form_identification to correct' FROM (
	SELECT count(*) as nbr, EventMaster.procure_form_identification FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id WHERE deleted <> 1 AND EventControl.event_type NOT IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event') GROUP BY EventMaster.procure_form_identification
) res WHERE res.nbr > 1;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure pathology report'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ V((0[1-9])|(1[0-9])) -PST[0-9]+$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure diagnostic information worksheet'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ V((0[1-9])|(1[0-9])) -FBP[0-9]+$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure questionnaire administration worksheet'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ V((0[1-9])|(1[0-9])) -QUE[0-9]+$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type = 'procure follow-up worksheet'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ V((0[1-9])|(1[0-9])) -FSP[0-9]+$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong event_masters.procure_form_identification format to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event')
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ Vx -FSPx$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Follow-up Worksheet with no date to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet') AND (EventMaster.event_date IS NULL OR EventMaster.event_date LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Duplicated procure_form_identification to correct' FROM (
	SELECT count(*) as nbr, TreatmentMaster.procure_form_identification FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id WHERE deleted <> 1 AND TreatmentControl.tx_method NOT IN ('procure follow-up worksheet - treatment','procure medication worksheet - drug','other tumor treatment') GROUP BY TreatmentMaster.procure_form_identification
) res WHERE res.nbr > 1;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet - drug'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ Vx -MEDx$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ Vx -FSPx$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ V((0[1-9])|(1[0-9])) -MED[0-9]+$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Wrong treatment_masters.procure_form_identification format to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'other tumor treatment'
AND procure_form_identification NOT REGEXP'^PS2P0[0-9]+ Vx -FSPx$' OR procure_form_identification IS NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT procure_form_identification AS '### MESSAGE ### Medication Worksheet with no date to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet' AND (TreatmentMaster.start_date IS NULL OR TreatmentMaster.start_date LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type and drug type mismatch. Please confirm and correct', TreatmentDetail.treatment_type, Drug.type, Drug.generic_name
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
INNER JOIN drugs Drug ON TreatmentDetail.drug_id = Drug.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type != Drug.type;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type different than radiotherapy but site information set. Please confirm and correct', TreatmentDetail.treatment_type, TreatmentDetail.treatment_site
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type NOT IN ('radiotherapy','antalgic radiotherapy','brachytherapy') AND TreatmentDetail.treatment_site IS NOT NULL AND TreatmentDetail.treatment_site NOT LIKE '';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type like prostatectomy and precision information set. Please confirm and correct', TreatmentDetail.treatment_type, TreatmentDetail.treatment_precision
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE '%prostatectomy%' AND TreatmentDetail.treatment_precision IS NOT NULL AND TreatmentDetail.treatment_precision NOT LIKE '';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT TreatmentMaster.procure_form_identification AS '### MESSAGE ### Treatment Follow-up worksheet with treatment type different than chemotherapy but line information set. Please confirm and correct', TreatmentDetail.treatment_type, TreatmentDetail.chemotherapy_line
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
WHERE TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type NOT LIKE '%chemotherapy%' AND TreatmentDetail.chemotherapy_line IS NOT NULL AND TreatmentDetail.chemotherapy_line NOT LIKE '';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT '### MESSAGE ### Blood type undefined', collection_id, sample_master_id
FROM sample_masters SampleMaster
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
INNER JOIN sd_spe_bloods SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
WHERE SampleMaster.deleted <> 1 AND SampleControl.sample_type = 'blood'  AND (blood_type = '' OR blood_type IS NULL);";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT barcode AS '### MESSAGE ### List of block with wrong [type] and [freezing method] link. To correct.', block_type, procure_freezing_type
FROM aliquot_masters
INNER JOIN ad_blocks ON id = aliquot_master_id
WHERE deleted <> 1 AND ((block_type = 'frozen' AND procure_freezing_type NOT IN ('ISO', 'ISO+OCT', 'OCT', '')) OR (block_type = 'paraffin' AND procure_freezing_type != ''));";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT count(*) AS '### MESSAGE ### List of whatman paper with storage date time. To remove storage date.' 
FROM aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl 
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.deleted <> 1 AND AliquotMaster.storage_datetime IS NOT NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT barcode AS '### MESSAGE ### List of aliquots with missing concentration unit.'
FROM aliquot_masters
INNER JOIN ad_tubes ON id = aliquot_master_id
WHERE deleted <> 1 AND concentration NOT LIKE '' AND concentration IS NOT NULL AND (concentration_unit IS NULL OR concentration_unit LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT count(*) AS '### MESSAGE ### Number of blood tubes defined as in stock. To correct if required.', blood_type
FROM sample_masters SampleMaster
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
INNER JOIN sd_spe_bloods SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
WHERE AliquotMaster.deleted <> 1 AND SampleControl.sample_type = 'blood' AND AliquotControl.aliquot_type = 'tube'
AND blood_type != 'paxgene' AND in_stock != 'no'
GROUP BY blood_type;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT count(*) AS '### MESSAGE ### Number of procure_total_quantity_ug values updated. To validate (revs data not updated).', concentration_unit
FROM aliquot_masters, ad_tubes
WHERE deleted <> 1 AND id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND current_volume NOT LIKE '' AND current_volume IS NOT NULL 
AND concentration_unit IN ('ug/ul', 'ng/ul', 'pg/ul') GROUP BY concentration_unit;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "UPDATE aliquot_masters, ad_tubes
SET procure_total_quantity_ug = (current_volume*concentration/1000000)
WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND current_volume NOT LIKE '' AND current_volume IS NOT NULL 
AND concentration_unit = 'pg/ul';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "UPDATE aliquot_masters, ad_tubes
SET procure_total_quantity_ug = (current_volume*concentration/1000)
WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND current_volume NOT LIKE '' AND current_volume IS NOT NULL 
AND concentration_unit = 'ng/ul';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "UPDATE aliquot_masters, ad_tubes
SET procure_total_quantity_ug = (current_volume*concentration)
WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
AND current_volume NOT LIKE '' AND current_volume IS NOT NULL 
AND concentration_unit = 'ug/ul';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT Participant.participant_identifier AS '### TODO ### : Wrong participant idenitifier format : to correct'
FROM participants Participant WHERE Participant.participant_identifier NOT REGEXP '^PS[1-4]P[0-9]{4}$';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT 'Form Identification Control (should match participant identifier) : Correct data if list below is not empty' AS '### MESSAGE ###';
SELECT CONCAT('ConsentMaster', '.', ConsentMaster.id) AS 'Model.id', Participant.participant_identifier, ConsentMaster.procure_form_identification
FROM participants Participant
INNER JOIN consent_masters ConsentMaster ON Participant.id = ConsentMaster.participant_id AND ConsentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND ConsentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier)
UNION ALL
SELECT CONCAT('TreatmentMaster', '.', TreatmentMaster.id) AS 'Model.id', Participant.participant_identifier, TreatmentMaster.procure_form_identification
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND TreatmentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier)
UNION ALL
SELECT CONCAT('EventMaster', '.', EventMaster.id) AS 'Model.id', Participant.participant_identifier, EventMaster.procure_form_identification
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id AND EventMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND EventMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier);";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT Collection.id AS '### MESSAGE ### : Collections with no visit - Has to be corrected'
FROM collections Collection
WHERE Collection.deleted <> 1 AND (Collection.procure_visit IS NULL OR Collection.procure_visit LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT AliquotMaster.barcode AS '### MESSAGE ### : Aliquots not linked to a participant - Has to be corrected'
FROM aliquot_masters AliquotMaster
INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
WHERE AliquotMaster.deleted <> 1 AND Collection.deleted <> 1 AND (Collection.participant_id IS NULL OR Collection.participant_id LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT 'Aliquot Barcode Control : Check barcodes match participant_identifier + visit (Correct data if list below is not empty)' AS '### MESSAGE ###';
SELECT CONCAT('AliquotMaster', '.', AliquotMaster.id) AS 'Model.id', Participant.participant_identifier, Collection.procure_visit, AliquotMaster.barcode
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\ ');";

dislayErrorAndMessage($import_summary);

updateAliquotUseAndVolume();
insertIntoRevs();

$query = "UPDATE versions SET permissions_regenerated = 0;";
customQuery($query, __FILE__, __LINE__);

//==============================================================================================
// DEV Functions
//==============================================================================================

function insertIntoRevs() {
	global $import_date;
	global $import_by;
	$tables = array(
		'participants' => 0,
		'misc_identifiers' => 0,
			
		'consent_masters' => 0,
		'procure_cd_sigantures' => 1,
		
		'event_masters' => 0,
		'procure_ed_lifestyle_quest_admin_worksheets' => 1,
		'procure_ed_clinical_followup_worksheet_aps' => 1,
		'procure_ed_lab_pathologies' => 1,
		'procure_ed_clinical_followup_worksheet_clinical_events' => 1,
		'procure_ed_followup_worksheet_other_tumor_diagnosis' => 1,
		'procure_ed_followup_worksheet_clinical_notes' => 1,
		'procure_ed_lab_diagnostic_information_worksheets' => 1,
			
		'treatment_masters' => 0,
		'procure_txd_medication_drugs' => 1,
		'procure_txd_followup_worksheet_treatments' => 1,
		
		'collections' => 0,
			
		'sample_masters' => 0,
		'specimen_details' => 1,
		'derivative_details' => 1,
		'sd_spe_tissues' => 1,
		'sd_spe_bloods' => 1,
		'sd_der_serums' => 1,
		'sd_der_pbmcs' => 1,
		'sd_der_plasmas' => 1,
		'sd_spe_urines' => 1,
		'sd_der_urine_cents' => 1,
		'sd_der_rnas' => 1,
		
		'aliquot_masters' => 0,
		'ad_tubes' => 1,
		'ad_whatman_papers' => 1,
		'ad_blocks' => 1,
	
		'aliquot_internal_uses' => 0,	
		'source_aliquots' => 0	,

		'quality_ctrls' => 0,
	
		'storage_masters' => 0,
		'std_nitro_locates' => 1,
		'std_fridges' => 1,
		'std_freezers' => 1,
		'std_boxs' => 1,		
		'std_racks' => 1
	);
	
	foreach($tables as $table_name => $is_detail_table) {
		$fields = array();
		$results = customQuery("DESC $table_name;", __FILE__, __LINE__);
		while($row = $results->fetch_assoc()) {
			$field = $row['Field'];
			if(!in_array($field, array('created', 'created_by','modified', 'modified_by','deleted'))) $fields[$row['Field']] = $row['Field'];
		}
		$fields = implode(',', $fields);
		if(!$is_detail_table) {
			$query = "INSERT INTO ".$table_name."_revs ($fields, modified_by, version_created) (SELECT $fields, $import_by, '$import_date' FROM $table_name)";
		} else {
			$query = "INSERT INTO ".$table_name."_revs ($fields, version_created) (SELECT $fields, '$import_date' FROM $table_name)";
		}
		customQuery($query, __FILE__, __LINE__);
	}
}

function loadATiMControlData(){
	$controls = array();
	// MiscIdentifierControl
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['MiscIdentifierControl'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	// ConsentControl
	$query = "SELECT id, controls_type, detail_tablename FROM consent_controls WHERE flag_active = 1;";
	$results =customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['ConsentControl'][$row['controls_type']] = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	// EventControl
	$query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['EventControl'][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	// TreatmentControl
	$query = "select tc.id, tc.tx_method, tc.detail_tablename, te.id as te_id, te.detail_tablename as te_detail_tablename
		from treatment_controls tc
		LEFT JOIN treatment_extend_controls te ON tc.treatment_extend_control_id = te.id AND te.flag_active = '1'
		where tc.flag_active = '1';";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['TreatmentControl'][$row['tx_method']] = array(
				'treatment_control_id' => $row['id'],
				'detail_tablename' => $row['detail_tablename'],
				'te_treatment_control_id' => $row['te_id'],
				'te_detail_tablename' => $row['te_detail_tablename'],
		);
	}
	//SampleControl
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue', 'blood', 'serum', 'plasma', 'pbmc','dna','rna','urine','centrifuged urine')";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['sample_aliquot_controls'][$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}
	foreach($controls['sample_aliquot_controls'] as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = customQuery($query, __FILE__, __LINE__);
		while($row = $results->fetch_assoc()){
			$controls['sample_aliquot_controls'][$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}
	}
	//StorageControl
	$query = "SELECT id as storage_control_id, storage_type, detail_tablename, coord_x_type,coord_x_size,coord_y_type,coord_y_size FROM storage_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['storage_controls'][$row['storage_type']] = $row;
	}
	return $controls;
}

//=================================================================================================================================
// System Functions
//=================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function formatNewLineData($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[trim(utf8_encode($field))] = trim(utf8_encode($data[$key]));
		} else {
			$line_data[trim(utf8_encode($field))] = '';
		}
	}
	return $line_data;
}

function importDie($msg, $rollbak = true) {
	if($rollbak) {
	}
	pr('-------------------------------------------------------------------------------------------------------------------------------------');
	$counter = 0;
	foreach(debug_backtrace() as $debug_data) {
		$counter++;
		pr("$counter- Function ".$debug_data['function']."() [File: ".$debug_data['file']." - Line: ".$debug_data['line']."]");
	}
	pr('-------------------------------------------------------------------------------------------------------------------------------------');
	die($msg);
}

function customQuery($query, $file, $line, $insert = false) {
	global $db_connection;
	$query_res = mysqli_query($db_connection, $query) or importDie("QUERY ERROR: file $file line $line [".mysqli_error($db_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}
	
function customInsert($data, $table_name, $file, $line, $is_detail_table = false, $insert_into_revs = false) {
	global $import_date;
	global $import_by;
	
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen(str_replace(array(' ', "\n"), array('', ''), $value))) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "'$import_date'", "created_by" => "'$import_by'", "modified" => "'$import_date'", "modified_by" => "'$import_by'");
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$record_id = customQuery("INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $file, $line, true);
	// Insert into revs table
// 	if($insert_into_revs) {
// 		$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'", "modified_by" => "'$import_by'");
// 		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
// 		customQuery("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $file, $line, true);
// 	}
	
	return $record_id;
}

function getDateAndAccuracy($data, $field, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 732 $field $file, $line");
	$date = str_replace(array(' ', 'N/A', 'n/a', 'x', '??'), array('', '', '', '', '', ''), $data[$field]);
	if(empty($date) || $date == '-') {
		return array('date' => null, 'accuracy' =>null);
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		return array('date' => $date, 'accuracy' => 'c');	
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$date,$matches)) {
		return array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])$/',$date,$matches)) {
		return array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^((19|20)([0-9]{2})\-([01][0-9]))\-unk$/',$date,$matches)) {
		return array('date' => $matches[1].'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else if(preg_match('/^([0-3][0-9])\-([01][0-9])\-(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		$import_summary[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [field <b>$field</b> - file <b>$file</b> - line: <b>$line</b>]";
		return array('date' => null, 'accuracy' =>null);
	}	
}


function getDateTimeAndAccuracy($data, $field_date, $field_time, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', 'x', '??', '?', 'X'), array('', '', '', '', '', '', '', ''), $data[$field_time]);
	//Get Date
	$tmp_date = getDateAndAccuracy($data, $field_date, $data_type, $file, $line);
	if(!$tmp_date['date']) {
		if(strlen($time) && $time != '-') $import_summary[$data_type]['@@ERROR@@']['DateTime: Only time is set'][] = "See following fields details. [fields <b>$field_date</b> & <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
		return array('datetime' => null, 'accuracy' =>null);
	} else {
		$formatted_date = $tmp_date['date'];
		$formatted_date_accuracy = $tmp_date['accuracy'];
		//Combine date and time
		if(!strlen($time) || $time == '-' || $time == '­') {
			return array('datetime' => $formatted_date.' 00:00', 'accuracy' => str_replace('c', 'h', $formatted_date_accuracy));
		} else {
			if($formatted_date_accuracy != 'c') {
				$import_summary[$data_type]['@@ERROR@@']['Time set for an unaccuracy date'][] = "Date and time are set but date is unaccuracy. No datetime will be set! [fields <b>$field_date</b> & <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
				return array('datetime' => null, 'accuracy' =>null);
			} else if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
				return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
			} else if(preg_match('/^0\.[0-9]+$/', $time)) {
				$hour = floor(24*$time);
				$mn = round((24*$time - $hour)*60);
				$mn = (strlen($mn) == 1)? '0'.$mn  : $mn ;
				if($mn == '60') {
					$mn = '00';
					$hour += 1;
				}
				if($hour > 23) die('ERR time >= 24 79904044--4-44');
				$time=$hour.':'.$mn;				
				return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
			} else {
				$import_summary[$data_type]['@@ERROR@@']['Time Format Error (1)'][] = "Format of time '".$data[$field_time]."' is not supported! [field <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
				return array('datetime' => null, 'accuracy' =>null);;
			}
		}
	}
}

function getTime($data, $field_time, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', 'x', '??', '?', 'X'), array('', '', '', '', '', '', '', ''), $data[$field_time]);
	if(!strlen($time) || $time == '-' || $time == '­') {
		return null;
	} else {
		if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
			return (strlen($time) == 5)? $time : '0'.$time;
		} else if(preg_match('/^0\.[0-9]+$/', $time)) {
			$hour = floor(24*$time);
			$mn = round((24*$time - $hour)*60);
			$mn = (strlen($mn) == 1)? '0'.$mn  : $mn ;
			if($mn == '60') {
				$mn = '00';
				$hour += 1;
			}
			if($hour > 23) die('ERR time >= 24 79904044--4-44');
			$time=$hour.':'.$mn;
			return (strlen($time) == 5)? $time : '0'.$time;
		} else {
			$import_summary[$data_type]['@@ERROR@@']['Time Format Error (2)'][] = "Format of time '".$data[$field_time]."' is not supported! [field <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
			return null;
		}
	}
}

function getDecimal($data, $field, $data_type, $file_name, $line_counter) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 7eeee $field $file_name, $line_counter");
	$decimal_value = str_replace(array('x', 'X', '?', '-', '­', 'n/a', 'N/A', 'N/D'), array('','','', '', '', '', '', ''), $data[$field]);
	if(strlen($decimal_value)) {
		if(preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $decimal_value)) {
			return str_replace(',', '.', $decimal_value);
		} else {
			$import_summary[$data_type]['@@ERROR@@']["Wrong decimal format for field '$field'"][] = "See value [".$data[$field]."]. [field <b>$field</b> - file <b>$file_name</b> - line: <b>$line_counter</b>]";
			return '';
		}
	} else {
		return '';
	}	
}

function dislayErrorAndMessage($import_summary) {
	$err_counter = 0;
	foreach($import_summary as $worksheet => $data1) {
		echo "<br><br><FONT COLOR=\"blue\" >
			=====================================================================<br>
			Errors on $worksheet<br>
			=====================================================================</FONT><br>";
		foreach($data1 as $message_type => $data2) {
			$color = 'black';
			switch($message_type) {
				case '@@ERROR@@':
					$color = 'red';
					break;
				case '@@WARNING@@':
					$color = 'orange';
					break;
				case '@@MESSAGE@@':
					$color = 'green';
					break;
				default:
					echo '<br><br><br>UNSUPORTED message_type : '.$message_type.'<br><br><br>';
			}
			foreach($data2 as $error => $details) {
				$err_counter++;
				$error = str_replace("\n", ' ', utf8_decode("[ER#$err_counter] $error"));
				echo "<br><br><FONT COLOR=\"$color\" ><b>$error</b></FONT><br>";
				foreach($details as $detail) {
					$detail = str_replace("\n", ' ', $detail);
					echo ' - '.utf8_decode($detail)."<br>";	
				}
			}
		}
	}	
}

//==============================================================================================
// DEV Functions
//==============================================================================================

function truncate() {
	$truncate_queries = array(
		'TRUNCATE aliquot_internal_uses;', 'TRUNCATE aliquot_internal_uses_revs;',
		'TRUNCATE quality_ctrls;', 'TRUNCATE quality_ctrls_revs;',
		'TRUNCATE source_aliquots;', 'TRUNCATE source_aliquots_revs;',
			
		'TRUNCATE ad_blocks;', 'TRUNCATE ad_blocks_revs;',
		'TRUNCATE ad_whatman_papers;', 'TRUNCATE ad_whatman_papers_revs;',
		'TRUNCATE ad_tubes;', 'TRUNCATE ad_tubes_revs;',
		'DELETE FROM aliquot_masters;', 'DELETE FROM aliquot_masters_revs;',

		'TRUNCATE sd_der_rnas;', 'TRUNCATE sd_der_rnas_revs;',
		'TRUNCATE sd_der_urine_cents;', 'TRUNCATE sd_der_urine_cents_revs;',
		'TRUNCATE sd_spe_urines;', 'TRUNCATE sd_spe_urines_revs;',
		'TRUNCATE sd_der_plasmas;', 'TRUNCATE sd_der_plasmas_revs;',
		'TRUNCATE sd_der_pbmcs;', 'TRUNCATE sd_der_pbmcs_revs;',
		'TRUNCATE sd_der_serums;', 'TRUNCATE sd_der_serums_revs;',
		'TRUNCATE sd_spe_tissues;', 'TRUNCATE sd_spe_tissues_revs;',
		'TRUNCATE sd_spe_bloods;', 'TRUNCATE sd_spe_bloods_revs;',
		'TRUNCATE specimen_details;', 'TRUNCATE specimen_details_revs;',
		'TRUNCATE derivative_details;', 'TRUNCATE derivative_details_revs;',
		'UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null;',
		'DELETE FROM sample_masters;', 'DELETE FROM sample_masters_revs;',

		'DELETE FROM collections;', 'DELETE FROM collections_revs;',
			
		'TRUNCATE std_nitro_locates;', 'TRUNCATE std_nitro_locates_revs;',
		'TRUNCATE std_fridges;', 'TRUNCATE std_fridges_revs;',
		'TRUNCATE std_freezers;', 'TRUNCATE std_freezers_revs;',
		'TRUNCATE std_boxs;', 'TRUNCATE std_boxs_revs;',
		'TRUNCATE std_racks;', 'TRUNCATE std_racks_revs;',
		'UPDATE storage_masters SET parent_id = null;',
		'DELETE FROM storage_masters;', 'DELETE FROM storage_masters_revs;',
			
		'TRUNCATE procure_txd_medication_drugs;', 'TRUNCATE procure_txd_medication_drugs_revs;',
		'TRUNCATE procure_txd_followup_worksheet_treatments;', 'TRUNCATE procure_txd_followup_worksheet_treatments_revs;',
		'DELETE FROM treatment_masters;', 'DELETE FROM treatment_masters_revs;',
		
		'TRUNCATE procure_ed_followup_worksheet_clinical_notes;', 'TRUNCATE procure_ed_followup_worksheet_clinical_notes_revs;',
		'TRUNCATE procure_ed_followup_worksheet_other_tumor_diagnosis;', 'TRUNCATE procure_ed_followup_worksheet_other_tumor_diagnosis_revs;',
		'TRUNCATE procure_ed_clinical_followup_worksheet_clinical_events;', 'TRUNCATE procure_ed_clinical_followup_worksheet_clinical_events_revs;',
		'TRUNCATE procure_ed_lab_diagnostic_information_worksheets;', 'TRUNCATE procure_ed_lab_diagnostic_information_worksheets_revs;',
		'TRUNCATE procure_ed_lab_pathologies;', 'TRUNCATE procure_ed_lab_pathologies_revs;',
		'TRUNCATE procure_ed_clinical_followup_worksheet_aps;', 'TRUNCATE procure_ed_clinical_followup_worksheet_aps_revs;',
		'TRUNCATE procure_ed_lifestyle_quest_admin_worksheets;', 'TRUNCATE procure_ed_lifestyle_quest_admin_worksheets_revs;',
		'DELETE FROM event_masters;', 'DELETE FROM event_masters_revs;',
		'DELETE FROM event_masters WHERE event_control_id = 54;', 'DELETE FROM event_masters_revs WHERE event_control_id = 54;',
		
		'TRUNCATE procure_cd_sigantures;', 'TRUNCATE procure_cd_sigantures_revs;',
		'DELETE FROM consent_masters;', 'DELETE FROM consent_masters_revs;',

		'TRUNCATE misc_identifiers;', 'TRUNCATE misc_identifiers_revs;',
		'DELETE FROM participants;','DELETE FROM participants_revs;'
	);
	
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

function updateAliquotUseAndVolume() {
	
	foreach(getViewCreateStatement() AS $table => $create_sql) {
		customQuery('DROP TABLE IF EXISTS '.$table, __FILE__, __LINE__);
		customQuery('DROP VIEW IF EXISTS '.$table, __FILE__, __LINE__);
		customQuery($create_sql, __FILE__, __LINE__);
	}
	foreach(getView() AS $table => $view_sql) {
		$queries = explode("UNION ALL", $view_sql);
		foreach($queries as $query){
			customQuery('INSERT INTO '.$table. '('.str_replace('%%WHERE%%', '', $query).')', __FILE__, __LINE__);
		}
	}

	//-A-Use counter
	$use_counters_updated = array();
	//Search all aliquots linked to at least one use and having use_counter = 0
	$tmp_sql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, us.use_counter
		FROM aliquot_masters am
		INNER JOIN (SELECT count(*) AS use_counter, aliquot_master_id FROM view_aliquot_uses GROUP BY aliquot_master_id) us ON am.id = us.aliquot_master_id
		WHERE am.deleted <> 1 AND (am.use_counter IS NULL OR am.use_counter = 0)";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET use_counter = '".$row['use_counter']."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}
	//Search all unused aliquots having use_counter != 0
	$tmp_sql = "SELECT id AS aliquot_master_id, barcode, aliquot_label FROM aliquot_masters WHERE deleted <> 1 AND use_counter != 0 AND id NOT IN (SELECT DISTINCT aliquot_master_id FROM view_aliquot_uses);";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET use_counter = '".$row['use_counter']."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}	
	//Search all aliquots having use_counter != real use counter (from view_aliquot_uses)
	$tmp_sql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label,us.use_counter FROM aliquot_masters am INNER JOIN (SELECT aliquot_master_id, count(*) AS use_counter FROM view_aliquot_uses GROUP BY aliquot_master_id) us ON us.aliquot_master_id = am.id WHERE am.deleted <> 1 AND us.use_counter != am.use_counter;";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET use_counter = '".$row['use_counter']."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}
	
	//-B-Current Volume
	//Search all aliquots having current_volume > 0 but a sum of used_volume (from view_aliquot_uses) > initial_volume
	$tmp_sql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume, am.current_volume, us.sum_used_volumes FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id INNER JOIN (SELECT aliquot_master_id, SUM(used_volume) AS sum_used_volumes FROM view_aliquot_uses WHERE used_volume IS NOT NULL GROUP BY aliquot_master_id) AS us ON us.aliquot_master_id = am.id WHERE am.deleted != 1 AND ac.volume_unit IS NOT NULL AND am.initial_volume < us.sum_used_volumes AND am.current_volume != 0;";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET current_volume = '0' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}
	//Search all aliquots having current_volume != initial volume - used_volume (from view_aliquot_uses) > initial_volume
	$tmp_sql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume, am.current_volume, us.sum_used_volumes FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id INNER JOIN (SELECT aliquot_master_id, SUM(used_volume) AS sum_used_volumes FROM view_aliquot_uses WHERE used_volume IS NOT NULL GROUP BY aliquot_master_id) AS us ON us.aliquot_master_id = am.id WHERE am.deleted != 1 AND ac.volume_unit IS NOT NULL AND am.initial_volume >= us.sum_used_volumes AND am.current_volume != (am.initial_volume - us.sum_used_volumes);";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET current_volume = '".($row['initial_volume'] - $row['sum_used_volumes'])."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}
	
	/*
	//-C-Used Volume
	$used_volume_updated = array();
	//Search all aliquot internal use having used volume not null but no volume unit
	$tmp_sql = "SELECT AliquotInternalUse.id AS aliquot_internal_use_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			AliquotInternalUse.used_volume AS used_volume,
			AliquotControl.volume_unit
			FROM aliquot_internal_uses AS AliquotInternalUse
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE AliquotInternalUse.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND AliquotInternalUse.used_volume IS NOT NULL;";
	$aliquots_to_clean_up = $AliquotMaster_model->query($tmp_sql);
	if($aliquots_to_clean_up) {
		$AliquotInternalUse_model = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
		$AliquotInternalUse_model->check_writable_fields = false;
		foreach($aliquots_to_clean_up as $new_aliquot) {
			$AliquotInternalUse_model->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$AliquotInternalUse_model->id = $new_aliquot['AliquotInternalUse']['aliquot_internal_use_id'];
			if(!$AliquotInternalUse_model->save(array('AliquotInternalUse' => array('id' => $new_aliquot['AliquotInternalUse']['aliquot_internal_use_id'], 'used_volume' => '')), false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			$used_volume_updated[$new_aliquot['AliquotMaster']['aliquot_master_id']] = $new_aliquot['AliquotMaster']['barcode'];
		}
	}
	//Search all aliquot used as source aliquot, used volume not null but no volume unit
	$tmp_sql = "SELECT SourceAliquot.id AS source_aliquot_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			SourceAliquot.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM source_aliquots AS SourceAliquot
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE SourceAliquot.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND SourceAliquot.used_volume IS NOT NULL;";
	$aliquots_to_clean_up = $AliquotMaster_model->query($tmp_sql);
	if($aliquots_to_clean_up) {
		$SourceAliquot_model = AppModel::getInstance("InventoryManagement", "SourceAliquot", true);
		$SourceAliquot_model->check_writable_fields = false;
		foreach($aliquots_to_clean_up as $new_aliquot) {
			$SourceAliquot_model->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$SourceAliquot_model->id = $new_aliquot['SourceAliquot']['source_aliquot_id'];
			if(!$SourceAliquot_model->save(array('SourceAliquot' => array('id' => $new_aliquot['SourceAliquot']['source_aliquot_id'], 'used_volume' => '')), false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			$used_volume_updated[$new_aliquot['AliquotMaster']['aliquot_master_id']] = $new_aliquot['AliquotMaster']['barcode'];
		}
	}
	//Search all aliquot used as parent aliquot, used volume not null but no volume unit
	$tmp_sql = "SELECT Realiquoting.id AS realiquoting_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			Realiquoting.parent_used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM realiquotings AS Realiquoting
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE Realiquoting.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND Realiquoting.parent_used_volume IS NOT NULL;";
	$aliquots_to_clean_up = $AliquotMaster_model->query($tmp_sql);
	if($aliquots_to_clean_up) {
		$Realiquoting_model = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
		$Realiquoting_model->check_writable_fields = false;
		foreach($aliquots_to_clean_up as $new_aliquot) {
			$Realiquoting_model->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$Realiquoting_model->id = $new_aliquot['Realiquoting']['realiquoting_id'];
			if(!$Realiquoting_model->save(array('Realiquoting' => array('id' => $new_aliquot['Realiquoting']['realiquoting_id'], 'parent_used_volume' => '')), false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			$used_volume_updated[$new_aliquot['AliquotMaster']['aliquot_master_id']] = $new_aliquot['AliquotMaster']['barcode'];
		}
	}
	//Search all aliquot used for quality conbtrol, used volume not null but no volume unit
	$tmp_sql = "SELECT QualityCtrl.id AS quality_control_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			QualityCtrl.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM quality_ctrls AS QualityCtrl
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE QualityCtrl.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND QualityCtrl.used_volume IS NOT NULL;";
	$aliquots_to_clean_up = $AliquotMaster_model->query($tmp_sql);
	if($aliquots_to_clean_up) {
		$QualityCtrl_model = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
		$QualityCtrl_model->check_writable_fields = false;
		foreach($aliquots_to_clean_up as $new_aliquot) {
			$QualityCtrl_model->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$QualityCtrl_model->id = $new_aliquot['QualityCtrl']['quality_control_id'];
			if(!$QualityCtrl_model->save(array('QualityCtrl' => array('id' => $new_aliquot['QualityCtrl']['quality_control_id'], 'used_volume' => '')), false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			$used_volume_updated[$new_aliquot['AliquotMaster']['aliquot_master_id']] = $new_aliquot['AliquotMaster']['barcode'];
		}
	}
	if($used_volume_updated) {
		$ViewAliquotUse_model = AppModel::getInstance('InventoryManagement', 'ViewAliquotUse');
		foreach(explode("UNION ALL", $ViewAliquotUse_model::$table_query) as $query) {
			$ViewAliquotUse_model->query('REPLACE INTO '.$ViewAliquotUse_model->table. '('.str_replace('%%WHERE%%', 'AND AliquotMaster.id IN ('.implode(',',array_keys($used_volume_updated)).')', $query).')');
		}
		AppController::addWarningMsg(__('aliquot used volume has been removed for following aliquots : ').(implode(', ', $used_volume_updated)));
	}
	*/
	
}

function getViewCreateStatement() {
	$data = array( 'view_aliquot_uses' => 
		"CREATE TABLE view_aliquot_uses (
			  id varchar(20) NOT NULL,
			  aliquot_master_id int NOT NULL,
			  use_definition varchar(50) NOT NULL DEFAULT '',
			  use_code varchar(250) NOT NULL DEFAULT '',
			  use_details VARchar(250) NOT NULL DEFAULT '',
			  used_volume decimal(10,5) DEFAULT NULL,
			  aliquot_volume_unit varchar(20) DEFAULT NULL,
			  use_datetime datetime DEFAULT NULL,
			  use_datetime_accuracy char(1) NOT NULL DEFAULT '',
			  duration VARCHAR(250) NOT NULL DEFAULT '',
			  duration_unit VARCHAR(250) NOT NULL DEFAULT '',
			  used_by VARCHAR(50) DEFAULT NULL,
			  created datetime NOT NULL,
			  detail_url varchar(250) NOT NULL DEFAULT '',
			  sample_master_id int(11) NOT NULL,
			  collection_id int(11) NOT NULL,
			  study_summary_id int(11) DEFAULT NULL,
			  procure_created_by_bank char(1) DEFAULT '')");
	return $data;
	
}
function getView() {
	
	$data = array( 'view_aliquot_uses' => 
	"SELECT CONCAT(AliquotInternalUse.id,6) AS id,
		AliquotMaster.id AS aliquot_master_id,
		AliquotInternalUse.type AS use_definition,
		AliquotInternalUse.use_code AS use_code,
		AliquotInternalUse.use_details AS use_details,
		AliquotInternalUse.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		AliquotInternalUse.use_datetime AS use_datetime,
		AliquotInternalUse.use_datetime_accuracy AS use_datetime_accuracy,
		AliquotInternalUse.duration AS duration,
		AliquotInternalUse.duration_unit AS duration_unit,
		AliquotInternalUse.used_by AS used_by,
		AliquotInternalUse.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		AliquotInternalUse.study_summary_id AS study_summary_id,
AliquotInternalUse.procure_created_by_bank AS procure_created_by_bank
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotInternalUse.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(SourceAliquot.id,1) AS `id`,
		AliquotMaster.id AS aliquot_master_id,
		CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
		SampleMaster.sample_code AS use_code,
		'' AS `use_details`,
		SourceAliquot.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		DerivativeDetail.creation_datetime AS use_datetime,
		DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
		'' AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		'-1' AS study_summary_id,
SampleMaster.procure_created_by_bank AS procure_created_by_bank
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		WHERE SourceAliquot.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'realiquoted to' AS use_definition,
		AliquotMasterChild.barcode AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id,
AliquotMasterChild.procure_created_by_bank AS procure_created_by_bank
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(QualityCtrl.id,3) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'quality control' AS use_definition,
		QualityCtrl.qc_code AS use_code,
		'' AS use_details,
		QualityCtrl.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		QualityCtrl.date AS use_datetime,
		QualityCtrl.date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		QualityCtrl.run_by AS used_by,
		QualityCtrl.created AS created,
		CONCAT('/InventoryManagement/QualityCtrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityCtrl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id,
QualityCtrl.procure_created_by_bank AS procure_created_by_bank
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(OrderItem.id,4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'aliquot shipment' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		Shipment.datetime_shipped AS use_datetime,
		Shipment.datetime_shipped_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Shipment.shipped_by AS used_by,
		Shipment.created AS created,
		CONCAT('/Order/Shipments/detail/',Shipment.order_id,'/',Shipment.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
'p' AS procure_created_by_bank
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		JOIN `orders` AS `Order` ON  Order.id = OrderLine.order_id
		WHERE OrderItem.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(AliquotReviewMaster.id,5) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'specimen review' AS use_definition,
		SpecimenReviewMaster.review_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		SpecimenReviewMaster.review_date AS use_datetime,
		SpecimenReviewMaster.review_date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/InventoryManagement/SpecimenReviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id,
'' AS procure_created_by_bank
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 %%WHERE%%");
	return $data;
}

?>