<?php
class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	
//	static $db_port 		= "8889";
//	static $db_user 		= "root";
//	static $db_pwd			= "root";
//	static $db_schema		= "atim_tf_coeur";
	
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "tfri";
	
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/test.xls";
	
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/CHUM-COEUR-clinical data-v0.1.15_reviewed.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/CHUS-COEUR v1-15_reviewed.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/McGill-COEUR- v1-15_reviewed.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/TFRI-COEUR-CBCF-1.15_reviewed.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/TFRI-COEUR-CHUQ-clinical data v4-1.15_reviewed.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/TFRI-COEUR-OVCare v0-1.15_reviewed.xls";
	static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/TTR-COEUR-clinical v1.15_reviewed.xls";
	
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/DEMO.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/CHUM-COEUR-clinical data-v0.1.15.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/CHUS-COEUR v0.1-15.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TTR-COEUR-clinical data-v0.1.15.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/McGill-COEUR- v0-1.15.xls";
	//header row =1 -> static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/OHRI-COEUR.xls";//file to read
// 	static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-CBCF-1.15.xls";//file to read
// 	static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-OVCare v0-1.15.xls";//file to read
// 	static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-CHUQ-clinical data v4-1.15.xls";//file to read

	static $xls_header_rows = 2;

	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well
	
	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	//--------------------------------------
	
	
	//this shouldn't be edited here
	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
	
	static function addModel(Model $m, $ref_name){
		if(array_key_exists($ref_name, Config::$models)){
			die("Defining model ref name [".$ref_name."] more than once\n");
		}
		Config::$models[$ref_name] = $m;
	}

	static $eoc_file_event_types	= array('ca125', 'ct scan', 'biopsy', 'surgery(other)', 'surgery(ovarectomy)', 'chemotherapy', 'radiotherapy');
	static $opc_file_event_types	= array('biopsy', 'surgery', 'chemotherapy', 'radiology', 'radiotherapy', 'hormonal therapy');
	
	static $sample_aliquot_controls = array();
	static $banks = array();
	static $drugs	= array();
	static $tissue_source = array();
	
	static $identifiers = array();
}

//add you start queries here
Config::$addon_queries_start[] = "DROP TABLE IF EXISTS start_time";
Config::$addon_queries_start[] = "CREATE TABLE start_time (SELECT NOW() AS start_time)";

//add your end queries here
//Config::$addon_queries_end[] = "INSERT INTO clinical_collection_links (participant_id, collection_id, created, created_by, modified, modified_by) 
//	(SELECT p.mysql_id, c.mysql_id, 1, NOW(), 1, NOW() 
//	FROM id_linking AS p 
//	INNER JOIN id_linking AS c ON c.csv_reference='collections' AND p.csv_id=c.csv_id WHERE p.csv_reference='participants')";
//Config::$addon_queries_end[] = "TRUNCATE id_linking";
//Config::$addon_queries_end[] = "UPDATE participants SET vital_status='deceased' WHERE vital_status='dead'";
//Config::$addon_queries_end[] = "UPDATE aliquot_masters SET barcode=CONCAT('', id) WHERE barcode=''";
//add some value domains names that you want to use in post read/write functions
//Config::$value_domains[] = "...";

//Config::$value_domains[] = new ValueDomain("qc_tf_eoc_event_drug", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
//Config::$value_domains[] = new ValueDomain("qc_tf_surgery_type", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
//Config::$value_domains[] = new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

Config::$value_domains['qc_tf_ct_scan_precision']= new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['tissue_laterality']= new ValueDomain("tissue_laterality", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['qc_tf_tissue_type']= new ValueDomain("qc_tf_tissue_type", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "participants";
Config::$parent_models[] = "collections";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/participants.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_eocs.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_no_site.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site1.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site2.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site_ca125.php';
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_primary_cancers.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_progression.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_eocs.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_tx_eocs.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_other.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_tx_other.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM//terry_fox_coeur/dataImporterConfig/tablesMapping/collections.php';

// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/participants.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_eocs.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_no_site.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site1.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site2.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site_ca125.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_primary_cancers.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_progression.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_eocs.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_tx_eocs.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_other.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_tx_other.php';
// Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/collections.php';


function mainDxCondition(Model $m){
	//used as pre insert, not a real test
	global $primary_number;
	$m->values['primary_number'] = $primary_number ++;
	
	$m->custom_data['last_participant_id'] = $m->parent_model->last_id;
	return true;
}

function addonFunctionStart(){
	$query = "SELECT identifier_value, misc_identifier_control_id FROM misc_identifiers";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		checkAndAddIdentifier($row['identifier_value'], $row['misc_identifier_control_id']);
	}
	
	// SET banks
	$query = "SELECT id, name, misc_identifier_control_id FROM banks";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$banks[$row['name']] = array(
			'id' => $row['id'],
			'misc_identifier_control_id' => $row['misc_identifier_control_id']);
	}	
	
	$query = "SELECT generic_name FROM drugs";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$drugs[] = $row['generic_name'];
	}	
	
	$query = "select id,sample_type from sample_controls where sample_type in ('tissue','blood', 'ascite', 'serum', 'plasma', 'dna', 'blood cell')";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 7) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'volume_unit' => $row['volume_unit']);
		}	
	}

	$query = "SELECT value FROM structure_permissible_values_customs INNEr JOIN structure_permissible_values_custom_controls "
		."ON structure_permissible_values_custom_controls.id = structure_permissible_values_customs.control_id "
		."WHERE name LIKE 'tissue source'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$tissue_source[] = $row['value'];
	}
	Config::$tissue_source[] = '';	
}

function checkAndAddIdentifier($identifier_value, $identifier_control_id){
	$key = sprintf("%s-%d", $identifier_value, $identifier_control_id);
	if(array_key_exists($key, Config::$identifiers)){
		global $insert;
		$insert = false;
		echo "ERROR: identifier value [",$identifier_value,"] already exists for control id [",$identifier_control_id,"]\n";
	}else{
		Config::$identifiers[$key] = null;
	}
}

function addonFunctionEnd(){
	
	// DIAGNOSIS / TRT / EVENT LINKS CREATION
	
	$query  ="SELECT participant_id, COUNT(*) AS c FROM diagnosis_masters WHERE created >= (SELECT start_time FROM start_time) GROUP BY participant_id HAVING c > 1";
	$result = mysqli_query(Config::$db_connection, $query) or die("reading in addonFunctionEnd failed");
	$ids = array();
	while($row = $result->fetch_assoc()){
		$ids[] = $row['participant_id'];
	}
	mysqli_free_result($result);
	
	if(!empty($ids)){
		echo "MESSAGE: The tx and events for participants with ids (".implode(", ", $ids).") couldn't be linked to a dx because they have more than one.\n";
	}
	
	$ids[] = 0;
	$query = "UPDATE event_masters "
		."LEFT JOIN diagnosis_masters ON event_masters.participant_id=diagnosis_masters.participant_id "
		."SET event_masters.diagnosis_master_id=diagnosis_masters.id "
		."WHERE event_masters.created >= (SELECT start_time FROM start_time) AND event_masters.participant_id NOT IN(".implode(", ", $ids).")";
	mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed");
	
	if(Config::$insert_revs){
		$query = "UPDATE event_masters_revs INNER JOIN event_masters ON event_masters.id = event_masters_revs.id SET event_masters_revs.diagnosis_master_id = event_masters.diagnosis_master_id";
		mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed (revs table)");
	}	

	$query = "UPDATE tx_masters "
		."LEFT JOIN diagnosis_masters ON tx_masters.participant_id=diagnosis_masters.participant_id "
		."SET tx_masters.diagnosis_master_id=diagnosis_masters.id "
		."WHERE tx_masters.created >= (SELECT start_time FROM start_time) AND tx_masters.participant_id NOT IN(".implode(", ", $ids).")";
	mysqli_query(Config::$db_connection, $query) or die("update 2 in addonFunctionEnd failed");

	if(Config::$insert_revs){
		$query = "UPDATE tx_masters_revs INNER JOIN tx_masters ON tx_masters.id = tx_masters_revs.id SET tx_masters_revs.diagnosis_master_id = tx_masters.diagnosis_master_id";
		mysqli_query(Config::$db_connection, $query) or die("update 2 in addonFunctionEnd failed (revs table)");
	}	
	
	// COLLECTION / PARTICIPANTS LINKS CREATION
	
	$query = "INSERT INTO clinical_collection_links (participant_id, collection_id, created, created_by, modified, modified_by) 
		(SELECT p.mysql_id, c.mysql_id, 1, NOW(), 1, NOW() 
		FROM id_linking AS p 
		INNER JOIN id_linking AS c ON c.csv_reference='collections' AND p.csv_id=c.csv_id WHERE p.csv_reference='participants')";
	mysqli_query(Config::$db_connection, $query) or die("collection linking failed qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	if(Config::$insert_revs){
		$query = "INSERT INTO clinical_collection_links_revs (id, participant_id, collection_id, modified_by, version_created) "
			."(SELECT id, participant_id, collection_id, modified_by, NOW() FROM clinical_collection_links WHERE collection_id IN (SELECT c.mysql_id FROM id_linking AS c WHERE c.csv_reference='collections'))";
		mysqli_query(Config::$db_connection, $query) or die("collection linking failed qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}
	
	$query = "TRUNCATE id_linking";
	mysqli_query(Config::$db_connection, $query) or die("collection linking failed qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	// EMPTY DATES CLEAN UP
	
	$date_times_to_check = array(
		'collections.collection_datetime',
		'diagnosis_masters.dx_date',
		'event_masters.event_date',
		'participants.date_of_birth',
		'participants.date_of_death',
		'participants.qc_tf_suspected_date_of_death',
		'participants.qc_tf_last_contact',
		'tx_masters.start_date',
		'tx_masters.finish_date');

	foreach($date_times_to_check as $table_field) {
		$names = explode(".", $table_field);
		
		$query = "UPDATE ".$names[0]." SET ".$names[1]." = null WHERE ".$names[1]." LIKE '0000-00-00%'";
		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
		
		if(Config::$insert_revs){
			$query = "UPDATE ".$names[0]."_revs SET ".$names[1]." = null WHERE ".$names[1]." LIKE '0000-00-00%'";
			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");			
		}
	}
	
	// LAST DATA UPDATE
	
	$query = "UPDATE participants SET vital_status='deceased' WHERE vital_status='dead'";
	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	if(Config::$insert_revs){
		$query = "UPDATE participants_revs SET vital_status='deceased' WHERE vital_status='dead'";
		mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	}
	
	$query = "UPDATE aliquot_masters SET barcode=CONCAT('', id) WHERE barcode=''";
	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	if(Config::$insert_revs){
		$query = "UPDATE aliquot_masters_revs SET barcode=CONCAT('', id) WHERE barcode=''";
		mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	}
}